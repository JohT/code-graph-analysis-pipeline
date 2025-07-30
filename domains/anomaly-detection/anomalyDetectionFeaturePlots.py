#!/usr/bin/env python

# This Python script creates plots that might help to find anomalies in code.
# It queries the Graph database, aggregates the data from previously calculated metrics and plots the diagrams into files.
#
# Input Parameters:
#  - --verbose: for finer grained log, optional
#  - query_parameters: e.g. "projection_node_label=Package", required
#
# Requires:
#  - tunedLeidenCommunityDetection.py
#  - tunedNodeEmbeddingClustering
#  - umap2dNodeEmbeddings.py

import typing

import os
import sys
import argparse
import pprint
import contextlib

import pandas as pd
import numpy as np

from neo4j import GraphDatabase, Driver

import matplotlib.pyplot as plot
import seaborn

from visualization import plot_annotation_style, annotate_each, annotate_each_with_index, scale_marker_sizes, zoom_into_center, zoom_into_center_while_preserving_scores_above_threshold, zoom_into_center_while_preserving_top_scores

class Parameters:
    required_parameters_ = ["projection_node_label"]

    def __init__(self, input_parameters: typing.Dict[str, str], report_directory: str = "", verbose: bool = False):
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

        from matplotlib import __version__ as matplotlib_version
        print('matplotlib version: {}'.format(matplotlib_version))

        from seaborn import __version__ as seaborn_version  # type: ignore
        print('seaborn version: {}'.format(seaborn_version))

        from neo4j import __version__ as neo4j_version
        print('neo4j version: {}'.format(neo4j_version))

        print('---------------------------------------')

    @classmethod
    def from_input_parameters(cls, input_parameters: typing.Dict[str, str], report_directory: str = "", verbose: bool = False):
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

    @classmethod
    def example(cls):
        return cls({"projection_node_label": "Package"})

    def get_query_parameters(self) -> typing.Dict[str, str]:
        return self.query_parameters_.copy()  # copy enforces immutability

    def get_projection_node_label(self) -> str:
        return self.query_parameters_["projection_node_label"]

    def get_report_directory(self) -> str:
        return self.report_directory

    def is_verbose(self) -> bool:
        return self.verbose_


def parse_input_parameters() -> Parameters:
    # Convert list of "key=value" strings to a dictionary
    def parse_key_value_list(param_list: typing.List[str]) -> typing.Dict[str, str]:
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


def get_graph_database_driver() -> Driver:
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", os.environ.get("NEO4J_INITIAL_PASSWORD"))
    )
    driver.verify_connectivity()
    print("anomalyDetectionFeaturePlots: Successfully connected to Neo4j")
    return driver


def query_cypher_to_data_frame(query: typing.LiteralString, parameters: typing.Optional[typing.Dict[str, typing.Any]] = None):
    records, summary, keys = driver.execute_query(query, parameters_=parameters)
    print(f"anomalyDetectionFeaturePlots: Successfully queried data from Neo4j after {summary.result_available_after} ms")
    return pd.DataFrame([record.values() for record in records], columns=keys)


def query_cypher_to_data_frame_suppress_warnings(query: typing.LiteralString, parameters: typing.Optional[typing.Dict[str, typing.Any]] = None):
    """
    Executes the Cypher query in the given file and returns the result as a pandas DataFrame.
    This function suppresses any warnings or error messages that would normally be printed to stderr.
    This is useful when you want to run a query without cluttering the output with warnings.
    Parameters:
    - filename: The name of the file containing the Cypher query.
    - parameters: Optional dictionary of parameters to pass to the Cypher query.
    Returns:
    - A pandas DataFrame containing the results of the Cypher query.
    """
    with open(os.devnull, 'w') as devnull, contextlib.redirect_stderr(devnull):
        return query_cypher_to_data_frame(query, parameters)


