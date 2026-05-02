#!/usr/bin/env python

# Generates overview charts as SVG files and derived CSV files from Neo4j graph data.
# Covers general graph structure (node labels, relationship types, graph density),
# Java artifact type composition (Class, Interface, Enum, Annotation), and
# TypeScript module element composition (TypeAlias, Interface, Variable, Function).
#
# SVG files produced:
#   Overview_General_Node_Label_Combination_Count_High.svg
#   Overview_General_Node_Label_Combination_Count_Low.svg
#   Overview_General_Node_Label_Count.svg
#   Overview_General_Relationship_Type_Count_High.svg
#   Overview_General_Relationship_Type_Count_Low.svg
#   Overview_Java_Types_Per_Artifact_Stacked.svg
#   Overview_Java_Class_Types_Per_Artifact_Normalized.svg
#   Overview_Java_Interface_Types_Per_Artifact_Normalized.svg
#   Overview_Java_Enum_Types_Per_Artifact_Normalized.svg
#   Overview_Java_Annotation_Types_Per_Artifact_Normalized.svg
#   Overview_Java_Packages_Per_Artifact.svg
#   Overview_Typescript_Elements_Per_Module_Stacked.svg
#   Overview_Typescript_TypeAlias_Elements_Per_Module_Normalized.svg
#   Overview_Typescript_Interface_Elements_Per_Module_Normalized.svg
#   Overview_Typescript_Variable_Elements_Per_Module_Normalized.svg
#   Overview_Typescript_Function_Elements_Per_Module_Normalized.svg
#
# Derived CSV files produced:
#   Overview_General_Graph_Density.csv
#   Java_Types_Per_Artifact_Grouped.csv
#   Java_Types_Per_Artifact_Grouped_Normalized.csv
#   Typescript_Elements_Per_Module_Grouped.csv
#   Typescript_Elements_Per_Module_Grouped_Normalized.csv
#
# Input Parameters:
#  --report_directory   path to the directory where output files will be written
#  --neo4j_uri          Neo4j bolt URI (default: bolt://localhost:7687)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - NEO4J_INITIAL_PASSWORD environment variable must be set.
#  - At least one Java or TypeScript code artifact must be scanned and imported.
#  - If no data is present the script exits with code 0 without generating any files.

import os
import sys
import argparse
from pathlib import Path

import pandas as pd
import numpy as np
import matplotlib
matplotlib.use("Agg")  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot
from neo4j import GraphDatabase, Driver

SCRIPT_NAME = "overviewCharts"

FIGURE_WIDTH_PIE = 9
FIGURE_HEIGHT_PIE = 9
FIGURE_WIDTH_BAR = 9
FIGURE_HEIGHT_BAR = 6
FIGURE_WIDTH_NODE_LABEL_GRID = 10
FIGURE_HEIGHT_NODE_LABEL_GRID = 10

MAIN_COLORMAP = "nipy_spectral"

# Percentage threshold below which label combination slices are combined into "others" for the high chart
NODE_LABEL_COMBINATION_HIGH_THRESHOLD = 0.5
# Percentage threshold below which label combinations are combined into "others" for the low chart
NODE_LABEL_COMBINATION_LOW_THRESHOLD = 0.3
# Percentage threshold for the boundary between the high and low node label combination charts
NODE_LABEL_COMBINATION_BOUNDARY_PERCENT = 0.50

RELATIONSHIP_TYPE_HIGH_THRESHOLD = 0.5
RELATIONSHIP_TYPE_LOW_THRESHOLD = 0.3
RELATIONSHIP_TYPE_BOUNDARY_PERCENT = 0.50

PACKAGES_PER_ARTIFACT_THRESHOLD = 0.7

TOP_THIRTY = 30
TOP_FORTY = 40

PIE_LABEL_FONTSIZE = 6
PIE_PCT_DISTANCE = 1.15
PIE_BASE_EXPLODE = 0.02
PIE_OTHERS_EXPLODE = 0.2


