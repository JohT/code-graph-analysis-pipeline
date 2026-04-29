#!/usr/bin/env python

# Generates 2D UMAP scatter plots of node embeddings stored in Neo4j as SVG files.
# Reads embedding vectors directly from Neo4j (not from CSV files).
# Plots are colored by Leiden community id when available, falling back to PageRank size,
# and finally to a uniform colour when neither property is present.
#
# Charts produced per (node label, embedding algorithm) combination:
#   <NodeLabel>_Embeddings_<Algorithm>_UMAP2D_Scatter.svg
#
# Input Parameters:
#  --report_directory   path to the directory where SVG files will be written
#  --neo4j_uri          Neo4j bolt URI (default: bolt://localhost:7687)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - NEO4J_INITIAL_PASSWORD environment variable must be set.
#  - nodeEmbeddingsCsv.sh must have run at least once so embedding properties exist on graph nodes.
#  - If no embedding data is present the script exits with code 0 without generating any files.

import os
import sys
import argparse
from pathlib import Path

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot
import matplotlib.colors as mpl_colors
import matplotlib.lines as mpl_lines
from neo4j import GraphDatabase, Driver
import umap
from typing import Optional
from sklearn.metrics import silhouette_score as sklearn_silhouette_score
from sklearn.metrics import davies_bouldin_score as sklearn_davies_bouldin_score

SCRIPT_NAME = "nodeEmbeddingsCharts"

FIGURE_WIDTH = 14
FIGURE_HEIGHT = 10

SCATTER_POINT_SIZE_DEFAULT = 10
SCATTER_ALPHA = 1.0
COLORMAP_COMMUNITY = "nipy_spectral"
COLORMAP_CENTRALITY = "viridis"
COMPARISON_GRID_COLUMNS = 2

# Set to True to include GraphSAGE embeddings in charts and comparison grids.
# GraphSAGE is computationally expensive (requires model training) and is therefore disabled by default.
# When True, all node labels will include a GraphSAGE panel; labels without data show "No data available".
GRAPHSAGE_ENABLED: bool = False

ANNOTATION_MAX_NAME_LENGTH = 20
SCATTER_HALO_SIZE_MULTIPLIER = 6
SCATTER_HALO_SIZE_CONSTANT = 12
SCATTER_HALO_ALPHA = 0.12

ANNOTATION_STYLE: dict = {
    "textcoords": "offset points",
    "arrowprops": dict(arrowstyle="->", color="black", alpha=0.3),
    "fontsize": 6,
    "backgroundcolor": "white",
    "bbox": dict(boxstyle="round,pad=0.3", edgecolor="silver", facecolor="whitesmoke", alpha=0.8),
}


# ── Parameters ────────────────────────────────────────────────────────────────

class Parameters:
    """Holds parsed command-line parameters for node-embedding chart generation."""

    def __init__(self, report_directory: str, neo4j_uri: str, verbose: bool) -> None:
        self.report_directory = report_directory
        self.neo4j_uri = neo4j_uri
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters("
            f"report_directory={self.report_directory!r}, "
            f"neo4j_uri={self.neo4j_uri!r}, "
            f"verbose={self.verbose})"
        )

    @staticmethod
    def log_dependency_versions() -> None:
        """Print versions of key dependencies for diagnostics."""
        print("---------------------------------------")
        print(f"Python version: {sys.version}")
        from pandas import __version__ as pandas_version
        print(f"pandas version: {pandas_version}")
        from numpy import __version__ as numpy_version
        print(f"numpy version: {numpy_version}")
        from matplotlib import __version__ as matplotlib_version
        print(f"matplotlib version: {matplotlib_version}")
        from neo4j import __version__ as neo4j_version
        print(f"neo4j version: {neo4j_version}")
        from umap import __version__ as umap_version
        print(f"umap-learn version: {umap_version}")
        print("---------------------------------------")


# ── Community quality scores ──────────────────────────────────────────────────

