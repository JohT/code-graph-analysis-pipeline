#!/usr/bin/env python

# Generates external dependency charts as SVG files from Neo4j graph data.
# Charts are saved to the report directory and referenced by the Markdown summary report.
#
# Input Parameters:
#  --language Java|Typescript  (required)
#  --report_directory          path to write SVG files
#  --verbose                   optional finer-grained logging
#
# Prerequisites:
#  - Neo4j must be running with scanned artifacts loaded.
#  - ExternalType and ExternalAnnotation labels must already exist (see externalDependenciesCsv.sh).
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

SCRIPT_NAME = "externalDependencyCharts"
JAVA_LANGUAGE = "Java"
TYPESCRIPT_LANGUAGE = "Typescript"
DRILLDOWN_SECONDARY_THRESHOLD_PERCENT = 0.3


class Parameters:
    def __init__(
        self,
        language: str,
        queries_directory: str,
        report_directory: str,
        verbose: bool,
    ) -> None:
        self.language = language
        self.queries_directory = queries_directory
        self.report_directory = report_directory
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters(language={self.language!r}, "
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
        description="Generates external dependency charts as SVG files from Neo4j graph data."
    )
    parser.add_argument(
        "--language",
        type=str,
        required=True,
        choices=[JAVA_LANGUAGE, TYPESCRIPT_LANGUAGE],
        help="Programming language to analyse: Java or Typescript",
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
        language=args.language,
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


def select_top_artifacts_by_package_count(
    per_artifact_data: pd.DataFrame,
    top_count: int = 15,
) -> typing.List[str]:
    """Returns the names of the top artifacts ranked by total internal packages using external dependencies."""
    totals = (
        per_artifact_data
        .groupby("artifactName")["numberOfPackages"]
        .sum()
        .nlargest(top_count)
    )
    return totals.index.tolist()


def build_external_package_per_artifact_pivot(
    per_artifact_data: pd.DataFrame,
    package_name_column: str,
    top_artifacts: typing.List[str],
) -> pd.DataFrame:
    """
    Creates a pivot table: rows = external packages, columns = artifacts,
    values = number of internal packages. Limited to the given top artifacts.
    """
    filtered = per_artifact_data[per_artifact_data["artifactName"].isin(top_artifacts)]
    return filtered.pivot_table(
        values="numberOfPackages",
        index=package_name_column,
        columns="artifactName",
        fill_value=0,
        aggfunc="sum",
    )


def derive_second_level_package_name(full_package_name: str) -> str:
    """Returns the first two dot-separated segments of a package name (e.g. 'javax.xml' from 'javax.xml.stream')."""
    parts = full_package_name.split(".")
    return ".".join(parts[:2]) if len(parts) >= 2 else full_package_name


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
    fig, ax = plot.subplots(figsize=(9, 9))
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
        ax=ax,
        explode=offsets,
    )
    plot.title(title, pad=15)
    ax.legend(bbox_to_anchor=(1.08, 1), loc="upper left")
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(fig)


def save_stacked_bar_chart(
    pivot_data: pd.DataFrame,
    title: str,
    xlabel: str,
    ylabel: str,
    file_path: str,
) -> None:
    """
    Renders a stacked bar chart (transposed pivot: artifacts on x-axis, external packages stacked).
    Skips silently when the input is empty.
    """
    if pivot_data.empty:
        print(f"{SCRIPT_NAME}: No data for '{title}', skipping chart.")
        return

    fig, ax = plot.subplots(figsize=(14, 8))
    pivot_data.transpose().plot(
        kind="bar",
        grid=True,
        title=title,
        xlabel=xlabel,
        ylabel=ylabel,
        stacked=True,
        legend=True,
        cmap="nipy_spectral",
        ax=ax,
    )
    ax.legend(bbox_to_anchor=(1.0, 1.0))
    plot.tight_layout()
    plot.savefig(file_path, bbox_inches="tight")
    plot.close(fig)


