#!/usr/bin/env python

# Generates git history charts as SVG files from CSV data produced by gitHistoryCsv.sh.
# Charts are saved to the report directory and referenced by the Markdown summary report.
#
# Charts produced:
#   Treemaps (directory commit statistics): 13 charts
#   Co-change treemaps: 3 charts
#   Bar chart (files per commit distribution): 1 chart
#   Histograms (co-changed files by metric): 4 charts
#   Wordcloud (git authors): 1 chart
#
# Input Parameters:
#  --report_directory   path to the report directory (contains CSV files from gitHistoryCsv.sh)
#  --verbose            optional finer-grained logging
#
# Prerequisites:
#  - gitHistoryCsv.sh must have run first to produce the required CSV files.
#  - If the report directory does not exist or CSVs are absent, exits with 0 without generating anything.

import os
import sys
import argparse
from typing import Any, cast

import pandas as pd
import numpy as np

import matplotlib
matplotlib.use('Agg')  # Non-interactive backend — required for headless script execution
import matplotlib.pyplot as plot

from plotly import graph_objects as plotly_graph_objects
from plotly.express import colors as plotly_colors
from plotly.subplots import make_subplots

SCRIPT_NAME = "gitHistoryCharts"

# ── Plotly layout constants ───────────────────────────────────────────────────

PLOTLY_MAIN_LAYOUT_BASE_SETTINGS: dict[str, Any] = dict(
    margin=dict(t=80, l=15, r=15, b=15),
)
PLOTLY_TREEMAP_FIGURE_SHOW_SETTINGS = dict(
    width=1080,
    height=1080,
    config={"scrollZoom": False, "displaylogo": False, "displayModeBar": False},
)
PLOTLY_TREEMAP_MARKER_BASE_STYLE = dict(
    cornerradius=5,
)
PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE = dict(
    **PLOTLY_TREEMAP_MARKER_BASE_STYLE,
    colorscale="Hot_r",
)


# ── Parameters ────────────────────────────────────────────────────────────────

class Parameters:
    def __init__(self, report_directory: str, verbose: bool) -> None:
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
        from numpy import __version__ as numpy_version
        print(f"numpy version: {numpy_version}")
        from plotly import version as plotly_version
        print(f"plotly version: {plotly_version}")
        from matplotlib import __version__ as matplotlib_version
        print(f"matplotlib version: {matplotlib_version}")
        print("---------------------------------------")


