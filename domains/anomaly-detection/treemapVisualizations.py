#!/usr/bin/env python

# This Python script uses Plotly Treemap Charts (https://plotly.com/python/treemaps) to visualize anomaly detection results.

from typing import Any, Dict, List, Tuple, Literal, LiteralString, Optional, cast

import os
import sys
import argparse
import pprint
import logging

import pandas as pd
import numpy as np

from neo4j import GraphDatabase, Driver

from plotly import graph_objects as plotly_graph_objects


class Parameters:
    required_parameters_ = ["projection_language"]

    def __init__(self, input_parameters: Dict[str, str], report_directory: str = "", verbose: bool = False):
        self.query_parameters_ = input_parameters.copy()  # copy enforces immutability
        self.report_directory = report_directory
        self.verbose_ = verbose

    def __repr__(self):
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
    def from_input_parameters(cls, input_parameters: Dict[str, str], report_directory: str = "", verbose: bool = False):
        """
        Creates a Parameters instance from a dictionary of input parameters.
        The dictionary must contain the following keys:
         - "projection_node_label": The node type of the projection.
        """
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
        if self.__is_code_language_available():
            return self.__get_projection_language()
        return ""

    def get_report_directory(self) -> str:
        return self.report_directory

    def is_verbose(self) -> bool:
        return self.verbose_


def parse_input_parameters() -> Parameters:
    # Convert list of "key=value" strings to a dictionary
    def parse_key_value_list(param_list: List[str]) -> Dict[str, str]:
        param_dict = {}
        for item in param_list:
            if '=' in item:
                key, value = item.split('=', 1)
                param_dict[key] = value
        return param_dict

    parser = argparse.ArgumentParser(
        description="Unsupervised clustering to assign labels to code units (Java packages, types,...) and their dependencies based on how structurally similar they are within a software system.")
    parser.add_argument('--verbose', action='store_true', help='Enable verbose mode to log all details')
    parser.add_argument('--report_directory', type=str, default="", help='Path to the report directory')
    parser.add_argument('query_parameters', nargs='*', type=str, help='List of key=value Cypher query parameters')
    parser.set_defaults(verbose=False)
    args = parser.parse_args()
    return Parameters.from_input_parameters(parse_key_value_list(args.query_parameters), args.report_directory, args.verbose)


def get_file_path(name: str, parameters: Parameters, extension: str = 'svg') -> str:
    name = parameters.get_report_directory() + '/' + name.replace(' ', '_') + '.' + extension
    if parameters.is_verbose():
        print(f"treemapVisualizations: Saving file {name}")
    return name


def get_graph_database_driver() -> Driver:
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", os.environ.get("NEO4J_INITIAL_PASSWORD"))
    )
    driver.verify_connectivity()
    return driver


def query_cypher_to_data_frame(query: LiteralString, parameters: Optional[Dict[str, Any]] = None):
    records, _, keys = driver.execute_query(query, parameters_=parameters)
    return pd.DataFrame([record.values() for record in records], columns=keys)


# ----------------------------------------
# Base settings for image rendering
# ----------------------------------------


image_rendering_settings = {
    "format": "svg",
    "width": 1920,
    "height": 1080,
}

# ----------------------------------------
# Base settings for Plotly Treemap
# ----------------------------------------

plotly_main_layout_base_settings = {
    "margin": {"t": 60, "l": 15, "r": 15, "b": 20},
}
plotly_treemap_layout_base_settings = dict(
    **plotly_main_layout_base_settings
)
plotly_bar_layout_base_settings = dict(
    **plotly_main_layout_base_settings
)
plotly_treemap_marker_base_style = {
    "cornerradius": 5
}

plotly_treemap_marker_base_color_scale = dict(
    **plotly_treemap_marker_base_style,
    colorscale='Hot_r',
)


# ----------------------------------------
# Base functions for Treemap chart visualization
# ----------------------------------------

# Ignore kaleido logging noise when writing images
logging.getLogger("kaleido").setLevel(logging.WARNING)

