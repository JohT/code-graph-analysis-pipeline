#!/usr/bin/env python

# Generates path finding charts as SVG files from CSV data produced by internalDependenciesCsv.sh.
# Charts are saved to the report directory subdirectories and referenced by the Markdown summary report.
#
# Input Parameters:
#  --report_directory   path to the report directory (contains Java_Artifact/, Java_Package/, etc.)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - internalDependenciesCsv.sh must have run first to produce the required CSV files.

import os
import sys
import argparse
import typing

import pandas as pd
import numpy as np

import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

SCRIPT_NAME = "pathFindingCharts"

# Column names from the path finding Cypher query results
DISTANCE_COLUMN = "distance"
PAIR_COUNT_COLUMN = "pairCount"
TOTAL_PAIR_COUNT_COLUMN = "distanceTotalPairCount"
SOURCE_PROJECT_COLUMN = "sourceProject"
IS_DIFFERENT_TARGET_PROJECT_COLUMN = "isDifferentTargetProject"

# Abstraction level configurations: (subdirectory, nodeLabel, description)
ABSTRACTION_LEVELS = [
    ("Java_Package",     "Package",         "Java Package"),
    ("Java_Artifact",    "Artifact",        "Java Artifact"),
    ("Typescript_Module","Module",           "TypeScript Module"),
    ("NPM_NonDevPackage","NpmNonDevPackage", "NPM Non-Dev Package"),
    ("NPM_DevPackage",   "NpmDevPackage",    "NPM Dev Package"),
]

# Colormap matching the original PathFindingJava.ipynb notebook
MAIN_COLOR_MAP = "nipy_spectral"


