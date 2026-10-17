#!/usr/bin/env python

# This Python script uses Plotly Treemap Charts (https://plotly.com/python/treemaps) to visualize anomaly detection results for SCIP-indexed code.

from typing import Any, Literal, LiteralString, cast, TYPE_CHECKING

import os
import sys
import argparse
import pprint
import logging
from pathlib import Path

import pandas as pd
import numpy as np

from neo4j import GraphDatabase, Driver

# Import plotly only for type checking; runtime imports are lazy inside functions for testing with minimal dependencies
if TYPE_CHECKING:
    from plotly import graph_objects as plotly_graph_objects


class Parameters:
    required_parameters_ = ["projection_language"]

    def __init__(self, input_parameters: dict[str, str], report_directory: str = "", verbose: bool = False):
        self.query_parameters_ = input_parameters.copy()
        self.report_directory = report_directory
        self.verbose_ = verbose

    def __repr__(self) -> str:
        pretty_dict = pprint.pformat(self.query_parameters_, indent=4)
        return f"Parameters: verbose={self.verbose_}, report_directory={self.report_directory}, query_parameters:\n{pretty_dict}"

    @staticmethod
    def log_dependency_versions_() -> None:
        print('---------------------------------------')
        print('Python version: {}'.format(sys.version))
        from numpy import __version__ as numpy_version
        print('numpy version: {}'.format(numpy_version))
        from pandas import __version__ as pandas_version
        print('pandas version: {}'.format(pandas_version))
        from neo4j import __version__ as neo4j_version
        print('neo4j version: {}'.format(neo4j_version))
        from plotly import version as plotly_version
        print('plotly version: {}'.format(plotly_version))
        print('---------------------------------------')

    @classmethod
    def from_input_parameters(cls, input_parameters: dict[str, str], report_directory: str = "", verbose: bool = False) -> "Parameters":
        missing_parameters = [parameter for parameter in cls.required_parameters_ if parameter not in input_parameters]
        if missing_parameters:
            raise ValueError("Missing parameters:", missing_parameters)
        created_parameters = cls(input_parameters, report_directory, verbose)
        if created_parameters.is_verbose():
            print(created_parameters)
            cls.log_dependency_versions_()
        return created_parameters

    def __is_code_language_available(self) -> bool:
        return "projection_language" in self.query_parameters_

    def __get_projection_language(self) -> str:
        return self.query_parameters_["projection_language"] if self.__is_code_language_available() else ""

    def get_title_prefix(self) -> str:
        """Return the language prefix used for output file names."""
        if self.__is_code_language_available():
            return self.__get_projection_language()
        return ""

    def get_report_directory(self) -> str:
        """Return the directory where SVG report files are written."""
        return self.report_directory

    def is_verbose(self) -> bool:
        """Return True when verbose logging is enabled."""
        return self.verbose_


def parse_input_parameters() -> Parameters:
    """Parse command-line arguments and return a Parameters instance."""
    def parse_key_value_list(param_list: list[str]) -> dict[str, str]:
        param_dict: dict[str, str] = {}
        for item in param_list:
            if '=' in item:
                key, value = item.split('=', 1)
                param_dict[key] = value
        return param_dict

    parser = argparse.ArgumentParser(
        description="Treemap visualization for anomaly detection results (Bridge, Outlier) for SCIP-indexed code across the file structure.")
    parser.add_argument('--verbose', action='store_true', help='Enable verbose mode to log all details')
    parser.add_argument('--report_directory', type=str, default="", help='Path to the report directory')
    parser.add_argument('query_parameters', nargs='*', type=str, help='List of key=value Cypher query parameters')
    parser.set_defaults(verbose=False)
    args = parser.parse_args()
    return Parameters.from_input_parameters(parse_key_value_list(args.query_parameters), args.report_directory, args.verbose)