def annotate_artifact_scatter_point(
    data_frame: pd.DataFrame,
    x_column: str,
    y_column: str,
    sort_by_highest: typing.List[str],
) -> None:
    """
    Annotates one artifact in the current scatter plot with an arrow and label.
    The artifact is selected by sorting the DataFrame: columns in sort_by_highest descend, others ascend.
    """
    sort_columns = [x_column, y_column, "artifactPackages", "artifactName"]
    ascending = [column not in sort_by_highest for column in sort_columns]
    row = data_frame.sort_values(by=sort_columns, ascending=ascending).iloc[0]

    label_box = dict(boxstyle="round4,pad=0.5", fc="w", alpha=0.8)
    plot.annotate(
        row["artifactName"],
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

    fig, ax = plot.subplots(figsize=(10, 7))
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
        ax=ax,
    )
    for sort_config in annotation_sort_configs:
        if not data_frame.empty:
            annotate_artifact_scatter_point(data_frame, x_column, y_column, sort_by_highest=sort_config)

    plot.savefig(file_path, bbox_inches="tight")
    plot.close(fig)


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
        title=f"{chart_name_prefix} (≥{primary_threshold_percent}%)",
        file_path=chart_file_path(f"{chart_name_prefix}_above_threshold", report_directory, verbose),
    )

    others_entries = filter_entries_below_percentage_threshold(source_data, value_column, primary_threshold_percent)
    drilldown_grouped = group_small_values_into_others(
        others_entries, value_column, name_column, DRILLDOWN_SECONDARY_THRESHOLD_PERCENT
    )
    save_pie_chart(
        grouped_data=drilldown_grouped,
        title=f"{chart_name_prefix} — others drill-down (<{primary_threshold_percent}%)",
        file_path=chart_file_path(f"{chart_name_prefix}_others_drilldown", report_directory, verbose),
    )


# ── Java chart generation ──────────────────────────────────────────────────────