class CommunityScores:
    """Silhouette and Davies-Bouldin scores measuring embedding-to-community alignment."""

    def __init__(self, silhouette: float, davies_bouldin: float) -> None:
        self.silhouette = silhouette
        self.davies_bouldin = davies_bouldin

    def __repr__(self) -> str:
        return (
            f"CommunityScores(silhouette={self.silhouette:.4f}, "
            f"davies_bouldin={self.davies_bouldin:.4f})"
        )

    @classmethod
    def calculate(cls, data: pd.DataFrame) -> "Optional[CommunityScores]":
        """Compute scores from a DataFrame with 'embedding' and 'communityLeidenId' columns.

        Returns None when community labels are absent or fewer than 2 communities exist.
        """
        if "communityLeidenId" not in data.columns or data["communityLeidenId"].isna().all():
            return None
        labels = data["communityLeidenId"].fillna(-1).astype(int)
        if labels.nunique() < 2:
            return None
        X = np.array(data["embedding"].tolist(), dtype=np.float32)
        silhouette = float(sklearn_silhouette_score(X, labels, metric="cosine"))
        davies_bouldin = float(sklearn_davies_bouldin_score(X, labels))
        return cls(silhouette, davies_bouldin)


def parse_parameters() -> Parameters:
    """Parse command-line arguments and return a Parameters instance."""
    parser = argparse.ArgumentParser(
        description="Generates 2D UMAP scatter plots of node embeddings stored in Neo4j."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="reports/node-embeddings",
        help="Path to the directory where SVG chart files will be written",
    )
    parser.add_argument(
        "--neo4j_uri",
        type=str,
        default="bolt://localhost:7687",
        help="Neo4j bolt URI (default: bolt://localhost:7687)",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        default=False,
        help="Enable verbose mode for detailed logging",
    )
    args = parser.parse_args()
    parameters = Parameters(
        report_directory=args.report_directory,
        neo4j_uri=args.neo4j_uri,
        verbose=args.verbose,
    )
    if parameters.verbose:
        print(f"{SCRIPT_NAME}: {parameters}")
        Parameters.log_dependency_versions()
    return parameters


# ── Neo4j connectivity ────────────────────────────────────────────────────────

def get_graph_database_driver(neo4j_uri: str, verbose: bool) -> Driver:
    """Connect to Neo4j and return a verified driver instance."""
    neo4j_password = os.environ.get("NEO4J_INITIAL_PASSWORD") or ""
    if not neo4j_password:
        print(f"{SCRIPT_NAME}: Warning: NEO4J_INITIAL_PASSWORD environment variable is not set", file=sys.stderr)
    driver = GraphDatabase.driver(
        uri=neo4j_uri,
        auth=("neo4j", neo4j_password),
    )
    driver.verify_connectivity()
    if verbose:
        print(f"{SCRIPT_NAME}: Connected to Neo4j at {neo4j_uri}")
    return driver


# ── Data loading ──────────────────────────────────────────────────────────────

# Maps embedding property names to short algorithm display names used in chart titles and filenames.
# Applied to every node label. GraphSAGE is included only when GRAPHSAGE_ENABLED is True.
EMBEDDING_PROPERTIES: dict[str, str] = {
    "embeddingsFastRandomProjection": "FastRP",
    "embeddingsHashGNN": "HashGNN",
    "embeddingsNode2Vec": "Node2Vec",
    **({
        "embeddingsGraphSAGE": "GraphSAGE",
    } if GRAPHSAGE_ENABLED else {}),
}

# Node labels to generate charts for.
NODE_LABELS: list[str] = ["Artifact", "Package", "Type", "Module"]