def query_data(input_parameters: Parameters = Parameters.example()) -> pd.DataFrame:

    query: typing.LiteralString = """
        MATCH (codeUnit)
        WHERE $projection_node_label IN labels(codeUnit)
          AND (codeUnit.incomingDependencies IS NOT NULL OR codeUnit.outgoingDependencies IS NOT NULL)
          AND codeUnit.centralityArticleRank                       IS NOT NULL
          AND codeUnit.centralityPageRank                          IS NOT NULL
          AND codeUnit.centralityBetweenness                       IS NOT NULL
          AND codeUnit.communityLocalClusteringCoefficient         IS NOT NULL
          AND codeUnit.clusteringHDBSCANLabel                      IS NOT NULL
          AND codeUnit.clusteringHDBSCANProbability                IS NOT NULL
          AND codeUnit.clusteringHDBSCANNoise                      IS NOT NULL
          AND codeUnit.clusteringHDBSCANMedoid                     IS NOT NULL
          AND codeUnit.clusteringHDBSCANSize                       IS NOT NULL
          AND codeUnit.clusteringHDBSCANRadiusMax                  IS NOT NULL
          AND codeUnit.clusteringHDBSCANRadiusAverage              IS NOT NULL
          AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX IS NOT NULL
          AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY IS NOT NULL
        OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
            WITH *, artifact.name AS artifactName
        OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
            WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName
         WITH *
             ,coalesce(codeUnit.incomingDependencies, 0) AS incomingDependencies
             ,coalesce(codeUnit.outgoingDependencies, 0) AS outgoingDependencies
             ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
             ,coalesce(artifactName, projectName)        AS projectName
       RETURN DISTINCT 
              codeUnitName
             ,codeUnit.name                                        AS shortCodeUnitName
             ,projectName
             ,incomingDependencies
             ,outgoingDependencies
             ,codeUnit.centralityArticleRank                       AS articleRank
             ,codeUnit.centralityPageRank                          AS pageRank
             ,codeUnit.centralityBetweenness                       AS betweenness
             ,codeUnit.communityLocalClusteringCoefficient         AS clusteringCoefficient
             ,1.0 - codeUnit.communityLocalClusteringCoefficient   AS inverseClusteringCoefficient
             ,codeUnit.centralityPageRank - codeUnit.centralityArticleRank   AS pageToArticleRankDifference
             ,incomingDependencies + outgoingDependencies          AS degree
             ,codeUnit.clusteringHDBSCANLabel                      AS clusterLabel
             ,codeUnit.clusteringHDBSCANProbability                AS clusterProbability
             ,codeUnit.clusteringHDBSCANNoise                      AS clusterNoise
             ,codeUnit.clusteringHDBSCANMedoid                     AS clusterMedoid
             ,codeUnit.clusteringHDBSCANSize                       AS clusterSize
             ,codeUnit.clusteringHDBSCANRadiusMax                  AS clusterRadiusMax
             ,codeUnit.clusteringHDBSCANRadiusAverage              AS clusterRadiusAverage
             ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX AS embeddingVisualizationX
             ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY AS embeddingVisualizationY
        """
    if parameters.is_verbose():
        return query_cypher_to_data_frame(query, parameters=input_parameters.get_query_parameters())
    return query_cypher_to_data_frame_suppress_warnings(query, parameters=input_parameters.get_query_parameters())


def enhance_data_with_visualization_cluster_diameter(
    clustering_visualization_dataframe: pd.DataFrame,
    result_diameter_column_name: str = 'clusterVisualizationDiameter',
    cluster_label_column_name: str = "clusterLabel",
    x_position_column: str = "embeddingVisualizationX",
    y_position_column: str = "embeddingVisualizationY",
):
    def max_pairwise_distance(points):
        if len(points) < 2:
            return 0.0
        # Efficient vectorized pairwise distance computation
        dists = np.sqrt(
            np.sum((points[:, np.newaxis, :] - points[np.newaxis, :, :]) ** 2, axis=-1)
        )
        return np.max(dists)

    cluster_diameters = {}
    unique_cluster_labels = clustering_visualization_dataframe[cluster_label_column_name].unique()
    for cluster_label in unique_cluster_labels:
        if cluster_label == -1:
            cluster_diameters[-1] = 0.0
            continue

        cluster_nodes = clustering_visualization_dataframe[
            clustering_visualization_dataframe[cluster_label_column_name] == cluster_label
        ]
        cluster_diameters[cluster_label] = max_pairwise_distance(cluster_nodes[[x_position_column, y_position_column]].to_numpy())

    clustering_visualization_dataframe[result_diameter_column_name] = clustering_visualization_dataframe[cluster_label_column_name].map(cluster_diameters)