# ── Parameters ────────────────────────────────────────────────────────────────

class Parameters:
    """Holds parsed command-line parameters for overview chart generation."""

    def __init__(self, report_directory: Path, neo4j_uri: str, verbose: bool) -> None:
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


def parse_parameters() -> Parameters:
    """Parse command-line arguments and return a Parameters instance."""
    parser = argparse.ArgumentParser(
        description="Generates overview SVG charts and derived CSV files from Neo4j graph data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="reports/overview",
        help="Path to the directory where output files will be written",
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
    return Parameters(
        report_directory=Path(args.report_directory),
        neo4j_uri=args.neo4j_uri,
        verbose=args.verbose,
    )


# ── Neo4j connectivity ────────────────────────────────────────────────────────

def get_graph_database_driver(neo4j_uri: str, verbose: bool) -> Driver:
    """Connect to Neo4j and return a verified driver instance."""
    neo4j_password = os.environ.get("NEO4J_INITIAL_PASSWORD") or ""
    if not neo4j_password:
        print(
            f"{SCRIPT_NAME}: Error: NEO4J_INITIAL_PASSWORD environment variable must be set",
            file=sys.stderr,
        )
        raise ValueError("NEO4J_INITIAL_PASSWORD environment variable is required to connect to Neo4j")
    driver = GraphDatabase.driver(uri=neo4j_uri, auth=("neo4j", neo4j_password))
    driver.verify_connectivity()
    if verbose:
        print(f"{SCRIPT_NAME}: Connected to Neo4j at {neo4j_uri}")
    return driver


# ── Query helpers ─────────────────────────────────────────────────────────────

def read_cypher_file(cypher_file_path: Path, limit: int = -1) -> str:
    """Read a Cypher query file and optionally append a LIMIT clause.

    Args:
        cypher_file_path: Path to the .cypher file.
        limit: Maximum number of rows to return. A value of -1 means no limit is appended.

    Returns:
        The Cypher query string, with an optional LIMIT clause appended.
    """
    with cypher_file_path.open(encoding="utf-8") as cypher_file:
        query = " ".join(cypher_file.readlines())
    if limit > 0:
        query = f"{query}\nLIMIT {limit}"
    return query


def query_cypher_to_dataframe(driver: Driver, cypher_query: str) -> pd.DataFrame:
    """Execute a Cypher query and return the result as a DataFrame.

    Args:
        driver: A connected Neo4j driver instance.
        cypher_query: The Cypher query string to execute.

    Returns:
        A DataFrame containing the query results, or an empty DataFrame if no results.
    """
    records, _summary, keys = driver.execute_query(cypher_query)
    return pd.DataFrame([record.values() for record in records], columns=keys)


# ── Data helpers ──────────────────────────────────────────────────────────────

def group_to_others_below_threshold(
    data_frame: pd.DataFrame,
    value_column: str,
    name_column: str,
    threshold: float,
) -> pd.DataFrame:
    """Group rows below a percentage threshold into an 'others' category.

    Computes a fresh percentage column from value_column, replaces the name of any row
    below threshold percent with 'others', then aggregates (sums) and sorts descending.

    Args:
        data_frame: Input DataFrame.
        value_column: Name of the numeric value column used to compute percentages.
        name_column: Name of the column whose small values will be replaced with 'others'.
        threshold: Percentage threshold below which rows are grouped into 'others'.

    Returns:
        A new DataFrame with a percentage column added and 'others' grouping applied.
    """
    result = data_frame[[name_column, value_column]].copy()
    percent_column_name = f"{value_column}Percent"
    result[percent_column_name] = result[value_column] / result[value_column].sum() * 100.0
    result[name_column] = result[name_column].astype(str)
    result.loc[result[percent_column_name] < threshold, name_column] = "others"
    result = result.groupby(name_column).sum()
    return result.sort_values(by=percent_column_name, ascending=False)


def explode_index_value(
    data_frame: pd.DataFrame,
    index_value: str = "others",
    base_value: float = PIE_BASE_EXPLODE,
    emphasize_value: float = PIE_OTHERS_EXPLODE,
) -> np.ndarray:
    """Compute pie-slice explode offsets, emphasizing one named slice.

    Args:
        data_frame: DataFrame whose index provides the slice labels.
        index_value: The index label to emphasize (default: 'others').
        base_value: Base offset applied to every slice.
        emphasize_value: Additional offset applied only to the emphasized slice.

    Returns:
        A numpy array of explode values with the same length as the number of rows.
    """
    return (data_frame.index == index_value) * emphasize_value + base_value


# ── Chart helpers ─────────────────────────────────────────────────────────────

def plot_pie_chart(
    data_frame: pd.DataFrame,
    title: str,
    file_path: Path,
) -> None:
    """Generate a pie chart from a grouped DataFrame and save it as an SVG file.

    The first column in data_frame is treated as the count column. The matching
    percentage column (with 'Percent' suffix) must also be present, as produced
    by group_to_others_below_threshold.

    Args:
        data_frame: DataFrame indexed by category names, with count and percent columns.
        title: Chart title displayed above the pie.
        file_path: Path to the output SVG file.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data to plot for '{title}' — skipping.")
        return

    count_column_name = data_frame.columns[0]
    percent_column_name = f"{count_column_name}Percent"
    total_sum = float(data_frame[count_column_name].sum())

    def format_percentage(percentage: float) -> str:
        return f"{percentage:1.2f}% ({total_sum * percentage / 100.0:.0f})"

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH_PIE, FIGURE_HEIGHT_PIE))
    data_frame.plot(
        ax=axis,
        kind="pie",
        y=percent_column_name,
        ylabel="",
        legend=True,
        labeldistance=None,
        autopct=format_percentage,
        textprops={"fontsize": PIE_LABEL_FONTSIZE},
        pctdistance=PIE_PCT_DISTANCE,
        cmap=MAIN_COLORMAP,
        explode=explode_index_value(data_frame),
    )
    axis.set_title(title, pad=15)
    axis.legend(bbox_to_anchor=(1.08, 1), loc="upper left")
    figure.savefig(file_path, format="svg", bbox_inches="tight")
    plot.close(figure)
    print(f"{SCRIPT_NAME}: Saved {file_path.name}")


def plot_stacked_bar_chart(
    data_frame: pd.DataFrame,
    title: str,
    x_label: str,
    y_label: str,
    file_path: Path,
    x_column: str | None = None,
) -> None:
    """Generate a stacked bar chart and save it as an SVG file.

    Args:
        data_frame: DataFrame with category columns and artifact/module rows.
        title: Chart title.
        x_label: Label for the horizontal axis.
        y_label: Label for the vertical axis.
        file_path: Path to the output SVG file.
        x_column: Column name to use as the x-axis labels. When None, the index is used.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data to plot for '{title}' — skipping.")
        return

    figure, axis = plot.subplots(figsize=(FIGURE_WIDTH_BAR, FIGURE_HEIGHT_BAR))
    plot_kwargs: dict = {"ax": axis, "kind": "bar", "stacked": True, "cmap": MAIN_COLORMAP}
    if x_column is not None:
        plot_kwargs["x"] = x_column
    data_frame.plot(**plot_kwargs)
    axis.set_title(title)
    axis.set_xlabel(x_label)
    axis.set_ylabel(y_label)
    figure.savefig(file_path, format="svg", bbox_inches="tight")
    plot.close(figure)
    print(f"{SCRIPT_NAME}: Saved {file_path.name}")


# ── General charts ────────────────────────────────────────────────────────────

def generate_general_charts(
    driver: Driver,
    queries_directory: Path,
    report_directory: Path,
    verbose: bool,
) -> None:
    """Generate general graph overview SVG charts and write the graph density CSV.

    Covers node label combinations (high/low split), individual node label bar charts,
    relationship type distributions (high/low split), and graph density metrics.

    Args:
        driver: Connected Neo4j driver instance.
        queries_directory: Path to the directory containing .cypher query files.
        report_directory: Path to the directory where output files will be written.
        verbose: Whether to log progress.
    """
    if verbose:
        print(f"{SCRIPT_NAME}: Generating general charts...")

    # ── Node label combinations ──────────────────────────────────────────────

    node_label_combination_data = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Node_label_combination_count.cypher"),
    )

    total_nodes = 0
    if not node_label_combination_data.empty:
        total_nodes = int(node_label_combination_data["nodesWithThatLabels"].sum())

        node_label_combination_high = group_to_others_below_threshold(
            data_frame=node_label_combination_data,
            value_column="nodesWithThatLabels",
            name_column="nodeLabels",
            threshold=NODE_LABEL_COMBINATION_HIGH_THRESHOLD,
        )
        plot_pie_chart(
            data_frame=node_label_combination_high,
            title="Nodes per label combination (more than 0.5% overall)",
            file_path=report_directory / "Overview_General_Node_Label_Combination_Count_High.svg",
        )

        node_label_combination_low = node_label_combination_data.sort_values(
            by="nodesWithThatLabels", ascending=True
        )
        node_label_combination_low = node_label_combination_low[
            node_label_combination_low["nodesWithThatLabelsPercent"] <= NODE_LABEL_COMBINATION_BOUNDARY_PERCENT
        ].reset_index(drop=True)

        if not node_label_combination_low.empty:
            node_label_combination_low_grouped = group_to_others_below_threshold(
                data_frame=node_label_combination_low,
                value_column="nodesWithThatLabels",
                name_column="nodeLabels",
                threshold=NODE_LABEL_COMBINATION_LOW_THRESHOLD,
            )
            plot_pie_chart(
                data_frame=node_label_combination_low_grouped,
                title="Nodes per label combination (less than 0.5% overall)",
                file_path=report_directory / "Overview_General_Node_Label_Combination_Count_Low.svg",
            )

    # ── Individual node labels — 2×2 grid of bar charts ─────────────────────

    node_label_count_data = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Node_label_count.cypher"),
    )

    if not node_label_count_data.empty:
        figure, axes = plot.subplots(
            nrows=2,
            ncols=2,
            figsize=(FIGURE_WIDTH_NODE_LABEL_GRID, FIGURE_HEIGHT_NODE_LABEL_GRID),
        )
        figure.suptitle("Node count by label", fontsize=20)
        # Dynamically derive quadrant ranges based on actual data size
        labels_count = len(node_label_count_data)
        items_per_quadrant = (labels_count + 3) // 4  # Round up to distribute evenly
        quadrant_ranges = [
            (i * items_per_quadrant, min((i + 1) * items_per_quadrant, labels_count))
            for i in range(4)
        ]
        for quadrant_index, (start, end) in enumerate(quadrant_ranges):
            row_index = quadrant_index // 2
            column_index = quadrant_index % 2
            quadrant_data = node_label_count_data.iloc[start:end]
            # Skip empty slices
            if not quadrant_data.empty:
                quadrant_data.plot(
                    ax=axes[row_index, column_index],
                    kind="bar",
                    grid=True,
                    x="nodeLabel",
                    y="nodesWithThatLabel",
                    xlabel="node label",
                    ylabel="number of nodes",
                    legend=False,
                    fontsize=8,
                )
            else:
                axes[row_index, column_index].text(
                    0.5,
                    0.5,
                    "No data for this range",
                    ha="center",
                    va="center",
                    transform=axes[row_index, column_index].transAxes,
                )
        figure.savefig(
            report_directory / "Overview_General_Node_Label_Count.svg",
            format="svg",
            bbox_inches="tight",
        )
        plot.close(figure)
        print(f"{SCRIPT_NAME}: Saved Overview_General_Node_Label_Count.svg")

    # ── Relationship types ───────────────────────────────────────────────────

    relationship_type_data = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Relationship_type_count.cypher"),
    )

    total_relationships = 0
    if not relationship_type_data.empty:
        total_relationships = int(relationship_type_data["nodesWithThatRelationshipType"].sum())

        relationship_type_high = group_to_others_below_threshold(
            data_frame=relationship_type_data,
            value_column="nodesWithThatRelationshipType",
            name_column="relationshipType",
            threshold=RELATIONSHIP_TYPE_HIGH_THRESHOLD,
        )
        plot_pie_chart(
            data_frame=relationship_type_high,
            title="Relationship types (more than 0.5% overall)",
            file_path=report_directory / "Overview_General_Relationship_Type_Count_High.svg",
        )

        relationship_type_low = relationship_type_data.sort_values(
            by="nodesWithThatRelationshipType", ascending=True
        )
        relationship_type_low = relationship_type_low[
            relationship_type_low["nodesWithThatRelationshipTypePercent"] <= RELATIONSHIP_TYPE_BOUNDARY_PERCENT
        ].reset_index(drop=True)

        if not relationship_type_low.empty:
            relationship_type_low_grouped = group_to_others_below_threshold(
                data_frame=relationship_type_low,
                value_column="nodesWithThatRelationshipType",
                name_column="relationshipType",
                threshold=RELATIONSHIP_TYPE_LOW_THRESHOLD,
            )
            plot_pie_chart(
                data_frame=relationship_type_low_grouped,
                title="Relationship types (less than 0.5% overall)",
                file_path=report_directory / "Overview_General_Relationship_Type_Count_Low.svg",
            )

    # ── Graph density ────────────────────────────────────────────────────────

    if total_nodes > 0:
        directed_density = (
            total_relationships / (total_nodes * (total_nodes - 1))
            if total_nodes > 1
            else 0.0
        )
        density_data_frame = pd.DataFrame({
            "total_nodes": [total_nodes],
            "total_relationships": [total_relationships],
            "directed_graph_density": [directed_density],
            "directed_graph_density_percent": [directed_density * 100],
        })
        density_csv_path = report_directory / "Overview_General_Graph_Density.csv"
        density_data_frame.to_csv(density_csv_path, index=False)
        if verbose:
            print(f"{SCRIPT_NAME}: Saved Overview_General_Graph_Density.csv")


