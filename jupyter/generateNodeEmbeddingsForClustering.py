#!/usr/bin/env python

# This Python script performs unsupervised clustering to automatically assign meaningful labels to code units—such as Java packages and Java types—and their dependencies, based on how structurally similar they are within a software system.
# This is useful for understanding code structure, detecting modular boundaries, and identifying anomalies or outliers in large software systems without requiring manual labeling.
# It takes the code structure as a graph in Neo4j and generates node embeddings using Fast Random Projection (FastRP).
# These embeddings capture structural similarity and are clustered using HDBSCAN to assign labels or detect noise.
# For visualization, the embeddings are reduced to 2D using t-SNE.
# All results - including embeddings, cluster labels, and 2D coordinates — are written back to Neo4j for further use.

# Prerequisite: Provide the password for Neo4j in the environment variable "NEO4J_INITIAL_PASSWORD".

import typing
import numpy.typing as numpy_typing

import os
import contextlib

import pandas as pd
import typing as typ
import numpy as np

from neo4j import GraphDatabase, Driver

from openTSNE.sklearn import TSNE

from sklearn.base import BaseEstimator
from sklearn.metrics import adjusted_rand_score, adjusted_mutual_info_score, normalized_mutual_info_score
from sklearn.cluster import HDBSCAN  # type: ignore

import optuna
from optuna.samplers import TPESampler
from optuna.importance import get_param_importances, MeanDecreaseImpurityImportanceEvaluator
from optuna.trial import TrialState


def log_dependency_versions() -> None:
    print('---------------------------------------')

    from numpy import __version__ as numpy_version
    print('numpy version: {}'.format(numpy_version))

    from openTSNE import __version__ as openTSNE_version
    print('openTSNE version: {}'.format(openTSNE_version))

    from pandas import __version__ as pandas_version
    print('pandas version: {}'.format(pandas_version))

    from sklearn import __version__ as sklearn_version
    print('scikit-learn version: {}'.format(sklearn_version))

    from optuna import __version__ as optuna_version
    print('optuna version: {}'.format(optuna_version))

    print('---------------------------------------')


def get_graph_database_driver() -> Driver:
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", os.environ.get("NEO4J_INITIAL_PASSWORD"))
    )
    driver.verify_connectivity()
    return driver


def query_cypher_to_data_frame(query: typing.LiteralString, parameters: typing.Optional[typing.Dict[str, typing.Any]] = None):
    records, summary, keys = driver.execute_query(
        query, parameters_=parameters)
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


def write_batch_data_into_database(dataframe: pd.DataFrame, node_label: str, id_column: str = "nodeElementId", batch_size: int = 1000):
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
            return session.execute_write(update_batch, batch_rows)


