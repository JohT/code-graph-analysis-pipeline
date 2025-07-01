#!/usr/bin/env python

# This Python script runs the Leiden community detection algorithm
# and applies hyper-parameter tuning to get a overall modularity > 0.3
# and as many clusters as possible.
# The results with the best parameters are written back into the Graph database.

# Prerequisite: Provide the password for Neo4j in the environment variable "NEO4J_INITIAL_PASSWORD".

import typing

import os
import sys
import argparse
import pprint

import pandas as pd

from neo4j import GraphDatabase, Driver

import optuna
from optuna.samplers import TPESampler
from optuna.importance import get_param_importances, MeanDecreaseImpurityImportanceEvaluator
from optuna.trial import TrialState


class Parameters:
    required_parameters_ = ["projection_name", "projection_node_label", "projection_weight_property", "community_property"]

    def __init__(self, input_parameters: typing.Dict[str, str], verbose: bool = False, write_results_into_database: bool = True):
        self.query_parameters_ = input_parameters.copy()  # copy enforces immutability
        self.verbose_ = verbose
        self.write_results_into_database_ = write_results_into_database

    def __repr__(self):
        pretty_dict = pprint.pformat(self.query_parameters_, indent=4)
        return f"Parameters: verbose={self.verbose_}, write_results_into_database={self.write_results_into_database_}, query_parameters:\n{pretty_dict}"

    @staticmethod
    def log_dependency_versions_() -> None:
        print('---------------------------------------')

        print('Python version: {}'.format(sys.version))

        from pandas import __version__ as pandas_version
        print('pandas version: {}'.format(pandas_version))

        from neo4j import __version__ as neo4j_version
        print('neo4j version: {}'.format(neo4j_version))

        from optuna import __version__ as optuna_version
        print('optuna version: {}'.format(optuna_version))

        print('---------------------------------------')

    @classmethod
    def from_input_parameters(cls, input_parameters: typing.Dict[str, str], verbose: bool = False, write_results_into_database: bool = True):
        """
        Creates a Parameters instance from a dictionary of input parameters.
        The dictionary must contain the following keys:
         - "projection_name": The name of the projection.
         - "projection_node_label": The node type of the projection.
         - "projection_weight_property": The weight property of the projection.
         - "community_property": The node property that is written back into the Graph with the result of the community detection algorithm.
        """
        missing_parameters = [parameter for parameter in cls.required_parameters_ if parameter not in input_parameters]
        if missing_parameters:
            raise ValueError("Missing parameters:", missing_parameters)
        created_parameters = cls(input_parameters, verbose, write_results_into_database)
        if created_parameters.is_verbose():
            print(created_parameters)
            cls.log_dependency_versions_()
        return created_parameters

    @classmethod
    def example(cls):
        return cls(dict(
            projection_name="java-package-tuned-community",
            projection_node_label="Package",
            projection_weight_property="weight25PercentInterfaces",
            community_property="communityLeidenIdTuned"
        ))

    def get_query_parameters(self) -> typing.Dict[str, str]:
        return self.query_parameters_.copy()  # copy enforces immutability

    def clone_with_projection_name(self, projection_name: str):
        updated_parameter = self.get_query_parameters()
        updated_parameter.update({"projection_name": projection_name})
        return Parameters(updated_parameter)

    def get_projection_name(self) -> str:
        return self.query_parameters_["projection_name"]

    def is_verbose(self) -> bool:
        return self.verbose_

    def is_write_results_into_database(self) -> bool:
        return self.write_results_into_database_


