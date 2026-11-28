#!/usr/bin/env python

# Minimum Feedback Arc Set analysis for Strongly Connected Components in a code dependency graph.
# Reads Strongly Connected Component edge data from Neo4j, runs the Minimum Feedback Arc Set
# algorithm, writes CSV reports, and generates adjacency matrix heatmap SVG files.
#
# Two node type configurations are processed: Java Packages and SCIP Semantic Index Modules.
# For each node type, the top 5 Strongly Connected Components (by complexity score) are analysed.
#
# CSV outputs per node type (in the report subdirectory):
#   Minimum_Feedback_Arc_Set_Overview.csv    — component summary with edge counts and patterns
#   Minimum_Feedback_Arc_Set_Edges.csv       — all edges (DAG and feedback arcs) with classification
#   Minimum_Feedback_Arc_Set_Detail_Edges.csv — symbol/type detail edges within feedback arcs
#
# SVG outputs per node type:
#   Graph_Visualizations/Minimum_Feedback_Arc_Set_Heatmap_SCC_<id>.svg  — adjacency matrix heatmap
#   Graph_Visualizations/Minimum_Feedback_Arc_Set_<id>.gv               — hierarchical DOT graph
#
# Input parameters:
#   --report_directory   path to the base report directory (required)
#   --neo4j_uri          Neo4j bolt URI (default: bolt://localhost:7687)
#   --verbose            optional finer-grained logging

import argparse
import csv
import os
import sys
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path

import matplotlib
matplotlib.use("Agg")  # Non-interactive backend — required for headless script execution
import matplotlib.colors as mpl_colors
import matplotlib.pyplot as plot
import numpy as np
import pandas as pd
from neo4j import Driver, GraphDatabase

sys.path.insert(0, str(Path(__file__).parent))
import minimumFeedbackArcSet as mfas

SCRIPT_NAME = "minimumFeedbackArcSetCharts"

TOP_STRONGLY_CONNECTED_COMPONENTS_COUNT = 5
DETAIL_EDGES_QUERY_ROW_LIMIT = 500

PATTERN_DIRECTORY_LOCALITY = "Directory Locality"
PATTERN_ASYMMETRIC_DEPENDENCY = "Asymmetric Dependency"
PATTERN_HUB_MODULE = "Hub Module"
PATTERN_BALANCED_COUPLING = "Balanced Coupling"

PATTERN_RECOMMENDATIONS: dict[str, str] = {
    PATTERN_DIRECTORY_LOCALITY: "Often intentional. Consider documenting the coupling explicitly.",
    PATTERN_ASYMMETRIC_DEPENDENCY: "Cut the lighter direction. Low effort, high reward.",
    PATTERN_HUB_MODULE: "Extract an interface from the hub. High leverage on many cycles.",
    PATTERN_BALANCED_COUPLING: "Requires a new abstraction layer. Plan carefully.",
}

# Color values for the adjacency matrix heatmap: 0=white, 1=blue(DAG), 2=red(feedback arc)
HEATMAP_COLOR_NONE = 0
HEATMAP_COLOR_DAG_EDGE = 1
HEATMAP_COLOR_FEEDBACK_ARC = 2


# ── Configuration ─────────────────────────────────────────────────────────────


@dataclass(frozen=True)
class NodeTypeConfiguration:
    """Configuration for one node type processed by this script."""

    node_type: str
    display_name: str
    report_subdirectory: str
    detail_query_filename: str


NODE_TYPE_CONFIGURATIONS: tuple[NodeTypeConfiguration, ...] = (
    NodeTypeConfiguration(
        node_type="Package",
        display_name="Java Package",
        report_subdirectory="Java_Package",
        detail_query_filename="Minimum_Feedback_Arc_Set_Java_Package_Detail_Edges.cypher",
    ),
    NodeTypeConfiguration(
        node_type="SemanticCodeIndexModule",
        display_name="SCIP Module",
        report_subdirectory="SCIP_Semantic_Index_Module",
        detail_query_filename="Minimum_Feedback_Arc_Set_SCIP_Module_Detail_Edges.cypher",
    ),
)