def create_undirected_projection(parameters: dict) -> bool:
    """
    Creates an undirected homogenous in-memory Graph projection for/with Neo4j Graph Data Science Plugin.
    It returns True if there is data available for the given parameter and False otherwise.
    Parameters
    ----------
    dependencies_projection : str
        The name prefix for the in-memory projection for dependencies. Example: "java-package-embeddings-notebook"
    dependencies_projection_node : str
        The label of the nodes that will be used for the projection. Example: "Package"
    dependencies_projection_weight_property : str
        The name of the node property that contains the dependency weight. Example: "weight25PercentInterfaces"
    """

    query_for_data_validation = """
        MATCH (source)-[dependency:DEPENDS_ON]->(target)
        WHERE $dependencies_projection_node            IN labels(source)
        AND $dependencies_projection_node            IN labels(target)
        AND $dependencies_projection_weight_property IN keys(dependency)
        RETURN elementId(source) AS sourceElementId
        LIMIT 1
    """

    is_data_missing = query_cypher_to_data_frame(query_for_data_validation, parameters).empty
    if is_data_missing:
        return False

    query_cypher_to_data_frame("CALL gds.graph.drop($dependencies_projection, false)", parameters)
    query_cypher_to_data_frame("CALL gds.graph.drop($dependencies_projection + '-cleaned', false)", parameters)
    query_cypher_to_data_frame("CALL gds.graph.drop($dependencies_projection, false)", dict(dependencies_projection=parameters["dependencies_projection"] + '-cleaned-sampled'))
    # To include the direction of the relationships use the following line to create the projection:
    node_count: int = 0
    if parameters["dependencies_projection_node"] == "Type":
        # TODO Introduce enrichment so that complicated custom projections aren't necessary
        query_to_create_an_undirected_java_types_projection = """
            MATCH (internalType:Java&Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType)
            OPTIONAL MATCH (internalType)-[typeDependency:DEPENDS_ON]->(dependentType:Type&!PrimitiveType&!Void&!JavaType&!ResolvedDuplicateType&!ExternalType)
            WITH internalType
                ,typeDependency
                ,dependentType
                ,exists((internalType)<-[:DEPENDS_ON]-(:Type))   AS hasIncomingDependenciesInternal
            WHERE (hasIncomingDependenciesInternal OR dependentType IS NOT NULL)
            WITH gds.graph.project($dependencies_projection + '-cleaned', internalType, dependentType, {
                    sourceNodeProperties: internalType {.incomingDependencies, .outgoingDependencies}
                    ,targetNodeProperties: dependentType {.incomingDependencies, .outgoingDependencies}
                    ,relationshipProperties: typeDependency {.weight}
                    ,relationshipType: 'DEPENDS_ON'
                },
                {
                    undirectedRelationshipTypes: ['*']
                }
                ) AS projection
            RETURN projection.graphName       AS graphName
                ,projection.nodeCount         AS nodeCount
                ,projection.relationshipCount AS relationshipCount
                ,projection.projectMillis     AS projectMillis
        """
        results = query_cypher_to_data_frame(query_to_create_an_undirected_java_types_projection, parameters)
        node_count = results["nodeCount"].values[0]
    else:
        query_to_create_an_undirected_projection = """
            CALL gds.graph.project(
                $dependencies_projection,
                $dependencies_projection_node, 
                {
                    DEPENDS_ON: {
                        orientation: 'UNDIRECTED'
                    }
                },
                {
                    relationshipProperties: [$dependencies_projection_weight_property],
                    nodeProperties: ['incomingDependencies', 'outgoingDependencies', 'testMarkerInteger']
                }
            )
        """
        query_cypher_to_data_frame(query_to_create_an_undirected_projection, parameters)
        query_to_create_a_filtered_sub_graph = """
            CALL gds.graph.filter(
                $dependencies_projection + '-cleaned',
                $dependencies_projection,
                'n.testMarkerInteger = 0 AND (n.outgoingDependencies > 0 OR n.incomingDependencies > 0)',
                '*'
                )
        """
        results = query_cypher_to_data_frame(query_to_create_a_filtered_sub_graph, parameters)
        node_count = results["nodeCount"].values[0]

    print("The number of nodes in the projection is: " + str(node_count))

    return True


def get_projected_graph_information(projection_name: str) -> pd.DataFrame:
    """
    Returns the projection information for the given parameters.
    Parameters
    ----------
    projection_name : str
        The name prefix for the in-memory projection for dependencies. Example: "java-package-embeddings-notebook"
    """

    parameters = dict(
        dependencies_projection=projection_name,
    )
    return query_cypher_to_data_frame("CALL gds.graph.list($dependencies_projection + '-cleaned')", parameters)


def get_projected_graph_node_count(projection_name: str) -> int:
    """
    Returns the number of nodes in the projected graph.
    Parameters
    ----------
    projection_name : str
        The name prefix for the in-memory projection for dependencies. Example: "java-package-embeddings-notebook"
    """

    graph_information = get_projected_graph_information(projection_name)
    if graph_information.empty:
        return 0
    return graph_information["nodeCount"].values[0]


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


def noise_penalty_soft_ramp_non_linear(noise_ratio, ramp_start=0.6, ramp_end=0.8, sharpness=2):
    if noise_ratio <= ramp_start:
        return 1.0  # No penalty
    elif noise_ratio >= ramp_end:
        return 0.0  # Full penalty
    else:
        # Normalize noise into [0, 1] range for ramp
        x = (noise_ratio - ramp_start) / (ramp_end - ramp_start)
        return max(0.0, 1 - x**sharpness)


def adjusted_mutual_info_score_with_soft_ramp_noise_penalty(clustering_results: numpy_typing.NDArray, reference_communities: numpy_typing.NDArray, **kwargs) -> float:
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
    penalty = noise_penalty_soft_ramp_non_linear(get_noise_ratio(clustering_results), **kwargs)
    return float(score) * penalty


