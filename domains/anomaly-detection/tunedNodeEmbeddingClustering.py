#!/usr/bin/env python

# This Python script performs unsupervised clustering to automatically assign meaningful labels to code units — such as Java packages and Java types — and their dependencies, based on how structurally similar they are within a software system.
# This is useful for understanding code structure, detecting modular boundaries, and identifying anomalies or outliers in large software systems without requiring manual labeling.
# It takes the code structure as a graph in Neo4j and generates node embeddings using Fast Random Projection (FastRP).
# These embeddings capture structural similarity and are clustered using HDBSCAN to assign labels or detect noise.
# All results - including embeddings, cluster labels, and 2D coordinates — are written back to Neo4j for further use.

# Prerequisite:
# - Already existing Graph with analyzed code units (like Java Packages) and their dependencies.
# - Provide the password for Neo4j in the environment variable "NEO4J_INITIAL_PASSWORD".

import typing
import numpy.typing as numpy_typing

import os
import sys
import argparse
import pprint
import contextlib

import pandas as pd
import numpy as np

from neo4j import GraphDatabase, Driver

# from sklearn.base import BaseEstimator # Extend from sklearn BaseEstimator to use e.g. GridSearchCV for hyperparameter tuning.
from sklearn.metrics import adjusted_rand_score, adjusted_mutual_info_score, normalized_mutual_info_score
from sklearn.cluster import HDBSCAN  # type: ignore

import optuna
from optuna.samplers import TPESampler
from optuna.importance import get_param_importances, MeanDecreaseImpurityImportanceEvaluator
from optuna.trial import TrialState


class Parameters:
    required_parameters_ = ["projection_name", "projection_node_label", "projection_weight_property", "community_property", "embedding_property"]

    def __init__(self, input_parameters: typing.Dict[str, str], verbose: bool = False):
        self.query_parameters_ = input_parameters.copy()  # copy enforces immutability
        self.verbose_ = verbose

    def __repr__(self):
        pretty_dict = pprint.pformat(self.query_parameters_, indent=4)
        return f"Parameters: verbose={self.verbose_}, query_parameters:\n{pretty_dict}"

    @staticmethod
    def log_dependency_versions_() -> None:
        print('---------------------------------------')

        print('Python version: {}'.format(sys.version))

        from numpy import __version__ as numpy_version
        print('numpy version: {}'.format(numpy_version))

        from pandas import __version__ as pandas_version
        print('pandas version: {}'.format(pandas_version))

        from sklearn import __version__ as sklearn_version
        print('scikit-learn version: {}'.format(sklearn_version))

        from neo4j import __version__ as neo4j_version
        print('neo4j version: {}'.format(neo4j_version))

        from optuna import __version__ as optuna_version
        print('optuna version: {}'.format(optuna_version))

        print('---------------------------------------')

    @classmethod
    def from_input_parameters(cls, input_parameters: typing.Dict[str, str], verbose: bool = False):
        """
        Creates a Parameters instance from a dictionary of input parameters.
        The dictionary must contain the following keys:
         - "projection_name": The name of the projection.
         - "projection_node_label": The node type of the projection.
         - "projection_weight_property": The weight property of the projection.
         - "community_property": The node property containing the pre-calculated reference community id.
        """
        missing_parameters = [parameter for parameter in cls.required_parameters_ if parameter not in input_parameters]
        if missing_parameters:
            raise ValueError("Missing parameters:", missing_parameters)
        created_parameters = cls(input_parameters, verbose)
        if created_parameters.is_verbose():
            print(created_parameters)
            cls.log_dependency_versions_()
        return created_parameters

    @classmethod
    def example(cls):
        return cls(dict(
            projection_name="java-package-embeddings-clustering",
            projection_node_label="Package",
            projection_weight_property="weight25PercentInterfaces",
            community_property="communityLeidenIdTuned",
        ))

    def get_query_parameters(self) -> typing.Dict[str, str]:
        return self.query_parameters_.copy()  # copy enforces immutability

    def clone_with_projection_name(self, projection_name: str):
        updated_parameter = self.get_query_parameters()
        updated_parameter.update({"projection_name": projection_name})
        return Parameters(updated_parameter)

    def get_projection_name(self) -> str:
        return self.query_parameters_["projection_name"]

    def get_projection_node_label(self) -> str:
        return self.query_parameters_["projection_node_label"]

    def get_embedding_property(self) -> str:
        return self.query_parameters_["embedding_property"]

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
    parser.add_argument('query_parameters', nargs='*', type=str, help='List of key=value Cypher query parameters')
    parser.set_defaults(verbose=False)
    args = parser.parse_args()
    return Parameters.from_input_parameters(parse_key_value_list(args.query_parameters), args.verbose)