def load_embeddings(
    driver: Driver,
    node_label: str,
    embedding_property: str,
    verbose: bool,
) -> pd.DataFrame:
    """Load embedding vectors and optional coloring properties from Neo4j.

    Returns a DataFrame with columns: name, embedding, communityLeidenId (optional),
    centralityPageRank (optional). Returns an empty DataFrame if no nodes have the property set.
    """
    # Validate against allowlists as defense-in-depth before passing to the query.
    if node_label not in NODE_LABELS:
        raise ValueError(f"{SCRIPT_NAME}: Unknown node label {node_label!r}. Expected one of: {NODE_LABELS}")
    if embedding_property not in EMBEDDING_PROPERTIES:
        raise ValueError(f"{SCRIPT_NAME}: Unknown embedding property {embedding_property!r}. Expected one of: {list(EMBEDDING_PROPERTIES.keys())}")
    # Use Cypher parameter syntax throughout:
    #   $node_label IN labels(n)  — avoids embedding the label name in the query string
    #   n[$embedding_property]    — avoids embedding the property name in the query string
    # This follows the same pattern as Dependencies_0_Check_Projectable.cypher.
    query = (
        "MATCH (codeUnit) "
        "WHERE $node_label IN labels(codeUnit) "
        "  AND codeUnit[$embedding_property] IS NOT NULL "
        "RETURN "
        "  coalesce(codeUnit.name, split(toString(elementId(codeUnit)), ':')[-1]) AS short_name, "
        "  codeUnit[$embedding_property] AS embedding, "
        "  codeUnit.communityLeidenId    AS communityLeidenId, "
        "  codeUnit.centralityPageRank   AS centralityPageRank"
    )
    with driver.session() as session:
        result = session.run(query, node_label=node_label, embedding_property=embedding_property)
        records = result.data()
    if not records:
        if verbose:
            print(f"{SCRIPT_NAME}: No nodes with label {node_label!r} have property {embedding_property!r} — skipping")
        return pd.DataFrame()
    data_frame = pd.DataFrame(records)
    if verbose:
        print(f"{SCRIPT_NAME}: Loaded {len(data_frame)} {node_label} nodes with {embedding_property}")
    return data_frame


# ── UMAP dimensionality reduction ─────────────────────────────────────────────

def apply_umap(embeddings_data: pd.DataFrame, verbose: bool) -> pd.DataFrame:
    """Reduce the embedding vectors to 2D coordinates using UMAP.

    Args:
        embeddings_data: DataFrame with an 'embedding' column of float arrays.
        verbose: Whether to log progress.

    Returns:
        A copy of the input DataFrame with additional columns 'umap_x' and 'umap_y'.
    """
    embedding_matrix = np.array(embeddings_data["embedding"].tolist(), dtype=np.float32)
    n_neighbors = min(15, len(embedding_matrix) - 1)
    reducer = umap.UMAP(n_components=2, n_neighbors=n_neighbors, random_state=42, n_jobs=1)
    coordinates = reducer.fit_transform(embedding_matrix)
    coordinates = np.asarray(coordinates) # Convert to dense numpy array
    result = embeddings_data.copy()
    result["umap_x"] = coordinates[:, 0]
    result["umap_y"] = coordinates[:, 1]
    if verbose:
        print(f"{SCRIPT_NAME}: UMAP reduction complete — {len(result)} points projected to 2D")
    return result


# ── Annotation helpers ────────────────────────────────────────────────────────

def _truncate_name(text: str, max_length: int = ANNOTATION_MAX_NAME_LENGTH) -> str:
    """Truncate text to max_length, replacing the last three characters with '...' when exceeded."""
    if len(text) <= max_length:
        return text
    return text[:max_length - 3] + "..."


def _find_community_medoids(data: pd.DataFrame) -> pd.DataFrame:
    """Return one representative row per community — the point closest to the community centroid."""
    medoids = []
    for _, group in data.groupby("communityLeidenId"):
        cx = group["umap_x"].median()
        cy = group["umap_y"].median()
        distances = (group["umap_x"] - cx) ** 2 + (group["umap_y"] - cy) ** 2
        medoids.append(data.loc[distances.idxmin()])
    return pd.DataFrame(medoids).reset_index(drop=True)


def _find_top_k_community_medoids(data: pd.DataFrame, k: int = 20) -> pd.DataFrame:
    """Return medoids for the k largest communities only."""
    top_communities = (
        data.groupby("communityLeidenId")
        .size()
        .nlargest(k)
        .index
    )
    return _find_community_medoids(data[data["communityLeidenId"].isin(top_communities)])