def parse_input_parameters() -> Parameters:
    # Convert list of "key=value" strings to a dictionary
    def parse_key_value_list(param_list: typing.List[str]) -> typing.Dict[str, str]:
        param_dict = {}
        for item in param_list:
            if '=' in item:
                key, value = item.split('=', 1)
                param_dict[key] = value
        return param_dict

    parser = argparse.ArgumentParser(description="Tuned Leiden Community Detection Algorithm for maximized community count and modularity > 0.3.")
    parser.add_argument('--verbose', action='store_true', help='Enable verbose mode to log all details')
    parser.add_argument('--write-results-into-database', action=argparse.BooleanOptionalAction, help='Write the results back into Neo4j (default) or just mutate the projected graph (prefix no-)')
    parser.add_argument('query_parameters', nargs='*', type=str, help='List of key=value Cypher query parameters')
    parser.set_defaults(verbose=False, write_results_into_database=True)
    args = parser.parse_args()
    return Parameters.from_input_parameters(parse_key_value_list(args.query_parameters), args.verbose, args.write_results_into_database)


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


def soft_ramp_limited_penalty(score: float, lower_threshold: float, upper_threshold: float, sharpness: int) -> float:
    if score <= lower_threshold:
        return 1.0  # No penalty
    elif score >= upper_threshold:
        return 0.0  # Full penalty
    else:
        # Normalize noise into [0, 1] range for ramp
        x = (score - lower_threshold) / (upper_threshold - lower_threshold)
        return max(0.0, 1 - x**sharpness)