def get_plotly_figure_write_image_settings(name: str, path: str):
    """
    Returns the settings for the plotly figure write_image method
    :param name: Name of the figure
    :return: Dictionary with settings for the write_image method
    """
    return {
        "file": path + "/" + name + "." + image_rendering_settings['format'],
        "format": image_rendering_settings['format'],
        "width": image_rendering_settings['width'],
        "height": image_rendering_settings['height'],
    }


def create_treemap_settings(data_frame: pd.DataFrame, element_path_column: str = 'elementPath', element_name_column: str = "elementName") -> plotly_graph_objects.Treemap:
    """
    Creates a Plotly Treemap with the given settings and data frame.
    data_frame : pd.DataFrame : The input data frame
    return :plotly_graph_objects.Treemap : The prepared Plotly Treemap
    """
    return plotly_graph_objects.Treemap(
        labels=data_frame[element_name_column],
        parents=data_frame['directoryParentPath'],
        ids=data_frame[element_path_column],
        customdata=data_frame[['fileCount', 'absoluteAnomalyScore', 'normalizedAuthorityRank', 'normalizedBottleneckRank', 'normalizedBridgeRank', 'normalizedHubRank', 'normalizedOutlierRank', 'elementPath']],
        hovertemplate='<b>%{label}</b><br>Highlighted anomalies: %{customdata[0]}<br>Anomaly Score: %{customdata[1]:.4f}<br>Authority: %{customdata[2]}, Bottleneck: %{customdata[3]}, Bridge: %{customdata[4]}, Hub: %{customdata[5]}, Outlier: %{customdata[6]}<br>Path: %{customdata[7]}',
        maxdepth=-1,
        root_color="lightgrey",
        marker=dict(**plotly_treemap_marker_base_style),
    )


# ----------------------------------------
# Base functions to prepare data for Treemap chart visualization
# ----------------------------------------


def remove_last_path_file_extension(file_path_elements: list) -> list:
    """
    Removes the file extension of the last element of the file path so that only the file name remains.
    file_path_elements : list : The list of file path elements where the last one contains the file name with extension
    return : list : The list of the directories + the file name without extension as last element.
    """
    if not file_path_elements:
        return ['']
    if len(file_path_elements) == 1:
        return [os.path.splitext(file_path_elements[0])[0]]
    return file_path_elements[:-1] + [os.path.splitext(file_path_elements[-1])[0]]


def join_path_elements(file_path_elements: list) -> list:
    """
    Joins the file path elements (and removes the file extension).
    file_path_elements : list : The list of levels to convert
    return : list : The list of directories
    """
    prepared_path_elements = remove_last_path_file_extension(file_path_elements)
    return ['/'.join(prepared_path_elements[:i+1]) for i in range(len(prepared_path_elements))]


def add_element_path_column(input_dataframe: pd.DataFrame, file_path_column: str, element_path_column: str = 'elementPath'):
    """
    Adds a directory column to the input DataFrame based on the file path column.
    input_dataframe : pd.DataFrame : The input DataFrame
    file_path_column : str : The name of the file path column
    directory_column : str : The name of the directory column to be added
    return : pd.DataFrame : The DataFrame with added directory column
    """
    if element_path_column in input_dataframe.columns:
        return input_dataframe # Column already exists
    
    input_dataframe.insert(0, element_path_column, input_dataframe[file_path_column].str.split('/').apply(join_path_elements))
    input_dataframe = input_dataframe.explode(element_path_column)
    return input_dataframe


def add_element_name_column(input_dataframe: pd.DataFrame, element_path_column: str = 'elementPath', element_name_column: str = 'elementName'):
    """
    Adds a directory name column to the input DataFrame based on the directory column.
    input_dataframe : pd.DataFrame : The input DataFrame
    directory_column : str : The name of the directory column
    directory_name_column : str : The name of the directory name column to be added
    return : pd.DataFrame : The DataFrame with added directory name column
    """
    if element_name_column in input_dataframe.columns:
        return input_dataframe # Column already exists
    
    splitted_directories = input_dataframe[element_path_column].str.rsplit('/', n=1)
    input_dataframe.insert(1, element_name_column, splitted_directories.apply(lambda x: (x[-1])))
    return input_dataframe


