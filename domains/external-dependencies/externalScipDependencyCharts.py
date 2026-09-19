#!/usr/bin/env python

# Generates SCIP external dependency charts as SVG files from Neo4j graph data.
# Charts are saved to the report directory and referenced by the Markdown summary report.
# Language-agnostic: SCIP indices may contain multiple languages.
#
# Input Parameters:
#  --report_directory  path to write SVG files
#  --verbose           optional finer-grained logging
#
# Prerequisites:
#  - Neo4j must be running with SCIP index data loaded.
#  - SemanticCodeIndexInternalType and SemanticCodeIndexExternalType nodes must exist.
#  - NEO4J_INITIAL_PASSWORD environment variable must be set.

import os
import sys
import argparse
import typing
from typing import LiteralString, cast

import pandas as pd

import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

from neo4j import GraphDatabase, Driver

SCRIPT_NAME = "externalScipDependencyCharts"
CHART_PREFIX = "Scip_"
DRILLDOWN_SECONDARY_THRESHOLD_PERCENT = 0.3


class Parameters:
    def __init__(
        self,
        queries_directory: str,
        report_directory: str,
        verbose: bool,
    ) -> None:
        self.queries_directory = queries_directory
        self.report_directory = report_directory
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters("
            f"queries_directory={self.queries_directory!r}, "
            f"report_directory={self.report_directory!r}, "
            f"verbose={self.verbose})"
        )

    @staticmethod
    def log_dependency_versions() -> None:
        print("---------------------------------------")
        print(f"Python version: {sys.version}")
        from pandas import __version__ as pandas_version
        print(f"pandas version: {pandas_version}")
        from matplotlib import __version__ as matplotlib_version
        print(f"matplotlib version: {matplotlib_version}")
        from neo4j import __version__ as neo4j_version
        print(f"neo4j version: {neo4j_version}")
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    script_directory = os.path.dirname(os.path.abspath(__file__))
    default_queries_directory = os.path.join(script_directory, "queries")

    parser = argparse.ArgumentParser(
        description="Generates SCIP external dependency charts as SVG files from Neo4j graph data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the directory where SVG files are written",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        default=False,
        help="Enable verbose mode for detailed logging",
    )
    args = parser.parse_args()

    parameters = Parameters(
        queries_directory=default_queries_directory,
        report_directory=args.report_directory,
        verbose=args.verbose,
    )
    if parameters.verbose:
        print(parameters)
        Parameters.log_dependency_versions()
    return parameters


def connect_to_graph_database() -> Driver:
    password = os.environ.get("NEO4J_INITIAL_PASSWORD")
    if not password:
        print(
            f"{SCRIPT_NAME}: Environment variable NEO4J_INITIAL_PASSWORD must be set and non-empty "
            "before connecting to Neo4j.",
            file=sys.stderr,
        )
        sys.exit(1)

    graph_driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", password),
    )
    graph_driver.verify_connectivity()
    print(f"{SCRIPT_NAME}: Successfully connected to Neo4j")
    return graph_driver


def load_query_results(cypher_file_path: str, verbose: bool, driver: Driver) -> pd.DataFrame:
    """Reads a .cypher file and executes it against the graph database, returning a DataFrame."""
    with open(cypher_file_path, "r", encoding="utf-8") as cypher_file:
        query = cypher_file.read()
    if verbose:
        print(f"{SCRIPT_NAME}: Querying {os.path.basename(cypher_file_path)}")
    records, summary, keys = driver.execute_query(cast(LiteralString, query))
    if verbose:
        print(f"{SCRIPT_NAME}: Got {len(records)} rows after {summary.result_available_after} ms")
    return pd.DataFrame([record.values() for record in records], columns=keys)


def chart_file_path(name: str, report_directory: str, verbose: bool) -> str:
    """Returns the full SVG file path for a named chart."""
    path = os.path.join(report_directory, name.replace(" ", "_") + ".svg")
    if verbose:
        print(f"{SCRIPT_NAME}: Saving {path}")
    return path


# ── Pure data transformation functions ────────────────────────────────────────


def add_percentage_column(data_frame: pd.DataFrame, value_column: str) -> pd.DataFrame:
    """Returns a copy of the DataFrame with a percentage column added (based on column total)."""
    result = data_frame.copy()
    percent_column = value_column + "Percent"
    result[percent_column] = result[value_column] / result[value_column].sum() * 100.0
    return result