def get_clusters_by_criteria(
    data: pd.DataFrame,
    by: str,
    ascending: bool = True,
    cluster_count: int = 10,
    label_column_name: str = 'clusterLabel'
) -> pd.DataFrame:
    """ 
    Returns the rows for the "cluster_count" clusters with the largest (ascending=False) or smallest(ascending=True)
    value in the column specified with "by". Noise (labeled with -1) remains unfiltered.
    """
    if ascending:
        threshold = data.groupby(by=label_column_name)[by].min().nsmallest(cluster_count).iloc[-1]
        # print(f"Ascending threshold is {threshold} for {by}.")
        return data[(data[by] <= threshold) | (data[label_column_name] == -1)]

    threshold = data.groupby(by=label_column_name)[by].max().nlargest(cluster_count).iloc[-1]
    # print(f"Descending threshold is {threshold} for {by}.")
    return data[(data[by] >= threshold) | (data[label_column_name] == -1)]


def get_file_path(name: str, parameters: Parameters, extension: str = 'svg') -> str:
    name = parameters.get_report_directory() + '/' + name.replace(' ', '_') + '.' + extension
    if parameters.is_verbose():
        print(f"Saving file {name}")
    return name


def plot_standard_deviation_lines(color: typing.LiteralString, mean: float, standard_deviation: float, standard_deviation_factor: int = 0) -> None:
    """
    Plots vertical lines for the mean + factor times standard deviation (z-score references).
    """
    # Vertical line for the standard deviation
    positive_standard_deviation = mean + (standard_deviation_factor * standard_deviation)
    horizontal_line_label = f'Mean + {standard_deviation_factor} x Standard Deviation: {positive_standard_deviation:.2f}' if standard_deviation_factor != 0 else f'Mean: {mean:.2f}'

    plot.axvline(positive_standard_deviation, color=color, linestyle='dashed', linewidth=1, label=horizontal_line_label)

    if standard_deviation_factor != 0:
        negative_standard_deviation = mean - (standard_deviation_factor * standard_deviation)
        plot.axvline(negative_standard_deviation, color=color, linestyle='dashed', linewidth=1)

    plot.legend()


def plot_difference_between_article_and_page_rank(
    page_ranks: pd.Series,
    article_ranks: pd.Series,
    short_names: pd.Series,
    title: str,
    plot_file_path: str
) -> None:
    """
    Plots the difference between Article Rank and Page Rank for Java packages.

    Parameters
    ----------
    page_ranks : pd.Series
        DataFrame column containing Page Rank values.
    article_ranks : pd.Series
        DataFrame column containing Article Rank values.
    short_names : pd.Series
        DataFrame column containing short names of the code units.
    title: str
    """
    if page_ranks.empty or article_ranks.empty or short_names.empty:
        print("No data available to plot.")
        return

    # Calculate the difference between Article Rank and Page Rank
    page_to_article_rank_difference = page_ranks - article_ranks

    plot.figure(figsize=(10, 6))
    plot.hist(page_to_article_rank_difference, bins=50, color='blue', alpha=0.7, edgecolor='black')
    plot.title(title, pad=20)
    plot.xlabel('Absolute difference between Page Rank and Article Rank')
    plot.ylabel('Frequency')
    plot.xlim(left=page_to_article_rank_difference.min(), right=page_to_article_rank_difference.max())
    plot.yscale('log')  # Use logarithmic scale for better visibility of differences
    plot.grid(True)
    plot.tight_layout()

    mean_difference = page_to_article_rank_difference.mean()
    standard_deviation = page_to_article_rank_difference.std()

    # Vertical line for the mean
    plot_standard_deviation_lines('red', mean_difference, standard_deviation, standard_deviation_factor=0)
    # Vertical line for the standard deviation + mean (=z-score of 1)
    plot_standard_deviation_lines('orange', mean_difference, standard_deviation, standard_deviation_factor=1)
    # Vertical line for 2 x standard deviations + mean (=z-score of 2)
    plot_standard_deviation_lines('green', mean_difference, standard_deviation, standard_deviation_factor=2)

    def annotate_outliers(outliers: pd.DataFrame) -> None:
        if outliers.empty:
            return
        for dataframe_index, row in outliers.iterrows():
            index = typing.cast(int, dataframe_index)
            value = row['pageToArticleRankDifference']
            x_index_offset = - index * 10 if value > 0 else + index * 10
            plot.annotate(
                text=f'{row['shortName']} (rank #{row['page_rank_ranking']}, #{row['article_rank_ranking']})',
                xy=(value, 1),
                xytext=(value + x_index_offset, 60),
                rotation=90,
                **plot_annotation_style,
            )

    # Merge all series into a single DataFrame for easier handling
    page_to_article_rank_dataframe = pd.DataFrame({
        'shortName': short_names,
        'pageRank': page_ranks,
        'articleRank': article_ranks,
        'pageToArticleRankDifference': page_to_article_rank_difference,
        'page_rank_ranking': page_ranks.rank().astype(int),
        'article_rank_ranking': article_ranks.rank().astype(int)
    }, index=page_ranks.index)

    # Annotate values above z-score of 2 with their names
    positive_z_score_2 = mean_difference + 2 * standard_deviation
    positive_outliers = page_to_article_rank_dataframe[page_to_article_rank_difference > positive_z_score_2].sort_values(by='pageToArticleRankDifference', ascending=False).reset_index().head(5)
    annotate_outliers(positive_outliers)

    # Annotate values below z-score of -2 with their names
    negative_z_score_2 = mean_difference - 2 * standard_deviation
    negative_outliers = page_to_article_rank_dataframe[page_to_article_rank_difference < negative_z_score_2].sort_values(by='pageToArticleRankDifference', ascending=True).reset_index().head(5)
    annotate_outliers(negative_outliers)

    plot.savefig(plot_file_path)