def get_graph_database_driver() -> Driver:
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", os.environ.get("NEO4J_INITIAL_PASSWORD"))
    )
    driver.verify_connectivity()
    return driver


def query_cypher_to_data_frame(query: typing.LiteralString, parameters: typing.Optional[typing.Dict[str, typing.Any]] = None):
    records, summary, keys = driver.execute_query(query, parameters_=parameters)
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


def write_batch_data_into_database(dataframe: pd.DataFrame, node_label: str, id_column: str = "nodeElementId", batch_size: int = 1000, verbose: bool = False) -> None:
    """
    Writes the given dataframe to the Neo4j database using a batch write operation.

    Parameters:
    - dataframe: The pandas DataFrame to write.
    - label: The label to use for the nodes in the Neo4j database.
    - id_column: The name of the column in the DataFrame that contains the node IDs.
    - cypher_query_file: The file containing the Cypher query for writing the data.
    - batch_size: The number of rows to write in each batch.
    """
    def prepare_rows(dataframe):
        rows = []
        for _, row in dataframe.iterrows():
            properties_without_id = row.drop(labels=[id_column]).to_dict()
            rows.append({
                "nodeId": row[id_column],
                "properties": properties_without_id
            })
        return rows

    def update_batch(transaction, rows):
        query = """
            UNWIND $rows AS row
            MATCH (codeUnit)
            WHERE elementId(codeUnit) = row.nodeId
            AND $node_label IN labels(codeUnit) 
            SET codeUnit += row.properties
        """
        transaction.run(query, rows=rows, node_label=node_label)

    with driver.session() as session:
        for start in range(0, len(dataframe), batch_size):
            batch_dataframe = dataframe.iloc[start:start + batch_size]
            batch_rows = prepare_rows(batch_dataframe)
            if verbose:
                print(f"Writing data from {start} to {start + batch_size} resulting in length {len(batch_rows)}")
            session.execute_write(update_batch, batch_rows)


def get_noise_ratio(clustering_results: numpy_typing.NDArray) -> float:
    """
    Returns the ratio of noise points in the clustering results.
    Noise points are labeled as -1 in HDBSCAN.

    Parameters:
    - clustering_results: NDArray containing the clustering results.

    Returns:
    - A float representing the noise ratio.
    """
    return np.sum(clustering_results == -1) / len(clustering_results)


def adjusted_mutual_info_score_without_noise_penalty(clustering_results: numpy_typing.NDArray, reference_communities: numpy_typing.NDArray) -> float:
    mask_noise = clustering_results != -1  # Exclude noise points from the comparison
    return float(adjusted_mutual_info_score(reference_communities[mask_noise], clustering_results[mask_noise]))


def soft_ramp_limited_penalty(score: float, lower_threshold: float, upper_threshold: float, sharpness: int) -> float:
    if score <= lower_threshold:
        return 1.0  # No penalty
    elif score >= upper_threshold:
        return 0.0  # Full penalty
    else:
        # Normalize noise into [0, 1] range for ramp
        x = (score - lower_threshold) / (upper_threshold - lower_threshold)
        return max(0.0, 1 - x**sharpness)


def adjusted_mutual_info_score_with_soft_ramp_noise_penalty(clustering_results: numpy_typing.NDArray, reference_communities: numpy_typing.NDArray) -> float:
    """
    Computes the adjusted mutual information score with a custom noise penalty based on a soft ramp function.

    Parameters:
    - clustering_results: NDArray containing the clustering results.
    - reference_communities: NDArray containing the reference communities for comparison.
    - kwargs: Additional keyword arguments for the noise penalty function (e.g., sharpness).

    Returns:
    - A float representing the adjusted mutual information score with noise penalty.
    """
    score = adjusted_mutual_info_score_without_noise_penalty(reference_communities, clustering_results)
    penalty = soft_ramp_limited_penalty(get_noise_ratio(clustering_results), lower_threshold=0.6, upper_threshold=0.8, sharpness=2)
    return float(score) * penalty