def get_graph_database_driver() -> Driver:
    """Create and return a Neo4j driver connected to localhost."""
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", os.environ.get("NEO4J_INITIAL_PASSWORD"))
    )
    driver.verify_connectivity()
    return driver


def query_cypher_to_data_frame(driver: Driver, query: LiteralString, parameters: dict[str, Any] | None = None) -> pd.DataFrame:
    """Execute a Cypher query and return results as a DataFrame."""
    records, _, keys = driver.execute_query(query, parameters_=parameters)
    return pd.DataFrame([record.values() for record in records], columns=keys)


# ----------------------------------------
# Base settings for image rendering
# ----------------------------------------

IMAGE_RENDERING_SETTINGS: dict[str, Any] = {
    "format": "svg",
    "width": 1920,
    "height": 1080,
}

# ----------------------------------------
# Base settings for Plotly Treemap
# ----------------------------------------

plotly_main_layout_base_settings: dict[str, Any] = {
    "margin": {"t": 60, "l": 15, "r": 15, "b": 20},
}
plotly_treemap_layout_base_settings = dict(**plotly_main_layout_base_settings)
plotly_treemap_marker_base_style: dict[str, Any] = {"cornerradius": 5}
plotly_treemap_marker_base_color_scale = dict(
    **plotly_treemap_marker_base_style,
    colorscale='Hot_r',
)

# Ignore kaleido logging noise when writing images
logging.getLogger("kaleido").setLevel(logging.WARNING)


def plotly_values(data: pd.Series | pd.DataFrame) -> list:  # type: ignore[type-arg]
    """Return pandas column(s) as a plain Python list for Plotly/orjson serialization."""
    return data.to_numpy().tolist()


def get_plotly_figure_write_image_settings(name: str, report_directory: str) -> dict[str, Any]:
    """Return kwargs for Figure.write_image with the given file name and directory."""
    file_path = str(Path(report_directory) / f"{name}.{IMAGE_RENDERING_SETTINGS['format']}")
    return {
        "file": file_path,
        "format": IMAGE_RENDERING_SETTINGS['format'],
        "width": IMAGE_RENDERING_SETTINGS['width'],
        "height": IMAGE_RENDERING_SETTINGS['height'],
    }


def create_treemap_settings(data_frame: pd.DataFrame, element_path_column: str = 'elementPath', element_name_column: str = "elementName") -> "plotly_graph_objects.Treemap":
    """Create a base Plotly Treemap trace for anomaly detection visualization."""
    from plotly import graph_objects as plotly_graph_objects
    return plotly_graph_objects.Treemap(
        labels=plotly_values(data_frame[element_name_column]),
        parents=plotly_values(data_frame['directoryParentPath']),
        ids=plotly_values(data_frame[element_path_column]),
        customdata=plotly_values(data_frame[['fileCount', 'absoluteAnomalyScore', 'normalizedBridgeRank', 'normalizedOutlierRank', 'elementPath']]),
        hovertemplate='<b>%{label}</b><br>Highlighted anomalies: %{customdata[0]}<br>Anomaly Score: %{customdata[1]:.4f}<br>Bridge: %{customdata[2]}, Outlier: %{customdata[3]}<br>Path: %{customdata[4]}',
        maxdepth=-1,
        root_color="lightgrey",
        marker=dict(**plotly_treemap_marker_base_style),
    )


# ----------------------------------------
# Data preparation functions
# ----------------------------------------

def remove_last_path_file_extension(file_path_elements: list[str]) -> list[str]:
    """Remove the file extension from the last element of a split file path."""
    if not file_path_elements:
        return ['']
    if len(file_path_elements) == 1:
        return [Path(file_path_elements[0]).stem]
    return file_path_elements[:-1] + [Path(file_path_elements[-1]).stem]


def join_path_elements(file_path_elements: list[str]) -> list[str]:
    """Return cumulative path prefixes for all levels of a file path."""
    prepared_path_elements = remove_last_path_file_extension(file_path_elements)
    return ['/'.join(prepared_path_elements[:i + 1]) for i in range(len(prepared_path_elements))]