def add_parent_directory_column(input_dataframe: pd.DataFrame, element_path_column: str = 'elementPath', directory_parent_column: str = 'directoryParentPath'):
    """
    Adds a directory parent column to the input DataFrame based on the directory column.
    input_dataframe : pd.DataFrame : The input DataFrame
    directory_column : str : The name of the directory column
    directory_parent_column : str : The name of the directory parent column to be added
    return : pd.DataFrame : The DataFrame with added directory parent column
    """
    if directory_parent_column in input_dataframe.columns:
        return input_dataframe # Column already exists
    
    # Remove last path element from directory_column to get the directory_parent_column
    splitted_directories = input_dataframe[element_path_column].str.rsplit('/', n=1)
    input_dataframe.insert(1, directory_parent_column, splitted_directories.apply(lambda x: (x[0])))
    
    # Clear parent (set to empty string) when it equal to the directory
    input_dataframe.loc[input_dataframe[directory_parent_column] == input_dataframe[element_path_column], directory_parent_column] = ''
    return input_dataframe


def count_unique_aggregated_values(values: pd.Series):
    """
    Return the number of unique values from an array of array of strings.
    Meant to be used as an aggregation function for dataframe grouping.
    values : Series : The pandas Series of values
    return : int : The number of files
    """
    return len(np.unique(np.concatenate(values.to_list())))


def prepare_data_for_treemap(data: pd.DataFrame, debug: bool = False) -> pd.DataFrame:
    if debug:
        print("1. query result ---------------------")
        print(data)

    # 3. Add multiple rows for each file path containing all its directories paths in the new column 'elementPath'
    data = add_element_path_column(data, 'filePath', 'elementPath')

    if debug:
        print("3. added elementPath --------------")
        print(data)

    # Group the files by their directory and count the number of files of each directory (across all levels).
    common_named_aggregation = {
        "absoluteAnomalyScore": pd.NamedAgg(column="absoluteAnomalyScore", aggfunc="mean"),
        "normalizedAuthorityRank": pd.NamedAgg(column="normalizedAuthorityRank", aggfunc="max"),
        "normalizedBottleneckRank": pd.NamedAgg(column="normalizedBottleneckRank", aggfunc="max"),
        "normalizedBridgeRank": pd.NamedAgg(column="normalizedBridgeRank", aggfunc="max"),
        "normalizedHubRank": pd.NamedAgg(column="normalizedHubRank", aggfunc="max"),
        "normalizedOutlierRank": pd.NamedAgg(column="normalizedOutlierRank", aggfunc="max"),
    }

    data = data.groupby(['elementPath']).aggregate(
        filePaths=pd.NamedAgg(column="filePath", aggfunc=np.unique),
        firstFile=pd.NamedAgg(column="filePath", aggfunc="first"),
        maxAnomalyScore=pd.NamedAgg(column="absoluteAnomalyScore", aggfunc="max"),
        **common_named_aggregation
    )

    # Sort the grouped and aggregated entries by the name of the directory ascending and the anomaly score descending.
    # The author with the most commits will then be listed first for each directory.
    data = data.sort_values(by=['elementPath', 'absoluteAnomalyScore'], ascending=[True, False])
    data = data.reset_index()

    if debug:
        print("4. grouped by elementPath --------------")
        print(data)

    # Group the entries again now only by their directory path to get the aggregated number of anomalies and ranks.
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

    # Add the name of the directory (last '/' separated element) and the parent directory path to the table.
    data = add_element_name_column(data, 'elementPath', 'elementName')
    data = add_parent_directory_column(data, 'elementPath', 'directoryParentPath')

    if debug:
        print("6. added directory and parent name --------------")
        print(data)

    # Group finally by all columns except for the directory name, parent and path (first 3 columns) and pick the longest (max) directory path in case there are multiple.
    all_column_names_except_for_the_directory_path = data.columns.to_list()[3:]
    data = data.groupby(all_column_names_except_for_the_directory_path).aggregate(
        elementName=pd.NamedAgg(column="elementName", aggfunc=lambda names: '/'.join(names)),
        directoryParentPath=pd.NamedAgg(column="directoryParentPath", aggfunc="first"),
        elementPath=pd.NamedAgg(column="elementPath", aggfunc="last"),
    )

    # Reorder the column positions so that the directory path is again the first column. 
    all_column_names_with_the_directory_path_first = ['elementPath', 'directoryParentPath', 'elementName'] + all_column_names_except_for_the_directory_path
    data = data.reset_index()[all_column_names_with_the_directory_path_first]

    if debug:
        print("7. final grouping --------------")
        print(data)
        print("Statistics --------------")
        data.describe()
    
    return data