def generate_java_charts(queries_directory: str, report_directory: str, verbose: bool, driver: Driver) -> None:
    """Generates all external dependency charts for Java packages."""
    print(f"{SCRIPT_NAME}: Generating Java external dependency charts...")

    overall_data = load_query_results(
        os.path.join(queries_directory, "External_package_usage_overall.cypher"), verbose, driver
    )
    second_level_overall_data = load_query_results(
        os.path.join(queries_directory, "External_second_level_package_usage_overall.cypher"), verbose, driver
    )
    spread_data = load_query_results(
        os.path.join(queries_directory, "External_package_usage_spread.cypher"), verbose, driver
    )
    second_level_spread_data = load_query_results(
        os.path.join(queries_directory, "External_second_level_package_usage_spread.cypher"), verbose, driver
    )
    per_artifact_and_package_data = load_query_results(
        os.path.join(queries_directory, "External_package_usage_per_artifact_and_external_package.cypher"), verbose, driver
    )
    aggregated_data = load_query_results(
        os.path.join(queries_directory, "External_package_usage_per_artifact_package_aggregated.cypher"), verbose, driver
    )

    # ── Top external packages (Table 1 equivalent) ────────────────────────────
    if not overall_data.empty:
        save_pie_chart_pair(
            source_data=overall_data,
            value_column="numberOfExternalCallerTypes",
            name_column="externalPackageName",
            chart_name_prefix="Java_Top_external_packages_by_types",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=overall_data,
            value_column="numberOfExternalCallerPackages",
            name_column="externalPackageName",
            chart_name_prefix="Java_Top_external_packages_by_packages",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Second-level package grouping (Table 2 equivalent) ────────────────────
    if not second_level_overall_data.empty:
        save_pie_chart_pair(
            source_data=second_level_overall_data,
            value_column="numberOfExternalCallerTypes",
            name_column="externalSecondLevelPackageName",
            chart_name_prefix="Java_Top_second_level_packages_by_types",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=second_level_overall_data,
            value_column="numberOfExternalCallerPackages",
            name_column="externalSecondLevelPackageName",
            chart_name_prefix="Java_Top_second_level_packages_by_packages",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Most spread external packages (Table 3 equivalent) ────────────────────
    if not spread_data.empty:
        save_pie_chart_pair(
            source_data=spread_data,
            value_column="sumNumberOfTypes",
            name_column="externalPackageName",
            chart_name_prefix="Java_Most_spread_packages_by_types",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=spread_data,
            value_column="sumNumberOfPackages",
            name_column="externalPackageName",
            chart_name_prefix="Java_Most_spread_packages_by_packages",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Most spread second-level packages (Table 4 equivalent) ────────────────
    if not second_level_spread_data.empty:
        save_pie_chart_pair(
            source_data=second_level_spread_data,
            value_column="sumNumberOfTypes",
            name_column="externalSecondLevelPackageName",
            chart_name_prefix="Java_Most_spread_second_level_packages_by_types",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=second_level_spread_data,
            value_column="sumNumberOfPackages",
            name_column="externalSecondLevelPackageName",
            chart_name_prefix="Java_Most_spread_second_level_packages_by_packages",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Stacked bar: external packages per artifact (Table 7 equivalent) ──────
    if not per_artifact_and_package_data.empty:
        top_artifacts = select_top_artifacts_by_package_count(per_artifact_and_package_data)

        full_package_pivot = build_external_package_per_artifact_pivot(
            per_artifact_and_package_data, "externalPackageName", top_artifacts
        )
        save_stacked_bar_chart(
            pivot_data=full_package_pivot,
            title="External package usage per artifact (top 15)",
            xlabel="artifact",
            ylabel="number of internal packages",
            file_path=chart_file_path(
                "Java_External_package_usage_per_artifact_stacked", report_directory, verbose
            ),
        )

        per_artifact_second_level = per_artifact_and_package_data.copy()
        per_artifact_second_level["externalSecondLevelPackageName"] = (
            per_artifact_second_level["externalPackageName"]
            .apply(derive_second_level_package_name)
        )
        second_level_pivot = build_external_package_per_artifact_pivot(
            per_artifact_second_level, "externalSecondLevelPackageName", top_artifacts
        )
        save_stacked_bar_chart(
            pivot_data=second_level_pivot,
            title="External package usage per artifact — second-level grouping (top 15)",
            xlabel="artifact",
            ylabel="number of internal packages",
            file_path=chart_file_path(
                "Java_External_second_level_package_usage_per_artifact_stacked", report_directory, verbose
            ),
        )

    # ── Scatter: aggregated package usage patterns (Table 13 equivalent) ──────
    if not aggregated_data.empty:
        save_scatter_chart(
            data_frame=aggregated_data,
            x_column="numberOfExternalPackages",
            y_column="maxNumberOfPackagesPercentage",
            size_column="artifactPackages",
            color_column="stdNumberOfPackagesPercentage",
            title="External package usage — max internal packages %",
            xlabel="external package count",
            ylabel="max percentage of internal packages",
            file_path=chart_file_path(
                "Java_External_package_usage_max_internal_packages_percent", report_directory, verbose
            ),
            annotation_sort_configs=[
                ["numberOfExternalPackages", "maxNumberOfPackagesPercentage"],
                ["maxNumberOfPackagesPercentage"],
                [],
            ],
        )
        save_scatter_chart(
            data_frame=aggregated_data,
            x_column="numberOfExternalPackages",
            y_column="medNumberOfPackagesPercentage",
            size_column="artifactPackages",
            color_column="stdNumberOfPackagesPercentage",
            title="External package usage — median internal packages %",
            xlabel="external package count",
            ylabel="median percentage of internal packages",
            file_path=chart_file_path(
                "Java_External_package_usage_median_internal_packages_percent", report_directory, verbose
            ),
            annotation_sort_configs=[],
        )

    print(f"{SCRIPT_NAME}: Java charts complete.")


# ── TypeScript chart generation ────────────────────────────────────────────────


def generate_typescript_charts(queries_directory: str, report_directory: str, verbose: bool, driver: Driver) -> None:
    """Generates all external dependency charts for TypeScript modules and namespaces."""
    print(f"{SCRIPT_NAME}: Generating TypeScript external dependency charts...")

    module_overall_data = load_query_results(
        os.path.join(queries_directory, "External_module_usage_overall_for_Typescript.cypher"), verbose, driver
    )
    namespace_overall_data = load_query_results(
        os.path.join(queries_directory, "External_namespace_usage_overall_for_Typescript.cypher"), verbose, driver
    )
    module_spread_data = load_query_results(
        os.path.join(queries_directory, "External_module_usage_spread_for_Typescript.cypher"), verbose, driver
    )
    namespace_spread_data = load_query_results(
        os.path.join(queries_directory, "External_namespace_usage_spread_for_Typescript.cypher"), verbose, driver
    )

    # ── Module usage overall ───────────────────────────────────────────────────
    if not module_overall_data.empty:
        save_pie_chart_pair(
            source_data=module_overall_data,
            value_column="numberOfExternalCallerElements",
            name_column="externalModuleName",
            chart_name_prefix="Typescript_Top_external_modules_by_elements",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=module_overall_data,
            value_column="numberOfExternalCallerModules",
            name_column="externalModuleName",
            chart_name_prefix="Typescript_Top_external_modules_by_modules",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Namespace usage overall ────────────────────────────────────────────────
    if not namespace_overall_data.empty:
        save_pie_chart_pair(
            source_data=namespace_overall_data,
            value_column="numberOfExternalCallerElements",
            name_column="externalNamespaceName",
            chart_name_prefix="Typescript_Top_external_namespaces_by_elements",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=namespace_overall_data,
            value_column="numberOfExternalCallerModules",
            name_column="externalNamespaceName",
            chart_name_prefix="Typescript_Top_external_namespaces_by_modules",
            primary_threshold_percent=0.7,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Module spread ──────────────────────────────────────────────────────────
    if not module_spread_data.empty:
        save_pie_chart_pair(
            source_data=module_spread_data,
            value_column="sumNumberOfUsedExternalDeclarations",
            name_column="externalModuleName",
            chart_name_prefix="Typescript_Most_spread_modules_by_declarations",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=module_spread_data,
            value_column="numberOfInternalModules",
            name_column="externalModuleName",
            chart_name_prefix="Typescript_Most_spread_modules_by_modules",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    # ── Namespace spread ───────────────────────────────────────────────────────
    if not namespace_spread_data.empty:
        save_pie_chart_pair(
            source_data=namespace_spread_data,
            value_column="sumNumberOfUsedExternalDeclarations",
            name_column="externalModuleNamespace",
            chart_name_prefix="Typescript_Most_spread_namespaces_by_declarations",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )
        save_pie_chart_pair(
            source_data=namespace_spread_data,
            value_column="numberOfInternalModules",
            name_column="externalModuleNamespace",
            chart_name_prefix="Typescript_Most_spread_namespaces_by_modules",
            primary_threshold_percent=0.5,
            report_directory=report_directory,
            verbose=verbose,
        )

    print(f"{SCRIPT_NAME}: TypeScript charts complete.")


# ── Entry point ────────────────────────────────────────────────────────────────


def main() -> None:
    parameters = parse_parameters()

    if parameters.report_directory:
        os.makedirs(parameters.report_directory, exist_ok=True)

    driver = connect_to_graph_database()

    if parameters.language == JAVA_LANGUAGE:
        generate_java_charts(
            queries_directory=parameters.queries_directory,
            report_directory=parameters.report_directory,
            verbose=parameters.verbose,
            driver=driver,
        )
    elif parameters.language == TYPESCRIPT_LANGUAGE:
        generate_typescript_charts(
            queries_directory=parameters.queries_directory,
            report_directory=parameters.report_directory,
            verbose=parameters.verbose,
            driver=driver,
        )
    else:
        print(f"{SCRIPT_NAME}: Error: Unknown language '{parameters.language}'", file=sys.stderr)
        driver.close()
        sys.exit(1)

    driver.close()
    print(f"{SCRIPT_NAME}: Neo4j connection closed.")


if __name__ == "__main__":
    main()