def output_detailed_optuna_tuning_results(optimized_study: optuna.Study, name_of_the_optimized_algorithm: str):

    print(f"Best {name_of_the_optimized_algorithm} score with penalty:", optimized_study.best_value)
    print(f"Best {name_of_the_optimized_algorithm} parameter influence:", get_param_importances(optimized_study, evaluator=MeanDecreaseImpurityImportanceEvaluator()))

    valid_trials = [trial for trial in optimized_study.trials if trial.value is not None and trial.state == TrialState.COMPLETE]
    top_trials = sorted(valid_trials, key=lambda t: typing.cast(float, t.value), reverse=True)[:10]
    for i, trial in enumerate(top_trials):
        print(f"Best {name_of_the_optimized_algorithm} parameter rank: {i+1}, trial: {trial.number}, Value = {trial.value:.6f}, Params: {trial.params}")


class TunedClusteringResult:
    def __init__(self, labels: numpy_typing.NDArray, probabilities: numpy_typing.NDArray, medoids: numpy_typing.NDArray):
        self.labels = labels
        self.probabilities = probabilities
        self.medoids = medoids
        self.cluster_count = len(set(labels)) - (1 if -1 in labels else 0)
        self.noise_count = np.sum(labels == -1)
        self.noise_ratio = self.noise_count / len(labels) if len(labels) > 0 else 0

    def __repr__(self):
        return f"TunedClusteringResult(cluster_count={self.cluster_count}, noise_count={self.noise_count}, noise_ratio={self.noise_ratio}, labels=[...], probabilities=[...], medoids=[...])"


def tuned_hierarchical_density_based_spatial_clustering(embeddings: numpy_typing.NDArray, reference_community_ids: numpy_typing.NDArray) -> TunedClusteringResult:
    """
    Applies the optimized hierarchical density-based spatial clustering algorithm (HDBSCAN) to the given node embeddings.
    The parameters are tuned to get results similar to the ones of the community detection algorithm.
    The result is a list of cluster ids for each node embedding.
    """
    base_clustering_parameter = dict(
        metric='manhattan',  # Turned out to be the best option in most of the initial experiments
        allow_single_cluster=False
    )

    def objective(trial):
        max_node_count = embeddings.shape[0]
        clusterer = HDBSCAN(
            **base_clustering_parameter,
            # Restrict node count dependent parameters to the max overall node count for small graphs using "min"
            min_cluster_size=trial.suggest_int("min_cluster_size", 4, min(max_node_count, 50)),
            min_samples=trial.suggest_int("min_samples", 2, min(max_node_count, 30))
        )
        labels = clusterer.fit_predict(embeddings)
        return adjusted_mutual_info_score_with_soft_ramp_noise_penalty(labels, reference_community_ids)

    # For in-depth analysis of the tuning, add the following two parameters:
    # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)
    study = optuna.create_study(direction="maximize", sampler=TPESampler(seed=42), study_name="HDBSCAN")

    # Try (enqueue) two specific settings first that led to good results in initial experiments
    study.enqueue_trial({"min_cluster_size": 4, "min_samples": 2})
    study.enqueue_trial({"min_cluster_size": 5, "min_samples": 2})

    # Start the hyperparameter tuning
    study.optimize(objective, n_trials=20, timeout=10)
    print(f"Best HDBSCAN parameters (Optuna):", study.best_params)
    if parameters.is_verbose():
        output_detailed_optuna_tuning_results(study, 'HDBSCAN')

    # Run the clustering again with the best parameters
    cluster_algorithm = HDBSCAN(**base_clustering_parameter, **study.best_params, n_jobs=-1, store_centers='medoid')
    best_model = cluster_algorithm.fit(embeddings)

    return TunedClusteringResult(best_model.labels_, best_model.probabilities_, best_model.medoids_)