def _compute_point_sizes(data: pd.DataFrame) -> "pd.Series":
    """Compute per-node scatter sizes scaled by PageRank centrality.

    Mirrors the original notebook formula: clip(normalized * 50, max=30) + 2, giving a range of [2, 32].
    Falls back to SCATTER_POINT_SIZE_DEFAULT for all nodes when centrality is absent.
    """
    if "centralityPageRank" not in data.columns or data["centralityPageRank"].isna().all():
        return pd.Series([SCATTER_POINT_SIZE_DEFAULT] * len(data), index=data.index)
    centrality = data["centralityPageRank"].fillna(0.0)
    max_value = centrality.max()
    min_value = centrality.min()
    range_value = max_value - min_value if max_value > min_value else 1.0
    normalized = (centrality - min_value) / range_value
    return np.clip(normalized * 50, None, 30) + 2


# ── Chart generation ──────────────────────────────────────────────────────────

def _scatter_with_halo(
    axis: plot.Axes,
    x: "pd.Series",
    y: "pd.Series",
    **scatter_kwargs,
) -> object:
    """Draw a transparent halo behind the main scatter points for a shadow effect."""
    size = scatter_kwargs.pop("s", SCATTER_POINT_SIZE_DEFAULT)
    alpha = scatter_kwargs.pop("alpha", SCATTER_ALPHA)
    # Transparent halo — kept tight to avoid obscuring neighbouring points
    axis.scatter(x, y, s=size * SCATTER_HALO_SIZE_MULTIPLIER + SCATTER_HALO_SIZE_CONSTANT, alpha=SCATTER_HALO_ALPHA, linewidths=0, **scatter_kwargs)
    # Main opaque points
    return axis.scatter(x, y, s=size, alpha=alpha, linewidths=1, **scatter_kwargs)


def _annotate_community_medoids(axis: plot.Axes, reduced_data: pd.DataFrame) -> None:
    """Annotate community representative (medoid) nodes and the top-5 centrality nodes."""
    has_short_name = "short_name" in reduced_data.columns
    has_centrality = (
        "centralityPageRank" in reduced_data.columns
        and reduced_data["centralityPageRank"].notna().any()
    )
    if not has_short_name:
        return
    medoids = _find_top_k_community_medoids(reduced_data)
    if has_centrality:
        for _, row in reduced_data.nlargest(5, "centralityPageRank").iterrows():
            axis.annotate(
                _truncate_name(row["short_name"]),
                (row["umap_x"], row["umap_y"]),
                xytext=(5, 5),
                color="grey",
                **ANNOTATION_STYLE,
            )
    for _, row in medoids.iterrows():
        axis.annotate(
            f"{_truncate_name(row['short_name'])}({int(row['communityLeidenId'])})",
            (row["umap_x"], row["umap_y"]),
            xytext=(5, 5),
            **ANNOTATION_STYLE,
        )
    legend_elements: list[mpl_lines.Line2D] = [
        mpl_lines.Line2D(
            [0], [0], marker="o", color="w",
            label="Community representative (medoid)",
            markerfacecolor="black", markeredgecolor="black", markersize=5,
        ),
    ]
    if has_centrality:
        legend_elements.append(
            mpl_lines.Line2D(
                [0], [0], marker="o", color="w",
                label="Top PageRank centrality node",
                markerfacecolor="grey", markeredgecolor="grey", markersize=5,
            )
        )
    axis.legend(handles=legend_elements, loc="upper left", fontsize=6, framealpha=0.8)