def plot_clustering_coefficient_distribution(clustering_coefficients: pd.Series, title: str, plot_file_path: str) -> None:
    """
    Plots the distribution of clustering coefficients.

    Parameters
    ----------
    clustering_coefficients : pd.Series
        Series containing clustering coefficient values.
    """
    if clustering_coefficients.empty:
        print("No data available to plot.")
        return

    plot.figure(figsize=(10, 6))
    plot.figure(figsize=(10, 6))
    plot.hist(clustering_coefficients, bins=40, color='blue', alpha=0.7, edgecolor='black')
    plot.title(title, pad=20)
    plot.xlabel('Clustering Coefficient')
    plot.ylabel('Frequency')
    plot.xlim(left=clustering_coefficients.min(), right=clustering_coefficients.max())
    # plot.yscale('log')  # Use logarithmic scale for better visibility of differences
    plot.grid(True)
    plot.tight_layout()

    mean = clustering_coefficients.mean()
    standard_deviation = clustering_coefficients.std()

    # Vertical line for the mean
    plot_standard_deviation_lines('red', mean, standard_deviation, standard_deviation_factor=0)
    # Vertical line for 1 x standard deviations + mean (=z-score of 1)
    plot_standard_deviation_lines('green', mean, standard_deviation, standard_deviation_factor=1)

    plot.tight_layout()
    plot.savefig(plot_file_path)


def plot_clustering_coefficient_vs_page_rank(
    clustering_coefficients: pd.Series,
    page_ranks: pd.Series,
    short_names: pd.Series,
    clustering_noise: pd.Series,
    title: str,
    plot_file_path: str
) -> None:
    """
    Plots the relationship between clustering coefficients and Page Rank values.

    Parameters
    ----------
    clustering_coefficients : pd.Series
        Series containing clustering coefficient values.
    page_ranks : pd.Series
        Series containing Page Rank values.
    short_names : pd.Series
        Series containing short names of the code units.
    clustering_noise : pd.Series
        Series indicating whether the code unit is noise (value = 1) nor not (value = 0) from the clustering algorithm.
    """
    if clustering_coefficients.empty or page_ranks.empty or short_names.empty:
        print("No data available to plot.")
        return

    color = clustering_noise.map({0: 'blue', 1: 'gray'})

    plot.figure(figsize=(10, 6))
    plot.scatter(x=clustering_coefficients, y=page_ranks, alpha=0.7, color=color)
    plot.title(title, pad=20)
    plot.xlabel('Clustering Coefficient')
    plot.ylabel('Page Rank')

    # Add color bar: grey = noise, blue = non-noise
    scatter_noise = plot.scatter([], [], color='lightgrey', label='Noise', alpha=0.4)
    scatter = plot.scatter([], [], color='blue', label='Non-Noise', alpha=0.7)
    plot.legend(handles=[scatter, scatter_noise], loc='upper right', title='Clustering Noise')

    # Merge all series into a single DataFrame for easier handling
    combined_data = pd.DataFrame({
        'shortName': short_names,
        'clusteringCoefficient': clustering_coefficients,
        'pageRank': page_ranks,
        'clusterNoise': clustering_noise,
    }, index=clustering_coefficients.index)

    common_column_names_for_annotations = {
        "name_column": 'shortName',
        "x_position_column": 'clusteringCoefficient', 
        "y_position_column": 'pageRank'
    }

    # Annotate points with their names. Filter out values with a page rank smaller than 1.5 standard deviations
    mean_page_rank = page_ranks.mean()
    standard_deviation_page_rank = page_ranks.std()
    threshold_page_rank = mean_page_rank + 1.5 * standard_deviation_page_rank
    significant_points = combined_data[combined_data['pageRank'] > threshold_page_rank].sort_values(by='pageRank', ascending=False).reset_index(drop=True).head(10)
    annotate_each_with_index(
        significant_points, 
        using=plot.annotate, 
        value_column='pageRank',
        **common_column_names_for_annotations
    )

    # Annotate points with the highest clustering coefficients (top 20) and only show the lowest 5 page ranks
    combined_data['page_rank_ranking'] = combined_data['pageRank'].rank(ascending=False).astype(int)
    combined_data['clustering_coefficient_ranking'] = combined_data['clusteringCoefficient'].rank(ascending=False).astype(int)
    top_clustering_coefficients = combined_data.sort_values(by='clusteringCoefficient', ascending=False).reset_index(drop=True).head(20)
    top_clustering_coefficients = top_clustering_coefficients.sort_values(by='pageRank', ascending=True).reset_index(drop=True).head(5)
    annotate_each_with_index(
        top_clustering_coefficients, 
        using=plot.annotate, 
        value_column='clusteringCoefficient',
        **common_column_names_for_annotations
    )

    # plot.yscale('log')  # Use logarithmic scale for better visibility of differences
    plot.grid(True)
    plot.tight_layout()
    plot.savefig(plot_file_path)