# ── Java charts ───────────────────────────────────────────────────────────────

def generate_java_charts(
    driver: Driver,
    queries_directory: Path,
    report_directory: Path,
    verbose: bool,
) -> None:
    """Generate Java overview SVG charts and derived pivot CSV files.

    Produces stacked bar charts for artifact type composition (Class, Interface,
    Enum, Annotation) and a pie chart for package counts per artifact. Skips all
    charts silently if no Java type data is present.

    Args:
        driver: Connected Neo4j driver instance.
        queries_directory: Path to the directory containing .cypher query files.
        report_directory: Path to the directory where output files will be written.
        verbose: Whether to log progress.
    """
    if verbose:
        print(f"{SCRIPT_NAME}: Generating Java charts...")

    types_per_artifact = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Number_of_types_per_artifact.cypher"),
    )

    if types_per_artifact.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: No Java type data found — skipping Java charts.")
        return

    # ── Pivot: types per artifact by language element ────────────────────────

    types_per_artifact_grouped: pd.DataFrame = types_per_artifact.pivot(
        index="artifactName",
        columns="languageElement",
        values="numberOfTypes",
    )
    types_per_artifact_grouped.fillna(0, inplace=True)
    types_per_artifact_grouped["total"] = types_per_artifact_grouped.sum(axis=1)
    types_per_artifact_grouped.sort_values(by="total", ascending=False, inplace=True)
    types_per_artifact_grouped.drop("total", axis=1, inplace=True)
    column_totals = types_per_artifact_grouped.sum()
    types_per_artifact_grouped = types_per_artifact_grouped[
        column_totals.sort_values(ascending=False).index
    ]
    types_per_artifact_grouped = types_per_artifact_grouped.astype(int)
    types_per_artifact_grouped.to_csv(report_directory / "Java_Types_Per_Artifact_Grouped.csv")
    if verbose:
        print(f"{SCRIPT_NAME}: Saved Java_Types_Per_Artifact_Grouped.csv")

    # ── Stacked bar: top 30 artifacts ────────────────────────────────────────

    plot_stacked_bar_chart(
        data_frame=types_per_artifact_grouped.head(TOP_THIRTY),
        title="Top 30 types per artifact",
        x_label="Artifact",
        y_label="Types",
        file_path=report_directory / "Overview_Java_Types_Per_Artifact_Stacked.svg",
    )

    # ── Normalized: type composition per artifact ─────────────────────────────

    types_per_artifact_normalized: pd.DataFrame = types_per_artifact_grouped.div(
        types_per_artifact_grouped.sum(axis=1), axis=0
    ).multiply(100)
    types_per_artifact_normalized.to_csv(
        report_directory / "Java_Types_Per_Artifact_Grouped_Normalized.csv"
    )
    if verbose:
        print(f"{SCRIPT_NAME}: Saved Java_Types_Per_Artifact_Grouped_Normalized.csv")

    for language_element in ("Class", "Interface", "Enum", "Annotation"):
        if language_element not in types_per_artifact_normalized.columns:
            if verbose:
                print(f"{SCRIPT_NAME}: Column '{language_element}' not present — skipping normalized chart.")
            continue
        sorted_data = types_per_artifact_normalized.sort_values(
            by=language_element, ascending=False
        )
        plot_stacked_bar_chart(
            data_frame=sorted_data.head(TOP_THIRTY),
            title=f"{language_element} types [%] per artifact",
            x_label="Artifact",
            y_label="Types %",
            file_path=report_directory / f"Overview_Java_{language_element}_Types_Per_Artifact_Normalized.svg",
        )

    # ── Pie: packages per artifact ────────────────────────────────────────────

    packages_per_artifact = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Number_of_packages_per_artifact.cypher"),
    )

    if not packages_per_artifact.empty:
        packages_per_artifact_sorted = packages_per_artifact.sort_values(
            by="numberOfPackages", ascending=False
        ).reset_index(drop=True)
        packages_grouped = group_to_others_below_threshold(
            data_frame=packages_per_artifact_sorted,
            value_column="numberOfPackages",
            name_column="artifactName",
            threshold=PACKAGES_PER_ARTIFACT_THRESHOLD,
        )
        plot_pie_chart(
            data_frame=packages_grouped,
            title="Number of packages per artifact",
            file_path=report_directory / "Overview_Java_Packages_Per_Artifact.svg",
        )