class TuneableLeidenCommunityDetection: # (sklearn.BaseEstimator):
    """
    Encapsulates Leiden community detection algorithm for hyper-parameter tuning.
    """
    # Extend from sklearn BaseEstimator to use e.g. GridSearchCV for hyperparameter tuning.
    # The implementation is sklearn compatible and follows its schema (e.g. fit and score method).

    cypher_query_for_leiden_community_statistics_: typing.LiteralString = """
        CALL gds.leiden.stats(
            $projection_name + '-cleaned', {
            gamma: toFloat($leiden_gamma),
            theta: toFloat($leiden_theta),
            maxLevels: toInteger($leiden_max_levels),
            tolerance: 0.0000001,
            consecutiveIds: true,
            relationshipWeightProperty: $projection_weight_property
        })
    """
    cypher_query_to_mutate_leiden_communities_: typing.LiteralString = """
        CALL gds.leiden.mutate(
            $projection_name + '-cleaned', {
            gamma: toFloat($leiden_gamma),
            theta: toFloat($leiden_theta),
            maxLevels: toInteger($leiden_max_levels),
            tolerance: 0.0000001,
            consecutiveIds: true,
            relationshipWeightProperty: $projection_weight_property,
            mutateProperty: $community_property
        })
    """
    cypher_query_to_delete_leiden_communities_: typing.LiteralString = """
        CALL gds.graph.nodeProperties.drop(
            $projection_name + '-cleaned'
            ,$community_property
            ,{ failIfMissing: false }
        )
    """
    cypher_query_to_write_leiden_communities_: typing.LiteralString = """
        CALL gds.leiden.write(
            $projection_name + '-cleaned', {
            gamma: toFloat($leiden_gamma),
            theta: toFloat($leiden_theta),
            maxLevels: toInteger($leiden_max_levels),
            tolerance: 0.0000001,
            consecutiveIds: true,
            relationshipWeightProperty: $projection_weight_property,
            writeProperty: $community_property
        })
    """
    cypher_query_to_write_mutated_leiden_communities_: typing.LiteralString = """
        CALL gds.graph.nodeProperties.write(
            $projection_name + '-cleaned'
            ,[$community_property]
        )
    """

    def __init__(self,
                 parameters: Parameters = Parameters.example(),
                 # Tuneable algorithm parameters
                 gamma: float = 1.0,
                 theta: float = 0.001,
                 max_levels: int = 10,
                 ):
        self.parameters = parameters
        self.verbose = parameters.is_verbose()

        self.gamma = gamma
        self.theta = theta
        self.max_levels = max_levels

        self.mutation_finished_ = False

    def __to_algorithm_parameters(self) -> typing.Dict['str', 'str']:
        return {
            "leiden_gamma": str(self.gamma),
            "leiden_theta": str(self.theta),
            "leiden_max_levels": str(self.max_levels),
            **self.parameters.get_query_parameters()
        }

    def __run_algorithm(self) -> pd.DataFrame:
        algorithm_parameters = self.__to_algorithm_parameters()
        # For Debugging:
        # print("Calculating Leiden communities using Neo4j Graph Data Science with the following parameters: " + str(algorithm_parameters))
        return query_cypher_to_data_frame(self.cypher_query_for_leiden_community_statistics_, parameters=algorithm_parameters)

    def __check_fitted(self) -> None:
        """
        Checks if the model has been fitted by checking if the embeddings_ attribute exists.
        Raises a ValueError if the model has not been fitted yet.
        """
        if not hasattr(self, 'community_statistics_'):
            raise ValueError("The model has not been fitted yet. Please call the fit method before.")

    def fit(self, X=None, y=None) -> typing.Self:
        """
        Fits the model by calculating Leiden communities and their statistics.
        """
        self.community_statistics_ = self.__run_algorithm()
        return self

    def score(self, X=None, y=None) -> float:
        """
        The returned score is high for community detection results with high modularity and high community count.
        A penalty assures that a modularity lower than 0.3 (*1) will result in a score of zero ("worst").
        The community count is normalized by dividing it through the number of nodes in the projected Graph.
        To give the relative community count more weight, it is multiplied by 100. 

        (*1) Mane, Prachita; Shanbhag, Sunanda; Kamath, Tanmayee; Mackey, Patrick; and Springer, John, 
        "Analysis of Community Detection Algorithms for Large Scale Cyber Networks" (2016)
        """
        soft_ramped_modularity = 1.0 - soft_ramp_limited_penalty(self.get_modularity(), 0.30, 0.35, sharpness=1)
        score = float(self.get_community_count() * 100) / float(self.get_node_count_()) * soft_ramped_modularity
        # - For debugging purposes:
        # print(f"Score {score:.4f}= community count {self.get_community_count()} x soft_ramped {soft_ramped_modularity:.4f} modularity {self.get_modularity():.04f}")
        return score

    def mutate_communities(self) -> typing.Self:
        """
        Calculate Leiden communities and add them to (mutate) the projected in-memory Graph.
        This is useful for further processing or analysis.
        """
        algorithm_parameters = self.__to_algorithm_parameters()
        if self.verbose:
            print("")
            print("Mutate communities to the projected Graph with the following parameters: " + str(algorithm_parameters))
            print("")

        query_cypher_to_data_frame(self.cypher_query_to_delete_leiden_communities_, parameters=algorithm_parameters)
        query_cypher_to_data_frame(self.cypher_query_to_mutate_leiden_communities_, parameters=algorithm_parameters)

        self.mutation_finished_ = True
        print(f"Best Leiden Community Detection results saved in projected graph (mutate).")
        return self

    def write_communities(self) -> typing.Self:
        """
        Writes the calculated communities to the Neo4j database.
        This is useful for further processing or analysis.
        """
        algorithm_parameters = self.__to_algorithm_parameters()
        if self.verbose:
            print("")
            print("Writing communities to Neo4j with the following parameters: " + str(algorithm_parameters))
            print("")

        if self.mutation_finished_:
            query_cypher_to_data_frame(self.cypher_query_to_write_mutated_leiden_communities_, parameters=algorithm_parameters)
        else:
            query_cypher_to_data_frame(self.cypher_query_to_write_leiden_communities_, parameters=algorithm_parameters)

        print(f"Best Leiden Community Detection results written back into Neo4j.")
        return self

    def get_modularity(self) -> float:
        """
        Returns the modularity (global/overall) of the community statistics
        """
        self.__check_fitted()
        return float(self.community_statistics_['modularity'].iloc[0])

    def get_community_count(self) -> int:
        """
        Returns the number of detected communities
        """
        self.__check_fitted()
        return int(self.community_statistics_['communityCount'].iloc[0])

    def get_node_count_(self) -> int:
        """
        Returns the number of nodes in the projected Graph
        """
        self.__check_fitted()
        return int(self.community_statistics_['nodeCount'].iloc[0])