def group_small_values_into_others(
    data_frame: pd.DataFrame,
    value_column: str,
    name_column: str,
    threshold_percent: float,
) -> pd.DataFrame:
    """
    Groups rows whose percentage share of the total falls below threshold_percent
    into a single 'others' row. Returns index=name, columns=[value, percent], sorted descending.
    """
    result = data_frame[[name_column, value_column]].copy()
    percent_column = value_column + "Percent"
    result[percent_column] = result[value_column] / result[value_column].sum() * 100.0
    result[name_column] = result[name_column].astype(str)
    result.loc[result[percent_column] < threshold_percent, name_column] = "others"
    result = result.groupby(name_column).sum()
    return result.sort_values(by=percent_column, ascending=False)


def filter_entries_below_percentage_threshold(
    data_frame: pd.DataFrame,
    value_column: str,
    threshold_percent: float,
) -> pd.DataFrame:
    """
    Returns only rows whose percentage share of the *original* total is below
    threshold_percent. Used to drill down into the 'others' slice.
    Matches the grouping logic of group_small_values_into_others (< not <=)
    to avoid double-counting at the threshold boundary.
    """
    result = add_percentage_column(data_frame, value_column)
    percent_column = value_column + "Percent"
    result = result[result[percent_column] < threshold_percent]
    return result.reset_index(drop=True)


def explode_pie_slice(
    grouped_data: pd.DataFrame,
    slice_name: str = "others",
    base_offset: float = 0.02,
    emphasized_offset: float = 0.2,
) -> typing.List[float]:
    """
    Returns per-slice explode offsets for matplotlib pie charts.
    The slice matching slice_name is emphasized with a larger offset.
    """
    return [
        (emphasized_offset if index == slice_name else base_offset)
        for index in grouped_data.index
    ]


def select_top_internal_artifacts_by_module_count(
    per_artifact_data: pd.DataFrame,
    top_count: int = 15,
) -> typing.List[str]:
    """Returns the names of the top internal artifacts ranked by total internal modules using external dependencies."""
    totals = (
        per_artifact_data
        .groupby("internalArtifactName")["numberOfModules"]
        .sum()
        .nlargest(top_count)
    )
    return totals.index.tolist()


def build_external_artifact_per_internal_artifact_pivot(
    per_artifact_data: pd.DataFrame,
    top_artifacts: typing.List[str],
) -> pd.DataFrame:
    """
    Creates a pivot table: rows = external artifacts, columns = internal artifacts,
    values = number of internal modules. Limited to the given top internal artifacts.
    """
    filtered = per_artifact_data[per_artifact_data["internalArtifactName"].isin(top_artifacts)]
    return filtered.pivot_table(
        values="numberOfModules",
        index="externalArtifactName",
        columns="internalArtifactName",
        fill_value=0,
        aggfunc="sum",
    )


# ── Chart rendering functions ──────────────────────────────────────────────────


def save_pie_chart(grouped_data: pd.DataFrame, title: str, file_path: str) -> None:
    """
    Renders a pie chart from a grouped DataFrame (index=name, columns=[value, percent]) and saves as SVG.
    Skips silently when the input is empty.
    """
    if grouped_data.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    value_column = grouped_data.columns[0]
    percent_column = grouped_data.columns[1] if len(grouped_data.columns) > 1 else value_column + "Percent"
    total = grouped_data[value_column].sum()

    def format_slice_label(percentage: float) -> str:
        return f"{percentage:.2f}% ({total * percentage / 100.0:.0f})"

    offsets = explode_pie_slice(grouped_data)
    figure, axis = plot.subplots(figsize=(9, 9))
    grouped_data.plot(
        kind="pie",
        y=percent_column,
        ylabel="",
        legend=True,
        labeldistance=None,
        autopct=format_slice_label,
        textprops={"fontsize": 6},
        pctdistance=1.15,
        cmap="nipy_spectral",
        ax=axis,
        explode=offsets,
    )
    plot.title(title, pad=15)
    axis.legend(bbox_to_anchor=(1.08, 1), loc="upper left")
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


def save_stacked_bar_chart(
    pivot_data: pd.DataFrame,
    title: str,
    xlabel: str,
    ylabel: str,
    file_path: str,
) -> None:
    """
    Renders a stacked bar chart (transposed pivot: internal artifacts on x-axis, external artifacts stacked).
    Skips silently when the input is empty.
    """
    if pivot_data.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    figure, axis = plot.subplots(figsize=(14, 8))
    pivot_data.transpose().plot(
        kind="bar",
        grid=True,
        title=title,
        xlabel=xlabel,
        ylabel=ylabel,
        stacked=True,
        legend=True,
        cmap="nipy_spectral",
        ax=axis,
    )
    axis.legend(bbox_to_anchor=(1.0, 1.0))
    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