def _plot_by_community(
    figure: plot.Figure,
    axis: plot.Axes,
    reduced_data: pd.DataFrame,
) -> str:
    """Colour scatter points by Leiden community id, add a labelled colorbar, and annotate medoids."""
    community_ids = reduced_data["communityLeidenId"].fillna(-1).astype(int)
    unique_community_count = community_ids.nunique()
    colormap = plot.get_cmap(COLORMAP_COMMUNITY, unique_community_count)
    normalizer = mpl_colors.BoundaryNorm(
        boundaries=range(unique_community_count + 1),
        ncolors=unique_community_count,
    )
    community_rank = pd.Categorical(community_ids).codes
    scatter = _scatter_with_halo(
        axis,
        reduced_data["umap_x"],
        reduced_data["umap_y"],
        c=community_rank,
        cmap=colormap,
        norm=normalizer,
        s=_compute_point_sizes(reduced_data),
        alpha=SCATTER_ALPHA,
    )
    colour_bar = figure.colorbar(scatter, ax=axis, label="Leiden Community ID")
    colour_bar.set_ticks([])
    _annotate_community_medoids(axis, reduced_data)
    return f"coloured by {unique_community_count} Leiden communities"


def _plot_by_centrality(
    figure: plot.Figure,
    axis: plot.Axes,
    reduced_data: pd.DataFrame,
) -> str:
    """Size and colour scatter points by PageRank centrality and add a labelled colorbar."""
    page_rank_values = reduced_data["centralityPageRank"].fillna(0.0)
    min_rank = page_rank_values.min()
    max_rank = page_rank_values.max()
    rank_range = max_rank - min_rank if max_rank > min_rank else 1.0
    point_sizes = 5 + 195 * (page_rank_values - min_rank) / rank_range
    scatter = axis.scatter(
        reduced_data["umap_x"],
        reduced_data["umap_y"],
        c=page_rank_values,
        cmap=COLORMAP_CENTRALITY,
        s=point_sizes,
        alpha=SCATTER_ALPHA,
    )
    figure.colorbar(scatter, ax=axis, label="PageRank Centrality")
    return "sized/coloured by PageRank"


def _configure_scatter_axes(
    axis: plot.Axes,
    node_label: str,
    algorithm_name: str,
    scores: "Optional[CommunityScores]",
    title_suffix: str,
) -> None:
    """Set chart title (with optional quality scores), axis labels, and tick label size."""
    title_lines = [f"{node_label} — {algorithm_name} Embeddings (UMAP 2D)"]
    if scores is not None:
        title_lines.append(
            f"Silhouette Score (aim higher) = {scores.silhouette:.4f}  "
            f"Davies-Bouldin Score (aim lower) = {scores.davies_bouldin:.4f}"
        )
    if title_suffix:
        title_lines.append(title_suffix)
    axis.set_title("\n".join(title_lines))
    axis.set_xlabel("UMAP Dimension 1")
    axis.set_ylabel("UMAP Dimension 2")
    axis.tick_params(axis="both", labelsize=7)


def generate_embedding_scatter(
    reduced_data: pd.DataFrame,
    node_label: str,
    algorithm_name: str,
    report_directory: str,
    verbose: bool,
    scores: "Optional[CommunityScores]" = None,
) -> None:
    """Generate and save a 2D UMAP scatter plot of node embeddings as an SVG file.

    Colours points by Leiden community id when available, adds a shadow halo effect,
    annotates community medoids and top-centrality nodes.
    Falls back to PageRank-proportional point sizes when Leiden ids are absent.
    Uses uniform colour and size when neither property is present.

    Args:
        reduced_data: DataFrame with umap_x, umap_y, communityLeidenId, centralityPageRank columns.
        node_label: Label of the node type (used in title and filename).
        algorithm_name: Short display name of the embedding algorithm.
        report_directory: Directory where the SVG file will be saved.
        verbose: Whether to log progress.
        scores: Optional pre-computed community quality scores to include in the title.
    """
    has_community = (
        "communityLeidenId" in reduced_data.columns
        and reduced_data["communityLeidenId"].notna().any()
    )
    has_centrality = (
        "centralityPageRank" in reduced_data.columns
        and reduced_data["centralityPageRank"].notna().any()
    )

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH, FIGURE_HEIGHT))

    if has_community:
        title_suffix = _plot_by_community(figure, axis, reduced_data)
    elif has_centrality:
        title_suffix = _plot_by_centrality(figure, axis, reduced_data)
    else:
        axis.scatter(
            reduced_data["umap_x"],
            reduced_data["umap_y"],
            color="steelblue",
            s=SCATTER_POINT_SIZE_DEFAULT,
            alpha=SCATTER_ALPHA,
        )
        title_suffix = ""

    _configure_scatter_axes(axis, node_label, algorithm_name, scores, title_suffix)

    chart_name = f"{node_label}_Embeddings_{algorithm_name}_UMAP2D_Scatter"
    output_path = Path(report_directory) / f"{chart_name}.svg"
    figure.savefig(str(output_path), format="svg", bbox_inches="tight")
    plot.close(figure)
    if verbose:
        print(f"{SCRIPT_NAME}: Saved chart to {output_path}")