# ── Parameters ────────────────────────────────────────────────────────────────


@dataclass(frozen=True)
class Parameters:
    """Parsed command-line parameters."""

    report_directory: Path
    neo4j_uri: str
    verbose: bool

    def __post_init__(self) -> None:
        if not self.report_directory.exists():
            raise ValueError(f"Report directory does not exist: {self.report_directory}")


def parse_parameters() -> Parameters:
    """Parse and validate command-line arguments."""
    parser = argparse.ArgumentParser(
        description="Minimum Feedback Arc Set analysis for Strongly Connected Components."
    )
    parser.add_argument("--report_directory", required=True, help="Base report output directory.")
    parser.add_argument(
        "--neo4j_uri", default="bolt://localhost:7687", help="Neo4j bolt URI."
    )
    parser.add_argument("--verbose", action="store_true", help="Enable verbose logging.")
    args = parser.parse_args()
    return Parameters(
        report_directory=Path(args.report_directory),
        neo4j_uri=args.neo4j_uri,
        verbose=args.verbose,
    )


# ── Neo4j ─────────────────────────────────────────────────────────────────────


def connect_to_neo4j(uri: str) -> Driver:
    """Create and verify a Neo4j driver connection."""
    password = os.environ.get("NEO4J_INITIAL_PASSWORD")
    if not password:
        raise EnvironmentError("NEO4J_INITIAL_PASSWORD environment variable is not set.")
    driver = GraphDatabase.driver(
        uri=uri,
        auth=("neo4j", password),
        notifications_disabled_classifications=["UNRECOGNIZED"],
    )
    driver.verify_connectivity()
    return driver


def execute_cypher_from_file(
    driver: Driver,
    query_file: Path,
    parameters: dict[str, object] | None = None,
) -> pd.DataFrame:
    """Execute a Cypher query read from a file and return results as a DataFrame."""
    query_text = query_file.read_text(encoding="utf-8")
    records, _, keys = driver.execute_query(query_text, parameters_=parameters or {})
    return pd.DataFrame([record.values() for record in records], columns=keys)


# ── Pattern classification ────────────────────────────────────────────────────


def classify_dependency_pattern(
    source: str,
    target: str,
    forward_weight: int,
    backward_weight: int,
) -> str:
    """Classify the structural cycle pattern for a feedback arc edge pair.

    Four structural patterns detected from module naming and weight asymmetry:
    - Directory Locality: modules share the same parent directory path segment.
    - Asymmetric Dependency: one direction carries ≥ 60% of combined edge weight.
    - Hub Module: detected post-hoc when a node appears in many feedback arcs.
    - Balanced Coupling: fallback when no other pattern applies.

    Args:
        source: Module name on the feedback arc source side.
        target: Module name on the feedback arc target side.
        forward_weight: Dependency weight from source to target (the feedback arc weight).
        backward_weight: Dependency weight from target to source (the reverse arc weight).

    Returns:
        One of the four pattern label constants.
    """
    source_parent = source.rsplit("/", 1)[0] if "/" in source else source.rsplit(".", 1)[0] if "." in source else ""
    target_parent = target.rsplit("/", 1)[0] if "/" in target else target.rsplit(".", 1)[0] if "." in target else ""

    if source_parent and source_parent == target_parent:
        return PATTERN_DIRECTORY_LOCALITY

    total_weight = forward_weight + backward_weight
    if total_weight > 0:
        heavier_direction_ratio = max(forward_weight, backward_weight) / total_weight
        if heavier_direction_ratio >= 0.60:
            return PATTERN_ASYMMETRIC_DEPENDENCY

    return PATTERN_BALANCED_COUPLING