class Parameters:
    def __init__(
        self,
        report_directory: str,
        verbose: bool,
    ) -> None:
        self.report_directory = report_directory
        self.verbose = verbose

    def __repr__(self) -> str:
        return (
            f"Parameters("
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
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    parser = argparse.ArgumentParser(
        description="Generates path finding charts as SVG files from CSV data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the report directory containing abstraction-level subdirectories with CSV files",
    )
    parser.add_argument(
        "--verbose",
        action="store_true",
        default=False,
        help="Enable verbose mode for detailed logging",
    )
    args = parser.parse_args()
    return Parameters(
        report_directory=args.report_directory,
        verbose=args.verbose,
    )


def chart_file_path(name: str, level_directory: str, verbose: bool) -> str:
    """Returns the full SVG file path for a named chart within the level directory."""
    path = os.path.join(level_directory, name.replace(" ", "_") + ".svg")
    if verbose:
        print(f"{SCRIPT_NAME}: Saving {path}")
    return path


def load_csv(csv_path: str, verbose: bool) -> typing.Optional[pd.DataFrame]:
    """Loads a CSV file into a DataFrame. Returns None if the file does not exist or is empty."""
    if not os.path.isfile(csv_path):
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping {csv_path} — file not found")
        return None
    data_frame = pd.read_csv(csv_path, sep=",")
    if data_frame.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping {csv_path} — file is empty")
        return None
    if verbose:
        print(f"{SCRIPT_NAME}: Loaded {len(data_frame)} rows from {csv_path}")
    return data_frame


# ── Pure data transformation functions ────────────────────────────────────────


def aggregate_total_distribution(data_frame: pd.DataFrame) -> pd.DataFrame:
    """Aggregates path count per distance across all projects."""
    return (
        data_frame
        .groupby(DISTANCE_COLUMN)[PAIR_COUNT_COLUMN]
        .sum()
        .reset_index()
        .sort_values(DISTANCE_COLUMN)
    )


def pivot_distribution_by_project(
    data_frame: pd.DataFrame,
    distance_column: str,
    count_column: str,
    project_column: str,
) -> pd.DataFrame:
    """
    Pivots the per-project distribution into a wide format:
    rows = distance, columns = project names, values = path counts.
    Only includes intra-project pairs (isDifferentTargetProject == False).
    """
    intra = data_frame[data_frame[IS_DIFFERENT_TARGET_PROJECT_COLUMN] == False].copy()  # noqa: E712
    if intra.empty:
        return pd.DataFrame()
    pivoted = intra.pivot_table(
        index=distance_column,
        columns=project_column,
        values=count_column,
        aggfunc="sum",
        fill_value=0,
    )
    return pivoted.sort_index()


def normalize_distribution_by_project(pivoted_data: pd.DataFrame) -> pd.DataFrame:
    """Normalizes a pivoted distribution so each project column sums to 1.0 (100%)."""
    column_sums = pivoted_data.sum(axis=0)
    normalized = pivoted_data.div(column_sums, axis=1)
    return normalized


def max_distance_per_project(data_frame: pd.DataFrame) -> pd.DataFrame:
    """Returns the maximum distance (diameter) per source project, sorted descending."""
    return (
        data_frame
        .groupby(SOURCE_PROJECT_COLUMN)[DISTANCE_COLUMN]
        .max()
        .reset_index()
        .rename(columns={DISTANCE_COLUMN: "diameter"})
        .sort_values("diameter", ascending=False)
    )


# ── Chart generation functions ────────────────────────────────────────────────


def plot_distribution_bar(
    data_frame: pd.DataFrame,
    distance_column: str,
    count_column: str,
    title: str,
    file_path: str,
) -> None:
    """Saves a bar chart showing path count per distance to file_path as SVG."""
    figure, axes = plot.subplots(figsize=(10, 5))
    data_frame.plot(
        kind="bar",
        x=distance_column,
        y=count_column,
        ax=axes,
        legend=False,
        grid=True,
        fontsize=8,
        cmap=MAIN_COLOR_MAP,
        xlabel="Distance (number of hops)",
        ylabel="Number of paths",
        title=title,
    )
    axes.tick_params(axis="x", labelrotation=45)
    figure.tight_layout()
    figure.savefig(file_path, format="svg")
    plot.close(figure)


def plot_distribution_pie(
    data_frame: pd.DataFrame,
    distance_column: str,
    count_column: str,
    title: str,
    file_path: str,
) -> None:
    """Saves a pie chart showing percentage of paths per distance to file_path as SVG."""
    total = data_frame[count_column].sum()
    explode = np.full(len(data_frame), 0.01)

    def autopct(pct: float) -> str:
        return '{:1.2f}% ({:.0f})'.format(pct, total * pct / 100)

    figure, axes = plot.subplots(figsize=(8, 8))
    data_frame.plot(
        kind="pie",
        y=count_column,
        labels=data_frame[distance_column],
        labeldistance=None,
        legend=True,
        autopct=autopct,
        explode=explode,
        textprops={"fontsize": 8},
        pctdistance=1.2,
        cmap=MAIN_COLOR_MAP,
        ax=axes,
        title=title,
    )
    axes.set_ylabel("")
    axes.legend(bbox_to_anchor=(1.05, 1), loc="upper left", title="distance")
    figure.tight_layout()
    figure.savefig(file_path, format="svg")
    plot.close(figure)


def plot_per_project_stacked_bar(
    pivoted_data: pd.DataFrame,
    title: str,
    file_path: str,
    use_log_scale: bool = False,
) -> None:
    """Saves a stacked bar chart per project (distances stacked) as SVG."""
    if pivoted_data.empty:
        return
    figure, axes = plot.subplots(figsize=(max(10, len(pivoted_data.columns) * 0.8 + 4), 6))
    pivoted_data.T.plot(kind="bar", stacked=True, ax=axes, colormap=MAIN_COLOR_MAP)
    axes.set_xlabel("Project")
    axes.set_ylabel("Number of paths" + (" (log scale)" if use_log_scale else ""))
    axes.set_title(title)
    axes.legend(title="Distance", bbox_to_anchor=(1.05, 1), loc="upper left", fontsize="small")
    if use_log_scale:
        axes.set_yscale("log")
        axes.set_ylim(bottom=0.1)
    axes.tick_params(axis="x", labelrotation=45)
    figure.tight_layout()
    figure.savefig(file_path, format="svg")
    plot.close(figure)


def plot_per_project_normalized_bar(
    normalized_data: pd.DataFrame,
    title: str,
    file_path: str,
) -> None:
    """Saves a normalized stacked bar chart (each project sums to 100%) as SVG."""
    if normalized_data.empty:
        return
    figure, axes = plot.subplots(figsize=(max(10, len(normalized_data.columns) * 0.8 + 4), 6))
    (normalized_data * 100).T.plot(kind="bar", stacked=True, ax=axes, colormap=MAIN_COLOR_MAP)
    axes.set_xlabel("Project")
    axes.set_ylabel("Percentage of paths (%)")
    axes.set_title(title)
    axes.legend(title="Distance", bbox_to_anchor=(1.05, 1), loc="upper left", fontsize="small")
    axes.tick_params(axis="x", labelrotation=45)
    figure.tight_layout()
    figure.savefig(file_path, format="svg")
    plot.close(figure)


def plot_diameter_bar(
    data_frame: pd.DataFrame,
    project_column: str,
    diameter_column: str,
    title: str,
    file_path: str,
) -> None:
    """Saves a bar chart of graph diameter (max distance) per project, sorted descending."""
    if data_frame.empty:
        return
    display = data_frame.head(20)
    figure, axes = plot.subplots(figsize=(max(10, len(display) * 0.8 + 2), 5))
    display.plot(
        kind="bar",
        x=project_column,
        y=diameter_column,
        ax=axes,
        legend=False,
        grid=True,
        fontsize=8,
        cmap=MAIN_COLOR_MAP,
        xlabel="Project",
        ylabel="Graph diameter (max shortest path)",
        title=title,
    )
    axes.tick_params(axis="x", labelrotation=45)
    figure.tight_layout()
    figure.savefig(file_path, format="svg")
    plot.close(figure)


# ── Per-abstraction-level chart generation ────────────────────────────────────


def generate_charts_for_level(
    subdirectory: str,
    node_label: str,
    description: str,
    report_directory: str,
    verbose: bool,
) -> None:
    """Generates all path finding charts for a single abstraction level."""
    level_directory = os.path.join(report_directory, subdirectory)
    if not os.path.isdir(level_directory):
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping {description} — directory not found: {level_directory}")
        return

    all_pairs_shortest_paths_csv = os.path.join(
        level_directory,
        f"{node_label}_all_pairs_shortest_paths_distribution_per_project.csv",
    )
    longest_csv = os.path.join(
        level_directory,
        f"{node_label}_longest_paths_distribution.csv",
    )

    # ── All pairs shortest path charts ────────────────────────────────────────
    all_pairs_shortest_paths_data = load_csv(all_pairs_shortest_paths_csv, verbose)
    if all_pairs_shortest_paths_data is not None and not all_pairs_shortest_paths_data.empty:
        print(f"{SCRIPT_NAME}: Generating All Pairs Shortest Path charts for {description}...")

        total_all_pairs_shortest_paths = aggregate_total_distribution(all_pairs_shortest_paths_data)

        if not total_all_pairs_shortest_paths.empty:
            plot_distribution_bar(
                total_all_pairs_shortest_paths, DISTANCE_COLUMN, PAIR_COUNT_COLUMN,
                f"{description} — All Pairs Shortest Path Distribution",
                chart_file_path(f"{subdirectory}_AllPairsShortestPath_Bar", level_directory, verbose),
            )
            plot_distribution_pie(
                total_all_pairs_shortest_paths, DISTANCE_COLUMN, PAIR_COUNT_COLUMN,
                f"{description} — All Pairs Shortest Path by Distance",
                chart_file_path(f"{subdirectory}_AllPairsShortestPath_Pie", level_directory, verbose),
            )

        pivoted_all_pairs_shortest_paths = pivot_distribution_by_project(all_pairs_shortest_paths_data, DISTANCE_COLUMN, PAIR_COUNT_COLUMN, SOURCE_PROJECT_COLUMN)
        if not pivoted_all_pairs_shortest_paths.empty:
            plot_per_project_stacked_bar(
                pivoted_all_pairs_shortest_paths,
                f"{description} — All Pairs Shortest Path per Project (absolute, log scale)",
                chart_file_path(f"{subdirectory}_AllPairsShortestPath_StackedBar_Log", level_directory, verbose),
                use_log_scale=True,
            )
            normalized_all_pairs_shortest_paths = normalize_distribution_by_project(pivoted_all_pairs_shortest_paths)
            plot_per_project_normalized_bar(
                normalized_all_pairs_shortest_paths,
                f"{description} — All Pairs Shortest Path per Project (normalised)",
                chart_file_path(f"{subdirectory}_AllPairsShortestPath_StackedBar_Normalised", level_directory, verbose),
            )

        diameter_data = max_distance_per_project(all_pairs_shortest_paths_data)
        if not diameter_data.empty:
            plot_diameter_bar(
                diameter_data, SOURCE_PROJECT_COLUMN, "diameter",
                f"{description} — Graph Diameter per Project",
                chart_file_path(f"{subdirectory}_GraphDiameter_per_Project", level_directory, verbose),
            )

    # ── Longest path charts ────────────────────────────────────────────────────
    longest_data = load_csv(longest_csv, verbose)
    if longest_data is not None and not longest_data.empty:
        print(f"{SCRIPT_NAME}: Generating Longest Path charts for {description}...")

        total_longest = aggregate_total_distribution(longest_data)

        if not total_longest.empty:
            plot_distribution_bar(
                total_longest, DISTANCE_COLUMN, PAIR_COUNT_COLUMN,
                f"{description} — Longest Path Distribution",
                chart_file_path(f"{subdirectory}_LongestPath_Bar", level_directory, verbose),
            )
            plot_distribution_pie(
                total_longest, DISTANCE_COLUMN, PAIR_COUNT_COLUMN,
                f"{description} — Longest Path by Distance",
                chart_file_path(f"{subdirectory}_LongestPath_Pie", level_directory, verbose),
            )

        pivoted_longest = pivot_distribution_by_project(longest_data, DISTANCE_COLUMN, PAIR_COUNT_COLUMN, SOURCE_PROJECT_COLUMN)
        if not pivoted_longest.empty:
            plot_per_project_stacked_bar(
                pivoted_longest,
                f"{description} — Longest Path per Project (absolute, log scale)",
                chart_file_path(f"{subdirectory}_LongestPath_StackedBar_Log", level_directory, verbose),
                use_log_scale=True,
            )
            normalized_longest = normalize_distribution_by_project(pivoted_longest)
            plot_per_project_normalized_bar(
                normalized_longest,
                f"{description} — Longest Path per Project (normalised)",
                chart_file_path(f"{subdirectory}_LongestPath_StackedBar_Normalised", level_directory, verbose),
            )

        max_longest = max_distance_per_project(longest_data)
        if not max_longest.empty:
            plot_diameter_bar(
                max_longest, SOURCE_PROJECT_COLUMN, "diameter",
                f"{description} — Max Longest Path per Project",
                chart_file_path(f"{subdirectory}_MaxLongestPath_per_Project", level_directory, verbose),
            )


# ── Main ──────────────────────────────────────────────────────────────────────


def main() -> None:
    parameters = parse_parameters()

    if parameters.verbose:
        print(parameters)
        Parameters.log_dependency_versions()

    if not parameters.report_directory:
        print(f"{SCRIPT_NAME}: Error: --report_directory is required.", file=sys.stderr)
        sys.exit(1)

    if not os.path.isdir(parameters.report_directory):
        print(
            f"{SCRIPT_NAME}: Error: report directory does not exist: {parameters.report_directory}",
            file=sys.stderr,
        )
        sys.exit(1)

    print(f"{SCRIPT_NAME}: Generating path finding charts in {parameters.report_directory}...")

    for subdirectory, node_label, description in ABSTRACTION_LEVELS:
        generate_charts_for_level(
            subdirectory=subdirectory,
            node_label=node_label,
            description=description,
            report_directory=parameters.report_directory,
            verbose=parameters.verbose,
        )

    print(f"{SCRIPT_NAME}: Successfully finished.")


if __name__ == "__main__":
    main()