def plot_clusters(
    clustering_visualization_dataframe: pd.DataFrame,
    title: str,
    plot_file_path: str,
    main_color_map: str = "tab20",
    code_unit_column_name: str = "shortCodeUnitName",
    cluster_label_column_name: str = "clusterLabel",
    cluster_medoid_column_name: str = "clusterMedoid",
    centrality_column_name: str = "pageRank",
    x_position_column: str = 'embeddingVisualizationX',
    y_position_column: str = 'embeddingVisualizationY',
    cluster_visualization_diameter_column='clusterVisualizationDiameter'
) -> None:
    if clustering_visualization_dataframe.empty:
        print("No projected data to plot available")
        return

    # Create figure and subplots
    plot.figure(figsize=(10, 10))

    # Setup columns
    node_size_column = centrality_column_name

    clustering_visualization_dataframe_zoomed=zoom_into_center(
        clustering_visualization_dataframe, 
        x_position_column, 
        y_position_column
    )

    # Add column with scaled version of "node_size_column" for uniform marker scaling
    clustering_visualization_dataframe_zoomed = clustering_visualization_dataframe_zoomed.copy()
    clustering_visualization_dataframe_zoomed.loc[:, node_size_column + '_scaled'] = scale_marker_sizes(clustering_visualization_dataframe_zoomed[node_size_column])

    def get_common_plot_parameters(data: pd.DataFrame) -> dict:
        return {
            "x": data[x_position_column],
            "y": data[y_position_column],
            "s": data[node_size_column + '_scaled'],
        }

    # Separate HDBSCAN non-noise and noise nodes
    node_embeddings_without_noise = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column_name] != -1]
    node_embeddings_noise_only = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column_name] == -1]

    # ------------------------------------------
    # Subplot: HDBSCAN Clustering with KDE
    # ------------------------------------------
    plot.title(title, pad=20)

    unique_cluster_labels = node_embeddings_without_noise[cluster_label_column_name].unique()
    hdbscan_color_palette = seaborn.color_palette(main_color_map, len(unique_cluster_labels))
    hdbscan_cluster_to_color = dict(zip(unique_cluster_labels, hdbscan_color_palette))

    max_visualization_diameter = node_embeddings_without_noise[cluster_visualization_diameter_column].max()
    visualization_diameter_normalization_factor = max_visualization_diameter * 2

    # Plot noise points in gray
    plot.scatter(
        **get_common_plot_parameters(node_embeddings_noise_only),
        color='lightgrey',
        alpha=0.4,
        label="Noise"
    )

    for cluster_label in unique_cluster_labels:
        cluster_nodes = node_embeddings_without_noise[
            node_embeddings_without_noise[cluster_label_column_name] == cluster_label
        ]
        # By comparing the cluster diameter to the max diameter of all clusters in the quartile,
        # we can adjust the alpha value for the KDE plot to visualize smaller clusters more clearly.
        # This way, larger clusters will have a lower alpha value, making them less prominent and less prone to overshadow smaller clusters.
        cluster_diameter = cluster_nodes.iloc[0][cluster_visualization_diameter_column]
        alpha = max((1.0 - (cluster_diameter / (visualization_diameter_normalization_factor))) * 0.45 - 0.25, 0.02)

        # KDE cloud shape
        if len(cluster_nodes) > 1 and (
            cluster_nodes[x_position_column].std() > 0 or cluster_nodes[y_position_column].std() > 0
        ):
            seaborn.kdeplot(
                x=cluster_nodes[x_position_column],
                y=cluster_nodes[y_position_column],
                fill=True,
                alpha=alpha,
                levels=2,
                color=hdbscan_cluster_to_color[cluster_label],
                ax=plot.gca(),  # Use current axes
                warn_singular=False,
            )

        # Node scatter points
        plot.scatter(
            **get_common_plot_parameters(cluster_nodes),
            color=hdbscan_cluster_to_color[cluster_label],
            alpha=0.9,
            label=f"Cluster {cluster_label}"
        )

        # Annotate medoids of the cluster
        medoids = cluster_nodes[cluster_nodes[cluster_medoid_column_name] == 1]
        annotate_each(
            medoids,
            using=plot.annotate,
            name_column=code_unit_column_name,
            x_position_column=x_position_column,
            y_position_column=y_position_column,
            cluster_label_column=cluster_label_column_name,
            alpha=0.6
        )

    plot.tight_layout()
    plot.savefig(plot_file_path)


