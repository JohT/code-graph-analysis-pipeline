#!/usr/bin/env python

# This Python script detects anomalies in the codebase with the unsupervised learning method "Isolation Forest".
# It is designed to work with a Neo4j graph database containing code units (like Java packages or types) and their dependencies.
# To explain the results, we use SHAP (SHapley Additive exPlanations) to provide insights into the feature importances and how they contribute to the anomaly scores.
# All results - anomaly labels, anomaly scores and their most influential features — are written back to Neo4j for further use.

# Prerequisite:
# - Already existing Graph with analyzed code units (like Java Packages) and their dependencies.
# - Provide the password for Neo4j in the environment variable "NEO4J_INITIAL_PASSWORD".
# - Requires "tunedLeidenCommunityDetection.py", "tunedNodeEmbeddingClustering.py" and "umap2dNodeEmbedding.py" to be executed before this script to provide the necessary data.

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

from sklearn.ensemble import IsolationForest, RandomForestClassifier
from sklearn.decomposition import PCA
from sklearn.metrics import f1_score, make_scorer
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.preprocessing import StandardScaler

from optuna.importance import get_param_importances, MeanDecreaseImpurityImportanceEvaluator
from optuna.trial import TrialState
from optuna.samplers import TPESampler
from optuna import Study, create_study

import shap  # Explainable AI tool

import umap # Dimensionality reduction for visualization
import matplotlib.pyplot as plot

from visualization import annotate_each, annotate_each_with_index, scale_marker_sizes, zoom_into_center_while_preserving_top_scores, plot_annotation_style

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

        from sklearn import __version__ as sklearn_version
        print('scikit-learn version: {}'.format(sklearn_version))

        from neo4j import __version__ as neo4j_version
        print('neo4j version: {}'.format(neo4j_version))

        from optuna import __version__ as optuna_version
        print('optuna version: {}'.format(optuna_version))

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
        return cls({
            "projection_node_label": "Package",
        })

    def get_query_parameters(self) -> typing.Dict[str, str]:
        return self.query_parameters_.copy()  # copy enforces immutability

    def get_projection_node_label(self) -> str:
        return self.query_parameters_["projection_node_label"]

    def __is_code_language_available(self) -> bool:
        return "projection_language" in self.query_parameters_

    def __get_projection_language(self) -> str:
        return self.query_parameters_["projection_language"] if self.__is_code_language_available() else ""

    def get_title_prefix(self) -> str:
        if self.__is_code_language_available():
            return self.__get_projection_language() + " " + self.get_projection_node_label()
        return self.get_projection_node_label()

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


def get_file_path(name: str, parameters: Parameters, extension: str = 'svg') -> str:
    name = parameters.get_report_directory() + '/' + name.replace(' ', '_') + '.' + extension
    if parameters.is_verbose():
        print(f"tunedAnomalyDetectionExplained: Saving file {name}")
    return name


def get_neo4j_password() -> str:
    password = os.environ.get("NEO4J_INITIAL_PASSWORD")
    if password is None:
        raise RuntimeError("Environment variable NEO4J_INITIAL_PASSWORD is not set. Please set it to the Neo4j password.")
    return password