def add_element_path_column(input_dataframe: pd.DataFrame, file_path_column: str, element_path_column: str = 'elementPath') -> pd.DataFrame:
    """Explode file paths into one row per directory level in a new elementPath column."""
    if element_path_column in input_dataframe.columns:
        return input_dataframe
    input_dataframe.insert(0, element_path_column, input_dataframe[file_path_column].str.split('/').apply(join_path_elements))
    input_dataframe = input_dataframe.explode(element_path_column)
    return input_dataframe


def add_element_name_column(input_dataframe: pd.DataFrame, element_path_column: str = 'elementPath', element_name_column: str = 'elementName') -> pd.DataFrame:
    """Add a column with the short name (last path segment) for each element path."""
    if element_name_column in input_dataframe.columns:
        return input_dataframe
    splitted_directories = input_dataframe[element_path_column].str.rsplit('/', n=1)
    input_dataframe.insert(1, element_name_column, splitted_directories.apply(lambda x: x[-1]))
    return input_dataframe


def add_parent_directory_column(input_dataframe: pd.DataFrame, element_path_column: str = 'elementPath', directory_parent_column: str = 'directoryParentPath') -> pd.DataFrame:
    """Add a column with the parent path for each element path."""
    if directory_parent_column in input_dataframe.columns:
        return input_dataframe
    splitted_directories = input_dataframe[element_path_column].str.rsplit('/', n=1)
    input_dataframe.insert(1, directory_parent_column, splitted_directories.apply(lambda x: x[0]))
    input_dataframe.loc[input_dataframe[directory_parent_column] == input_dataframe[element_path_column], directory_parent_column] = ''
    return input_dataframe


def count_unique_aggregated_values(values: pd.Series) -> int:  # type: ignore[type-arg]
    """Return the count of unique values across an array-of-arrays Series."""
    return len(np.unique(np.concatenate(values.to_list())))


def prepare_data_for_treemap(data: pd.DataFrame, debug: bool = False) -> pd.DataFrame:
    """Aggregate anomaly data per directory level for Plotly Treemap rendering."""
    if debug:
        print("1. query result ---------------------")
        print(data)

    data = add_element_path_column(data, 'filePath', 'elementPath')

    if debug:
        print("3. added elementPath --------------")
        print(data)

    common_named_aggregation = {
        "absoluteAnomalyScore": pd.NamedAgg(column="absoluteAnomalyScore", aggfunc="mean"),
        "normalizedBridgeRank": pd.NamedAgg(column="normalizedBridgeRank", aggfunc="max"),
        "normalizedOutlierRank": pd.NamedAgg(column="normalizedOutlierRank", aggfunc="max"),
    }

    data = data.groupby(['elementPath']).aggregate(
        filePaths=pd.NamedAgg(column="filePath", aggfunc=lambda x: list(np.unique(x))),
        firstFile=pd.NamedAgg(column="filePath", aggfunc="first"),
        maxAnomalyScore=pd.NamedAgg(column="absoluteAnomalyScore", aggfunc="max"),
        **common_named_aggregation
    )

    data = data.sort_values(by=['elementPath', 'absoluteAnomalyScore'], ascending=[True, False])
    data = data.reset_index()

    if debug:
        print("4. grouped by elementPath --------------")
        print(data)

    data = data.groupby('elementPath').aggregate(
        fileCount=pd.NamedAgg(column="filePaths", aggfunc=count_unique_aggregated_values),
        firstFile=pd.NamedAgg(column="firstFile", aggfunc="first"),
        maxAnomalyScore=pd.NamedAgg(column="maxAnomalyScore", aggfunc="max"),
        **common_named_aggregation
    )
    data = data.reset_index()

    if debug:
        print("5. grouped by directory path --------------")
        print(data)

    data = add_element_name_column(data, 'elementPath', 'elementName')
    data = add_parent_directory_column(data, 'elementPath', 'directoryParentPath')

    if debug:
        print("6. added directory and parent name --------------")
        print(data)

    all_column_names_except_for_the_directory_path = data.columns.to_list()[3:]
    data = data.groupby(all_column_names_except_for_the_directory_path).aggregate(
        elementName=pd.NamedAgg(column="elementName", aggfunc=lambda names: '/'.join(names)),
        directoryParentPath=pd.NamedAgg(column="directoryParentPath", aggfunc="first"),
        elementPath=pd.NamedAgg(column="elementPath", aggfunc="last"),
    )

    all_column_names_with_the_directory_path_first = ['elementPath', 'directoryParentPath', 'elementName'] + all_column_names_except_for_the_directory_path
    data = data.reset_index()[all_column_names_with_the_directory_path_first]

    if debug:
        print("7. final grouping --------------")
        print(data)

    return data