class CommunityComparingScores:
    def __init__(self, adjusted_mutual_info_score: float, adjusted_rand_index: float, normalized_mutual_information: float):
        self.adjusted_mutual_info_score = adjusted_mutual_info_score
        self.adjusted_rand_index = adjusted_rand_index
        self.normalized_mutual_information = normalized_mutual_information
        self.scores = {
            "Adjusted Mutual Info Score": adjusted_mutual_info_score,
            "Adjusted Rand Index": adjusted_rand_index,
            "Normalized Mutual Information": normalized_mutual_information
        }

    def __repr__(self):
        return f"CommunityComparingScores(adjusted_mutual_info_score={self.adjusted_mutual_info_score}, adjusted_rand_index={self.adjusted_rand_index}, normalized_mutual_information={self.normalized_mutual_information})"


def get_community_comparing_scores(cluster_labels: numpy_typing.NDArray, reference_community_ids: numpy_typing.NDArray) -> CommunityComparingScores:
    """
    Returns a DataFrame with the scores of the clustering algorithm compared to the community detection algorithm.
    The scores are calculated using the adjusted rand index (ARI) and the normalized mutual information (NMI).
    """

    # Create a mask to filter out noise points. In HDBSCAN, noise points are labeled as -1
    mask = cluster_labels != -1
    ami = float(adjusted_mutual_info_score(reference_community_ids[mask], cluster_labels[mask]))
    ari = adjusted_rand_score(reference_community_ids[mask], cluster_labels[mask])
    nmi = float(normalized_mutual_info_score(reference_community_ids[mask], cluster_labels[mask]))

    return CommunityComparingScores(ami, ari, nmi)


def add_cluster_medoids_to_embeddings(embeddings: pd.DataFrame, clustering_result: TunedClusteringResult) -> pd.DataFrame:
    """
    Adds the column 'clusteringTunedHDBSCANIsMedoid' that marks the center (medoid) of a cluster with 1 and all other entries with 0.
    """
    assigned_labels = []

    def is_medoid(row):
        """ Checks if the embedding of the given row is a medoid (=center node of the cluster that may act as a representative)."""
        for medoid in clustering_result.medoids:
            if row['clusteringTunedHDBSCANLabel'] in assigned_labels:
                return 0 # The cluster with this label already has a medoid assigned
            if np.array_equal(row['embedding'], medoid):
                assigned_labels.append(row['clusteringTunedHDBSCANLabel'])
                return 1
        return 0

    embeddings['clusteringTunedHDBSCANIsMedoid'] = embeddings.apply(is_medoid, axis=1)
    return embeddings


def add_center_distances(embeddings: pd.DataFrame) -> pd.DataFrame:
    """
    Adds the column 'clusteringTunedHDBSCANNormalizedDistanceToMedoid':
    - Manhattan distance (L1 norm) to the cluster medoid, normalized per cluster.
    - Noise points (label == -1) receive 0.0.
    Adds the column 'clusteringTunedHDBSCANClusterMaxRadius':
    - Maximum Manhattan distance (L1 norm) of all points inside the same cluster (same label) to the medoid of that cluster
    - Noise points (label == -1) receive 0.0.
    Adds the column 'clusteringTunedHDBSCANClusterAverageRadius':
    - Average Manhattan distance (L1 norm) of all points inside the same cluster (same label) to the medoid of that cluster
    - Noise points (label == -1) receive 0.0.
    Assumes:
    - 'embedding' column contains vectors.
    - 'clusteringTunedHDBSCANLabel' exists.
    - 'clusteringTunedHDBSCANIsMedoid' is already set (1 for medoid, 0 otherwise) by function "add_cluster_medoids_to_embeddings".
    """
    # Map cluster label -> medoid embedding from existing dataframe
    medoids_by_label = {}
    for _, row in embeddings[embeddings['clusteringTunedHDBSCANIsMedoid'] == 1].iterrows():
        medoids_by_label[row['clusteringTunedHDBSCANLabel']] = row['embedding']

    # Prepare array to store normalized distances
    normalized_distances = np.full(len(embeddings), 0.0)

    cluster_max_distance_to_medoid = {}
    cluster_average_distance_to_medoid = {}

    # Group by cluster and compute normalized Manhattan distance to medoid
    for label, group in embeddings.groupby('clusteringTunedHDBSCANLabel'):
        if label == -1 or label not in medoids_by_label:
            cluster_max_distance_to_medoid[-1] = 0.0
            cluster_average_distance_to_medoid[-1] = 0.0
            continue  # Skip noise or missing medoids

        medoid = medoids_by_label[label]
        group_indices = group.index
        group_embeddings = np.stack(group['embedding'].apply(np.array).tolist())

        # Compute Manhattan distances
        distances = np.sum(np.abs(group_embeddings - medoid), axis=1)

        # Normalize per cluster
        max_distance = np.max(distances)
        cluster_max_distance_to_medoid[label] = max_distance
        cluster_average_distance_to_medoid[label] = np.average(distances)

        if max_distance == 0:
            normalized = np.zeros_like(distances)
        else:
            normalized = distances / max_distance

        normalized_distances[group_indices] = normalized

    embeddings['clusteringTunedHDBSCANNormalizedDistanceToMedoid'] = normalized_distances
    embeddings['clusteringTunedHDBSCANClusterMaxRadius'] = embeddings['clusteringTunedHDBSCANLabel'].map(cluster_max_distance_to_medoid)
    embeddings['clusteringTunedHDBSCANClusterAverageRadius'] = embeddings['clusteringTunedHDBSCANLabel'].map(cluster_average_distance_to_medoid)

    return embeddings