def plot_clusters_probabilities(
    clustering_visualization_dataframe: pd.DataFrame,
    title: str,
    plot_file_path: str,
    code_unit_column: str = "shortCodeUnitName",
    cluster_label_column: str = "clusterLabel",
    cluster_medoid_column: str = "clusterMedoid",
    cluster_size_column: str = "clusterSize",
    cluster_probability_column: str = "clusterProbability",
    size_column: str = "pageRank",
    x_position_column: str = 'embeddingVisualizationX',
    y_position_column: str = 'embeddingVisualizationY',
    annotate_n_lowest_probabilities: int = 10
) -> None:

    if clustering_visualization_dataframe.empty:
        print("No projected data to plot available")
        return

    clustering_visualization_dataframe_zoomed=zoom_into_center_while_preserving_top_scores(
        clustering_visualization_dataframe, 
        x_position_column, 
        y_position_column, 
        cluster_probability_column,
        annotate_n_lowest_probabilities,
        lowest_scores=True
    )

    # Add column with scaled version of "node_size_column" for uniform marker scaling
    clustering_visualization_dataframe_zoomed = clustering_visualization_dataframe_zoomed.copy()
    clustering_visualization_dataframe_zoomed.loc[:, size_column + '_scaled'] = scale_marker_sizes(clustering_visualization_dataframe_zoomed[size_column])

    def get_common_plot_parameters(data: pd.DataFrame) -> dict:
        return {
            "x": data[x_position_column],
            "y": data[y_position_column],
            "s": data[size_column + '_scaled'],
        }
    
    cluster_noise = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column] == -1]
    cluster_non_noise = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column] != -1]
    cluster_even_labels = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column] % 2 == 0]
    cluster_odd_labels = clustering_visualization_dataframe_zoomed[clustering_visualization_dataframe_zoomed[cluster_label_column] % 2 == 1]

    plot.figure(figsize=(10, 10))
    plot.title(title, pad=20)

    # Plot noise
    plot.scatter(
        **get_common_plot_parameters(cluster_noise),
        color='lightgrey',
        alpha=0.4,
        label='Noise'
    )

    # Plot even labels
    plot.scatter(
        **get_common_plot_parameters(cluster_even_labels),
        c=cluster_even_labels[cluster_probability_column],
        vmin=0.6,
        vmax=1.0,
        cmap='Greens',
        alpha=0.8,
        label='Even Label'
    )

    # Plot odd labels
    plot.scatter(
        **get_common_plot_parameters(cluster_odd_labels),
        c=cluster_odd_labels[cluster_probability_column],
        vmin=0.6,
        vmax=1.0,
        cmap='Blues',
        alpha=0.8,
        label='Odd Label'
    )

    # Annotate medoids of the cluster
    # Find center node of each cluster (medoid), sort them by cluster size descending and add a mean cluster probability column
    cluster_medoids = cluster_non_noise[cluster_non_noise[cluster_medoid_column] == 1]
    cluster_medoids_by_cluster_size = cluster_medoids.sort_values(by=cluster_size_column, ascending=False).head(20)
    mean_probabilities = cluster_non_noise.groupby(cluster_label_column)[cluster_probability_column].mean().rename('mean_cluster_probability')
    cluster_medoids_with_mean_probabilites = cluster_medoids_by_cluster_size.merge(mean_probabilities, on=cluster_label_column, how='left')

    annotate_each(
        cluster_medoids_with_mean_probabilites,
        using=plot.annotate,
        name_column=code_unit_column,
        x_position_column=x_position_column,
        y_position_column=y_position_column,
        cluster_label_column=cluster_label_column,
        probability_column='mean_cluster_probability',
        alpha=0.4
    )

    lowest_probabilities = cluster_non_noise.sort_values(by=cluster_probability_column, ascending=True).reset_index().head(annotate_n_lowest_probabilities)
    annotate_each_with_index(
        lowest_probabilities,
        using=plot.annotate,
        name_column=code_unit_column,
        x_position_column=x_position_column,
        y_position_column=y_position_column,
        probability_column=cluster_probability_column,
        color="red"
    )

    plot.tight_layout()
    plot.savefig(plot_file_path)