def output_detailed_optuna_tuning_results(optimized_study: optuna.Study) -> None:
    name_of_the_optimized_algorithm = 'Leiden Community Detection'

    print("")
    print(f"Best {name_of_the_optimized_algorithm} score:", optimized_study.best_value)
    print("")
    print(f"Best {name_of_the_optimized_algorithm} parameter influence:", get_param_importances(optimized_study, evaluator=MeanDecreaseImpurityImportanceEvaluator()))

    valid_trials = [trial for trial in optimized_study.trials if trial.value is not None and trial.state == TrialState.COMPLETE]
    top_trials = sorted(valid_trials, key=lambda t: typing.cast(float, t.value), reverse=True)[:10]
    for i, trial in enumerate(top_trials):
        print(f"Best {name_of_the_optimized_algorithm} parameter rank: {i+1}, trial: {trial.number}, Value = {trial.value:.6f}, Params: {trial.params}")
    print("")


def get_tuned_leiden_community_detection_algorithm(parameters: Parameters) -> TuneableLeidenCommunityDetection:
    if not parameters.is_verbose():
        optuna.logging.set_verbosity(optuna.logging.WARNING)

    def objective(trial):
        # Suggest values for each hyperparameter
        tuneable_parameters = dict(
            gamma=trial.suggest_float("gamma", low=0.7, high=1.3, step=0.01),
            theta=trial.suggest_float("theta", 0.0001, 0.01, log=True),
            # Fixed max_levels = 10 (default) since experiments showed only minor differences in the results
            # max_levels = trial.suggest_int("max_levels", 8, 12)
        )
        tuneable_leiden_community_detection = TuneableLeidenCommunityDetection(parameters, **tuneable_parameters).fit()
        return tuneable_leiden_community_detection.score()

    study_name = "LeidenCommunityDetection - " + parameters.get_projection_name()
    # For in-depth analysis of the tuning, add the following two parameters:
    # , storage=f"sqlite:///optuna_study_node_embeddings_java.db", load_if_exists=True)
    study = optuna.create_study(direction="maximize", sampler=TPESampler(seed=42), study_name=study_name)

    # Try (enqueue) specific settings first that led to good results in initial experiments
    study.enqueue_trial({'gamma': 1.0, 'theta': 0.001, 'max_levels': 10})  # default values
    study.enqueue_trial({'gamma': 1.14, 'theta': 0.001, 'max_levels': 10})

    # Execute the hyperparameter tuning
    study.optimize(objective, n_trials=20, timeout=30)

    # Output tuning results
    print(f"Best Leiden Community Detection parameters for {parameters.get_projection_name()} (Optuna):", study.best_params)
    if parameters.is_verbose():
        output_detailed_optuna_tuning_results(study)

    # Run the node embeddings algorithm again again with the best parameters
    tuned_leiden_community_detection = TuneableLeidenCommunityDetection(parameters, **study.best_params).fit()

    print("Best Leiden Community Detection Modularity: ", tuned_leiden_community_detection.get_modularity())
    print("Best Leiden Community Detection Community Count: ", tuned_leiden_community_detection.get_community_count())

    return tuned_leiden_community_detection

# ------------------------------------------------------------------------------------------------------------
#  MAIN
# ------------------------------------------------------------------------------------------------------------


parameters = parse_input_parameters()
driver = get_graph_database_driver()

tuned_leiden_community_detection = get_tuned_leiden_community_detection_algorithm(parameters)
if parameters.is_write_results_into_database():
    tuned_leiden_community_detection.write_communities()
else:
    tuned_leiden_community_detection.mutate_communities()

driver.close()