def apply_hub_module_pattern(
    feedback_arc_edges: list[mfas.EdgeTriple],
    patterns: dict[tuple[str, str], str],
) -> dict[tuple[str, str], str]:
    """Reclassify feedback arcs whose source or target appears in multiple arcs as Hub Module.

    A node is a hub when it appears (as source or target) in two or more feedback arcs
    within the same component. Hub patterns indicate a central module that should have
    an interface extracted.

    Args:
        feedback_arc_edges: Feedback arc edge triples for one component.
        patterns: Initial pattern classification per (source, target) pair.

    Returns:
        Updated pattern dictionary with Hub Module reclassifications applied.
    """
    node_counts: dict[str, int] = defaultdict(int)
    for source, target, _ in feedback_arc_edges:
        node_counts[source] += 1
        node_counts[target] += 1

    hub_nodes = {node for node, count in node_counts.items() if count >= 2}
    updated_patterns = dict(patterns)
    for source, target, _ in feedback_arc_edges:
        if source in hub_nodes or target in hub_nodes:
            updated_patterns[(source, target)] = PATTERN_HUB_MODULE

    return updated_patterns


# ── Topological depth (for heatmap ordering) ──────────────────────────────────


def compute_topological_depths(
    nodes: list[str],
    dag_edges: list[tuple[str, str]],
) -> dict[str, int]:
    """Assign each node its topological depth (0 for sources, +1 per downstream step).

    Uses BFS from source nodes. Unreached nodes are placed at the maximum depth.

    Args:
        nodes: All node identifiers.
        dag_edges: (source, target) pairs of the DAG (non-feedback-arc edges).

    Returns:
        Mapping of node → depth.
    """
    successors: dict[str, list[str]] = {node: [] for node in nodes}
    predecessor_counts: dict[str, int] = {node: 0 for node in nodes}

    for source, target in dag_edges:
        successors[source].append(target)
        predecessor_counts[target] += 1

    queue = [node for node in nodes if predecessor_counts[node] == 0]
    depths: dict[str, int] = {node: 0 for node in queue}

    while queue:
        current = queue.pop(0)
        for successor in successors[current]:
            proposed_depth = depths[current] + 1
            if successor not in depths or depths[successor] < proposed_depth:
                depths[successor] = proposed_depth
                queue.append(successor)

    maximum_depth = max(depths.values(), default=0)
    for node in nodes:
        if node not in depths:
            depths[node] = maximum_depth

    return depths


# ── Heatmap generation ────────────────────────────────────────────────────────


def generate_adjacency_heatmap(
    nodes: list[str],
    all_edges: list[mfas.EdgeTriple],
    feedback_arc_set: list[mfas.EdgeTriple],
    output_path: Path,
    title: str,
) -> None:
    """Generate and save an adjacency matrix heatmap SVG.

    Rows = source nodes, columns = target nodes, sorted by topological depth.
    Blue cells = DAG edges (keep after refactoring).
    Red cells = feedback arc edges (remove).
    White = no dependency.

    Args:
        nodes: All node names for this component.
        all_edges: Complete list of edges within the component.
        feedback_arc_set: Edges belonging to the feedback arc set.
        output_path: Destination SVG file path.
        title: Figure title string.
    """
    feedback_arc_pairs = {(source, target) for source, target, _ in feedback_arc_set}
    dag_edges = [(source, target) for source, target, _ in all_edges if (source, target) not in feedback_arc_pairs]

    depths = compute_topological_depths(nodes, dag_edges)
    sorted_nodes = sorted(nodes, key=lambda node: (depths.get(node, 0), node))

    matrix_size = len(sorted_nodes)
    node_index_map = {node: index for index, node in enumerate(sorted_nodes)}

    matrix = np.zeros((matrix_size, matrix_size))
    for source, target, _ in all_edges:
        if source in node_index_map and target in node_index_map:
            if (source, target) in feedback_arc_pairs:
                matrix[node_index_map[source]][node_index_map[target]] = HEATMAP_COLOR_FEEDBACK_ARC
            else:
                matrix[node_index_map[source]][node_index_map[target]] = HEATMAP_COLOR_DAG_EDGE

    # Updated colormap to match SCIP-matching scheme
    custom_colormap = mpl_colors.ListedColormap(["white", "#B0BEC5", "#E91E63"])

    figure_size = max(6, matrix_size * 0.55)
    figure, axis = plot.subplots(figsize=(figure_size, figure_size))

    axis.imshow(matrix, cmap=custom_colormap, vmin=0, vmax=2, aspect="auto")

    show_labels = matrix_size <= 35
    if show_labels:
        axis.set_xticks(range(matrix_size))
        axis.set_xticklabels(sorted_nodes, rotation=45, ha="right", fontsize=7)
        axis.set_yticks(range(matrix_size))
        axis.set_yticklabels(sorted_nodes, fontsize=7)

    axis.set_xlabel("Target", fontsize=9)
    axis.set_ylabel("Source", fontsize=9)
    axis.set_title(title, fontsize=10)

    # Updated legend to match new colors
    legend_elements = [
        plot.Rectangle((0, 0), 1, 1, facecolor="#B0BEC5", label="Keep (DAG edge)"),
        plot.Rectangle((0, 0), 1, 1, facecolor="#E91E63", label="Remove (feedback arc)"),
    ]
    axis.legend(handles=legend_elements, loc="upper right", fontsize=8)

    figure.tight_layout()
    figure.savefig(output_path, format="svg", bbox_inches="tight")
    plot.close(figure)