def mutual_exclusive_ranks(data: pd.DataFrame) -> pd.DataFrame:
    """Retain only the highest normalized rank per row; zero out the others."""
    modified_data = data.copy()

    for dataframe_index, row in modified_data.iterrows():
        index = cast(int, dataframe_index)
        max_rank_value = 0.0
        max_rank_column: str | None = None

        for column in archetype_columns:
            if row[column] > max_rank_value:
                max_rank_value = row[column]
                max_rank_column = column

        for column in archetype_columns:
            if column != max_rank_column:
                modified_data.at[index, column] = 0

    return modified_data


# ----------------------------------------
# Archetypes
# ----------------------------------------

Archetypes = Literal["Bridge", "Outlier"]
archetype_names: list[Archetypes] = ["Bridge", "Outlier"]


def get_archetype_column_name(archetype: Archetypes) -> str:
    """Return the DataFrame column name for the normalized rank of the given archetype."""
    return f"normalized{archetype}Rank"


def get_archetype_index(archetype: Archetypes) -> int:
    """Return the list index of the given archetype."""
    return archetype_names.index(archetype)


archetype_columns = [get_archetype_column_name(name) for name in archetype_names]

# ----------------------------------------
# Archetype Coloring
# ----------------------------------------

Color = tuple[int, int, int]
ColorPair = tuple[Color, Color]


def interpolate_color(low: Color, high: Color, normalized_value: float) -> str:
    """Linearly interpolate between two RGB tuples and return an rgb() string."""
    def lerp(component: int) -> int:
        return int(low[component] + (high[component] - low[component]) * normalized_value)
    return f"rgb({lerp(0)},{lerp(1)},{lerp(2)})"


def get_rank_color(rank: float, low: Color, high: Color) -> str:
    """Return white when rank is zero, otherwise interpolate between low and high."""
    if rank <= 0:
        return "rgb(255,255,255)"
    return interpolate_color(low, high, rank)


def combine_rank_colors(dataframe: pd.DataFrame, rank_columns: list[str], color_pairs: list[ColorPair]) -> list[str]:
    """Combine multiple rank columns into a single color per row, using the first nonzero rank."""
    combined: list[str] = []
    for _, row in dataframe.iterrows():
        color = "rgb(255,255,255)"
        for rank_col, (low, high) in zip(rank_columns, color_pairs):
            rank = row[rank_col]
            if rank > 0:
                color = get_rank_color(rank, low, high)
                break
        combined.append(color)
    return combined


def get_rank_color_for_archetype(dataframe: pd.DataFrame, archetype: Archetypes) -> list[str]:
    """Return a list of colors for one archetype across all rows."""
    archetype_column_name = get_archetype_column_name(archetype)
    coloring_pair = get_coloring_pairs()[archetype_names.index(archetype)]
    return combine_rank_colors(dataframe, [archetype_column_name], [coloring_pair])