# ── Comparison grid ──────────────────────────────────────────────────────────

def _render_no_data_subplot(ax: plot.Axes, algorithm_name: str) -> None:
    """Render a placeholder panel with a 'No data available' message for a missing algorithm."""
    ax.set_title(algorithm_name, fontsize=8)
    ax.text(
        0.5, 0.5, "No data available",
        ha="center", va="center",
        transform=ax.transAxes,
        fontsize=9, color="grey",
    )
    ax.set_xticks([])
    ax.set_yticks([])


def _render_data_subplot(
    ax: plot.Axes,
    reduced_data: pd.DataFrame,
    algorithm_name: str,
) -> None:
    """Render one data subplot in the comparison grid with community or centrality colouring."""
    scores = CommunityScores.calculate(reduced_data)
    has_community = (
        "communityLeidenId" in reduced_data.columns
        and reduced_data["communityLeidenId"].notna().any()
    )
    has_centrality = (
        "centralityPageRank" in reduced_data.columns
        and reduced_data["centralityPageRank"].notna().any()
    )

    if has_community:
        community_ids = reduced_data["communityLeidenId"].fillna(-1).astype(int)
        unique_count = community_ids.nunique()
        colormap = plot.get_cmap(COLORMAP_COMMUNITY, unique_count)
        normalizer = mpl_colors.BoundaryNorm(
            boundaries=range(unique_count + 1), ncolors=unique_count
        )
        community_rank = pd.Categorical(community_ids).codes
        _scatter_with_halo(
            ax,
            reduced_data["umap_x"],
            reduced_data["umap_y"],
            c=community_rank,
            cmap=colormap,
            norm=normalizer,
            s=_compute_point_sizes(reduced_data),
            alpha=SCATTER_ALPHA,
        )
        _annotate_community_medoids(ax, reduced_data)
    elif has_centrality:
        page_rank_values = reduced_data["centralityPageRank"].fillna(0.0)
        min_rank, max_rank = page_rank_values.min(), page_rank_values.max()
        rank_range = max_rank - min_rank if max_rank > min_rank else 1.0
        point_sizes = 5 + 195 * (page_rank_values - min_rank) / rank_range
        ax.scatter(
            reduced_data["umap_x"],
            reduced_data["umap_y"],
            c=page_rank_values,
            cmap=COLORMAP_CENTRALITY,
            s=point_sizes,
            alpha=SCATTER_ALPHA,
        )
    else:
        ax.scatter(
            reduced_data["umap_x"],
            reduced_data["umap_y"],
            color="steelblue",
            s=SCATTER_POINT_SIZE_DEFAULT,
            alpha=SCATTER_ALPHA,
        )

    title_lines = [algorithm_name]
    if scores is not None:
        title_lines.append(
            f"Silhouette (aim higher)={scores.silhouette:.3f}  Davies-Bouldin (aim lower)={scores.davies_bouldin:.3f}"
        )
    ax.set_title("\n".join(title_lines), fontsize=8)
    ax.set_xticks([])
    ax.set_yticks([])