# ── DOT graph generation ──────────────────────────────────────────────────────


def generate_dot_graph(
    nodes: list[str],
    all_edges: list[mfas.EdgeTriple],
    feedback_arc_set: list[mfas.EdgeTriple],
    detail_edges: pd.DataFrame,
    component_name: str,
    output_path: Path,
) -> None:
    """Generate a hierarchical GraphViz DOT file for one Strongly Connected Component.

    Nodes are code units (packages/modules). Solid edges are DAG edges retained after
    the Minimum Feedback Arc Set removal. Dashed red edges are the arcs to remove.
    Detail nodes (symbols/types) are included inline for small feedback arcs (≤ 5 detail edges).

    Args:
        nodes: All node names.
        all_edges: Complete edge list for this component.
        feedback_arc_set: Edges in the feedback arc set.
        detail_edges: DataFrame with columns sourceModuleName, targetModuleName,
                      sourceDetailName, targetDetailName.
        component_name: Display name for the graph title.
        output_path: Destination .gv file path.
    """
    feedback_arc_pairs = {(source, target) for source, target, _ in feedback_arc_set}
    feedback_arc_weights = {(source, target): weight for source, target, weight in feedback_arc_set}

    # Group detail edges per feedback arc
    detail_per_arc: dict[tuple[str, str], list[tuple[str, str]]] = defaultdict(list)
    if not detail_edges.empty:
        for _, row in detail_edges.iterrows():
            key = (str(row["sourceModuleName"]), str(row["targetModuleName"]))
            detail_per_arc[key].append((str(row["sourceDetailName"]), str(row["targetDetailName"])))

    # Nodes involved in feedback arcs get a warmer fill color
    feedback_arc_nodes = {node for source, target in feedback_arc_pairs for node in (source, target)}

    lines: list[str] = []
    graph_id = component_name.replace(" ", "_").replace("/", "_").replace(".", "_").replace("(", "").replace(")", "")
    lines.append(f'digraph MinimumFeedbackArcSet_{graph_id} {{')
    lines.append('    rankdir=TB;')
    lines.append('    fontname="Arial";')
    lines.append('    graph [label="' + component_name.replace('"', "'") + ' (SCC)\\nMinimum Feedback Arc Set"; labelloc=t; fontsize=12; bgcolor="#F0F4F8"];')
    lines.append('    node [fontname="Arial"; shape=box; style=filled; fontsize=11; fontcolor="#1A1A1A"];')
    lines.append('    edge [fontname="Arial"; fontsize=9];')
    lines.append("")

    # Main nodes: SCIP-matching colors
    # Blue for all main nodes (matching ScipModuleCyclicDependencies1.gv)
    for node in sorted(nodes):
        fill_color = "#B3E5FC"
        border_color = "#0277BD"
        label = node.rsplit("/", 1)[-1] if "/" in node else node.rsplit(".", 1)[-1] if "." in node else node
        lines.append(
            f'    "{node}" [label="{label}"; tooltip="{node}"; '
            f'fillcolor="{fill_color}"; color="{border_color}"; penwidth=1.5];'
        )

    lines.append("")

    # DAG edges (solid blue from SCIP)
    for source, target, weight in all_edges:
        if (source, target) not in feedback_arc_pairs:
            lines.append(
                f'    "{source}" -> "{target}" '
                f'[color="#B0BEC5"; penwidth=0.7; label="{weight}"];'
            )

    lines.append("")

    # Feedback arc edges (dashed magenta) with optional detail nodes
    for source, target in sorted(feedback_arc_pairs):
        weight = feedback_arc_weights.get((source, target), 0)
        arc_detail = detail_per_arc.get((source, target), [])
        detail_count = len(arc_detail)
        edge_label = f"{weight} refs"
        if detail_count > 0:
            edge_label += f"\\n({detail_count} symbols)"

        lines.append(
            f'    "{source}" -> "{target}" '
            f'[style=dashed; color="#E91E63"; penwidth=2.5; label="{edge_label}"];'
        )

        # Inline detail nodes when the arc has few contributors (keeps graph readable)
        max_detail_nodes_per_arc = 5
        if 0 < detail_count <= max_detail_nodes_per_arc:
            for source_detail, target_detail in arc_detail[:max_detail_nodes_per_arc]:
                source_detail_id = f"{source}__{source_detail}".replace(".", "_").replace("/", "_").replace("(", "_").replace(")", "_")
                target_detail_id = f"{target}__{target_detail}".replace(".", "_").replace("/", "_").replace("(", "_").replace(")", "_")
                # Symbol nodes in light blue (matching reference scheme)
                lines.append(
                    f'    "{source_detail_id}" '
                    f'[label="{source_detail}"; shape=ellipse; style=filled; '
                    f'fillcolor="#E8F4F8"; color="#01579B"; fontsize=8; penwidth=0.7; fontcolor="#1A1A1A"];'
                )
                lines.append(
                    f'    "{target_detail_id}" '
                    f'[label="{target_detail}"; shape=ellipse; style=filled; '
                    f'fillcolor="#E8F4F8"; color="#01579B"; fontsize=8; penwidth=0.7; fontcolor="#1A1A1A"];'
                )
                lines.append(
                    f'    "{source_detail_id}" -> "{target_detail_id}" '
                    f'[color="#B0BEC5"; penwidth=0.5];'
                )
                # Connect detail nodes to their parent module nodes
                lines.append(
                    f'    "{source}" -> "{source_detail_id}" '
                    f'[color="#D1C4E9"; penwidth=0.3; style=dotted; constraint=false];'
                )
                lines.append(
                    f'    "{target}" -> "{target_detail_id}" '
                    f'[color="#D1C4E9"; penwidth=0.3; style=dotted; constraint=false];'
                )

    lines.append("}")

    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