def plot_cluster_noise(
    clustering_visualization_dataframe: pd.DataFrame,
    title: str,
    plot_file_path: str,
    code_unit_column_name: str = "shortCodeUnitName",
    cluster_label_column_name: str = "clusterLabel",
    size_column_name: str = "degree",
    color_column_name: str = "pageRank",
    x_position_column='embeddingVisualizationX',
    y_position_column='embeddingVisualizationY',
    downscale_normal_sizes: float = 0.8
) -> None:
    if clustering_visualization_dataframe.empty:
        print("No projected data to plot available")
        return

    # Filter only noise points
    noise_points = clustering_visualization_dataframe[clustering_visualization_dataframe[cluster_label_column_name] == -1]
    noise_points = noise_points.sort_values(by=size_column_name, ascending=False).reset_index(drop=True)

    if noise_points.empty:
        print("No noise points to plot.")
        return

    plot.figure(figsize=(10, 10))
    plot.suptitle(title, fontsize=12)
    plot.title(f"red, annotation value=${color_column_name}$, size=${size_column_name}$", fontsize=10, pad=30)

    # Determine the color threshold for noise points
    color_10th_highest_value = noise_points[color_column_name].nlargest(10).iloc[-1]  # Get the 10th largest value
    color_90_quantile = noise_points[color_column_name].quantile(0.90)
    color_threshold = max(color_10th_highest_value, color_90_quantile)

    noise_points_zoomed = zoom_into_center_while_preserving_scores_above_threshold(
        noise_points,
        x_position_column,
        y_position_column,
        color_column_name,
        color_threshold
    )

    # Add column with scaled version of "node_size_column" for uniform marker scaling
    noise_points_zoomed = noise_points_zoomed.copy()
    noise_points_zoomed.loc[:, size_column_name + '_scaled'] = scale_marker_sizes(noise_points_zoomed[size_column_name], downscale_factor=downscale_normal_sizes)

    normal_noise_points = noise_points_zoomed[noise_points_zoomed[color_column_name] < color_threshold]
    highlighted_noise_points = noise_points_zoomed[noise_points_zoomed[color_column_name] >= color_threshold]

    def get_common_plot_parameters(data: pd.DataFrame) -> dict:
        return {
            "x": data[x_position_column],
            "y": data[y_position_column],
            "s": data[size_column_name + '_scaled'],
        }

    # Scatter plot for normal noise points
    plot.scatter(
        **get_common_plot_parameters(normal_noise_points),
        color="lightgrey",
        alpha=0.4
    )

    # Scatter plot for highlighted noise points
    plot.scatter(
        **get_common_plot_parameters(highlighted_noise_points),
        color="red",
        alpha=0.7
    )

    # Annotate the largest 10 points and all colored ones with their names
    annotate_each_with_index(
        data=highlighted_noise_points,
        using=plot.annotate,
        name_column=code_unit_column_name,
        x_position_column=x_position_column,
        y_position_column=y_position_column,
        value_column=color_column_name,
        color="red"
    )

    plot.xlabel(x_position_column)
    plot.ylabel(y_position_column)

    plot.tight_layout()
    plot.savefig(plot_file_path)


# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------