def generate_embedding_comparison_grid(
    all_reduced: "list[tuple[Optional[pd.DataFrame], str]]",
    node_label: str,
    report_directory: str,
    verbose: bool,
) -> None:
    """Generate a grid chart comparing all embedding algorithms for one node label.

    Each subplot uses the same shadow/halo and community-colouring style as the
    individual scatter charts.  The grid has COMPARISON_GRID_COLUMNS columns.
    Entries with None data are rendered as a "No data available" placeholder panel,
    so the grid layout is always consistent (e.g. always 2x2 when 4 algorithms expected).
    Output filename: <NodeLabel>_Embeddings_Comparison_UMAP2D_Grid.svg

    Args:
        all_reduced: List of (reduced_data_or_None, algorithm_name) pairs for this node label.
        node_label: Label of the node type (used in suptitle and filename).
        report_directory: Directory where the SVG file will be saved.
        verbose: Whether to log progress.
    """
    if not all_reduced:
        return

    n_cols = COMPARISON_GRID_COLUMNS
    n_rows = (len(all_reduced) + n_cols - 1) // n_cols
    grid_w = FIGURE_WIDTH // 2 * n_cols
    grid_h = FIGURE_HEIGHT // 2 * n_rows
    figure, axes_grid = plot.subplots(n_rows, n_cols, figsize=(grid_w, grid_h))
    axes_flat = np.array(axes_grid).flatten()

    for idx, (reduced_data, algorithm_name) in enumerate(all_reduced):
        ax = axes_flat[idx]
        if reduced_data is None:
            _render_no_data_subplot(ax, algorithm_name)
        else:
            _render_data_subplot(ax, reduced_data, algorithm_name)

    for j in range(len(all_reduced), len(axes_flat)):
        axes_flat[j].axis("off")

    figure.suptitle(
        f"{node_label} — Embedding Algorithm Comparison (UMAP 2D)", fontsize=10
    )
    plot.tight_layout()
    chart_name = f"{node_label}_Embeddings_Comparison_UMAP2D_Grid"
    output_path = Path(report_directory) / f"{chart_name}.svg"
    figure.savefig(str(output_path), format="svg", bbox_inches="tight")
    plot.close(figure)
    if verbose:
        print(f"{SCRIPT_NAME}: Saved comparison grid to {output_path}")


# ── Main entry point ──────────────────────────────────────────────────────────

def _generate_charts_for_label(
    driver: Driver,
    node_label: str,
    report_directory: str,
    verbose: bool,
) -> int:
    """Generate scatter charts and a comparison grid for all embedding algorithms of one node label.

    Returns:
        The number of charts generated for this label.
    """
    all_reduced_for_label: list[tuple[pd.DataFrame | None, str]] = []
    charts_generated = 0
    for embedding_property, algorithm_name in EMBEDDING_PROPERTIES.items():
        embeddings_data = load_embeddings(
            driver, node_label, embedding_property, verbose
        )
        if embeddings_data.empty:
            all_reduced_for_label.append((None, algorithm_name))
            continue

        reduced_data = apply_umap(embeddings_data, verbose)
        scores = CommunityScores.calculate(embeddings_data)
        generate_embedding_scatter(
            reduced_data,
            node_label,
            algorithm_name,
            report_directory,
            verbose,
            scores,
        )
        all_reduced_for_label.append((reduced_data, algorithm_name))
        charts_generated += 1

    has_data = any(d is not None for d, _ in all_reduced_for_label)
    if has_data and len(all_reduced_for_label) > 1:
        generate_embedding_comparison_grid(
            all_reduced_for_label, node_label, report_directory, verbose
        )
        charts_generated += 1

    return charts_generated


def main() -> None:
    """Generate UMAP 2D scatter plots for all available node embedding properties."""
    parameters = parse_parameters()
    report_directory = parameters.report_directory

    Path(report_directory).mkdir(parents=True, exist_ok=True)

    driver = get_graph_database_driver(parameters.neo4j_uri, parameters.verbose)

    total_charts = 0
    try:
        for node_label in NODE_LABELS:
            total_charts += _generate_charts_for_label(
                driver, node_label, report_directory, parameters.verbose
            )
    finally:
        driver.close()

    if parameters.verbose:
        print(f"{SCRIPT_NAME}: Generated {total_charts} charts in {report_directory!r}")

    if total_charts == 0:
        print(f"{SCRIPT_NAME}: No embedding properties found in Neo4j — no charts generated")


if __name__ == "__main__":
    main()