def annotate_scip_scatter_point(
    data_frame: pd.DataFrame,
    x_column: str,
    y_column: str,
    sort_by_highest: typing.List[str],
) -> None:
    """
    Annotates one artifact in the current scatter plot with an arrow and label.
    The artifact is selected by sorting the DataFrame: columns in sort_by_highest descend, others ascend.
    """
    sort_columns = [x_column, y_column, "artifactModules", "internalArtifactName"]
    ascending = [column not in sort_by_highest for column in sort_columns]
    row = data_frame.sort_values(by=sort_columns, ascending=ascending).iloc[0]

    label_box = dict(boxstyle="round4,pad=0.5", fc="w", alpha=0.8)
    plot.annotate(
        row["internalArtifactName"],
        xy=(row[x_column], row[y_column]),
        xycoords="data",
        xytext=(-30, -15),
        textcoords="offset points",
        size=6,
        bbox=label_box,
        arrowprops=dict(arrowstyle="-|>", mutation_scale=10, color="black"),
    )


def save_scatter_chart(
    data_frame: pd.DataFrame,
    x_column: str,
    y_column: str,
    size_column: str,
    color_column: str,
    title: str,
    xlabel: str,
    ylabel: str,
    file_path: str,
    annotation_sort_configs: typing.List[typing.List[str]],
) -> None:
    """
    Renders a scatter plot and annotates several notable artifacts.
    Each list in annotation_sort_configs defines which columns to sort descending
    for selecting one annotation point.
    Skips silently when the input is empty.
    """
    if data_frame.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    figure, axis = plot.subplots(figsize=(10, 7))
    data_frame.plot(
        kind="scatter",
        title=title,
        x=x_column,
        y=y_column,
        s=size_column,
        c=color_column,
        xlabel=xlabel,
        ylabel=ylabel,
        cmap="nipy_spectral",
        ax=axis,
    )
    for sort_config in annotation_sort_configs:
        if not data_frame.empty:
            annotate_scip_scatter_point(data_frame, x_column, y_column, sort_by_highest=sort_config)

    plot.savefig(file_path, bbox_inches="tight")
    plot.close(figure)


# ── Reusable pie chart pair generator ─────────────────────────────────────────


def save_pie_chart_pair(
    source_data: pd.DataFrame,
    value_column: str,
    name_column: str,
    chart_name_prefix: str,
    primary_threshold_percent: float,
    report_directory: str,
    verbose: bool,
) -> None:
    """
    Generates two pie charts from source_data:
    1. Entries at or above the threshold grouped by name (small ones merged into 'others').
    2. Drill-down of the 'others' group: only entries below the threshold.
    """
    grouped = group_small_values_into_others(source_data, value_column, name_column, primary_threshold_percent)
    save_pie_chart(
        grouped_data=grouped,
        title=f"{chart_name_prefix} (\u2265{primary_threshold_percent}%)",
        file_path=chart_file_path(f"{chart_name_prefix}_above_threshold", report_directory, verbose),
    )

    others_entries = filter_entries_below_percentage_threshold(source_data, value_column, primary_threshold_percent)
    drilldown_grouped = group_small_values_into_others(
        others_entries, value_column, name_column, DRILLDOWN_SECONDARY_THRESHOLD_PERCENT
    )
    save_pie_chart(
        grouped_data=drilldown_grouped,
        title=f"{chart_name_prefix} \u2014 others drill-down (<{primary_threshold_percent}%)",
        file_path=chart_file_path(f"{chart_name_prefix}_others_drilldown", report_directory, verbose),
    )


# ── SCIP chart generation ──────────────────────────────────────────────────────