def output_optuna_tuning_results(optimized_study: optuna.Study, name_of_the_optimized_algorithm: str):

    print(f"Best {name_of_the_optimized_algorithm} parameters (Optuna):", optimized_study.best_params)
    print(f"Best {name_of_the_optimized_algorithm} adjusted mutual info score with noise penalty:", optimized_study.best_value)
    print(f"Best {name_of_the_optimized_algorithm} parameter influence:", get_param_importances(optimized_study, evaluator=MeanDecreaseImpurityImportanceEvaluator()))

    valid_trials = [trial for trial in optimized_study.trials if trial.value is not None and trial.state == TrialState.COMPLETE]
    top_trials = sorted(valid_trials, key=lambda t: typing.cast(float, t.value), reverse=True)[:10]
    for i, trial in enumerate(top_trials):
        print(f"Best {name_of_the_optimized_algorithm} parameter rank: {i+1}, trial: {trial.number}, Value = {trial.value:.6f}, Params: {trial.params}")


class TunedClusteringResult:
    def __init__(self, labels: numpy_typing.NDArray, probabilities: numpy_typing.NDArray):
        self.labels = labels
        self.probabilities = probabilities
        self.cluster_count = len(set(labels)) - (1 if -1 in labels else 0)
        self.noise_count = np.sum(labels == -1)
        self.noise_ratio = self.noise_count / len(labels) if len(labels) > 0 else 0

    def __repr__(self):
        return f"TunedClusteringResult(cluster_count={self.cluster_count}, noise_count={self.noise_count}, noise_ratio={self.noise_ratio}, labels=[...], probabilities=[...], )"


def tuned_hierarchical_density_based_spatial_clustering_optuna(embeddings: numpy_typing.NDArray, reference_community_ids: numpy_typing.NDArray) -> TunedClusteringResult:
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
        min_cluster_size = trial.suggest_int("min_cluster_size", 4, 50)
        min_samples = trial.suggest_int("min_samples", 2, 30)

        clusterer = HDBSCAN(
            **base_clustering_parameter,
            min_cluster_size=min_cluster_size,
            min_samples=min_samples
        )
        labels = clusterer.fit_predict(embeddings)
        return adjusted_mutual_info_score_with_soft_ramp_noise_penalty(labels, reference_community_ids)

    # TODO create study with db?
    study = optuna.create_study(direction="maximize", sampler=TPESampler(seed=42), study_name="HDBSCAN")  # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)

    # Try (enqueue) two specific settings first that led to good results in initial experiments
    study.enqueue_trial({"min_cluster_size": 4, "min_samples": 2})
    study.enqueue_trial({"min_cluster_size": 5, "min_samples": 2})

    # Start the hyperparameter tuning
    study.optimize(objective, n_trials=20, timeout=10)
    output_optuna_tuning_results(study, 'HDBSCAN')

    # Run the clustering again with the best parameters
    cluster_algorithm = HDBSCAN(**base_clustering_parameter, **study.best_params, n_jobs=-1)
    best_model = cluster_algorithm.fit(embeddings)

    return TunedClusteringResult(best_model.labels_, best_model.probabilities_)


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


def add_clustering_results_to_embeddings(embeddings: pd.DataFrame, clustering_result: TunedClusteringResult) -> pd.DataFrame:
    """
    Adds the clustering results to the embeddings DataFrame.
    """
    embeddings['clusteringTunedHDBSCANLabel'] = clustering_result.labels
    embeddings['clusteringTunedHDBSCANProbability'] = clustering_result.probabilities
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


def get_labels_by_cluster_probability_descending(embeddings: pd.DataFrame) -> pd.DataFrame:
    """
    Returns the clustering results distribution for the given clustering name.
    """
    return embeddings.groupby("clusteringTunedHDBSCANLabel").aggregate(
        probability=("clusteringTunedHDBSCANProbability", 'mean'),
        count=('codeUnitName', 'count'),
        communityIds=('communityId', lambda x: list(set(x))),
        codeUnitNames=('codeUnitName', lambda x: list(set(x))),
    ).reset_index().sort_values(by='probability', ascending=False)