def add_clustering_results_to_embeddings(embeddings: pd.DataFrame, clustering_result: TunedClusteringResult) -> pd.DataFrame:
    """
    Adds the clustering results to the embeddings DataFrame.
    """
    embeddings['clusteringTunedHDBSCANLabel'] = clustering_result.labels
    embeddings['clusteringTunedHDBSCANProbability'] = clustering_result.probabilities

    # Add the cluster size
    cluster_sizes = embeddings['clusteringTunedHDBSCANLabel'].value_counts()
    embeddings['clusteringTunedHDBSCANClusterSize'] = embeddings['clusteringTunedHDBSCANLabel'].map(cluster_sizes)

    embeddings = add_cluster_medoids_to_embeddings(embeddings, clustering_result)
    embeddings = add_center_distances(embeddings)  # requires medoids
    return embeddings


def get_labels_by_cluster_count_descending(embeddings: pd.DataFrame) -> pd.DataFrame:
    """
    Returns the clustering results distribution for the given clustering name.
    """
    return embeddings.groupby('clusteringTunedHDBSCANLabel').aggregate(
        probability=('clusteringTunedHDBSCANProbability', 'mean'),
        count=('codeUnitName', 'count'),
        communityIds=('communityId', lambda x: list(set(x))),
        codeUnitNames=('codeUnitName', lambda x: list(set(x))),
    ).reset_index().sort_values(by='count', ascending=False)


class TunedHierarchicalDensityBasedSpatialClusteringResult:
    def __init__(self, embeddings: pd.DataFrame, clustering_result: TunedClusteringResult, community_comparing_scores: CommunityComparingScores, clustering_results_distribution: pd.DataFrame):
        self.embeddings = embeddings
        self.clustering_result = clustering_result
        self.community_comparing_scores = community_comparing_scores
        self.clustering_results_distribution = clustering_results_distribution

    def __repr__(self):
        return f"TunedHierarchicalDensityBasedSpatialClusteringResult(embeddings={self.embeddings}, clustering_result={self.clustering_result}, community_comparing_scores={self.community_comparing_scores}, clustering_results_distribution={self.clustering_results_distribution})"


def coordinate_tuned_hierarchical_density_based_spatial_clustering(embeddings: pd.DataFrame) -> TunedHierarchicalDensityBasedSpatialClusteringResult:
    """
    Applies the tuned hierarchical density-based spatial clustering algorithm (HDBSCAN) to the given node embeddings.
    The parameters are tuned to get results similar to the ones of the community detection algorithm.
    The result is the input DataFrame with the clustering results added.
    """

    # Apply the tuned HDBSCAN clustering algorithm
    embeddings_values = np.array(embeddings.embedding.tolist())
    community_reference_ids = np.array(embeddings.communityId.tolist())

    clustering_result = tuned_hierarchical_density_based_spatial_clustering(embeddings_values, community_reference_ids)
    print(clustering_result)

    community_comparing_scores = get_community_comparing_scores(clustering_result.labels, community_reference_ids)
    print(community_comparing_scores)

    # Add the clustering results to the embeddings DataFrame
    embeddings_with_clusters = add_clustering_results_to_embeddings(embeddings, clustering_result)

    # Get the clustering results distribution
    clustering_results_distribution = get_labels_by_cluster_count_descending(embeddings_with_clusters)

    return TunedHierarchicalDensityBasedSpatialClusteringResult(embeddings_with_clusters, clustering_result, community_comparing_scores, clustering_results_distribution)