# ── TypeScript charts ─────────────────────────────────────────────────────────

def generate_typescript_charts(
    driver: Driver,
    queries_directory: Path,
    report_directory: Path,
    verbose: bool,
) -> None:
    """Generate TypeScript overview SVG charts and derived pivot CSV files.

    Produces stacked bar charts for module element composition (TypeAlias, Interface,
    Variable, Function). Skips all charts silently if no TypeScript data is present.

    Args:
        driver: Connected Neo4j driver instance.
        queries_directory: Path to the directory containing .cypher query files.
        report_directory: Path to the directory where output files will be written.
        verbose: Whether to log progress.
    """
    if verbose:
        print(f"{SCRIPT_NAME}: Generating TypeScript charts...")

    elements_per_module = query_cypher_to_dataframe(
        driver,
        read_cypher_file(queries_directory / "Number_of_elements_per_module_for_Typescript.cypher"),
    )

    if elements_per_module.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: No TypeScript module data found — skipping TypeScript charts.")
        return

    # ── Pivot: elements per module by language element ────────────────────────

    elements_per_module_grouped: pd.DataFrame = elements_per_module.pivot(
        index=["fullQualifiedModuleName", "modulePath", "moduleName"],
        columns="languageElement",
        values="numberOfElements",
    )
    elements_per_module_grouped.fillna(0, inplace=True)
    elements_per_module_grouped["total"] = elements_per_module_grouped.sum(axis=1)
    elements_per_module_grouped.sort_values(by="total", ascending=False, inplace=True)
    elements_per_module_grouped.drop("total", axis=1, inplace=True)
    column_totals = elements_per_module_grouped.sum()
    elements_per_module_grouped = elements_per_module_grouped[
        column_totals.sort_values(ascending=False).index
    ]
    elements_per_module_grouped = elements_per_module_grouped.astype(int)
    (
        elements_per_module_grouped
        .reset_index()
        .drop(columns="fullQualifiedModuleName")
        .to_csv(report_directory / "Typescript_Elements_Per_Module_Grouped.csv", index=False)
    )
    if verbose:
        print(f"{SCRIPT_NAME}: Saved Typescript_Elements_Per_Module_Grouped.csv")

    # ── Stacked bar: top 30 modules ───────────────────────────────────────────

    plot_stacked_bar_chart(
        data_frame=elements_per_module_grouped.reset_index().head(TOP_THIRTY),
        title="Top 30 elements per module",
        x_label="Module",
        y_label="Elements",
        x_column="modulePath",
        file_path=report_directory / "Overview_Typescript_Elements_Per_Module_Stacked.svg",
    )

    # ── Normalized: element composition per module ────────────────────────────

    elements_per_module_normalized: pd.DataFrame = elements_per_module_grouped.div(
        elements_per_module_grouped.sum(axis=1), axis=0
    ).multiply(100)
    (
        elements_per_module_normalized
        .reset_index()
        .drop(columns="fullQualifiedModuleName")
        .to_csv(report_directory / "Typescript_Elements_Per_Module_Grouped_Normalized.csv", index=False)
    )
    if verbose:
        print(f"{SCRIPT_NAME}: Saved Typescript_Elements_Per_Module_Grouped_Normalized.csv")

    for language_element in ("TypeAlias", "Interface", "Variable", "Function"):
        if language_element not in elements_per_module_normalized.columns:
            if verbose:
                print(f"{SCRIPT_NAME}: Column '{language_element}' not present — skipping normalized chart.")
            continue
        sorted_data = elements_per_module_normalized.sort_values(
            by=language_element, ascending=False
        )
        plot_stacked_bar_chart(
            data_frame=sorted_data.reset_index().head(TOP_THIRTY),
            title=f"Exported {language_element.lower()}s [%] per module",
            x_label="Module",
            y_label="Elements %",
            x_column="moduleName",
            file_path=report_directory / f"Overview_Typescript_{language_element}_Elements_Per_Module_Normalized.svg",
        )


# ── Entry point ───────────────────────────────────────────────────────────────

def main() -> None:
    """Parse arguments, connect to Neo4j, and generate all overview charts."""
    parameters = parse_parameters()
    if parameters.verbose:
        print(f"{SCRIPT_NAME}: {parameters}")

    queries_directory = Path(__file__).parent / "queries" / "overview"
    parameters.report_directory.mkdir(parents=True, exist_ok=True)

    driver = get_graph_database_driver(parameters.neo4j_uri, parameters.verbose)
    try:
        generate_general_charts(driver, queries_directory, parameters.report_directory, parameters.verbose)
        generate_java_charts(driver, queries_directory, parameters.report_directory, parameters.verbose)
        generate_typescript_charts(driver, queries_directory, parameters.report_directory, parameters.verbose)
    finally:
        driver.close()

    if parameters.verbose:
        print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