class TunedHierarchicalDensityBasedSpatialClusteringResult:
    def __init__(self, embeddings: pd.DataFrame, clustering_result: TunedClusteringResult, community_comparing_scores: CommunityComparingScores, clustering_results_distribution: pd.DataFrame):
        self.embeddings = embeddings
        self.clustering_result = clustering_result
        self.community_comparing_scores = community_comparing_scores
        self.clustering_results_distribution = clustering_results_distribution

    def __repr__(self):
        return f"TunedHierarchicalDensityBasedSpatialClusteringResult(embeddings={self.embeddings}, clustering_result={self.clustering_result}, community_comparing_scores={self.community_comparing_scores}, clustering_results_distribution={self.clustering_results_distribution})"


def add_tuned_hierarchical_density_based_spatial_clustering(embeddings: pd.DataFrame) -> TunedHierarchicalDensityBasedSpatialClusteringResult:
    """
    Applies the tuned hierarchical density-based spatial clustering algorithm (HDBSCAN) to the given node embeddings.
    The parameters are tuned to get results similar to the ones of the community detection algorithm.
    The result is the input DataFrame with the clustering results added.
    """
    import time

    # Apply the tuned HDBSCAN clustering algorithm
    embeddings_values = np.array(embeddings.embedding.tolist())
    community_reference_ids = np.array(embeddings.communityId.tolist())

    clustering_result = tuned_hierarchical_density_based_spatial_clustering_optuna(embeddings_values, community_reference_ids)
    print(clustering_result)

    community_comparing_scores = get_community_comparing_scores(clustering_result.labels, community_reference_ids)
    print(community_comparing_scores)

    # Add the clustering results to the embeddings DataFrame
    embeddings = add_clustering_results_to_embeddings(embeddings, clustering_result)

    # Get the clustering results distribution
    clustering_results_distribution = get_labels_by_cluster_count_descending(embeddings)

    # Display the clustering results distribution
    print("HDBSCAN clustered labels by their size descending (top 10):", clustering_results_distribution.head(10))
    print("HDBSCAN clustered labels by their probability descending (top 10):", get_labels_by_cluster_probability_descending(embeddings).head(10))

    return TunedHierarchicalDensityBasedSpatialClusteringResult(embeddings, clustering_result, community_comparing_scores, clustering_results_distribution)


class DependencyProjectionParameters:
    def __init__(self,
                 projection_name: str = "java-type-embeddings-notebook",
                 projection_node: str = "Type",
                 projection_weight_property: str = "weight"
                 ):
        self.projection_name = projection_name
        self.projection_node = projection_node
        self.projection_weight_property = projection_weight_property

    @classmethod
    def from_projection_parameters(cls, projection_parameters: dict):
        """
        Creates a DependencyProjectionParameters instance from a dictionary of projection parameters.
        The dictionary must contain the following keys:
         - "dependencies_projection": The name of the projection.
         - "dependencies_projection_node": The node type of the projection.
         - "dependencies_projection_weight_property": The weight property of the projection.
        """
        if not all(key in projection_parameters for key in ["dependencies_projection", "dependencies_projection_node", "dependencies_projection_weight_property"]):
            raise ValueError("The projection parameters must contain the keys: 'dependencies_projection', 'dependencies_projection_node', 'dependencies_projection_weight_property'.")
        return cls(
            projection_name=projection_parameters["dependencies_projection"],
            projection_node=projection_parameters["dependencies_projection_node"],
            projection_weight_property=projection_parameters["dependencies_projection_weight_property"]
        )

    def get_cypher_parameters(self):
        return {
            "dependencies_projection": self.projection_name,
            "dependencies_projection_node": self.projection_node,
            "dependencies_projection_weight_property": self.projection_weight_property,
        }

    def clone_with_projection_name(self, projection_name: str):
        return DependencyProjectionParameters(
            projection_name=projection_name,
            projection_node=self.projection_node,
            projection_weight_property=self.projection_weight_property
        )