class HierarchicalDensityClusteringScores:

    def __init__(self, embedding_dimension: int, adjusted_mutual_info_score: float, confidence_score: float, noise_ratio: float, cluster_count: int):
        self.embedding_dimension = embedding_dimension
        self.adjusted_mutual_info_score = adjusted_mutual_info_score
        self.confidence_score = confidence_score
        self.noise_ratio = noise_ratio
        self.cluster_count = cluster_count

    def __repr__(self):
        return f"HierarchicalDensityClusteringScores(embedding_dimension={self.embedding_dimension}, adjusted_mutual_info_score={self.adjusted_mutual_info_score}, confidence_score={self.confidence_score}, noise_ratio={self.noise_ratio}, cluster_count={self.cluster_count})"

    @classmethod
    def cluster_embeddings_with_references(cls, embedding_column: pd.Series, reference_community_id_column: pd.Series) -> 'HierarchicalDensityClusteringScores':
        """
        Clusters the embeddings with the reference community ids and returns the clustering scores.

        Parameters
        ----------
        embedding_column : pd.Series
            The column containing the embeddings to be clustered.
        reference_community_id_column : pd.Series
            The column containing the reference community ids to compare the clustering results against.

        Returns
        -------
        HierarchicalDensityClusteringScores
            An instance of HierarchicalDensityClusteringScores containing the clustering scores.
        """
        hierarchical_density_based_spatial_clustering = HDBSCAN(
            cluster_selection_method='eom',
            metric='manhattan',
            min_samples=2,
            min_cluster_size=5,
            allow_single_cluster=False,
            n_jobs=-1
        )
        embeddings = np.array(embedding_column.tolist())
        clustering_result = hierarchical_density_based_spatial_clustering.fit(embeddings)

        reference_community_ids = np.array(reference_community_id_column.tolist())
        adjusted_mutual_info_score_value = adjusted_mutual_info_score_with_soft_ramp_noise_penalty(clustering_result.labels_, reference_community_ids)

        confidence_score = np.mean(clustering_result.probabilities_[clustering_result.labels_ != -1])
        noise_count = np.sum(clustering_result.labels_ == -1)
        noise_ratio = noise_count / len(clustering_result.labels_)
        cluster_count = len(set(clustering_result.labels_)) - (1 if -1 in clustering_result.labels_ else 0)
        return cls(len(embeddings[0]), adjusted_mutual_info_score_value, confidence_score, noise_ratio, cluster_count)