parameters = parse_input_parameters()
plot_type = parameters.get_projection_node_label()
report_directory = parameters.get_report_directory()

driver = get_graph_database_driver()
data = query_data(parameters)
enhance_data_with_visualization_cluster_diameter(data)

overall_cluster_count = data['clusterLabel'].nunique()

plot_difference_between_article_and_page_rank(
    data['pageRank'],
    data['articleRank'],
    data['shortCodeUnitName'],
    title=f"{plot_type} distribution of PageRank - ArticleRank differences",
    plot_file_path=get_file_path(f"{plot_type}_PageRank_Minus_ArticleRank_Distribution", parameters)
)

plot_clustering_coefficient_distribution(
    data['clusteringCoefficient'],
    title=f"{plot_type} distribution of clustering coefficients",
    plot_file_path=get_file_path(f"{plot_type}_ClusteringCoefficient_distribution", parameters)
)

plot_clustering_coefficient_vs_page_rank(
    data['clusteringCoefficient'],
    data['pageRank'],
    data['shortCodeUnitName'],
    data['clusterNoise'],
    title=f"{plot_type} clustering coefficient versus PageRank",
    plot_file_path=get_file_path(f"{plot_type}_ClusteringCoefficient_versus_PageRank", parameters)
)

if (overall_cluster_count < 20):
    print(f"anomalyDetectionFeaturePlots: Less than 20 clusters: {overall_cluster_count}. Only one plot containing all clusters will be created.")
    plot_clusters(
        clustering_visualization_dataframe=data,
        title=f"{plot_type} all clusters overall (less than 20)",
        plot_file_path=get_file_path(f"{plot_type}_Clusters_Overall", parameters)
    )
else:
    print(f"anomalyDetectionFeaturePlots: More than 20 clusters: {overall_cluster_count}. Different plots focussing on different features like cluster size will be created.")
    clusters_by_largest_size = get_clusters_by_criteria(
        data, by='clusterSize', ascending=False, cluster_count=20
    )
    plot_clusters(
        clustering_visualization_dataframe=clusters_by_largest_size,
        title=f"{plot_type} clusters with the largest size",
        plot_file_path=get_file_path(f"{plot_type}_Clusters_largest_size", parameters)
    )

    clusters_by_largest_max_radius = get_clusters_by_criteria(
        data, by='clusterRadiusMax', ascending=False, cluster_count=20
    )
    plot_clusters(
        clustering_visualization_dataframe=clusters_by_largest_max_radius,
        title=f"{plot_type} clusters with the largest max radius",
        plot_file_path=get_file_path(f"{plot_type}_Clusters_largest_max_radius", parameters)
    )

    clusters_by_largest_average_radius = get_clusters_by_criteria(
        data, by='clusterRadiusAverage', ascending=False, cluster_count=20
    )
    plot_clusters(
        clustering_visualization_dataframe=clusters_by_largest_average_radius,
        title=f"{plot_type} clusters with the largest average radius",
        plot_file_path=get_file_path(f"{plot_type}_Clusters_largest_average_radius", parameters)
    )

plot_clusters_probabilities(
    clustering_visualization_dataframe=data, 
    title=f"{plot_type} clustering probabilities (red=high uncertainty)",
    plot_file_path=get_file_path(f"{plot_type}_Cluster_probabilities", parameters)
)

plot_cluster_noise(
    clustering_visualization_dataframe=data,
    title=f"{plot_type} clustering noise points that are surprisingly central (red) or popular (size)",
    size_column_name='degree',
    color_column_name='pageRank',
    plot_file_path=get_file_path(f"{plot_type}_ClusterNoise_highly_central_and_popular", parameters)
)

plot_cluster_noise(
    clustering_visualization_dataframe=data,
    title=f"{plot_type} clustering noise points that bridge flow (red) and are poorly integrated (size)",
    size_column_name='inverseClusteringCoefficient',
    color_column_name='betweenness',
    plot_file_path=get_file_path(f"{plot_type}_ClusterNoise_poorly_integrated_bridges", parameters),
    downscale_normal_sizes=0.4
)

plot_cluster_noise(
    clustering_visualization_dataframe=data,
    title=f"{plot_type} clustering noise points with role inversion (size) possibly violating layering or dependency direction (red)",
    size_column_name='pageToArticleRankDifference',
    color_column_name='betweenness',
    plot_file_path=get_file_path(f"{plot_type}_ClusterNoise_role_inverted_bridges", parameters)
)

driver.close()