def parse_parameters() -> Parameters:
    parser = argparse.ArgumentParser(
        description="Generates git history charts as SVG files from CSV data."
    )
    parser.add_argument(
        "--report_directory",
        type=str,
        default="",
        help="Path to the report directory containing CSV files from gitHistoryCsv.sh",
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


# ── CSV loading helpers ───────────────────────────────────────────────────────

def load_csv(report_directory: str, filename: str, verbose: bool) -> pd.DataFrame:
    """Load a CSV file from the report directory. Returns empty DataFrame if file is missing."""
    path = os.path.join(report_directory, filename)
    if not os.path.isfile(path):
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping — CSV not found: {path}")
        return pd.DataFrame()
    data_frame = pd.read_csv(path)
    if verbose:
        print(f"{SCRIPT_NAME}: Loaded {len(data_frame)} rows from {path}")
    return data_frame


def get_plotly_figure_write_image_settings(report_directory: str, name: str) -> dict:
    """Returns the settings for the plotly figure write_image method."""
    return dict(
        file=os.path.join(report_directory, name + ".svg"),
        format="svg",
        width=1080,
        height=1080,
    )


# ── Data preparation functions ────────────────────────────────────────────────

def add_quantile_limited_column(input_data_frame: pd.DataFrame, column_name: str, quantile: float = 0.95) -> pd.DataFrame:
    """Limits the values of the given column to the given quantile (caps rather than filters)."""
    data_frame = input_data_frame.copy()
    column_values = data_frame[column_name]
    column_limit = column_values.quantile(quantile)
    data_frame[column_name + "_limited"] = np.where(column_values > column_limit, column_limit, column_values)
    return data_frame


def add_rank_column(input_data_frame: pd.DataFrame, column_name: str) -> pd.DataFrame:
    """Adds a dense rank column based on the given column."""
    data_frame = input_data_frame.copy()
    data_frame[column_name + "_rank"] = data_frame[column_name].rank(ascending=True, method="dense")
    return data_frame


def get_last_entry(values: list):
    """Returns the last element of a list."""
    return values[-1]


def add_file_extension_column(input_dataframe: pd.DataFrame, file_path_column: str, file_extension_column: str = "fileExtension") -> pd.DataFrame:
    """Adds a file extension column derived from the file path."""
    if file_extension_column in input_dataframe.columns:
        return input_dataframe
    file_path_col_pos = cast(int, input_dataframe.columns.get_loc(file_path_column))
    file_extensions = input_dataframe[file_path_column].str.split("/").map(get_last_entry)
    file_extensions = file_extensions.str.split(".").map(get_last_entry)
    input_dataframe.insert(file_path_col_pos + 1, file_extension_column, file_extensions)
    return input_dataframe


def remove_last_file_path_element(file_path_elements: list) -> list:
    return file_path_elements[:-1] if len(file_path_elements) > 1 else [""]


def convert_path_elements_to_directories(file_path_elements: list) -> list:
    directories = remove_last_file_path_element(file_path_elements)
    return ["/".join(directories[: i + 1]) for i in range(len(directories))]


def add_directory_column(input_dataframe: pd.DataFrame, file_path_column: str, directory_column: str = "directoryPath") -> pd.DataFrame:
    """Explodes file paths into all ancestor directory paths."""
    if directory_column in input_dataframe.columns:
        return input_dataframe
    input_dataframe.insert(
        0,
        directory_column,
        input_dataframe[file_path_column].str.split("/").apply(convert_path_elements_to_directories),
    )
    input_dataframe = input_dataframe.explode(directory_column)
    return input_dataframe


def add_directory_name_column(input_dataframe: pd.DataFrame, directory_column: str = "directoryPath", directory_name_column: str = "directoryName") -> pd.DataFrame:
    """Adds the final path component as a name column."""
    if directory_name_column in input_dataframe.columns:
        return input_dataframe
    splitted = input_dataframe[directory_column].str.rsplit("/", n=1)
    input_dataframe.insert(1, directory_name_column, splitted.apply(lambda x: x[-1]))
    return input_dataframe


def add_parent_directory_column(input_dataframe: pd.DataFrame, directory_column: str = "directoryPath", directory_parent_column: str = "directoryParentPath") -> pd.DataFrame:
    """Adds the parent directory path column."""
    if directory_parent_column in input_dataframe.columns:
        return input_dataframe
    splitted = input_dataframe[directory_column].str.rsplit("/", n=1)
    input_dataframe.insert(1, directory_parent_column, splitted.apply(lambda x: x[0]))
    input_dataframe.loc[
        input_dataframe[directory_parent_column] == input_dataframe[directory_column],
        directory_parent_column,
    ] = ""
    return input_dataframe


def collect_as_array(values: pd.Series):
    return np.asanyarray(values.to_list())


def second_entry(values: pd.Series):
    return values.iloc[1] if len(values) > 1 else None


def _to_array(value) -> list:
    """Converts a value to a list, splitting comma-separated strings if needed."""
    if isinstance(value, str):
        return value.split(",")
    return list(value)


def get_flattened_unique_values(values: pd.Series):
    return np.unique(np.concatenate([_to_array(v) for v in values.to_list()]))


def count_unique_aggregated_values(values: pd.Series):
    return len(np.unique(np.concatenate([_to_array(v) for v in values.to_list()])))


def get_most_frequent_entry(input_values: pd.Series):
    all_values = np.concatenate([_to_array(v) for v in input_values.to_list()])
    unique_vals, counts = np.unique(all_values, return_counts=True)
    return unique_vals[counts.argmax()]


# ── Directory commit statistics preparation ───────────────────────────────────

def prepare_directory_commit_statistics(commit_statistics_data: pd.DataFrame) -> tuple:
    """
    Multi-step grouping pipeline that transforms per-file commit statistics
    into a hierarchical directory structure suitable for treemaps.

    Returns: (git_files_with_commit_statistics, git_file_authors, git_file_extensions)
    """
    # Derive author rankings
    git_file_authors = (
        commit_statistics_data[["author", "commitCount"]]
        .groupby("author")
        .aggregate(authorCommitCount=pd.NamedAgg(column="commitCount", aggfunc="sum"))
        .sort_values(by="authorCommitCount", ascending=False)
        .reset_index()
    )
    git_file_authors["authorCommitCountRank"] = (
        git_file_authors["authorCommitCount"]
        .rank(ascending=False, method="dense")
        .astype(int)
    )

    # Add file extension column
    git_files_with_commit_statistics = add_file_extension_column(commit_statistics_data.copy(), "filePath", "fileExtension")

    # Derive extension rankings
    git_file_extensions = (
        git_files_with_commit_statistics["fileExtension"]
        .value_counts()
        .rename_axis("fileExtension")
        .reset_index(name="fileExtensionCount")
    )
    git_file_extensions["fileExtensionCountRank"] = (
        git_file_extensions["fileExtensionCount"]
        .rank(ascending=False, method="dense")
        .astype(int)
    )

    # Explode directories
    git_files_with_commit_statistics = add_directory_column(git_files_with_commit_statistics, "filePath", "directoryPath")

    common_named_aggregation = dict(
        daysSinceLastCommit=pd.NamedAgg(column="daysSinceLastCommit", aggfunc="min"),
        daysSinceLastCreation=pd.NamedAgg(column="daysSinceLastCreation", aggfunc="min"),
        daysSinceLastModification=pd.NamedAgg(column="daysSinceLastModification", aggfunc="min"),
        lastCommitDate=pd.NamedAgg(column="lastCommitDate", aggfunc="max"),
        lastCreationDate=pd.NamedAgg(column="lastCreationDate", aggfunc="max"),
        lastModificationDate=pd.NamedAgg(column="lastModificationDate", aggfunc="max"),
        maxCommitSha=pd.NamedAgg(column="maxCommitSha", aggfunc="max"),
    )

    # Group by directory + author
    git_files_with_commit_statistics = git_files_with_commit_statistics.groupby(["directoryPath", "author"]).aggregate(
        filePaths=pd.NamedAgg(column="filePath", aggfunc=np.unique),
        firstFile=pd.NamedAgg(column="filePath", aggfunc="first"),
        fileExtensions=pd.NamedAgg(column="fileExtension", aggfunc=collect_as_array),
        commitHashes=pd.NamedAgg(column="commitHashes", aggfunc=get_flattened_unique_values),
        intermediateCommitCount=pd.NamedAgg(column="commitHashes", aggfunc="count"),
        **common_named_aggregation,
    )
    git_files_with_commit_statistics = git_files_with_commit_statistics.sort_values(by=["directoryPath", "intermediateCommitCount"], ascending=[True, False])
    git_files_with_commit_statistics = git_files_with_commit_statistics.reset_index()

    # Group by directory only
    git_files_with_commit_statistics = git_files_with_commit_statistics.groupby("directoryPath").aggregate(
        fileCount=pd.NamedAgg(column="filePaths", aggfunc=count_unique_aggregated_values),
        firstFile=pd.NamedAgg(column="firstFile", aggfunc="first"),
        mostFrequentFileExtension=pd.NamedAgg(column="fileExtensions", aggfunc=get_most_frequent_entry),
        authorCount=pd.NamedAgg(column="author", aggfunc="nunique"),
        mainAuthor=pd.NamedAgg(column="author", aggfunc="first"),
        secondAuthor=pd.NamedAgg(column="author", aggfunc=second_entry),
        commitCount=pd.NamedAgg(column="commitHashes", aggfunc=count_unique_aggregated_values),
        **common_named_aggregation,
    )
    git_files_with_commit_statistics = git_files_with_commit_statistics.reset_index()

    # Add directory name and parent
    git_files_with_commit_statistics = add_directory_name_column(git_files_with_commit_statistics, "directoryPath", "directoryName")
    git_files_with_commit_statistics = add_parent_directory_column(git_files_with_commit_statistics, "directoryPath", "directoryParentPath")

    # Final grouping: consolidate duplicate entries
    all_columns_except_directory = git_files_with_commit_statistics.columns.to_list()[3:]
    git_files_with_commit_statistics = git_files_with_commit_statistics.groupby(all_columns_except_directory).aggregate(
        directoryName=pd.NamedAgg(column="directoryName", aggfunc=lambda names: "/".join(names)),
        directoryParentPath=pd.NamedAgg(column="directoryParentPath", aggfunc="first"),
        directoryPath=pd.NamedAgg(column="directoryPath", aggfunc="last"),
    )
    final_column_order = ["directoryPath", "directoryParentPath", "directoryName"] + all_columns_except_directory
    git_files_with_commit_statistics = git_files_with_commit_statistics.reset_index()[final_column_order]

    return git_files_with_commit_statistics, git_file_authors, git_file_extensions


# ── Treemap creation helpers ──────────────────────────────────────────────────

def create_treemap_commit_statistics_settings(data_frame: pd.DataFrame) -> plotly_graph_objects.Treemap:
    """Creates a Plotly Treemap with the given settings and data frame."""
    return plotly_graph_objects.Treemap(
        labels=data_frame["directoryName"],
        parents=data_frame["directoryParentPath"],
        ids=data_frame["directoryPath"],
        customdata=data_frame[
            [
                "fileCount",
                "mostFrequentFileExtension",
                "commitCount",
                "authorCount",
                "mainAuthor",
                "secondAuthor",
                "lastCommitDate",
                "daysSinceLastCommit",
                "lastCreationDate",
                "daysSinceLastCreation",
                "lastModificationDate",
                "daysSinceLastModification",
                "directoryPath",
            ]
        ],
        hovertemplate=(
            "<b>%{label}</b><br>"
            "Files: %{customdata[0]} (%{customdata[1]})<br>"
            "Commits: %{customdata[2]}<br>"
            "Authors: %{customdata[4]},  %{customdata[5]},.. (%{customdata[3]})<br>"
            "Last Commit: %{customdata[6]} (%{customdata[7]} days ago)<br>"
            "Last Created: %{customdata[8]} (%{customdata[9]} days ago)<br>"
            "Last Modified: %{customdata[10]} (%{customdata[11]} days ago)<br>"
            "Path: %{customdata[12]}"
        ),
        maxdepth=-1,
        root_color="lightgrey",
        marker=dict(**PLOTLY_TREEMAP_MARKER_BASE_STYLE),
    )


def create_rank_colorbar_for_graph_objects_treemap_marker(data_frame: pd.DataFrame, name_column: str, rank_column: str) -> dict:
    """Creates a plotly graph_objects.Treemap marker object for a colorbar representing ranked names."""
    inverse_ranked = data_frame[rank_column].max() + 1 - data_frame[rank_column]
    return dict(
        cornerradius=5,
        colors=inverse_ranked,
        colorscale=plotly_colors.qualitative.G10,
        colorbar=dict(
            title="Rank",
            tickmode="array",
            ticktext=data_frame[name_column],
            tickvals=inverse_ranked,
            tickfont_size=10,
        ),
    )


def write_image_and_log(figure: plotly_graph_objects.Figure, report_directory: str, name: str, verbose: bool) -> None:
    """Writes the figure as SVG and optionally logs the output path."""
    figure.write_image(**get_plotly_figure_write_image_settings(report_directory, name))
    if verbose:
        print(f"{SCRIPT_NAME}: Chart saved: {os.path.join(report_directory, name + '.svg')}")


# ── Treemap charts: directory commit statistics ───────────────────────────────

def generate_directory_commit_statistic_treemaps(
    git_files_with_commit_statistics: pd.DataFrame,
    git_file_authors: pd.DataFrame,
    git_file_extensions: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    # 1. Number of files per directory
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_files_with_commit_statistics),
        values=git_files_with_commit_statistics["fileCount"],
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Directories and their file count")
    write_image_and_log(figure, report_directory, "NumberOfFilesPerDirectory", verbose)

    # 2. Most frequent file extension per directory
    git_files_with_commit_statistics_and_file_extension_rank = pd.merge(
        git_files_with_commit_statistics,
        git_file_extensions,
        left_on="mostFrequentFileExtension",
        right_on="fileExtension",
        how="left",
        validate="m:1",
    )
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_files_with_commit_statistics),
        marker=create_rank_colorbar_for_graph_objects_treemap_marker(git_files_with_commit_statistics_and_file_extension_rank, "fileExtension", "fileExtensionCountRank"),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Most frequent file extension per directory")
    write_image_and_log(figure, report_directory, "MostFrequentFileExtensionPerDirectory", verbose)

    # 3. Number of commits per directory
    git_commit_count_per_directory = add_quantile_limited_column(git_files_with_commit_statistics, "commitCount", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_count_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_count_per_directory["commitCount_limited"],
            colorbar=dict(title="Commits"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Number of git commits")
    write_image_and_log(figure, report_directory, "NumberOfGitCommits", verbose)

    # 4. Number of distinct authors per directory
    git_commit_authors_per_directory = add_quantile_limited_column(git_files_with_commit_statistics, "authorCount", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_authors_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_authors_per_directory["authorCount_limited"],
            colorbar=dict(title="Authors"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Number of distinct commit authors")
    write_image_and_log(figure, report_directory, "NumberOfDistinctCommitAuthors", verbose)

    # 5. Directories with very few different authors (low bus-factor, focus = few authors)
    git_commit_authors_per_directory_low_focus = add_quantile_limited_column(git_files_with_commit_statistics, "authorCount", 0.33)
    author_count_top_limit = git_commit_authors_per_directory_low_focus["authorCount_limited"].max().astype(int).astype(str)
    author_count_top_limit_label_alias = {author_count_top_limit: author_count_top_limit + " or more"}
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_authors_per_directory_low_focus),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_authors_per_directory_low_focus["authorCount_limited"],
            colorbar=dict(
                title="Authors",
                tickmode="auto",
                labelalias=author_count_top_limit_label_alias,
            ),
            reversescale=True,
        ),
    ))
    figure.update_layout(
        **PLOTLY_MAIN_LAYOUT_BASE_SETTINGS,
        title="Number of distinct commit authors (red/black = only one or very few authors)",
    )
    write_image_and_log(figure, report_directory, "NumberOfDistinctCommitAuthorsLowFocus", verbose)

    # 6. Main author per directory
    git_files_with_commit_statistics_and_main_author_rank = pd.merge(
        git_files_with_commit_statistics,
        git_file_authors,
        left_on="mainAuthor",
        right_on="author",
        how="left",
        validate="m:1",
    )
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_files_with_commit_statistics),
        marker=create_rank_colorbar_for_graph_objects_treemap_marker(git_files_with_commit_statistics_and_main_author_rank, "mainAuthor", "authorCommitCountRank"),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Main authors with highest number of commits")
    write_image_and_log(figure, report_directory, "MainAuthorsWithHighestNumberOfCommits", verbose)

    # 7. Second author per directory
    git_files_with_commit_statistics_and_second_author_rank = pd.merge(
        git_files_with_commit_statistics,
        git_file_authors,
        left_on="secondAuthor",
        right_on="author",
        how="left",
        validate="m:1",
    )
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_files_with_commit_statistics),
        marker=create_rank_colorbar_for_graph_objects_treemap_marker(git_files_with_commit_statistics_and_second_author_rank, "secondAuthor", "authorCommitCountRank"),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Second author with the second highest number of commits")
    write_image_and_log(figure, report_directory, "SecondAuthorWithTheSecondHighestNumberOfCommits", verbose)

    # 8. Days since last commit per directory
    git_commit_days_since_last_commit_per_directory = add_quantile_limited_column(git_files_with_commit_statistics, "daysSinceLastCommit", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_commit_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_commit_per_directory["daysSinceLastCommit_limited"],
            colorbar=dict(title="Days"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Days since last commit")
    write_image_and_log(figure, report_directory, "DaysSinceLastCommit", verbose)

    # 9. Days since last commit per directory (ranked)
    git_commit_days_since_last_commit_per_directory = add_rank_column(git_files_with_commit_statistics, "daysSinceLastCommit")
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_commit_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_commit_per_directory["daysSinceLastCommit_rank"],
            colorbar=dict(title="Rank"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Rank of days since last commit")
    write_image_and_log(figure, report_directory, "DaysSinceLastCommitRanked", verbose)

    # 10. Days since last file creation per directory
    git_commit_days_since_last_file_creation_per_directory = add_quantile_limited_column(git_files_with_commit_statistics, "daysSinceLastCreation", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_file_creation_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_file_creation_per_directory["daysSinceLastCreation_limited"],
            colorbar=dict(title="Days"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Days since last file creation")
    write_image_and_log(figure, report_directory, "DaysSinceLastFileCreation", verbose)

    # 11. Days since last file creation per directory (ranked)
    git_commit_days_since_last_file_creation_per_directory = add_rank_column(git_files_with_commit_statistics, "daysSinceLastCreation")
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_file_creation_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_file_creation_per_directory["daysSinceLastCreation_rank"],
            colorbar=dict(title="Rank"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Rank of days since last file creation")
    write_image_and_log(figure, report_directory, "DaysSinceLastFileCreationRanked", verbose)

    # 12. Days since last file modification per directory
    git_commit_days_since_last_file_modification_per_directory = add_quantile_limited_column(git_files_with_commit_statistics, "daysSinceLastModification", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_file_modification_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_file_modification_per_directory["daysSinceLastModification_limited"],
            colorbar=dict(title="Days"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Days since last file modification")
    write_image_and_log(figure, report_directory, "DaysSinceLastFileModification", verbose)

    # 13. Days since last file modification per directory (ranked)
    git_commit_days_since_last_file_modification_per_directory = add_rank_column(git_files_with_commit_statistics, "daysSinceLastModification")
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(git_commit_days_since_last_file_modification_per_directory),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=git_commit_days_since_last_file_modification_per_directory["daysSinceLastModification_rank"],
            colorbar=dict(title="Rank"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Rank of days since last file modification")
    write_image_and_log(figure, report_directory, "DaysSinceLastFileModificationRanked", verbose)


# ── Co-change treemap charts ──────────────────────────────────────────────────

def generate_cochange_treemaps(
    git_files_with_commit_statistics: pd.DataFrame,
    cochange_data: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    # Prepare co-change data
    data_to_display = add_directory_column(cochange_data.copy(), "filePath", "directoryPath")
    data_to_display = (
        data_to_display.groupby(["directoryPath"])
        .aggregate(
            pairwiseChangeCommitCount=pd.NamedAgg(column="commitCount", aggfunc="sum"),
            pairwiseChangeFileCount=pd.NamedAgg(column="filePath", aggfunc="count"),
            pairwiseChangeAverageRate=pd.NamedAgg(column="coChangeRate", aggfunc="mean"),
            pairwiseChangeMaxLift=pd.NamedAgg(column="maxLift", aggfunc="max"),
            pairwiseChangeAverageLift=pd.NamedAgg(column="avgLift", aggfunc="mean"),
        )
        .reset_index()
    )
    data_to_display = pd.merge(
        git_files_with_commit_statistics,
        data_to_display,
        left_on="directoryPath",
        right_on="directoryPath",
        how="left",
        validate="m:1",
    )
    data_to_display["pairwiseChangeCommitCount"] = data_to_display["pairwiseChangeCommitCount"].fillna(0).astype(int)
    data_to_display["pairwiseChangeFileCount"] = data_to_display["pairwiseChangeFileCount"].fillna(0).astype(int)
    data_to_display["pairwiseChangeAverageRate"] = data_to_display["pairwiseChangeAverageRate"].fillna(0).astype(float)
    data_to_display["pairwiseChangeMaxLift"] = data_to_display["pairwiseChangeMaxLift"].fillna(0).astype(float)
    data_to_display["pairwiseChangeAverageLift"] = data_to_display["pairwiseChangeAverageLift"].fillna(0).astype(float)
    data_to_display = data_to_display.reset_index()

    # 14. Files that likely co-change with others
    data_to_display = add_quantile_limited_column(data_to_display, "pairwiseChangeCommitCount", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(data_to_display),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=data_to_display["pairwiseChangeCommitCount_limited"],
            colorbar=dict(title="Co-Changes"),
        ),
    ))
    figure.update_layout(**PLOTLY_MAIN_LAYOUT_BASE_SETTINGS, title="Files that likely co-change with others in update commits")
    write_image_and_log(figure, report_directory, "CoChangingFiles", verbose)

    # 15. Co-changing files max lift
    data_to_display = add_quantile_limited_column(data_to_display, "pairwiseChangeMaxLift", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(data_to_display),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=data_to_display["pairwiseChangeMaxLift_limited"],
            colorbar=dict(title="Co-Change Lift"),
        ),
    ))
    figure.update_layout(
        **PLOTLY_MAIN_LAYOUT_BASE_SETTINGS,
        title="Co-Changing files in update commits max lift (1=random, >1=more than random, <1=less than random)",
    )
    write_image_and_log(figure, report_directory, "CoChangingFilesMaxLift", verbose)

    # 16. Co-changing files average lift
    data_to_display = add_quantile_limited_column(data_to_display, "pairwiseChangeAverageLift", 0.98)
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_commit_statistics_settings(data_to_display),
        marker=dict(
            **PLOTLY_TREEMAP_MARKER_BASE_COLORSCALE,
            colors=data_to_display["pairwiseChangeAverageLift_limited"],
            colorbar=dict(title="Co-Change Lift"),
        ),
    ))
    figure.update_layout(
        **PLOTLY_MAIN_LAYOUT_BASE_SETTINGS,
        title="Co-Changing files in update commits average lift (1=random, >1=more than random, <1=less than random)",
    )
    write_image_and_log(figure, report_directory, "CoChangingFilesAverageLift", verbose)


# ── Bar chart: files per commit distribution ──────────────────────────────────

def generate_files_per_commit_bar_chart(
    git_file_count_per_commit: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    if git_file_count_per_commit.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping files-per-commit bar chart — no data")
        return
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Bar(
        x=git_file_count_per_commit["filesPerCommit"].head(30),
        y=git_file_count_per_commit["commitCount"].head(30),
    ))
    figure.update_layout(
        **PLOTLY_MAIN_LAYOUT_BASE_SETTINGS,
        title="Changed files per commit",
        xaxis_title="file count",
        yaxis_title="commit count",
    )
    write_image_and_log(figure, report_directory, "ChangedFilesPerCommit", verbose)


# ── Histogram charts: pairwise co-changed files ───────────────────────────────

def add_file_extension_rank_column(data_frame: pd.DataFrame, column_name: str) -> pd.DataFrame:
    if column_name + "_rank" in data_frame.columns:
        return data_frame
    data_frame[f"{column_name}ExtensionRank"] = (
        data_frame.groupby("fileExtensionPair", observed=False)[column_name]
        .rank(ascending=False, method="dense")
        .astype(int)
    )
    return data_frame


def plot_histogram_of_pairwise_changed_files(
    data_to_plot: pd.DataFrame,
    top_pairwise_changed_file_extensions: pd.Series,
    x_axis_column: str,
    x_axis_label: str,
    output_file_name: str,
    report_directory: str,
    verbose: bool,
    sub_plot_rows: int = 4,
    sub_plot_columns: int = 1,
) -> None:
    if data_to_plot.empty:
        print("No data to plot")
        return
    if top_pairwise_changed_file_extensions.size != sub_plot_rows * sub_plot_columns:
        raise ValueError(
            f"Number of top pairwise changed file extensions ({top_pairwise_changed_file_extensions.size}) "
            f"does not match the number of subplots ({sub_plot_rows * sub_plot_columns})."
        )

    figure = make_subplots(
        rows=sub_plot_rows,
        cols=sub_plot_columns,
        subplot_titles=top_pairwise_changed_file_extensions,
        vertical_spacing=0.06,
        horizontal_spacing=0.04,
    )
    for index, extension in enumerate(top_pairwise_changed_file_extensions, start=1):
        row = (index - 1) // sub_plot_columns + 1
        column = (index - 1) % sub_plot_columns + 1
        data_for_subplot = data_to_plot[data_to_plot["fileExtensionPair"] == extension]
        figure.add_trace(
            plotly_graph_objects.Histogram(
                x=data_for_subplot[x_axis_column],
                text=data_for_subplot["filePairLineBreak"],
                textposition="inside",
                hovertext=data_for_subplot["filePairWithRelativePath"],
                nbinsx=40,
                textfont=dict(size=12, color="white"),
                name=extension,
            ),
            row=row,
            col=column,
        )
        figure.update_xaxes(title_text=x_axis_label, row=row, col=column)
        figure.update_yaxes(title_text="File Pair Count (log)", type="log", row=row, col=column)

    figure.update_annotations(font=dict(size=18))
    figure.update_layout(
        margin=dict(t=100, l=10, r=10, b=10),
        title="Co-Changed Files by their " + x_axis_label.lower(),
        title_font_size=20,
        title_y=0.99,
        bargap=0.05,
        height=2000,
        width=1000,
        showlegend=False,
    )
    figure.write_image(**get_plotly_figure_write_image_settings(report_directory, output_file_name))
    if verbose:
        print(f"{SCRIPT_NAME}: Chart saved: {os.path.join(report_directory, output_file_name + '.svg')}")


def find_top_pairwise_changed_file_extensions(input_data: pd.DataFrame, top_n: int = 10) -> pd.DataFrame:
    """Finds the top N pairwise changed file extensions based on pair count."""
    top_extensions = (
        input_data.groupby("fileExtensionPair", observed=False)
        .aggregate(fileExtensionPairCount=pd.NamedAgg(column="filePairWithRelativePath", aggfunc="count"))
        .reset_index()
    )
    return top_extensions.sort_values(by="fileExtensionPairCount", ascending=False).reset_index(drop=True).head(top_n)


def generate_pairwise_histograms(
    pairwise_changed_git_files: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    if pairwise_changed_git_files.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping pairwise histograms — no data")
        return

    # Find top 4 file extension pairs (matching the original notebook behavior)
    top_pairwise_changed_file_extensions_data = find_top_pairwise_changed_file_extensions(pairwise_changed_git_files, top_n=4)

    if len(top_pairwise_changed_file_extensions_data) < 4:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping pairwise histograms — fewer than 4 extension pairs "
                  f"(found {len(top_pairwise_changed_file_extensions_data)})")
        return

    pairwise_changed_git_files = pairwise_changed_git_files.merge(top_pairwise_changed_file_extensions_data, on="fileExtensionPair")
    top_pairwise_changed_file_extensions = top_pairwise_changed_file_extensions_data["fileExtensionPair"]
    pairwise_changed_git_files = pairwise_changed_git_files[pairwise_changed_git_files["fileExtensionPair"].isin(top_pairwise_changed_file_extensions)]

    pairwise_changed_git_files = add_file_extension_rank_column(pairwise_changed_git_files, "updateCommitCount")
    pairwise_changed_git_files = add_file_extension_rank_column(pairwise_changed_git_files, "updateCommitMinConfidence")
    pairwise_changed_git_files = add_file_extension_rank_column(pairwise_changed_git_files, "updateCommitJaccardSimilarity")
    pairwise_changed_git_files = add_file_extension_rank_column(pairwise_changed_git_files, "updateCommitLift")

    plot_histogram_of_pairwise_changed_files(
        data_to_plot=pairwise_changed_git_files,
        top_pairwise_changed_file_extensions=top_pairwise_changed_file_extensions,
        x_axis_column="updateCommitCount",
        x_axis_label="Commit Count",
        output_file_name="CoChangedFilesByCommitCount",
        report_directory=report_directory,
        verbose=verbose,
    )

    plot_histogram_of_pairwise_changed_files(
        data_to_plot=pairwise_changed_git_files,
        top_pairwise_changed_file_extensions=top_pairwise_changed_file_extensions,
        x_axis_column="updateCommitMinConfidence",
        x_axis_label="Commit Min Confidence",
        output_file_name="CoChangedFilesByCommitMinConfidence",
        report_directory=report_directory,
        verbose=verbose,
    )

    plot_histogram_of_pairwise_changed_files(
        data_to_plot=pairwise_changed_git_files,
        top_pairwise_changed_file_extensions=top_pairwise_changed_file_extensions,
        x_axis_column="updateCommitLift",
        x_axis_label="Commit Lift",
        output_file_name="CoChangedFilesByCommitLift",
        report_directory=report_directory,
        verbose=verbose,
    )

    plot_histogram_of_pairwise_changed_files(
        data_to_plot=pairwise_changed_git_files,
        top_pairwise_changed_file_extensions=top_pairwise_changed_file_extensions,
        x_axis_column="updateCommitJaccardSimilarity",
        x_axis_label="Commit Jaccard Similarity",
        output_file_name="CoChangedFilesByCommitJaccardSimilarity",
        report_directory=report_directory,
        verbose=verbose,
    )


# ── Git author wordcloud ──────────────────────────────────────────────────────

def generate_git_author_wordcloud(
    git_author_words_with_frequency: pd.DataFrame,
    report_directory: str,
    verbose: bool,
) -> None:
    if git_author_words_with_frequency.empty:
        if verbose:
            print(f"{SCRIPT_NAME}: Skipping wordcloud — no data")
        return
    try:
        from wordcloud import WordCloud  # type: ignore
    except ImportError:
        print(f"{SCRIPT_NAME}: Warning: wordcloud library not installed — skipping wordcloud chart")
        return

    words_with_frequency_dict = git_author_words_with_frequency.set_index(git_author_words_with_frequency.columns[0]).to_dict()[git_author_words_with_frequency.columns[1]]
    wordcloud = WordCloud(
        width=800,
        height=800,
        max_words=600,
        collocations=False,
        background_color="white",
        colormap="viridis",
    ).generate_from_frequencies(words_with_frequency_dict)

    plot.figure(figsize=(15, 15))
    plot.imshow(wordcloud, interpolation="bilinear")
    plot.axis("off")
    plot.title("Wordcloud of git authors")
    path = os.path.join(report_directory, "GitAuthorWordcloud.svg")
    plot.savefig(path, format="svg", bbox_inches="tight")
    plot.close()
    if verbose:
        print(f"{SCRIPT_NAME}: Chart saved: {path}")


# ── Main ──────────────────────────────────────────────────────────────────────

def main() -> None:
    params = parse_parameters()

    if params.verbose:
        params.log_dependency_versions()
        print(params)

    report_directory = params.report_directory
    verbose = params.verbose

    if not report_directory:
        print(f"{SCRIPT_NAME}: No report directory specified. Use --report_directory.")
        sys.exit(1)

    if not os.path.isdir(report_directory):
        print(f"{SCRIPT_NAME}: Report directory does not exist: {report_directory} — no git data, skipping chart generation.")
        sys.exit(0)

    print(f"{SCRIPT_NAME}: Generating charts in {report_directory}")

    # Load commit statistics CSV (primary data source)
    commit_statistics = load_csv(report_directory, "List_git_files_with_commit_statistics_by_author.csv", verbose)
    if commit_statistics.empty:
        print(f"{SCRIPT_NAME}: Primary CSV not found or empty — no git data, skipping chart generation.")
        sys.exit(0)

    # Prepare hierarchical directory data
    git_files_with_commit_statistics, git_file_authors, git_file_extensions = prepare_directory_commit_statistics(commit_statistics)

    if git_files_with_commit_statistics.empty:
        print(f"{SCRIPT_NAME}: No directory statistics available — skipping treemap charts.")
    else:
        print(f"{SCRIPT_NAME}: Generating directory commit statistic treemaps...")
        generate_directory_commit_statistic_treemaps(
            git_files_with_commit_statistics, git_file_authors, git_file_extensions, report_directory, verbose
        )

        # Co-change treemaps require the files-changed-together CSV
        cochange_data = load_csv(report_directory, "List_git_files_that_were_changed_together_with_another_file.csv", verbose)
        if not cochange_data.empty:
            print(f"{SCRIPT_NAME}: Generating co-change treemaps...")
            generate_cochange_treemaps(git_files_with_commit_statistics, cochange_data, report_directory, verbose)

    # Files per commit bar chart
    git_file_count_per_commit = load_csv(report_directory, "List_git_files_per_commit_distribution.csv", verbose)
    if not git_file_count_per_commit.empty:
        print(f"{SCRIPT_NAME}: Generating files-per-commit bar chart...")
        generate_files_per_commit_bar_chart(git_file_count_per_commit, report_directory, verbose)

    # Pairwise histograms use the full pairwise changed files list (same as the original notebook)
    pairwise_changed_git_files = load_csv(report_directory, "List_pairwise_changed_files.csv", verbose)
    if not pairwise_changed_git_files.empty:
        print(f"{SCRIPT_NAME}: Generating pairwise changed files histograms...")
        generate_pairwise_histograms(pairwise_changed_git_files, report_directory, verbose)

    # Wordcloud
    git_author_words_with_frequency = load_csv(report_directory, "Words_for_git_author_Wordcloud_with_frequency.csv", verbose)
    if not git_author_words_with_frequency.empty:
        print(f"{SCRIPT_NAME}: Generating git author wordcloud...")
        generate_git_author_wordcloud(git_author_words_with_frequency, report_directory, verbose)

    print(f"{SCRIPT_NAME}: Chart generation complete.")


if __name__ == "__main__":
    main()