class TuneableFastRandomProjectionNodeEmbeddings:  # (sklearn.BaseEstimator):
    """
    Encapsulates Fast Random Projection (FRP, FastRP) for hyper-parameter tuning.
    """
    # Extend from sklearn BaseEstimator to use e.g. GridSearchCV for hyperparameter tuning.
    # The implementation is sklearn compatible and follows its schema (e.g. fit and score method).

    cypher_query_for_generating_embeddings_: typing.LiteralString = """
        CALL gds.fastRP.stream(
            $projection_name + '-cleaned', {
                embeddingDimension: toInteger($embedding_dimension)
                ,randomSeed: toInteger($embedding_random_seed)
                ,normalizationStrength: toFloat($normalization_strength)
                ,iterationWeights: [0.0, 0.0, 1.0, toFloat($forth_iteration_weight)]
                ,relationshipWeightProperty: $projection_weight_property
                }
            )
            YIELD nodeId, embedding
            WITH gds.util.asNode(nodeId) AS codeUnit
                ,embedding
            OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
            WITH *, artifact.name AS artifactName
            OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
            WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
            RETURN DISTINCT 
                    coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
                ,codeUnit.name                       AS shortCodeUnitName
                ,elementId(codeUnit)                 AS nodeElementId
                ,coalesce(artifactName, projectName) AS projectName
                ,codeUnit[$community_property]       AS communityId
                ,embedding
    """

    cypher_query_for_writing_embeddings_: typing.LiteralString = """
        CALL gds.fastRP.write(
            $projection_name + '-cleaned', {
                embeddingDimension: toInteger($embedding_dimension)
                ,randomSeed: 30
                ,relationshipWeightProperty: $projection_weight_property
                ,writeProperty: $write_property
            }
        )
    """
    cypher_file_for_read_ = "../cypher/Node_Embeddings/Node_Embeddings_1d_Fast_Random_Projection_Tuneable_Stream.cypher"
    cypher_file_for_write_ = "../cypher/Node_Embeddings/Node_Embeddings_1e_Fast_Random_Projection_Tuneable_Write.cypher"

    def __init__(self,
                 parameters: Parameters = Parameters.example(),
                 # Tuneable algorithm parameters
                 embedding_dimension: int = 64,
                 random_seed: int = 42,
                 normalization_strength: float = 0.3,
                 forth_iteration_weight: float = 1.0,
                 ):
        self.parameters_ = parameters
        self.verbose_ = parameters.is_verbose()
        self.write_property_ = parameters.get_embedding_property()

        self.embedding_dimension = embedding_dimension
        self.random_seed = random_seed
        self.normalization_strength = normalization_strength
        self.forth_iteration_weight = forth_iteration_weight

    def __to_algorithm_parameters(self) -> typing.Dict['str', 'str']:
        return {
            "embedding_dimension": str(self.embedding_dimension),
            "normalization_strength": str(self.normalization_strength),
            "forth_iteration_weight": str(self.forth_iteration_weight),
            "embedding_random_seed": str(self.random_seed),
            "write_property": str(self.write_property_),
            **self.parameters_.get_query_parameters()
        }

    def __run_algorithm(self) -> pd.DataFrame:
        algorithm_parameters = self.__to_algorithm_parameters()
        # For Debugging:
        # print("Generating embeddings using Neo4j Graph Data Science with the following parameters: " + str(algorithm_parameters))
        if self.verbose_:
            return query_cypher_to_data_frame(self.cypher_query_for_generating_embeddings_, parameters=algorithm_parameters)

        return query_cypher_to_data_frame_suppress_warnings(self.cypher_query_for_generating_embeddings_, parameters=algorithm_parameters)

    def __check_fitted(self) -> None:
        """
        Checks if the model has been fitted by checking if the embeddings_ attribute exists.
        Raises a ValueError if the model has not been fitted yet.
        """
        if not hasattr(self, 'embeddings_') or not hasattr(self, 'clustering_scores_'):
            raise ValueError("The model has not been fitted yet. Please call the fit method before.")

    def fit(self, X=None, y=None) -> typing.Self:
        """
        Fits the model by generating node embeddings and calculating the Hopkins statistic.
        """
        self.embeddings_ = self.__run_algorithm()
        self.clustering_scores_ = HierarchicalDensityClusteringScores.cluster_embeddings_with_references(self.embeddings_.embedding, self.embeddings_.communityId)
        return self

    def score(self, X=None, y=None) -> float:
        """
        Returns the score of the model based on the adjusted mutual info score comparing the clusters with pre calculated Leiden communities.
        """
        self.__check_fitted()
        return self.clustering_scores_.adjusted_mutual_info_score

    def write_embeddings(self) -> typing.Self:
        """
        Writes the generated embeddings to the Neo4j database.
        This is useful for further processing or analysis of the embeddings.
        """
        algorithm_parameters = self.__to_algorithm_parameters()
        if self.verbose_:
            print("")
            print("Writing embeddings to Neo4j with the following parameters: " + str(algorithm_parameters))
            print("")

        if self.verbose_:
            query_cypher_to_data_frame(self.cypher_query_for_writing_embeddings_, parameters=algorithm_parameters)
        else:
            query_cypher_to_data_frame_suppress_warnings(self.cypher_query_for_writing_embeddings_, parameters=algorithm_parameters)
        print(f"Best Fast Random Projection results written back into Neo4j.")
        return self

    def get_embeddings(self) -> pd.DataFrame:
        """
        Returns the generated embeddings
        """
        self.__check_fitted()
        return self.embeddings_

    def get_clustering_scores(self) -> HierarchicalDensityClusteringScores:
        """
        Returns the clustering scores, which include the adjusted mutual info score, confidence score, noise ratio, and cluster count.
        """
        self.__check_fitted()
        return self.clustering_scores_