def mutual_exclusive_ranks(data: pd.DataFrame) -> pd.DataFrame:
    """
    Modifies the input data frame to ensure that only one archetype rank is non-zero per row.
    The archetype with the highest normalized rank is retained, and others are set to zero.
    data : pd.DataFrame : The input data frame
    return : pd.DataFrame : The modified data frame with mutual exclusive ranks
    """
    modified_data = data.copy()
    
    for dataframe_index, row in modified_data.iterrows():
        index = cast(int, dataframe_index)
        max_rank_value = 0
        max_rank_column = None
        
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

Archetypes = Literal["Authority", "Bottleneck", "Bridge", "Hub", "Outlier"]
archetype_names: List[Archetypes] = ["Authority", "Bottleneck", "Bridge", "Hub", "Outlier"]

def get_archetype_column_name(archetype: Archetypes) -> str:
    """
    Returns the column name for the given archetype.
    archetype : Archetypes : The archetype name
    return : str : The column name for the given archetype
    """
    return f"normalized{archetype}Rank"

def get_archetype_index(archetype: Archetypes) -> int:
    """
    Returns the index of the given archetype.
    archetype : Archetypes : The archetype name
    return : int : The index of the given archetype
    """
    return archetype_names.index(archetype)

archetype_columns = [get_archetype_column_name(name) for name in archetype_names]


# ----------------------------------------
# Archetype Coloring
# ----------------------------------------

Color = Tuple[int, int, int]  # RGB (red, green, blue) color tuple
ColorPair = Tuple[Color, Color]  # Low and high color pair

def interpolate_color(low: Color, high: Color, normalized_value: float) -> str:
    """Linear interpolation between two RGB tuples, returns rgba string."""
    
    def linear_interpolation_of_color_component(color_component: int) -> int:
        return int(low[color_component] + (high[color_component] - low[color_component]) * normalized_value)
    
    red = linear_interpolation_of_color_component(0)
    green = linear_interpolation_of_color_component(1)
    blue = linear_interpolation_of_color_component(2)
    return f"rgb({red},{green},{blue})"


def get_rank_color(rank: float, low: Color, high: Color) -> str:
    """Return transparent if rank == 0, else interpolate between low and high."""
    if rank <= 0:
        return "rgb(255,255,255)"
    return interpolate_color(low, high, rank)


def combine_rank_colors(
    dataframe: pd.DataFrame,
    rank_columns: List[str],
    color_pairs: List[ColorPair],
) -> List[str]:
    """Combine multiple ranks, using the first nonzero value's color."""
    combined: List[str] = []
    for _, row in dataframe.iterrows():
        color = "rgb(255,255,255)"
        for rank_col, (low, high) in zip(rank_columns, color_pairs):
            rank = row[rank_col]
            if rank > 0:
                color = get_rank_color(rank, low, high)
                break
        combined.append(color)
    return combined


def get_rank_color_for_archetype(dataframe: pd.DataFrame, archetype: Archetypes) -> List[str]:
    """Get combined rank colors for a specific archetype."""
    archetype_column_name = get_archetype_column_name(archetype)
    coloring_pair = get_coloring_pairs()[archetype_names.index(archetype)]
    return combine_rank_colors(dataframe, [archetype_column_name], [coloring_pair])