def create_tuneable(class_to_create: typing.Type, verbose: bool = False) -> typing.Any:
    if not hasattr(class_to_create, '__init__'):
        raise ValueError(f"The class {class_to_create.__name__} does not have an __init__ method. It cannot be created.")
    if not callable(class_to_create.__init__):
        raise ValueError(f"The class {class_to_create.__name__} has an __init__ method, but it is not callable. It cannot be created.")
    if not issubclass(class_to_create, BaseEstimator):
        raise ValueError(f"The class {class_to_create.__name__} does not inherit from BaseEstimator. It cannot be created.")

    # print(f"Creating a tuneable estimator for the class {class_to_create.__name__}...")

    class TuneableEstimator():
        def __init__(self):
            self.class_to_create_ = class_to_create
            self.verbose = verbose

        def with_projection_parameters(self, projection_parameters: dict) -> typing.Any:
            """
            Creates an instance of the given class (using its constructor) with projection parameters from a dict.
            The dict must contain the following keys: 
             - "dependencies_projection"
             - "dependencies_projection_node"
             - "dependencies_projection_weight_property".
            """

            # print(f"...with projection parameters: {projection_parameters}")
            return self.class_to_create_(
                dependency_projection=DependencyProjectionParameters.from_projection_parameters(projection_parameters),  # type: ignore
                verbose=self.verbose  # type: ignore
            )
    return TuneableEstimator()


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


class TuneableFastRandomProjectionNodeEmbeddings(BaseEstimator):
    """
    Can be used with GridSearchCV or RandomizedSearchCV to tune the parameters of the Fast Random Projection node embeddings.
    """

    cypher_query_for_generating_embeddings_: typing.LiteralString = """
        CALL gds.fastRP.stream(
            $dependencies_projection + '-cleaned', {
                embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
                ,randomSeed: toInteger($dependencies_projection_embedding_random_seed)
                ,normalizationStrength: toFloat($dependencies_projection_fast_random_projection_normalization_strength)
                ,iterationWeights: [0.0, 0.0, 1.0, toFloat($dependencies_projection_fast_random_projection_forth_iteration_weight)]
                ,relationshipWeightProperty: $dependencies_projection_weight_property
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
                ,codeUnit.name                               AS shortCodeUnitName
                ,elementId(codeUnit)                         AS nodeElementId
                ,coalesce(artifactName, projectName)         AS projectName
                ,coalesce(codeUnit.communityLeidenId, 0)     AS communityId
                ,coalesce(codeUnit.centralityPageRank, 0.01) AS centrality
                ,embedding
    """

    cypher_query_for_writing_embeddings_: typing.LiteralString = """
        CALL gds.fastRP.write(
            $dependencies_projection + '-cleaned', {
                embeddingDimension: toInteger($dependencies_projection_embedding_dimension)
                ,randomSeed: 30
                ,relationshipWeightProperty: $dependencies_projection_weight_property
                ,writeProperty: $dependencies_projection_write_property
            }
        )
    """
    cypher_file_for_read_ = "../cypher/Node_Embeddings/Node_Embeddings_1d_Fast_Random_Projection_Tuneable_Stream.cypher"
    cypher_file_for_write_ = "../cypher/Node_Embeddings/Node_Embeddings_1e_Fast_Random_Projection_Tuneable_Write.cypher"

    def __init__(self,
                 dependency_projection: DependencyProjectionParameters = DependencyProjectionParameters(),
                 verbose: bool = False,
                 # Tuneable algorithm parameters
                 embedding_dimension: int = 64,
                 random_seed: int = 42,
                 fast_random_projection_normalization_strength: float = 0.3,
                 fast_random_projection_forth_iteration_weight: float = 1.0,
                 ):
        self.dependency_projection = dependency_projection
        self.verbose = verbose

        self.embedding_dimension = embedding_dimension
        self.random_seed = random_seed
        self.fast_random_projection_normalization_strength = fast_random_projection_normalization_strength
        self.fast_random_projection_forth_iteration_weight = fast_random_projection_forth_iteration_weight

    def __to_embedding_parameters(self):
        return {
            "dependencies_projection_embedding_dimension": str(self.embedding_dimension),
            "dependencies_projection_fast_random_projection_normalization_strength": str(self.fast_random_projection_normalization_strength),
            "dependencies_projection_fast_random_projection_forth_iteration_weight": str(self.fast_random_projection_forth_iteration_weight),
            "dependencies_projection_embedding_random_seed": str(self.random_seed),
            "dependencies_projection_write_property": "embeddingsFastRandomProjectionForClustering",
            **self.dependency_projection.get_cypher_parameters()
        }

    def __generate_embeddings(self):
        node_embedding_parameters = self.__to_embedding_parameters()

        if self.verbose:
            print("Generating embeddings using Neo4j Graph Data Science with the following parameters: " + str(node_embedding_parameters))
            return query_cypher_to_data_frame(self.cypher_query_for_generating_embeddings_, parameters=node_embedding_parameters)

        return query_cypher_to_data_frame_suppress_warnings(self.cypher_query_for_generating_embeddings_, parameters=node_embedding_parameters)

    def __check_fitted(self):
        """
        Checks if the model has been fitted by checking if the embeddings_ attribute exists.
        Raises a ValueError if the model has not been fitted yet.
        """
        if not hasattr(self, 'embeddings_') or not hasattr(self, 'clustering_scores_'):
            raise ValueError("The model has not been fitted yet. Please call the fit method before.")

    def fit(self, X=None, y=None):
        """
        Fits the model by generating node embeddings and calculating the Hopkins statistic.
        """
        self.embeddings_ = self.__generate_embeddings()
        self.clustering_scores_ = HierarchicalDensityClusteringScores.cluster_embeddings_with_references(self.embeddings_.embedding, self.embeddings_.communityId)
        return self

    def score(self, X=None, y=None):
        """
        Returns the score of the model based on the adjusted mutual info score comparing the clusters with pre calculated Leiden communities.
        """
        self.__check_fitted()
        return self.clustering_scores_.adjusted_mutual_info_score

    def write_embeddings(self):
        """
        Writes the generated embeddings to the Neo4j database.
        This is useful for further processing or analysis of the embeddings.
        """
        node_embedding_parameters = self.__to_embedding_parameters()
        print("Writing embeddings to Neo4j with the following parameters: " + str(node_embedding_parameters))

        if self.verbose:
            query_cypher_to_data_frame(self.cypher_query_for_writing_embeddings_, parameters=node_embedding_parameters)
        else:
            query_cypher_to_data_frame_suppress_warnings(self.cypher_query_for_writing_embeddings_, parameters=node_embedding_parameters)
        return self

    def get_embeddings(self):
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