def get_tuned_fast_random_projection_node_embeddings(parameters: Parameters) -> TuneableFastRandomProjectionNodeEmbeddings:
    if not parameters.is_verbose():
        optuna.logging.set_verbosity(optuna.logging.WARNING)

    def objective(trial):
        # Suggest values for each hyperparameter
        tuneable_parameters = {
            "embedding_dimension": trial.suggest_categorical("embedding_dimension", [64, 128, 256]),
            "normalization_strength": trial.suggest_float("normalization_strength", low=-1.0, high=1.0, step=0.1),
            "forth_iteration_weight": trial.suggest_float("forth_iteration_weight", low=0.0, high=2.0, step=0.1),
        }
        # Note: Fast Random Projection is intentionally applied to the whole Graph without sampling.
        #       It scales well for larger Graphs and it is beneficial for the quality of the downstream clustering.
        tuneable_fast_random_projection = TuneableFastRandomProjectionNodeEmbeddings(parameters, **tuneable_parameters)
        tuneable_fast_random_projection.fit()
        return tuneable_fast_random_projection.score()

    study_name = "FastRandomProjection - " + parameters.get_projection_name()
    # For in-depth analysis of the tuning, add the following two parameters:
    # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)
    study = optuna.create_study(direction="maximize", sampler=TPESampler(seed=42), study_name=study_name)  # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)

    # Try (enqueue) two specific settings first that led to good results in initial experiments
    study.enqueue_trial({'embedding_dimension': 128, 'forth_iteration_weight': 0.5, 'normalization_strength': 0.3})
    study.enqueue_trial({'embedding_dimension': 128, 'forth_iteration_weight': 1.0, 'normalization_strength': 0.5})
    study.enqueue_trial({'embedding_dimension': 256, 'forth_iteration_weight': 0.5, 'normalization_strength': 0.3})
    study.enqueue_trial({'embedding_dimension': 256, 'forth_iteration_weight': 1.0, 'normalization_strength': 0.3})

    # Start the hyperparameter tuning
    study.optimize(objective, n_trials=80, timeout=40)
    print(f"Best Fast Random Projection (FastRP) parameters for {parameters.get_projection_name()} (Optuna):", study.best_params)
    if parameters.is_verbose():
        output_detailed_optuna_tuning_results(study, 'Fast Random Projection (FastRP)')

    # Run the node embeddings algorithm again with the best parameters and return it
    return TuneableFastRandomProjectionNodeEmbeddings(parameters, **study.best_params).fit()


# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------


parameters = parse_input_parameters()
driver = get_graph_database_driver()

tuned_fast_random_projection = get_tuned_fast_random_projection_node_embeddings(parameters)
embeddings = tuned_fast_random_projection.get_embeddings()

clustering_results = coordinate_tuned_hierarchical_density_based_spatial_clustering(embeddings)
embeddings = clustering_results.embeddings

if parameters.is_verbose():
    print("HDBSCAN clustered labels by their size descending (top 10):", clustering_results.clustering_results_distribution.head(10))
    print("HDBSCAN clustered labels by their probability descending (top 10):", clustering_results.clustering_results_distribution.sort_values(by='probability', ascending=False).head(10))

tuned_fast_random_projection.write_embeddings()
data_to_write = pd.DataFrame(data={
    'nodeElementId': embeddings["nodeElementId"],
    'clusteringHDBSCANLabel': embeddings['clusteringTunedHDBSCANLabel'],
    'clusteringHDBSCANProbability': embeddings['clusteringTunedHDBSCANProbability'],
    'clusteringHDBSCANNoise': (embeddings['clusteringTunedHDBSCANLabel'] == -1).astype(int),
    'clusteringHDBSCANMedoid': embeddings['clusteringTunedHDBSCANIsMedoid'].astype(int),
    'clusteringHDBSCANSize': embeddings['clusteringTunedHDBSCANClusterSize'].astype(int),
    'clusteringHDBSCANRadiusAverage': embeddings['clusteringTunedHDBSCANClusterAverageRadius'],
    'clusteringHDBSCANRadiusMax': embeddings['clusteringTunedHDBSCANClusterMaxRadius'],
    'clusteringHDBSCANNormalizedDistanceToMedoid': embeddings['clusteringTunedHDBSCANNormalizedDistanceToMedoid'],
})
write_batch_data_into_database(data_to_write, parameters.get_projection_node_label(), verbose=parameters.is_verbose())

driver.close()