def get_graph_database_driver() -> Driver:
    driver = GraphDatabase.driver(
        uri="bolt://localhost:7687",
        auth=("neo4j", get_neo4j_password())
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
                print(f"tunedAnomalyDetectionExplained: Writing data from {start} to {start + batch_size} resulting in length {len(batch_rows)}")
            session.execute_write(update_batch, batch_rows)


def query_data(input_parameters: Parameters = Parameters.example()) -> pd.DataFrame:

    query: typing.LiteralString = """
        MATCH (codeUnit)
        WHERE $projection_node_label IN labels(codeUnit)
          AND (codeUnit.incomingDependencies IS NOT NULL OR codeUnit.outgoingDependencies IS NOT NULL)
          AND codeUnit.embeddingsFastRandomProjectionTunedForClustering  IS NOT NULL
          AND codeUnit.centralityPageRank                                IS NOT NULL
          AND codeUnit.centralityArticleRank                             IS NOT NULL
          AND codeUnit.centralityBetweenness                             IS NOT NULL
          AND codeUnit.communityLocalClusteringCoefficient               IS NOT NULL
          AND codeUnit.clusteringHDBSCANProbability                      IS NOT NULL
          AND codeUnit.clusteringHDBSCANNoise                            IS NOT NULL
          AND codeUnit.clusteringHDBSCANMedoid                           IS NOT NULL
          AND codeUnit.clusteringHDBSCANRadiusAverage                    IS NOT NULL
          AND codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid       IS NOT NULL
          AND codeUnit.clusteringHDBSCANSize                             IS NOT NULL
          AND codeUnit.clusteringHDBSCANLabel                            IS NOT NULL
          AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX       IS NOT NULL
          AND codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY       IS NOT NULL
        OPTIONAL MATCH (artifact:Java:Artifact)-[:CONTAINS]->(codeUnit)
            WITH *, artifact.name AS artifactName
        OPTIONAL MATCH (projectRoot:Directory)<-[:HAS_ROOT]-(proj:TS:Project)-[:CONTAINS]->(codeUnit)
            WITH *, last(split(projectRoot.absoluteFileName, '/')) AS projectName   
         WITH * 
             ,coalesce(codeUnit.incomingDependencies, 0) AS incomingDependencies
             ,coalesce(codeUnit.outgoingDependencies, 0) AS outgoingDependencies
             ,coalesce(codeUnit.fqn, codeUnit.globalFqn, codeUnit.fileName, codeUnit.signature, codeUnit.name) AS codeUnitName
             ,coalesce(artifactName, projectName, "")    AS projectName
       RETURN DISTINCT 
              codeUnitName
             ,codeUnit.name                                                 AS shortCodeUnitName
             ,projectName
             ,elementId(codeUnit)                                           AS nodeElementId
             ,incomingDependencies
             ,outgoingDependencies
             ,incomingDependencies + outgoingDependencies                   AS degree
             ,codeUnit.embeddingsFastRandomProjectionTunedForClustering     AS embedding
             ,codeUnit.centralityPageRank                                   AS pageRank
             ,codeUnit.centralityArticleRank                                AS articleRank
             ,codeUnit.centralityPageRank - codeUnit.centralityArticleRank  AS pageToArticleRankDifference
             ,codeUnit.centralityBetweenness                                AS betweenness
             ,codeUnit.communityLocalClusteringCoefficient                  AS localClusteringCoefficient
             ,1.0 - codeUnit.clusteringHDBSCANProbability                   AS clusterApproximateOutlierScore
             ,codeUnit.clusteringHDBSCANNoise                               AS clusterNoise
             ,codeUnit.clusteringHDBSCANRadiusAverage                       AS clusterRadiusAverage
             ,codeUnit.clusteringHDBSCANNormalizedDistanceToMedoid          AS clusterDistanceToMedoid
             ,codeUnit.clusteringHDBSCANSize                                AS clusterSize
             ,codeUnit.clusteringHDBSCANLabel                               AS clusterLabel
             ,codeUnit.clusteringHDBSCANMedoid                              AS clusterMedoid
             ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX          AS embeddingVisualizationX
             ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY          AS embeddingVisualizationY
        """
    if parameters.is_verbose():
        return query_cypher_to_data_frame(query, parameters=input_parameters.get_query_parameters())
    return query_cypher_to_data_frame_suppress_warnings(query, parameters=input_parameters.get_query_parameters())


def validate_data(features: pd.DataFrame) -> None:
    if features.isnull().values.any():
        null_columns = features.columns[features.isnull().any()].tolist()
        raise RuntimeError(f"tunedAnomalyDetectionExplained: Data Validation Error: Some values in columns {null_columns} are null. Fix the wrong values or filter them out.")


def standardize_features(features: pd.DataFrame, feature_list: list[str]) -> numpy_typing.NDArray:
    features_to_scale = features[feature_list]
    scaler = StandardScaler()
    return scaler.fit_transform(features_to_scale)


def remove_constant_features(features: pd.DataFrame, feature_names: list[str], is_verbose: bool = False) -> list[str]:
    """
    Removes constant features from the feature list.
    """
    non_constant_features = []
    for feature in feature_names:
        if features[feature].nunique() > 1:
            non_constant_features.append(feature)
        else:
            if is_verbose:
                print("tunedAnomalyDetectionExplained: Removing constant feature {feature}")
    return non_constant_features


def reduce_dimensionality_of_node_embeddings(
        features: pd.DataFrame,
        min_dimensions: int = 20,
        max_dimensions: int = 35,
        target_variance: float = 0.90,
        embedding_column_name: str = 'embedding',
        random_seed: int = 42,
) -> numpy_typing.NDArray:
    """
    Automatically reduce the dimensionality of node embeddings using Principal Component Analysis (PCA)
    to reach a target explained variance ratio with the lowest possible number of components (output dimensions).

    Parameters:
    - features (pd.DataFrame) with a column 'embedding', where every value contains a float array with original dimensions.
    - min_dimensions: Even if possible with the given variance, don't go below this number of dimensions for the output
    - max_dimensions: Return at most the max number of dimensions, even if that means, that the target variance can't be met.
    - target_variance (float): Cumulative variance threshold (default: 0.90)
    - embedding_column_name (string): Defaults to 'embedding'

    Returns: Reduced embeddings as an numpy array
    """

    # Convert the input and get the original dimension
    embeddings = np.stack(features[embedding_column_name].apply(np.array).tolist())
    original_dimension = embeddings.shape[1]

    # Fit PCA without dimensionality reduction to get explained variance
    full_principal_component_analysis_without_reduction = PCA()
    full_principal_component_analysis_without_reduction.fit(embeddings)

    # Find smallest number of components to reach target variance
    cumulative_variance = np.cumsum(full_principal_component_analysis_without_reduction.explained_variance_ratio_)
    best_n_components = np.searchsorted(cumulative_variance, target_variance) + 1
    best_n_components = max(best_n_components, min_dimensions)  # Use at least min_dimensions
    best_n_components = min(best_n_components, max_dimensions)  # Use at most max_dimensions

    # The number of components must be between 0 and min(n_samples, n_features)
    best_n_components = min(best_n_components, min(embeddings.shape[0], embeddings.shape[1]))

    # Apply PCA with optimal number of components
    principal_component_analysis = PCA(n_components=best_n_components, random_state=random_seed)
    principal_component_analysis_results = principal_component_analysis.fit_transform(embeddings)

    explained_variance_ratio_sum = sum(principal_component_analysis.explained_variance_ratio_)
    print(f"Dimensionality reduction from {original_dimension} to {best_n_components} (min {min_dimensions}, max {max_dimensions}) of node embeddings using Principal Component Analysis (PCA): Explained variance is {explained_variance_ratio_sum:.4f}.")

    return principal_component_analysis_results


def output_optuna_tuning_results(optimized_study: Study, name_of_the_optimized_algorithm: str):

    print(f"tunedAnomalyDetectionExplained: Best {name_of_the_optimized_algorithm} parameters (Optuna):", optimized_study.best_params)
    print(f"tunedAnomalyDetectionExplained: Best {name_of_the_optimized_algorithm} score:", optimized_study.best_value)
    print(f"tunedAnomalyDetectionExplained: Best {name_of_the_optimized_algorithm} parameter influence:", get_param_importances(optimized_study, evaluator=MeanDecreaseImpurityImportanceEvaluator()))

    valid_trials = [trial for trial in optimized_study.trials if trial.value is not None and trial.state == TrialState.COMPLETE]
    top_trials = sorted(valid_trials, key=lambda t: typing.cast(float, t.value), reverse=True)[:10]
    for i, trial in enumerate(top_trials):
        print(f"tunedAnomalyDetectionExplained: Best {name_of_the_optimized_algorithm} parameter rank: {i+1}, trial: {trial.number}, Value = {trial.value:.6f}, Params: {trial.params}")


class AnomalyDetectionResults:
    def __init__(self,
                 anomaly_labels: np.ndarray,
                 anomaly_scores: np.ndarray,
                 random_forest_classifier: RandomForestClassifier,
                 feature_importances: np.ndarray
                 ):
        self.anomaly_labels = anomaly_labels
        self.anomaly_scores = anomaly_scores
        self.random_forest_classifier = random_forest_classifier
        self.feature_importances = feature_importances

    def is_empty(self) -> bool:
        return (self.anomaly_labels.size == 0 and
                self.anomaly_scores.size == 0 and
                self.feature_importances.size == 0)

    def __repr__(self):
        return (f"AnomalyDetectionResults(anomaly_labels={self.anomaly_labels.shape}, "
                f"anomaly_scores={self.anomaly_scores.shape}, "
                f"random_forest_classifier={type(self.random_forest_classifier).__name__}, "
                f"feature_importances={self.feature_importances.shape})")

    @classmethod
    def no_anomalies(cls):
        return cls(
            anomaly_labels=np.array([]),
            anomaly_scores=np.array([]),
            random_forest_classifier=RandomForestClassifier(),
            feature_importances=np.array([])
        )


def tune_anomaly_detection_models(
    feature_matrix: np.ndarray,
    parameters: Parameters,
    contamination: float | typing.Literal["auto"] = 0.05,
    random_seed: int = 42,
    number_of_trials: int = 25,
    optimization_timeout_in_seconds: int = 50
) -> AnomalyDetectionResults:
    """
    Tunes both Isolation Forest and a proxy Random Forest using Optuna, maximizing the F1 score
    between Isolation Forest pseudo-labels and proxy predictions. The proxy model mimics the behavior of the Isolation Forest 
    and is mainly used to provide feature importances and explainability using SHAP values later.

    Parameters:
    - feature_matrix: np.ndarray of shape (n_samples, n_features), preprocessed input features.
    - contamination: favor only a few suspicious cases with a fixed percentage
    - random_seed: seed for reproducibility.
    - number_of_trials: number of Optuna optimization trials.
    - number_of_cross_validation_folds: number of cross validation (CV) folds for proxy model validation.

    Returns:
    - AnomalyDetectionResults containing:
        - anomaly_labels: np.ndarray of shape (n_samples,), binary labels indicating anomalies (1) or normal (0).
        - anomaly_scores: np.ndarray of shape (n_samples,), anomaly scores where higher values indicate more anomalous instances.
        - random_forest_classifier: trained Random Forest classifier that mimics the Isolation Forest behavior.
        - feature_importances: np.ndarray of shape (n_features,), feature importances from the Random Forest classifier.
    """

    def objective(trial) -> float:
        # Isolation Forest hyperparameters
        max_samples_ratio = trial.suggest_float("isolation_max_samples", 0.1, 0.5)
        number_of_rows = feature_matrix.shape[0]
        if int(max_samples_ratio * number_of_rows) < 2:
            print("tunedAnomalyDetectionExplained: Warning: Isolation Forest max_samples would resolve to less than 2. Invalid hyper-parameters.")
            return 0.0
    
        isolation_forest = IsolationForest(
            max_samples=max_samples_ratio,
            contamination=contamination,
            n_estimators=trial.suggest_int("isolation_n_estimators", 100, 400),
            random_state=random_seed
        )
        # Train Isolation Forest
        isolation_forest.fit(feature_matrix)

        # Generate pseudo-labels: 1 = anomaly, 0 = normal
        pseudo_labels = (isolation_forest.predict(feature_matrix) == -1).astype(int)
        if len(np.unique(pseudo_labels)) < 2:
            print("tunedAnomalyDetectionExplained: Warning: Isolation Forest did not detect any anomalies. Returning a low score.")
            return 0.0

        # Proxy Random Forest hyperparameters
        proxy_random_forest = RandomForestClassifier(
            n_estimators=trial.suggest_int("proxy_n_estimators", 100, 500),
            max_depth=trial.suggest_int("proxy_max_depth", 4, 20),
            random_state=random_seed,
            min_samples_leaf=1,
            max_features="sqrt"
        )

        # Custom scorer that won’t fail if class 1 is absent
        f1_scorer = make_scorer(f1_score, average='binary', zero_division=0)

        n_splits = min(3, np.min(np.bincount(pseudo_labels)))  # Avoid folds with missing classes
        if n_splits < 2:
            print(f"tunedAnomalyDetectionExplained: Warning:  Not enough data (n_splits={n_splits} for meaningful Cross Validation (CV).")
            return 0.0  # Not enough data for meaningful Cross Validation (CV)

        cross_validation = StratifiedKFold(n_splits=n_splits)

        # Train proxy model
        # Use cross-validation to get robust F1 score
        f1_scores = cross_val_score(
            proxy_random_forest,
            feature_matrix,
            pseudo_labels,
            cv=cross_validation,
            scoring=f1_scorer,
        )
        return float(np.mean(f1_scores))

    # Print the number of samples and features in the feature matrix
    n_samples = feature_matrix.shape[0]
    print(f"tunedAnomalyDetectionExplained: Tuning Anomaly Detection: Number of samples: {n_samples}, Number of features: {feature_matrix.shape[1]}, Number of trials: {number_of_trials}")

    # Run Optuna optimization
    study = create_study(direction="maximize", sampler=TPESampler(seed=random_seed), study_name="AnomalyDetection_Tuning")

    # Try (enqueue) default settings
    study.enqueue_trial({'isolation_max_samples': min(256, n_samples) / n_samples, 'isolation_n_estimators': 100, 'proxy_n_estimators': 100})
    
    # Try (enqueue) some specific settings that led to good results during experiments
    study.enqueue_trial({'isolation_max_samples': 0.42726366840740576, 'isolation_n_estimators': 141, 'proxy_n_estimators': 190, 'proxy_max_depth': 5})
    study.enqueue_trial({'isolation_max_samples': 0.40638732079782663, 'isolation_n_estimators': 108, 'proxy_n_estimators': 191, 'proxy_max_depth': 9})
    
    study.enqueue_trial({'isolation_max_samples': 0.10010443935999927, 'isolation_n_estimators': 350, 'proxy_n_estimators': 344, 'proxy_max_depth': 8})
    study.enqueue_trial({'isolation_max_samples': 0.10015063610944819, 'isolation_n_estimators': 329, 'proxy_n_estimators': 314, 'proxy_max_depth': 8})

    study.optimize(objective, n_trials=number_of_trials, timeout=optimization_timeout_in_seconds)

    # Output tuning results
    print(f"Best Isolation & Random Forest parameters for {parameters.get_title_prefix()} after {len(study.trials)}/{number_of_trials} trials with best #{study.best_trial.number} (Optuna):", study.best_params)

    if parameters.is_verbose():
        output_optuna_tuning_results(study, study.study_name)

    if np.isclose(study.best_value, 0.0, rtol=1e-09, atol=1e-09):
        red = "\x1b[31;20m"
        reset = "\x1b[0m"
        print(f"{red}tunedAnomalyDetectionExplained: Error: No valid trials found. All trials returned a score of 0.0. No anomalies detectable. Check the data and parameters.{reset}")
        return AnomalyDetectionResults.no_anomalies()

    # Train best models from best params
    best_params = study.best_params

    best_isolation_forest = IsolationForest(
        n_estimators=best_params["isolation_n_estimators"],
        max_samples=best_params["isolation_max_samples"],
        contamination=contamination,
        random_state=random_seed
    )
    anomaly_detection_results = best_isolation_forest.fit_predict(feature_matrix)
    anomaly_labels = (anomaly_detection_results == -1).astype(int)  # 1 means "anomaly", 0 means "non-anomaly"
    anomaly_scores = best_isolation_forest.decision_function(feature_matrix) * -1  # higher = more anomalous

    best_proxy_random_forest = RandomForestClassifier(
        n_estimators=best_params["proxy_n_estimators"],
        max_depth=best_params["proxy_max_depth"],
        random_state=random_seed,
        min_samples_leaf=1,
        max_features="sqrt"
    )
    best_proxy_random_forest.fit(feature_matrix, anomaly_detection_results)

    return AnomalyDetectionResults(anomaly_labels, anomaly_scores, best_proxy_random_forest, best_proxy_random_forest.feature_importances_)


def add_anomaly_detection_results_to_features(
    features: pd.DataFrame,
    anomaly_detection_results: AnomalyDetectionResults,
    anomaly_label_column: str = 'anomalyLabel',
    anomaly_score_column: str = 'anomalyScore',
    anomaly_rank_column: str = 'anomalyRank'
) -> pd.DataFrame:
    """
    Adds anomaly detection results to the feature and returns the updated dataframe.

    Parameters:
    - features: pd.DataFrame of shape (n_samples, n_features).
    - anomaly_detection_results: AnomalyDetectionResults object containing labels and scores.
    - anomaly_label_column: Name for the anomaly label column.
    - anomaly_score_column: Name for the anomaly score column.

    Returns:
    - Updated feature dataframe with anomaly labels and scores.
    """

    # Add anomaly labels and scores to the feature matrix
    features[anomaly_label_column] = anomaly_detection_results.anomaly_labels
    features[anomaly_score_column] = anomaly_detection_results.anomaly_scores
    features[anomaly_rank_column] = features[anomaly_score_column].rank(method='dense', ascending=False).astype(int)
    return features


def prepare_features_for_2d_visualization(features: np.ndarray, anomaly_detection_results: pd.DataFrame) -> pd.DataFrame:
    """
    Reduces the dimensionality of the features down to two dimensions for 2D visualization using UMAP.
    see https://umap-learn.readthedocs.io
    """

    # Check if features are empty
    if features is None or len(features) == 0:
        print("No feature data available")
        return anomaly_detection_results

    # Check if features and anomaly_detection_results have compatible lengths
    if features.shape[0] != anomaly_detection_results.shape[0]:
        raise ValueError("Features and anomaly_detection_results must have the same number of samples.")

    # Use UMAP to reduce the dimensionality to 2D for visualization
    umap_reducer = umap.UMAP(n_components=2, min_dist=0.3, random_state=47, n_jobs=1)
    two_dimensional_features = umap_reducer.fit_transform(features)
    
    # Convert to dense numpy array (works for both sparse and dense input)
    feature_coordinates = np.asarray(two_dimensional_features)

    anomaly_detection_results['featureVisualizationX'] = feature_coordinates[:, 0]
    anomaly_detection_results['featureVisualizationY'] = feature_coordinates[:, 1]

    return anomaly_detection_results


def get_top_10_anomalies(
        anomaly_detected_features: pd.DataFrame,
        anomaly_label_column: str = "anomalyLabel",
        anomaly_score_column: str = "anomalyScore"
) -> pd.DataFrame:
    anomalies = anomaly_detected_features[anomaly_detected_features[anomaly_label_column] == 1]
    return anomalies.sort_values(by=anomaly_score_column, ascending=False).head(10)


def get_top_10_non_anomalies(
        anomaly_detected_features: pd.DataFrame,
        anomaly_label_column: str = "anomalyLabel",
        anomaly_score_column: str = "anomalyScore"
) -> pd.DataFrame:
    anomalies = anomaly_detected_features[anomaly_detected_features[anomaly_label_column] != 1]
    return anomalies.sort_values(by=anomaly_score_column, ascending=True).head(10)


def plot_anomalies(
    features_to_visualize: pd.DataFrame,
    title_prefix: str,
    plot_file_path: str,
    code_unit_column: str = "shortCodeUnitName",
    cluster_label_column: str = "clusterLabel",
    cluster_medoid_column: str = "clusterMedoid",
    cluster_size_column: str = "clusterSize",
    anomaly_label_column: str = "anomalyLabel",
    anomaly_score_column: str = "anomalyScore",
    size_column: str = "articleRank",
    x_position_column: str = 'embeddingVisualizationX',
    y_position_column: str = 'embeddingVisualizationY',

) -> None:

    if features_to_visualize.empty:
        print("No projected data to plot available")
        return

    annotate_top_n_anomalies: int = 10
    annotate_top_n_non_anomalies: int = 3
    annotate_top_n_clusters: int = 10

    features_to_visualize_zoomed=zoom_into_center_while_preserving_top_scores(
        features_to_visualize, 
        x_position_column, 
        y_position_column, 
        anomaly_score_column, 
        annotate_top_n_anomalies
    )
    # Add column with scaled version of "node_size_column" for uniform marker scaling
    features_to_visualize_zoomed = features_to_visualize_zoomed.copy()
    features_to_visualize_zoomed.loc[:, size_column + '_scaled'] = scale_marker_sizes(features_to_visualize_zoomed[size_column])

    def get_common_plot_parameters(data: pd.DataFrame) -> dict:
        return {
            "x": data[x_position_column],
            "y": data[y_position_column],
            "s": data[size_column + '_scaled'],
        }
    cluster_anomalies = features_to_visualize_zoomed[features_to_visualize_zoomed[anomaly_label_column] == 1]
    cluster_without_anomalies = features_to_visualize_zoomed[features_to_visualize_zoomed[anomaly_label_column] != 1]
    cluster_noise = cluster_without_anomalies[cluster_without_anomalies[cluster_label_column] == -1]
    cluster_non_noise = cluster_without_anomalies[cluster_without_anomalies[cluster_label_column] != -1]

    plot.figure(figsize=(10, 10))
    plot.title(
        label=f"{title_prefix} Anomalies (size={size_column}, main-color=cluster, red=anomaly, green=non-anomaly)", 
        pad=30,
        bbox=dict(facecolor='white', edgecolor='none', pad=2, alpha=0.6)
    )
    # Plot noise (from clustering)
    plot.scatter(
        **get_common_plot_parameters(cluster_noise),
        color='lightgrey',
        alpha=0.4,
        label='Noise'
    )

    # Plot clusters
    plot.scatter(
        **get_common_plot_parameters(cluster_non_noise),
        c=cluster_non_noise[cluster_label_column],
        cmap='tab20',
        alpha=0.7,
        label='Clusters'
    )

    # Plot anomalies
    plot.scatter(
        **get_common_plot_parameters(cluster_anomalies),
        c=cluster_anomalies[anomaly_score_column],
        cmap="Reds",
        alpha=0.9,
        label='Anomaly'
    )
    
    common_column_names_for_annotations = {
        "name_column": code_unit_column, 
        "x_position_column": x_position_column, 
        "y_position_column": y_position_column
    }

    # Annotate medoids of the cluster
    cluster_medoids = cluster_non_noise[cluster_non_noise[cluster_medoid_column] == 1].sort_values(by=cluster_size_column, ascending=False).head(annotate_top_n_clusters)
    annotate_each(
        cluster_medoids, 
        using=plot.annotate, 
        cluster_label_column=cluster_label_column,
        **common_column_names_for_annotations,
        alpha=0.4
    )

    # Annotate top non-anomalies
    non_anomalies = cluster_without_anomalies.sort_values(by=anomaly_score_column, ascending=True).reset_index(drop=True).head(annotate_top_n_non_anomalies)
    annotate_each_with_index(
        non_anomalies, 
        using=plot.annotate, 
        value_column=anomaly_score_column,
        **common_column_names_for_annotations,
        color="green",
        alpha=0.7
    )

    # Annotate top anomalies
    anomalies = cluster_anomalies.sort_values(by=anomaly_score_column, ascending=False).reset_index(drop=True).head(annotate_top_n_anomalies)
    annotate_each_with_index(
        anomalies, 
        using=plot.annotate, 
        value_column=anomaly_score_column,
        **common_column_names_for_annotations,
        color="red",
    )

    plot.tight_layout(pad=0.2)
    plot.axis('off')
    
    plot.savefig(plot_file_path)
    plot.close()


def plot_features_with_anomalies(
    features_to_visualize: pd.DataFrame,
    title_prefix: str,
    plot_file_path: str,
    code_unit_column: str = "shortCodeUnitName",
    cluster_label_column: str = "clusterLabel",
    anomaly_label_column: str = "anomalyLabel",
    anomaly_score_column: str = "anomalyScore",
    size_column: str = "articleRank",
    x_position_column: str = 'featureVisualizationX',
    y_position_column: str = 'featureVisualizationY',
    annotate_top_n_anomalies: int = 5,
    annotate_fully_top_n_anomalies: int = 3,
) -> None:
    
    if features_to_visualize.empty:
        print("No projected data to plot available")
        return
    
    def truncate(text: str, max_length: int = 22):
        if len(text) <= max_length:
            return text
        return text[:max_length - 3] + "..."

    features_to_visualize.loc[:, size_column + '_scaled'] = scale_marker_sizes(features_to_visualize[size_column])
    def get_common_plot_parameters(data: pd.DataFrame) -> dict:
        return {
            "x": data[x_position_column],
            "y": data[y_position_column],
            "s": data[size_column + '_scaled'],
        }
    cluster_anomalies = features_to_visualize[features_to_visualize[anomaly_label_column] == 1]
    cluster_without_anomalies = features_to_visualize[features_to_visualize[anomaly_label_column] != 1]
    cluster_noise = cluster_without_anomalies[cluster_without_anomalies[cluster_label_column] == -1]
    cluster_non_noise = cluster_without_anomalies[cluster_without_anomalies[cluster_label_column] != -1]

    plot.figure(figsize=(10, 10))
    plot.title(f"{title_prefix} Anomaly Detection Features (size={size_column}, red=anomaly, blue=noise)", pad=20)

    # Plot noise (from clustering)
    plot.scatter(
        **get_common_plot_parameters(cluster_noise),
        color='lightblue',
        alpha=0.4,
        label='Noise'
    )

    # Plot clusters
    plot.scatter(
        **get_common_plot_parameters(cluster_non_noise),
        color='lightgrey',
        alpha=0.6,
        label='Clusters'
    )

    # Plot anomalies
    plot.scatter(
        **get_common_plot_parameters(cluster_anomalies),
        c=cluster_anomalies[anomaly_score_column],
        cmap="Reds",
        alpha=0.95,
        label='Anomaly',
    )

    # Annotate top anomalies
    anomalies = cluster_anomalies.sort_values(by=anomaly_score_column, ascending=False).reset_index(drop=True).head(annotate_top_n_anomalies)
    anomalies_in_reversed_order = anomalies.iloc[::-1] # plot most important annotations last to overlap less important ones
    for dataframe_index, row in anomalies_in_reversed_order.iterrows():
        index = typing.cast(int, dataframe_index)
        text = f"{index + 1}"
        xytext = (5, 5)
        if index < annotate_fully_top_n_anomalies:
            text = f"{text}: {truncate(row[code_unit_column])}"
            xytext = (5, 5 + (index % 4) * 12)

        plot.annotate(
            text=text,
            xy=(row[x_position_column], row[y_position_column]),
            xytext=xytext,
            color='red',
            **plot_annotation_style
        )

    plot.savefig(plot_file_path)
    plot.close()

    
DType = typing.TypeVar("DType", bound=np.generic)
Numpy_Array = numpy_typing.NDArray[DType]
Two_Dimensional_Vector = typing.Annotated[Numpy_Array, typing.Literal[2]]


class AnomaliesExplanationResults:
    def __init__(self,
                 shap_anomaly_values: Numpy_Array,
                 shap_expected_anomaly_value: float,
                 ):
        assert shap_anomaly_values.ndim == 2, "The 'shap_anomaly_values' must be a 2D numpy array."
        self.shap_anomaly_values = shap_anomaly_values
        self.shap_expected_anomaly_value = shap_expected_anomaly_value

    def __repr__(self):
        return (f"AnomaliesExplanationResults(shap_anomaly_values shape={self.shap_anomaly_values.shape}, "
                f"shap_expected_anomaly_value shape={self.shap_expected_anomaly_value})")


def explain_anomalies_with_shap(
        random_forest_model: RandomForestClassifier,
        prepared_features: Numpy_Array,
        parameters: Parameters
) -> AnomaliesExplanationResults:
    """
    Use SHAP to explain the detected anomalies.
    """
    if not isinstance(prepared_features, np.ndarray) or len(prepared_features.shape) != 2:
        raise ValueError("Prepared_features must be a 2D numpy array.")

    # Use TreeExplainer on Random Forest Proxy Model
    # This is necessary because Isolation Forest does not support SHAP explanations directly.
    explainer = shap.TreeExplainer(random_forest_model)
    shap_values = explainer.shap_values(prepared_features)
    shap_anomaly_values = shap_values[:, :, 1]  # Class 1 = anomaly

    if parameters.is_verbose():
        print(f"tunedAnomalyDetectionExplained: Explain Anomaly Decision with SHAP: features shape={prepared_features.shape}")
        print(f"tunedAnomalyDetectionExplained: Explain Anomaly Decision with SHAP: values shape={np.shape(shap_values)}")
        print(f"tunedAnomalyDetectionExplained: Explain Anomaly Decision with SHAP: anomaly values shape={shap_anomaly_values.shape}")
        print(f"tunedAnomalyDetectionExplained: Explain Anomaly Decision with SHAP: expected_value shape={np.shape(typing.cast(np.ndarray, explainer.expected_value))}")
        print(f"tunedAnomalyDetectionExplained: Explain Anomaly Decision with SHAP: expected_value type={type(explainer.expected_value)}")

    shap_expected_anomaly_value = typing.cast(Numpy_Array, explainer.expected_value)[1]  # Class 1 = anomaly

    return AnomaliesExplanationResults(shap_anomaly_values, shap_expected_anomaly_value)


def plot_shap_explained_beeswarm(
    shap_anomaly_values: np.ndarray,
    prepared_features: np.ndarray,
    feature_names: list[str],
    plot_file_path: str,
    title_prefix: str = "",
) -> None:
    """
    Uses the SHAP values for anomalies to visaulize the global feature importance in a beeswarm plot.
    Best for global understanding of which features drive anomalies.
    Adds direction of impact (color shows feature value).
    Useful when you want to see how values push predictions toward normal or anomalous.
    """

    shap.summary_plot(
        shap_anomaly_values,
        prepared_features,
        feature_names=feature_names,
        plot_type="dot",
        max_display=20,
        plot_size=(12, 6),  # (width, height) in inches
        show=False
    )
    plot.title(f"How {title_prefix} features drive anomalies globally (beeswarm plot)", fontsize=12)
    plot.savefig(plot_file_path)
    plot.close()


def plot_shap_explained_local_feature_importance(
    index_to_explain,
    anomalies_explanation_results: AnomaliesExplanationResults,
    prepared_features: np.ndarray,
    feature_names: list[str],
    title: str,
    plot_file_path: str,
    rounding_precision: int = 4,
):
    """    
    Uses the SHAP values for anomalies to visualize the local feature importance for a specific anomaly.
    This function generates a force plot showing how each feature contributes to the anomaly score for a specific anomaly instance.
    The force plot is a powerful visualization that helps to understand the impact of each feature for each as anomaly classified data point.
    Visual breakdown of how each feature contributes to the score.
    Highly interpretable for debugging single nodes.
    """
    shap_anomaly_values = anomalies_explanation_results.shap_anomaly_values
    expected_anomaly_value = anomalies_explanation_results.shap_expected_anomaly_value

    shap_values_rounded = np.round(shap_anomaly_values[index_to_explain], rounding_precision)
    prepared_features_rounded = prepared_features[index_to_explain].round(rounding_precision)
    base_value_rounded = np.round(expected_anomaly_value, rounding_precision)

    shap.force_plot(
        base_value_rounded,
        shap_values_rounded,
        prepared_features_rounded,
        feature_names=feature_names,
        matplotlib=True,
        show=False,
        contribution_threshold=0.06
    )
    current_figure = plot.gcf()

    # Resize fonts manually (best effort, affects all text)
    for text in current_figure.findobj(match=plot.Text):
        text.set_fontsize(10)  # Set smaller font

    plot.title(title, fontsize=16, loc='left', y=0.05)
    plot.savefig(plot_file_path)
    plot.close()


def plot_all_shap_explained_local_feature_importance(
        data: pd.DataFrame,
        explanation_results: AnomaliesExplanationResults,
        prepared_features: np.ndarray,
        feature_names: list[str],
        parameters: Parameters,
        title_prefix: str = "",
        code_unit_name_column: str = "codeUnitName"
    ) -> None:

    index=0
    for row_index, row in data.iterrows():
        row_index = typing.cast(int, row_index)
        index=index+1
        plot_shap_explained_local_feature_importance(
            index_to_explain=row_index,
            anomalies_explanation_results=explanation_results,
            prepared_features=prepared_features,
            feature_names=feature_names,
            title=f"{title_prefix} \"{row[code_unit_name_column]}\" anomaly #{index} explained",
            plot_file_path=get_file_path(f"Anomaly_{index}_shap_explanation", parameters),
        )


def plot_shap_explained_top_10_feature_dependence(
    shap_anomaly_values: np.ndarray,
    prepared_features: np.ndarray,
    feature_names: list[str],
    plot_file_path: str,
    title_prefix: str = "",
):
    """
    Uses the SHAP values for anomalies to visualize the top 10 feature dependence plots.
    This function generates dependence plots for the top 10 features that contribute most to the anomaly score
    based on the mean absolute SHAP values across all anomalies.
    Dependence plots show how the SHAP value of a feature varies with its value, helping to understand the relationship between feature values and their impact on the anomaly score.
    """

    mean_shap_anomaly_value = np.abs(shap_anomaly_values).mean(axis=0)
    sorted_by_mean_ascending = np.argsort(mean_shap_anomaly_value)
    top_10_indices_ascending = sorted_by_mean_ascending[-10:]
    top_10_indices_descending = top_10_indices_ascending[::-1]  # Reverse to get descending order
    top_feature_names = [feature_names[i] for i in top_10_indices_descending]  # Get names of top features

    figure, axes = plot.subplots(5, 2, figsize=(15, 20))  # 5 rows x 2 columns
    figure.suptitle(f"{title_prefix} Anomalies: Top 10 feature dependence plots", fontsize=16)
    axes = axes.flatten()  # Flatten for easy iteration

    for index, feature in enumerate(top_feature_names):
        shap.dependence_plot(
            ind=feature,  # Feature name or index
            shap_values=shap_anomaly_values,
            features=prepared_features,
            feature_names=feature_names,
            interaction_index=None,  # Set to a feature name/index to see interactions
            show=False,
            ax=axes[index]
        )

    plot.tight_layout(rect=(0.0, 0.02, 1.0, 0.98))
    plot.savefig(plot_file_path)
    plot.close()


def add_top_shap_features_to_anomalies(
    shap_anomaly_values: np.ndarray,
    feature_names: list[str],
    anomaly_detected_features: pd.DataFrame,
    anomaly_label_column: str = "anomalyLabel",
    top_n: int = 3
) -> pd.DataFrame:
    """
    Adds top-N SHAP features and their SHAP values for each anomaly in the dataset.

    Parameters:
    - shap_values_array: SHAP values array with shape (n_samples, n_features).
    - feature_names: List of names corresponding to the features.
    - anomaly_detected_features: Original DataFrame containing anomaly labels.
    - anomaly_label_column: Name of the column indicating anomalies (1 = anomaly).
    - top_n: Number of top influential features to extract.

    Returns:
    - DataFrame with additional columns:
      anomalyTopFeature_1, ..., topFeature_N
      anomalyTopFeatureSHAPValue_, ..., topFeatureSHAPValue_N
    """
    # Convert SHAP values to DataFrame for easier processing
    shap_dataframe = pd.DataFrame(shap_anomaly_values, columns=feature_names)

    # Get indices of rows marked as anomalies
    anomaly_indices = anomaly_detected_features[anomaly_detected_features[anomaly_label_column] == 1].index

    # Initialize result columns
    for rank in range(1, top_n + 1):
        anomaly_detected_features[f"anomalyTopFeature_{rank}"] = ""
        anomaly_detected_features[f"anomalyTopFeatureSHAPValue_{rank}"] = 0.0

    # Loop over each anomaly and assign top features + SHAP values
    for index in anomaly_indices:
        row_values = shap_dataframe.loc[index]
        top_features = row_values.abs().sort_values(ascending=False).head(top_n)
        for rank, (feature_name, shap_value) in enumerate(row_values[top_features.index].items(), 1):
            anomaly_detected_features.at[index, f"anomalyTopFeature_{rank}"] = feature_name
            anomaly_detected_features.at[index, f"anomalyTopFeatureSHAPValue_{rank}"] = shap_value

    return anomaly_detected_features


def add_node_embedding_shap_sum(
    shap_anomaly_values: np.ndarray,
    feature_names: list[str],
    anomaly_detected_features: pd.DataFrame,
    anomaly_label_column: str = "anomalyLabel",
    output_column_name: str = "anomalyNodeEmbeddingSHAPSum"
) -> pd.DataFrame:
    """
    Adds a column with the sum of SHAP values for all features that start with 'nodeEmbedding'.
    The sum is signed, so that negative values contributing to an anomaly are reduced by positive numbers indicating "normal" tendencies.

    Parameters:
    - shap_anomaly_values: SHAP values array with shape (n_samples, n_features).
    - feature_names: List of names corresponding to the features.
    - anomaly_detected_features: Original DataFrame containing anomaly labels.
    - anomaly_label_column: Name of the column indicating anomalies (1 = anomaly).
    - output_column_name: Name of the new column to store the SHAP sum.

    Returns:
    - DataFrame with an additional column containing the summed SHAP values for nodeEmbedding features.
    """
    # Convert SHAP values into a DataFrame for easier manipulation
    shap_values_dataframe = pd.DataFrame(shap_anomaly_values, columns=feature_names)

    # Identify all features whose names start with "nodeEmbedding"
    node_embedding_features = [name for name in feature_names if name.startswith("nodeEmbedding")]

    # Default initialize new column
    anomaly_detected_features[output_column_name] = 0.0

    # Get indices of rows marked as anomalies
    anomaly_indices = anomaly_detected_features[anomaly_detected_features[anomaly_label_column] == 1].index

    # Compute raw signed sum of SHAP values for each anomaly row
    for row_index in anomaly_indices:
        row_shap_values = shap_values_dataframe.loc[row_index, node_embedding_features]
        shap_sum = row_shap_values.sum()  # signed sum
        anomaly_detected_features.at[row_index, output_column_name] = shap_sum

    return anomaly_detected_features


def output_top_shap_explained_global_features_as_markdown_table(
    shap_anomaly_values: np.ndarray,
    feature_names: list[str],
    output_file_path: str,
    top_n_features: int = 10
):
    # Compute mean absolute shap value across all samples for each feature (importance ranking)
    mean_absolute_shap_values = np.abs(shap_anomaly_values).mean(axis=0)

    # Create DataFrame with feature names and mean shap values
    feature_importance = pd.DataFrame({
        "Feature": feature_names,
        "Mean absolute SHAP value": mean_absolute_shap_values
    })

    # Aggregate all nodeEmbedding* features
    mask = feature_importance["Feature"].str.startswith("nodeEmbedding")
    node_embedding_sum = feature_importance.loc[mask, "Mean absolute SHAP value"].sum()

    # Append aggregated feature
    feature_importance = pd.concat([
        feature_importance,
        pd.DataFrame([{
            "Feature": "*Node embeddings aggregated*",
            "Mean absolute SHAP value": node_embedding_sum
        }])
    ])

    # Sort by importance
    top_features = feature_importance.sort_values("Mean absolute SHAP value", ascending=False).head(top_n_features + 1)

    # Build markdown table manually using column names
    headers = list(top_features.columns)
    rows = top_features.values.tolist()

    markdown_header_row =  "| " + " | ".join(headers) + " |\n"
    markdown_table = markdown_header_row

    markdown_header_separator_row = "| " + " | ".join(["---"] * len(headers)) + " |\n"
    markdown_table += markdown_header_separator_row

    for row in rows:
        markdown_data_row = "| " + " | ".join([str(row[0]), f"{row[1]:.6f}"]) + " |\n"
        markdown_table += markdown_data_row

    # Save to file
    with open(output_file_path, "w") as f:
        f.write(markdown_table)

    print(f"tunedAnomalyDetectionExplained: Markdown table with top {top_n_features} SHAP explained features saved to {output_file_path}")


# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------

features_for_visualization_to_exclude_from_training: typing.List[str] = [
    'codeUnitName',
    'shortCodeUnitName',
    'projectName',
    'nodeElementId',
    'clusterLabel',
    'clusterSize',
    'clusterMedoid',
    'clusterNoise',  # highly correlated with "clusterApproximateOutlierScore". doesn't improve F1 score of proxy model.
    'embeddingVisualizationX',
    'embeddingVisualizationY',
]

parameters = parse_input_parameters()
title_prefix = parameters.get_title_prefix()
driver = get_graph_database_driver()
features = query_data(parameters)

if parameters.is_verbose():
    print("tunedAnomalyDetectionExplained: Features for anomaly detection of {title_prefix} (first 5 rows):", features.head(5))

validate_data(features)

if features.empty:
    print(f"tunedAnomalyDetectionExplained: Warning: No data. Skipping Anomaly Detection for {title_prefix}.")
    sys.exit(0)

features_to_standardize = features.columns.drop(features_for_visualization_to_exclude_from_training + ['embedding']).to_list()
features_to_standardize = remove_constant_features(features, features_to_standardize, is_verbose=parameters.is_verbose())
features_standardized = standardize_features(features, features_to_standardize)
node_embeddings_reduced = reduce_dimensionality_of_node_embeddings(features)
features_prepared = np.hstack([features_standardized, node_embeddings_reduced])
feature_names = list(features_to_standardize) + [f'nodeEmbeddingPCA_{i}' for i in range(node_embeddings_reduced.shape[1])]

anomaly_detection_results = tune_anomaly_detection_models(features_prepared, parameters)
if anomaly_detection_results.is_empty():
    sys.exit(0)

features = add_anomaly_detection_results_to_features(features, anomaly_detection_results)

if parameters.is_verbose():
    print("tunedAnomalyDetectionExplained: Top 10 anomalies:")
    print(get_top_10_anomalies(features).reset_index(drop=True))
    print("tunedAnomalyDetectionExplained: Top 10 non-anomalies:")
    print(get_top_10_non_anomalies(features).reset_index(drop=True))

plot_anomalies(
    features_to_visualize=features,
    title_prefix=parameters.get_title_prefix(),
    plot_file_path=get_file_path("Anomalies", parameters)
)

features = prepare_features_for_2d_visualization(
    features_prepared,
    features
)

plot_features_with_anomalies(
    features_to_visualize=features,
    title_prefix=parameters.get_title_prefix(),
    plot_file_path=get_file_path("AnomalyDetectionFeatures", parameters),
)

if parameters.is_verbose():
    feature_importances = pd.Series(anomaly_detection_results.feature_importances, index=feature_names).sort_values(ascending=False)
    print("tunedAnomalyDetectionExplained: Most influential features for anomaly detection according to the proxy model directly without SHAP (top 10):")
    print(feature_importances.head(10))

explanation_results = explain_anomalies_with_shap(
    random_forest_model=anomaly_detection_results.random_forest_classifier,
    prepared_features=features_prepared,
    parameters=parameters
)

plot_shap_explained_beeswarm(
    shap_anomaly_values=explanation_results.shap_anomaly_values,
    prepared_features=features_prepared,
    feature_names=feature_names,
    title_prefix=title_prefix,
    plot_file_path=get_file_path("Anomaly_feature_importance_explained", parameters)
)

plot_all_shap_explained_local_feature_importance(
    data=get_top_10_anomalies(features),
    explanation_results=explanation_results,
    prepared_features=features_prepared,
    feature_names=feature_names,
    parameters=parameters,
    title_prefix=title_prefix
)

plot_shap_explained_top_10_feature_dependence(
    shap_anomaly_values=explanation_results.shap_anomaly_values,
    prepared_features=features_prepared,
    feature_names=feature_names,
    title_prefix=title_prefix,
    plot_file_path=get_file_path("Anomaly_feature_dependence_explained", parameters)
)

add_top_shap_features_to_anomalies(
    shap_anomaly_values=explanation_results.shap_anomaly_values,
    feature_names=feature_names,
    anomaly_detected_features=features
)

add_node_embedding_shap_sum(
    shap_anomaly_values=explanation_results.shap_anomaly_values,
    feature_names=feature_names,
    anomaly_detected_features=features
)

output_top_shap_explained_global_features_as_markdown_table(
    shap_anomaly_values=explanation_results.shap_anomaly_values,
    feature_names=feature_names,
    output_file_path=get_file_path("Top_anomaly_features", parameters, 'md')
)

if parameters.is_verbose():
    print("tunedAnomalyDetectionExplained: Features with added anomaly score explanation columns:")
    print(features[features["anomalyLabel"] == 1].sort_values(by='anomalyScore', ascending=False).head(10))

data_to_write = pd.DataFrame(data={
    'nodeElementId': features["nodeElementId"],
    'anomalyLabel': features['anomalyLabel'].astype(int),
    'anomalyScore': features['anomalyScore'],
    'anomalyRank': features['anomalyRank'],
    'anomalyTopFeature1': features['anomalyTopFeature_1'],
    'anomalyTopFeature2': features['anomalyTopFeature_2'],
    'anomalyTopFeature3': features['anomalyTopFeature_3'],
    'anomalyTopFeatureSHAPValue1': features['anomalyTopFeatureSHAPValue_1'],
    'anomalyTopFeatureSHAPValue2': features['anomalyTopFeatureSHAPValue_2'],
    'anomalyTopFeatureSHAPValue3': features['anomalyTopFeatureSHAPValue_3'],
    'anomalyNodeEmbeddingSHAPSum': features['anomalyNodeEmbeddingSHAPSum'],
})
write_batch_data_into_database(data_to_write, parameters.get_projection_node_label(), verbose=parameters.is_verbose())

driver.close()