def get_tuned_fast_random_projection_node_embeddings(projection_parameters: dict) -> TuneableFastRandomProjectionNodeEmbeddings:

    def objective(trial):
        # Here we intentionally use the original projection parameters, not the sampled ones,
        # since the sampling is not necessary for Fast Random Projection embeddings.
        tuneable_fast_random_projection = create_tuneable(TuneableFastRandomProjectionNodeEmbeddings).with_projection_parameters(projection_parameters)
        # Suggest values for each hyperparameter
        tuneable_fast_random_projection.set_params(
            embedding_dimension=trial.suggest_categorical("embedding_dimension", [64, 128, 256]),
            fast_random_projection_normalization_strength=trial.suggest_float("fast_random_projection_normalization_strength", low=-1.0, high=1.0, step=0.1),
            fast_random_projection_forth_iteration_weight=trial.suggest_float("fast_random_projection_forth_iteration_weight", low=0.0, high=2.0, step=0.1),
        )
        tuneable_fast_random_projection.fit()
        return tuneable_fast_random_projection.score()

    # TODO create study with db?
    study_name = "FastRandomProjection4Java" + projection_parameters["dependencies_projection_node"]
    study = optuna.create_study(direction="maximize", sampler=TPESampler(seed=42), study_name=study_name)  # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)

    # Try (enqueue) two specific settings first that led to good results in initial experiments
    study.enqueue_trial({'embedding_dimension': 128, 'fast_random_projection_forth_iteration_weight': 0.5, 'fast_random_projection_normalization_strength': 0.3})
    study.enqueue_trial({'embedding_dimension': 128, 'fast_random_projection_forth_iteration_weight': 1.0, 'fast_random_projection_normalization_strength': 0.5})
    study.enqueue_trial({'embedding_dimension': 256, 'fast_random_projection_forth_iteration_weight': 0.5, 'fast_random_projection_normalization_strength': 0.3})
    study.enqueue_trial({'embedding_dimension': 256, 'fast_random_projection_forth_iteration_weight': 1.0, 'fast_random_projection_normalization_strength': 0.3})

    # Start the hyperparameter tuning
    study.optimize(objective, n_trials=80, timeout=40)
    output_optuna_tuning_results(study, 'Fast Random Projection (FastRP)')

    # Run the node embeddings algorithm again again with the best parameters
    tuned_fast_random_projection = create_tuneable(TuneableFastRandomProjectionNodeEmbeddings).with_projection_parameters(projection_parameters)
    tuned_fast_random_projection.set_params(**study.best_params)
    return tuned_fast_random_projection.fit()