def get_coloring_pairs() -> list[ColorPair]:
    """Define the coloring scheme for each anomaly detection archetype."""
    assert len(archetype_names) == 2, "Expected exactly 2 archetypes."
    return [
        ((239, 237, 245), (106, 81, 163)),  # Bridge: Purple shades
        ((240, 240, 240), (82, 82, 82)),    # Outlier: Gray shades
    ]


# ----------------------------------------
# Data query
# ----------------------------------------

def query_data(driver: Driver) -> pd.DataFrame:
    """Query anomalous SemanticCodeIndexInternalType nodes with Bridge/Outlier ranks."""
    query: LiteralString = """
        MATCH (anomalyScoreStats:SemanticCodeIndexInternalType)
        WHERE anomalyScoreStats.anomalyScore < 0
        ORDER BY anomalyScoreStats.anomalyScore ASCENDING
        LIMIT 150
         WITH collect(anomalyScoreStats.anomalyScore)[-1] AS anomalyScoreThreshold
        MATCH (anomalyRankStats:SemanticCodeIndexInternalType)
         WITH anomalyScoreThreshold
             ,max(anomalyRankStats.anomalyBridgeRank)  AS maxAnomalyBridgeRank
             ,max(anomalyRankStats.anomalyOutlierRank) AS maxAnomalyOutlierRank
        MATCH (anomalous:SemanticCodeIndexInternalType)
        WHERE (anomalous.anomalyScore < anomalyScoreThreshold
           OR  anomalous.anomalyOutlierRank IS NOT NULL
           OR  anomalous.anomalyBridgeRank  IS NOT NULL)
        OPTIONAL MATCH (artifact:SemanticCodeIndexArtifact)-[:CONTAINS]->(anomalous)
          WITH *
              ,coalesce(artifact.projectName + '/', '') AS projectName
        RETURN replace(projectName + anomalous.file, '//', '/') AS filePath
              ,CASE WHEN anomalous.anomalyScore < 0 THEN abs(anomalous.anomalyScore) ELSE 0 END AS absoluteAnomalyScore
              ,coalesce(toFloat(anomalous.anomalyBridgeRank)  / maxAnomalyBridgeRank,  0) AS normalizedBridgeRank
              ,coalesce(toFloat(anomalous.anomalyOutlierRank) / maxAnomalyOutlierRank, 0) AS normalizedOutlierRank
        ORDER BY filePath ASCENDING
        """
    return query_cypher_to_data_frame(driver, query)


# ----------------------------------------
# Chart generation
# ----------------------------------------