# ── Analysis and CSV writing ──────────────────────────────────────────────────


def analyse_node_type(
    driver: Driver,
    configuration: NodeTypeConfiguration,
    report_base_directory: Path,
    queries_directory: Path,
    verbose: bool,
) -> None:
    """Run Minimum Feedback Arc Set analysis for one node type configuration.

    Reads Strongly Connected Component edges from Neo4j, runs the MFAS algorithm
    on each of the top strongly connected components, classifies patterns, queries
    detail edges for each feedback arc, and writes all outputs.

    Args:
        driver: Active Neo4j driver.
        configuration: Node type settings (type name, display name, subdirectory).
        report_base_directory: Root report directory.
        queries_directory: Directory containing .cypher query files.
        verbose: Whether to log extra detail.
    """
    report_directory = report_base_directory / configuration.report_subdirectory
    report_directory.mkdir(parents=True, exist_ok=True)

    scc_edges_query = queries_directory / "Minimum_Feedback_Arc_Set_SCC_Edges.cypher"
    detail_query_file = queries_directory / configuration.detail_query_filename

    if verbose:
        print(f"{SCRIPT_NAME}: Querying Strongly Connected Component edges for {configuration.display_name}...")

    scc_edges_dataframe = execute_cypher_from_file(
        driver,
        scc_edges_query,
        parameters={
            "scc_node_type": configuration.node_type,
            "top_n_sccs": TOP_STRONGLY_CONNECTED_COMPONENTS_COUNT,
        },
    )

    if scc_edges_dataframe.empty:
        print(
            f"{SCRIPT_NAME}: No Strongly Connected Components found for {configuration.display_name}. "
            "Skipping (run cyclic-dependencies CSV report first to populate SCC data)."
        )
        return

    overview_rows: list[dict[str, object]] = []
    edge_rows: list[dict[str, object]] = []
    detail_edge_rows: list[dict[str, object]] = []

    visualizations_directory = report_directory / "Graph_Visualizations"
    visualizations_directory.mkdir(parents=True, exist_ok=True)

    for component_id, component_group in scc_edges_dataframe.groupby("componentId"):
        component_name = str(component_group["componentName"].iloc[0])
        component_size = int(component_group["componentSize"].iloc[0])
        classification = str(component_group["classification"].iloc[0])

        if verbose:
            print(f"{SCRIPT_NAME}: Analysing component {component_id} ({component_name}) — {component_size} members...")

        all_edges: list[mfas.EdgeTriple] = [
            (str(row["sourceName"]), str(row["targetName"]), int(row["weight"]))
            for _, row in component_group.iterrows()
        ]

        # Deduplicate parallel edges by keeping maximum weight per pair
        deduplicated: dict[tuple[str, str], int] = {}
        for source, target, weight in all_edges:
            key = (source, target)
            deduplicated[key] = max(deduplicated.get(key, 0), weight)
        deduplicated_edges: list[mfas.EdgeTriple] = [(s, t, w) for (s, t), w in deduplicated.items()]

        feedback_arc_set = mfas.find_feedback_arc_set(deduplicated_edges)
        feedback_arc_pairs = {(source, target) for source, target, _ in feedback_arc_set}

        # Build reverse-weight map for pattern classification
        reverse_weights: dict[tuple[str, str], int] = {
            (target, source): weight for source, target, weight in deduplicated_edges
        }

        # Initial pattern classification per feedback arc
        patterns: dict[tuple[str, str], str] = {}
        for source, target, weight in feedback_arc_set:
            backward_weight = reverse_weights.get((source, target), 0)
            patterns[(source, target)] = classify_dependency_pattern(
                source, target, weight, backward_weight
            )

        # Apply hub module reclassification
        patterns = apply_hub_module_pattern(feedback_arc_set, patterns)

        # Collect overview
        pattern_counts = Counter(patterns.values())
        dominant_pattern = pattern_counts.most_common(1)[0][0] if pattern_counts else ""
        overview_rows.append({
            "componentId": component_id,
            "componentName": component_name,
            "componentSize": component_size,
            "classification": classification,
            "totalEdgeCount": len(deduplicated_edges),
            "feedbackArcEdgeCount": len(feedback_arc_set),
            "dagEdgeCount": len(deduplicated_edges) - len(feedback_arc_set),
            "dominantPattern": dominant_pattern,
        })

        # Collect all edges (both DAG and feedback arc)
        for source, target, weight in deduplicated_edges:
            is_feedback_arc = (source, target) in feedback_arc_pairs
            pattern = patterns.get((source, target), "")
            recommendation = PATTERN_RECOMMENDATIONS.get(pattern, "") if is_feedback_arc else ""
            # Find short names from the original dataframe
            matching = component_group[component_group["sourceName"] == source]
            source_short = str(matching["sourceShortName"].iloc[0]) if not matching.empty else source.rsplit("/", 1)[-1]
            matching = component_group[component_group["targetName"] == target]
            target_short = str(matching["targetShortName"].iloc[0]) if not matching.empty else target.rsplit("/", 1)[-1]
            edge_rows.append({
                "componentId": component_id,
                "componentName": component_name,
                "sourceName": source,
                "sourceShortName": source_short,
                "targetName": target,
                "targetShortName": target_short,
                "weight": weight,
                "isFeedbackArc": str(is_feedback_arc).lower(),
                "pattern": pattern,
                "recommendation": recommendation,
            })

        # Query and collect detail edges for each feedback arc
        all_component_detail = pd.DataFrame()
        for source, target, _ in feedback_arc_set:
            if detail_query_file.exists():
                try:
                    detail = execute_cypher_from_file(
                        driver,
                        detail_query_file,
                        parameters={
                            "component_id": int(component_id),
                            "source_name": source,
                            "target_name": target,
                        },
                    )
                    if not detail.empty:
                        all_component_detail = pd.concat([all_component_detail, detail], ignore_index=True)
                        for _, row in detail.head(DETAIL_EDGES_QUERY_ROW_LIMIT).iterrows():
                            detail_edge_rows.append({
                                "componentId": component_id,
                                "componentName": component_name,
                                "sourceModuleName": str(row["sourceModuleName"]),
                                "targetModuleName": str(row["targetModuleName"]),
                                "sourceDetailName": str(row["sourceDetailName"]),
                                "targetDetailName": str(row["targetDetailName"]),
                            })
                except Exception as error:  # noqa: BLE001 — detail edges are optional
                    if verbose:
                        print(f"{SCRIPT_NAME}: Detail edge query failed for {source}→{target}: {error}")

        # Heatmap: nodes are those connected by any edge in this component
        component_nodes = list({node for source, target, _ in deduplicated_edges for node in (source, target)})
        heatmap_path = visualizations_directory / f"Minimum_Feedback_Arc_Set_Heatmap_SCC_{component_id}.svg"
        generate_adjacency_heatmap(
            nodes=component_nodes,
            all_edges=deduplicated_edges,
            feedback_arc_set=feedback_arc_set,
            output_path=heatmap_path,
            title=f"SCC {component_id}: {component_name} — Adjacency Matrix (Blue=Keep, Red=Feedback Arc)",
        )
        if verbose:
            print(f"{SCRIPT_NAME}: Heatmap written to {heatmap_path}")

        # DOT graph
        dot_path = visualizations_directory / f"Minimum_Feedback_Arc_Set_{component_id}.gv"
        generate_dot_graph(
            nodes=component_nodes,
            all_edges=deduplicated_edges,
            feedback_arc_set=feedback_arc_set,
            detail_edges=all_component_detail,
            component_name=f"{component_name} (SCC {component_id})",
            output_path=dot_path,
        )
        if verbose:
            print(f"{SCRIPT_NAME}: DOT graph written to {dot_path}")

    # Write CSVs
    _write_csv(pd.DataFrame(overview_rows), report_directory / "Minimum_Feedback_Arc_Set_Overview.csv")
    _write_csv(pd.DataFrame(edge_rows), report_directory / "Minimum_Feedback_Arc_Set_Edges.csv")
    _write_csv(pd.DataFrame(detail_edge_rows), report_directory / "Minimum_Feedback_Arc_Set_Detail_Edges.csv")

    print(
        f"{SCRIPT_NAME}: {configuration.display_name} — "
        f"{len(overview_rows)} component(s), "
        f"{sum(r['feedbackArcEdgeCount'] for r in overview_rows)} feedback arc(s)."  # type: ignore[call-overload]
    )


def _write_csv(dataframe: pd.DataFrame, path: Path) -> None:
    """Write a DataFrame to CSV using non-numeric quoting for consistent awk parsing."""
    if dataframe.empty:
        return
    dataframe.to_csv(path, index=False, quoting=csv.QUOTE_NONNUMERIC)


# ── Entry point ───────────────────────────────────────────────────────────────


def main() -> None:
    """Run Minimum Feedback Arc Set analysis for all configured node types."""
    parameters = parse_parameters()
    queries_directory = Path(__file__).parent / "queries"

    print(f"{SCRIPT_NAME}: Connecting to Neo4j at {parameters.neo4j_uri}...")
    driver = connect_to_neo4j(parameters.neo4j_uri)

    try:
        for configuration in NODE_TYPE_CONFIGURATIONS:
            print(f"{SCRIPT_NAME}: Processing {configuration.display_name}...")
            analyse_node_type(
                driver=driver,
                configuration=configuration,
                report_base_directory=parameters.report_directory,
                queries_directory=queries_directory,
                verbose=parameters.verbose,
            )
    finally:
        driver.close()

    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