def get_coloring_pairs() -> List[Tuple[Tuple[int, int, int], Tuple[int, int, int]]]:
    """Define the coloring scheme for each archetype."""
    assert len(archetype_names) == 5, "Expected exactly 5 archetypes."
    return [
        ((222, 235, 247), (33, 113, 181)), # Authority, Red shades
        ((254, 230, 206), (217, 72, 1)),   # Bottleneck, Green shades
        ((239, 237, 245), (106, 81, 163)), # Bridge, Blue shades
        ((254, 224, 210), (165,15,21)),    # Hub, Orange shades
        ((240, 240, 240), (82, 82, 82)),   # Outlier, Purple shades
    ]

# ----------------------------------------
# Data query
# ----------------------------------------

def query_data() -> pd.DataFrame:
    query: LiteralString = """
        MATCH (anomalyScoreStats:File&!Directory&!Archive)
        WHERE anomalyScoreStats.anomalyScore < 0
        ORDER BY anomalyScoreStats.anomalyScore ASCENDING
        LIMIT 150 // n largest negative anomaly scores as threshold
         WITH collect(anomalyScoreStats.anomalyScore)[-1] AS anomalyScoreThreshold
        MATCH (anomalyRankStats:File&!Directory&!Archive)
         WITH anomalyScoreThreshold
             ,max(anomalyRankStats.anomalyAuthorityRank)  AS maxAnomalyAuthorityRank
             ,max(anomalyRankStats.anomalyBottleneckRank) AS maxAnomalyBottleneckRank
             ,max(anomalyRankStats.anomalyBridgeRank)     AS maxAnomalyBridgeRank
             ,max(anomalyRankStats.anomalyHubRank)        AS maxAnomalyHubRank
             ,max(anomalyRankStats.anomalyOutlierRank)    AS maxAnomalyOutlierRank
        MATCH (anomalous:File&!Directory&!Archive)
        WHERE (anomalous.anomalyScore < anomalyScoreThreshold
           OR  anomalous.anomalyHubRank        IS NOT NULL
           OR  anomalous.anomalyAuthorityRank  IS NOT NULL
           OR  anomalous.anomalyBottleneckRank IS NOT NULL
           OR  anomalous.anomalyOutlierRank    IS NOT NULL
           OR  anomalous.anomalyBridgeRank     IS NOT NULL)
        OPTIONAL MATCH (project:Artifact|Project)-[:CONTAINS]->(anomalous)
          WITH *
              ,coalesce(project.name + '/', '')                     AS projectName
              ,coalesce(anomalous.fileName, anomalous.relativePath) AS fileName
        RETURN replace(projectName + fileName, '//', '/')   AS filePath
              ,CASE WHEN anomalous.anomalyScore < 0 THEN abs(anomalous.anomalyScore) ELSE 0 END AS absoluteAnomalyScore
              ,coalesce(toFloat(anomalous.anomalyAuthorityRank) / maxAnomalyAuthorityRank, 0)   AS normalizedAuthorityRank
              ,coalesce(toFloat(anomalous.anomalyBottleneckRank) / maxAnomalyBottleneckRank, 0) AS normalizedBottleneckRank
              ,coalesce(toFloat(anomalous.anomalyBridgeRank) / maxAnomalyBridgeRank, 0)         AS normalizedBridgeRank
              ,coalesce(toFloat(anomalous.anomalyHubRank / maxAnomalyHubRank), 0)               AS normalizedHubRank
              ,coalesce(toFloat(anomalous.anomalyOutlierRank) / maxAnomalyOutlierRank, 0)       AS normalizedOutlierRank
        ORDER BY filePath ASCENDING
        """
    return query_cypher_to_data_frame(query)


# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------


parameters = parse_input_parameters()
title_prefix = parameters.get_title_prefix()
driver = get_graph_database_driver()

print(f"treemapVisualizations: Querying {title_prefix} data for treemap visualization...")
anomaly_file_paths = query_data()

print(f"treemapVisualizations: Preparing {title_prefix} data for treemap visualization...")
anomaly_file_paths = prepare_data_for_treemap(anomaly_file_paths)

# --- Visualizing Anomaly Scores