def generate_treemap_visualizations(data: pd.DataFrame, parameters: Parameters) -> None:
    """Generate and save all 4 SCIP anomaly detection treemap SVGs to the report directory."""
    from plotly import graph_objects as plotly_graph_objects
    
    title_prefix = parameters.get_title_prefix()
    report_dir = parameters.get_report_directory()

    # --- Treemap 1: Average anomaly score per directory
    print(f"scipTreemapAnomalyDetection: Creating {title_prefix} anomaly scores treemap visualization...")
    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_settings(data),
        marker=dict(
            **plotly_treemap_marker_base_color_scale,
            colors=plotly_values(data['absoluteAnomalyScore']),
            colorbar={"title": "score"},
        ),
    ))
    figure.update_layout(
        **plotly_treemap_layout_base_settings,  # type: ignore[arg-type]
        title=f'Average {title_prefix} anomaly score per directory',
    )
    figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap1AverageAnomalyScorePerDirectory", report_dir))

    # --- Treemap 2: Archetypes overview
    print(f"scipTreemapAnomalyDetection: Creating {title_prefix} archetypes overview treemap visualization...")
    mutual_exclusive_archetype_ranks_data = mutual_exclusive_ranks(data)

    coloring_pairs = get_coloring_pairs()
    combined_colors = combine_rank_colors(mutual_exclusive_archetype_ranks_data, archetype_columns, coloring_pairs)

    overview_figure = plotly_graph_objects.Figure()
    overview_figure.add_trace(plotly_graph_objects.Treemap(
        create_treemap_settings(mutual_exclusive_archetype_ranks_data),
        marker=dict(
            **plotly_treemap_marker_base_style,
            line={"width": 1, "color": "black"},
            showscale=False,
            colors=combined_colors,
        ),
        name="Anomalies",
        opacity=0.8
    ))

    for name, (low, high) in zip(archetype_names, coloring_pairs):
        bright_color = interpolate_color(low, high, 0.4)
        dark_color = interpolate_color(low, high, 1.0)
        overview_figure.add_trace(plotly_graph_objects.Scatter(
            x=[None],
            y=[None],
            mode="markers",
            marker={"size": 12, "color": bright_color, "line": {"width": 2, "color": dark_color}},
            name=name,
            legendgroup=name,
            showlegend=True,
        ))

    overview_figure.update_layout(
        **plotly_treemap_layout_base_settings,  # type: ignore[arg-type]
        title=f'Overview of all {title_prefix} detected anomaly archetypes per directory',
        legend={
            "orientation": "h",
            "yanchor": "bottom",
            "y": -0.12,
            "xanchor": "center",
            "x": 0.5
        }
    )
    overview_figure.update_xaxes(visible=False)
    overview_figure.update_yaxes(visible=False)
    overview_figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap2ArchetypesOverviewPerDirectory", report_dir))

    # --- Treemaps 3 & 4: Individual archetypes
    def plot_single_archetype_treemap(archetype: Archetypes, file_index: int, source_data: pd.DataFrame) -> None:
        """Plot a treemap focused on a single anomaly detection archetype."""
        data_to_display = source_data.copy()
        data_to_display = data_to_display[data_to_display[archetype_columns].sum(axis=1) > 0]

        # Skip writing when no data is available for this archetype
        if data_to_display.empty:
            print(f"scipTreemapAnomalyDetection: Skipping {title_prefix} archetype '{archetype}' treemap (no data).")
            return

        print(f"scipTreemapAnomalyDetection: Creating {title_prefix} archetype '{archetype}' treemap visualization...")
        colors = get_rank_color_for_archetype(data_to_display, archetype)

        archetype_figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
            create_treemap_settings(data_to_display),
            marker=dict(
                **plotly_treemap_marker_base_style,
                colors=colors,
                line={"width": 1, "color": "black"},
                colorbar={"title": "rank"},
            ),
        ))
        archetype_figure.update_layout(
            **plotly_treemap_layout_base_settings,  # type: ignore[arg-type]
            title=f'{title_prefix} Archetype "{archetype}" per directory',
        )
        archetype_figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap{file_index}Archetype{archetype}PerDirectory", report_dir))

    plot_single_archetype_treemap("Bridge", 3, data)
    plot_single_archetype_treemap("Outlier", 4, data)


# ── Entry point ───────────────────────────────────────────────────────────────


def main() -> None:
    """Run the SCIP anomaly detection treemap visualization pipeline."""
    parameters = parse_input_parameters()
    title_prefix = parameters.get_title_prefix()
    driver = get_graph_database_driver()

    print(f"scipTreemapAnomalyDetection: Querying {title_prefix} SCIP anomaly data for treemap visualization...")
    anomaly_file_paths = query_data(driver)

    if anomaly_file_paths.empty:
        print(f"scipTreemapAnomalyDetection: No anomaly data found for {title_prefix} SCIP InternalType nodes. Skipping treemap visualizations.")
        driver.close()
        raise SystemExit(0)

    print(f"scipTreemapAnomalyDetection: Preparing {title_prefix} anomaly data for treemap visualization...")
    anomaly_file_paths = prepare_data_for_treemap(anomaly_file_paths)

    generate_treemap_visualizations(anomaly_file_paths, parameters)

    driver.close()
    print("scipTreemapAnomalyDetection: Successfully created SCIP anomaly detection treemap visualizations.")


if __name__ == "__main__":
    main()