def generate_scip_charts(queries_directory: str, report_directory: str, verbose: bool, driver: Driver) -> None:
    """Generates all external dependency charts for SCIP index data."""
    print(f"{SCRIPT_NAME}: Generating SCIP external dependency charts...")

    overall_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_overall_for_Scip.cypher"), verbose, driver
    )
    spread_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_spread_for_Scip.cypher"), verbose, driver
    )
    overall_excluding_tests_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_overall_excluding_tests_for_Scip.cypher"), verbose, driver
    )
    spread_excluding_tests_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_spread_excluding_tests_for_Scip.cypher"), verbose, driver
    )
    overall_normalized_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_overall_normalized_for_Scip.cypher"), verbose, driver
    )
    spread_normalized_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_spread_normalized_for_Scip.cypher"), verbose, driver
    )
    per_artifact_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_per_internal_artifact_for_Scip.cypher"), verbose, driver
    )
    aggregated_data = load_query_results(
        os.path.join(queries_directory, "External_artifact_usage_per_internal_module_aggregated_for_Scip.cypher"), verbose, driver
    )

    # ── Top external artifacts by internal caller types ───────────────────────
    if not overall_data.empty:
        save_pie_chart_pair(
            source_data=overall_data,
            value_column="numberOfInternalCallerTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_by_types",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=overall_data,
            value_column="numberOfInternalCallerModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_by_modules",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Most spread external artifacts ────────────────────────────────────────
    if not spread_data.empty:
        save_pie_chart_pair(
            source_data=spread_data,
            value_column="sumNumberOfTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_by_types",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=spread_data,
            value_column="sumNumberOfModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_by_modules",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Excluding-tests: top external artifacts ────────────────────────────────
    if not overall_excluding_tests_data.empty:
        save_pie_chart_pair(
            source_data=overall_excluding_tests_data,
            value_column="numberOfInternalCallerTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_excluding_tests_by_types",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=overall_excluding_tests_data,
            value_column="numberOfInternalCallerModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_excluding_tests_by_modules",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Excluding-tests: most spread external artifacts ────────────────────────
    if not spread_excluding_tests_data.empty:
        save_pie_chart_pair(
            source_data=spread_excluding_tests_data,
            value_column="sumNumberOfTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_excluding_tests_by_types",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=spread_excluding_tests_data,
            value_column="sumNumberOfModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_excluding_tests_by_modules",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Normalized: top external artifacts ────────────────────────────────────
    if not overall_normalized_data.empty:
        save_pie_chart_pair(
            source_data=overall_normalized_data,
            value_column="numberOfInternalCallerTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_normalized_by_types",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=overall_normalized_data,
            value_column="numberOfInternalCallerModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Top_external_artifacts_normalized_by_modules",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Normalized: most spread external artifacts ─────────────────────────────
    if not spread_normalized_data.empty:
        save_pie_chart_pair(
            source_data=spread_normalized_data,
            value_column="sumNumberOfTypes",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_normalized_by_types",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=spread_normalized_data,
            value_column="sumNumberOfModules",
            name_column="externalArtifactName",
            chart_name_prefix=f"{CHART_PREFIX}Most_spread_artifacts_normalized_by_modules",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Stacked bar: external artifact usage per internal artifact ─────────────
    if not per_artifact_data.empty:
        top_artifacts = select_top_internal_artifacts_by_module_count(per_artifact_data)
        pivot = build_external_artifact_per_internal_artifact_pivot(per_artifact_data, top_artifacts)
        save_stacked_bar_chart(
            pivot_data=pivot,
            title="SCIP external artifact usage per internal artifact (top 15)",
            xlabel="internal artifact",
            ylabel="number of internal modules",
            file_path=chart_file_path(
                f"{CHART_PREFIX}External_artifact_usage_per_artifact_stacked", report_directory, verbose
            ),
        )

    # ── Scatter: aggregated module usage patterns ──────────────────────────────
    if not aggregated_data.empty:
        save_scatter_chart(
            data_frame=aggregated_data,
            x_column="numberOfExternalArtifacts",
            y_column="maxNumberOfModulesPercentage",
            size_column="artifactModules",
            color_column="stdNumberOfModulesPercentage",
            title="SCIP external artifact usage \u2014 max internal modules %",
            xlabel="external artifact count",
            ylabel="max percentage of internal modules",
            file_path=chart_file_path(
                f"{CHART_PREFIX}External_artifact_usage_max_internal_modules_percent", report_directory, verbose
            ),
            annotation_sort_configs=[
                ["numberOfExternalArtifacts", "maxNumberOfModulesPercentage"],
                ["maxNumberOfModulesPercentage"],
                [],
            ],
        )

    print(f"{SCRIPT_NAME}: SCIP charts complete.")


# ── Entry point ────────────────────────────────────────────────────────────────


def main() -> None:
    parameters = parse_parameters()

    if parameters.report_directory:
        os.makedirs(parameters.report_directory, exist_ok=True)

    driver = connect_to_graph_database()
    generate_scip_charts(
        queries_directory=parameters.queries_directory,
        report_directory=parameters.report_directory,
        verbose=parameters.verbose,
        driver=driver,
    )
    driver.close()
    print(f"{SCRIPT_NAME}: Neo4j connection closed.")


if __name__ == "__main__":
    main()