print(f"treemapVisualizations: Creating {title_prefix} anomaly scores treemap visualization...")
figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
    create_treemap_settings(anomaly_file_paths),
    marker=dict(
        **plotly_treemap_marker_base_color_scale,
        colors=anomaly_file_paths['absoluteAnomalyScore'], 
        colorbar={"title": "score"},
    ),
))
figure.update_layout(
    **plotly_treemap_layout_base_settings, # type: ignore
    title=f'Average {title_prefix} anomaly score per directory',
)
figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap1AverageAnomalyScorePerDirectory", parameters.get_report_directory()))

# --- Visualizing Archetypes

print(f"treemapVisualizations: Creating {title_prefix} archetypes overview treemap visualization...")
mutual_exclusive_archetype_ranks_data = mutual_exclusive_ranks(anomaly_file_paths)

coloring_pairs = get_coloring_pairs()
combined_colors = combine_rank_colors(mutual_exclusive_archetype_ranks_data, archetype_columns, coloring_pairs)

figure = plotly_graph_objects.Figure()

figure.add_trace(plotly_graph_objects.Treemap(
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

# Add dummy scatter traces for legend
for name, (low, high) in zip(archetype_names, coloring_pairs):
    bright_color = interpolate_color(low, high, 0.4)  # light tone for legend filling
    dark_color = interpolate_color(low, high, 1.0)  # darkest tone for legend outline
    figure.add_trace(plotly_graph_objects.Scatter(
        x=[None],
        y=[None],
        mode="markers",
        marker={"size": 12, "color": bright_color, "line": {"width": 2, "color": dark_color}},
        name=name,
        legendgroup=name,
        showlegend=True,
    ))

figure.update_layout(
    **plotly_treemap_layout_base_settings, # type: ignore
    title=f'Overview of all {title_prefix} anomaly archetypes per directory',
    legend={
        "orientation": "h", # horizontal legend
        "yanchor": "bottom",
        "y": -0.12,
        "xanchor": "center",
        "x": 0.5
    }
)
figure.update_xaxes(visible=False)
figure.update_yaxes(visible=False)
figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap2ArchetypesOverviewPerDirectory", parameters.get_report_directory()))

# --- Visualizing Archetypes individually

def plot_single_archetype_treemap(archetype: Archetypes, title_prefix: str, file_index: int, data: pd.DataFrame):
    """
    Plots a treemap for the given archetype using the provided data.
    archetype : Archetypes : The archetype to plot
    data : pd.DataFrame : The input data frame
    """
    print(f"treemapVisualizations: Creating {title_prefix} archetype '{archetype}' treemap visualization...")
    data_to_display = data.copy()
    data_to_display = data_to_display[data_to_display[archetype_columns].sum(axis=1) > 0]

    combined_colors = get_rank_color_for_archetype(data_to_display, archetype)

    figure = plotly_graph_objects.Figure(plotly_graph_objects.Treemap(
        create_treemap_settings(data_to_display),
        marker=dict(
            **plotly_treemap_marker_base_style,
            colors=combined_colors,
            line={"width": 1, "color": "black"},
            colorbar={"title": "rank"},
        ),
    ))
    figure.update_layout(
        **plotly_treemap_layout_base_settings, # type: ignore
        title=f'{title_prefix} Archetype "{archetype}" per directory',
    )
    figure.write_image(**get_plotly_figure_write_image_settings(f"{title_prefix}Treemap{file_index}Archetype{archetype}PerDirectory", parameters.get_report_directory()))

plot_single_archetype_treemap("Authority", title_prefix, 3, anomaly_file_paths)
plot_single_archetype_treemap("Bottleneck", title_prefix, 4, anomaly_file_paths)
plot_single_archetype_treemap("Bridge", title_prefix, 5, anomaly_file_paths)
plot_single_archetype_treemap("Hub", title_prefix, 6, anomaly_file_paths)
plot_single_archetype_treemap("Outlier", title_prefix, 7, anomaly_file_paths)

driver.close()
print("treemapVisualizations: Successfully created treemap visualizations.")