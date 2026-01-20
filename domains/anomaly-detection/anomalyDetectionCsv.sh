#!/usr/bin/env bash

# Pipeline that coordinates anomaly detection using the Graph Data Science Library of Neo4j.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/anomaly-detection.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANOMALY_DETECTION_SCRIPT_DIR=${ANOMALY_DETECTION_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "anomalyDetectionCsv: ANOMALY_DETECTION_SCRIPT_DIR=${ANOMALY_DETECTION_SCRIPT_DIR}"
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/../../scripts"} # Repository directory containing the shell scripts
# Get the "cypher" query directory for gathering features.
ANOMALY_DETECTION_FEATURE_CYPHER_DIR=${ANOMALY_DETECTION_FEATURE_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/features"}
ANOMALY_DETECTION_QUERY_CYPHER_DIR=${ANOMALY_DETECTION_QUERY_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/queries"}
ANOMALY_DETECTION_LABEL_CYPHER_DIR=${ANOMALY_DETECTION_LABEL_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/labels"}

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher" and "execute_cypher_summarized"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Query or recalculate features.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
anomaly_detection_features() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    echo "anomalyDetectionCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Collecting features for ${nodeLabel} nodes..."

    # Determine the Betweenness centrality (with the directed graph projection) if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Betweenness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Betweenness-Write.cypher" "${@}"
    # Determine the local clustering coefficient if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-LocalClusteringCoefficient-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-LocalClusteringCoefficient-Write.cypher" "${@}"
    # Determine the page rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Write.cypher" "${@}"
    # Determine the article rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Write.cypher" "${@}"
    # Determine the normalized difference between Page Rank and Article Rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Write.cypher" "${@}"
    # Determine the "abstractness" (interfaces = 100%, abstract classes = 70%, classes & functions = 0%)
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_Java.cypher" "${@}"
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_JavaType.cypher" "${@}"
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_TypeScriptModules.cypher" "${@}"
    # Determines strongly connected components if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-StronglyConnectedComponents-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-StronglyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-StronglyConnectedComponents-CreateNode.cypher" "${@}"
    execute_cypher "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-StronglyConnectedComponents-CreateDependency.cypher" "${@}"
    # Determines weakly connected components if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-WeaklyConnectedComponents-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-WeaklyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-WeaklyConnectedComponents-CreateNode.cypher" "${@}"
}

# Run queries to find anomalies in the graph.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Default: "Java". Example: "Typescript"
anomaly_detection_queries() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    # Within the absolute (full) report directory for anomaly detection, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    echo "anomalyDetectionCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Executing Queries for ${nodeLabel} nodes..."
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionPotentialImbalancedRoles.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_PotentialImbalancedRoles.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionPotentialOverEngineerOrIsolated.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_PotentialOverEngineerOrIsolated.csv"
    
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionHiddenBridgeNodes.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_HiddenBridgeNodes.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionPopularBottlenecks.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_PopularBottlenecks.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionSilentCoordinators.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_SilentCoordinators.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionOverReferencesUtilities.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_OverReferencesUtilities.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionFragileStructuralBridges.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_FragileStructuralBridges.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionDependencyHungryOrchestrators.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_DependencyHungryOrchestrators.csv"
    execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionUnexpectedCentralNodes.cypher" "${@}" > "${detail_report_directory}/AnomalyDetection_UnexpectedCentralNodes.csv"
}

# Label code units with top anomalies by archetype.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_labels() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    # Within the absolute (full) report directory for anomaly detection, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    echo "anomalyDetectionCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Labelling ${language} ${nodeLabel} anomalies..."
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeRemoveLabels.cypher" "${@}"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeAuthority.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopAuthority.csv"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeBottleneck.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopBottleneck.csv"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeHub.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopHub.csv"
    # The following two label types require Python scripts to run first and are skipped here intentionally:
    # execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeBridge.cypher" "${@}"
    # execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeOutlier.cypher" "${@}"
}

# Run the anomaly detection pipeline.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_csv_reports() {
    time anomaly_detection_features "${@}"
    time anomaly_detection_queries "${@}"
    time anomaly_detection_labels "${@}"
}

# Create report directory
REPORT_NAME="anomaly-detection"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
PROJECTION_NAME="dependencies_projection"
ALGORITHM_PROJECTION="projection_name"

PROJECTION_NODE="dependencies_projection_node"
ALGORITHM_NODE="projection_node_label"

PROJECTION_WEIGHT="dependencies_projection_weight_property"
ALGORITHM_WEIGHT="projection_weight_property"

PROJECTION_LANGUAGE="dependencies_projection_language"
ALGORITHM_LANGUAGE="projection_language"

# Code independent algorithm parameters
COMMUNITY_PROPERTY="community_property=communityLeidenIdTuned"
EMBEDDING_PROPERTY="embedding_property=embeddingsFastRandomProjectionTunedForClustering"

# -- Java Artifact Node Embeddings -------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=artifact-anomaly-detection" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=artifact-anomaly-detection-directed" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"
    anomaly_detection_csv_reports "${ALGORITHM_PROJECTION}=artifact-anomaly-detection" "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
fi

# -- Java Package Node Embeddings --------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=package-anomaly-detection" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=package-anomaly-detection-directed" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"
    anomaly_detection_csv_reports "${ALGORITHM_PROJECTION}=package-anomaly-detection" "${ALGORITHM_NODE}=Package" "${ALGORITHM_WEIGHT}=weight25PercentInterfaces" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
fi

# -- Java Type Node Embeddings -----------------------------------

if createUndirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-anomaly-detection"; then
    createDirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-anomaly-detection-directed"
    anomaly_detection_csv_reports "${ALGORITHM_PROJECTION}=type-anomaly-detection" "${ALGORITHM_NODE}=Type" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
fi

# -- Typescript Module Node Embeddings ---------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-embedding" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-embedding-directed" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"
    anomaly_detection_csv_reports "${ALGORITHM_PROJECTION}=typescript-module-embedding" "${ALGORITHM_NODE}=Module" "${ALGORITHM_WEIGHT}=lowCouplingElement25PercentWeight" "${ALGORITHM_LANGUAGE}=Typescript" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
fi

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "anomalyDetectionCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."