def prepare_node_embeddings_for_2d_visualization(embeddings: pd.DataFrame) -> pd.DataFrame:
    """
    Reduces the dimensionality of the node embeddings (e.g. 64 floating point numbers in an array)
    to two dimensions for 2D visualization.
    see https://opentsne.readthedocs.io
    """

    if embeddings.empty:
        print("No projected data for node embeddings dimensionality reduction available")
        return embeddings

    # Calling the fit_transform method just with a list doesn't work.
    # It leads to an error with the following message: 'list' object has no attribute 'shape'
    # This can be solved by converting the list to a numpy array using np.array(..).
    # See https://bobbyhadz.com/blog/python-attributeerror-list-object-has-no-attribute-shape
    embeddings_as_numpy_array = np.array(embeddings.embedding.to_list())

    # Use t-distributed Stochastic Neighbor Embedding (t-SNE) to reduce the dimensionality
    # of the previously calculated node embeddings to 2 dimensions for visualization
    t_distributed_stochastic_neighbor_embedding = TSNE(n_components=2, verbose=False, random_state=47)
    two_dimension_node_embeddings = t_distributed_stochastic_neighbor_embedding.fit_transform(embeddings_as_numpy_array)
    # display(two_dimension_node_embeddings.shape) # Display the shape of the t-SNE result

    # Create a new DataFrame with the results of the 2 dimensional node embeddings
    # and the code unit and artifact name of the query above as preparation for the plot
    embeddings['embeddingVisualizationX'] = [value[0] for value in two_dimension_node_embeddings]
    embeddings['embeddingVisualizationY'] = [value[1] for value in two_dimension_node_embeddings]

    return embeddings


def execute_tuned_node_embeddings_clustering(projection_parameters: dict):

    if create_undirected_projection(projection_parameters):
        tuned_fast_random_projection = get_tuned_fast_random_projection_node_embeddings(projection_parameters)
        embeddings = tuned_fast_random_projection.get_embeddings()
        embeddings = add_tuned_hierarchical_density_based_spatial_clustering(embeddings).embeddings
        embeddings = prepare_node_embeddings_for_2d_visualization(embeddings)

        tuned_fast_random_projection.write_embeddings()
        data_to_write = pd.DataFrame(data={
            'nodeElementId': embeddings["nodeElementId"],
            'clusteringHDBSCANLabel': embeddings['clusteringTunedHDBSCANLabel'],
            'clusteringHDBSCANProbability': embeddings['clusteringTunedHDBSCANProbability'],
            'embeddingFastRandomProjectionVisualizationX': embeddings["embeddingVisualizationX"],
            'embeddingFastRandomProjectionVisualizationY': embeddings["embeddingVisualizationY"],
        })
        write_batch_data_into_database(data_to_write, projection_parameters['dependencies_projection_node'])
    else:
        graph_node = projection_parameters['dependencies_projection_node']
        programming_language = projection_parameters['dependencies_projection_language']
        print(f"No projected data for {programming_language} {graph_node} node embeddings calculation available.")

# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------

log_dependency_versions()
driver = get_graph_database_driver()
optuna.logging.set_verbosity(optuna.logging.WARNING)

java_package_projection_parameters = {
    "dependencies_projection": "java-package-embeddings-clustering",
    "dependencies_projection_node": "Package",
    "dependencies_projection_language": "Java", 
    "dependencies_projection_weight_property": "weight25PercentInterfaces",
}
execute_tuned_node_embeddings_clustering(java_package_projection_parameters)

java_type_projection_parameters = {
    "dependencies_projection": "java-type-embeddings-clustering",
    "dependencies_projection_node": "Type",
    "dependencies_projection_language": "Java", 
    "dependencies_projection_weight_property": "weight",
}
execute_tuned_node_embeddings_clustering(java_type_projection_parameters)