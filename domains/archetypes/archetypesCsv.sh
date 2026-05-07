#!/usr/bin/env bash

# Pipeline that coordinates archetype classification using the Graph Data Science Library of Neo4j.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/archetypes.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/archetypes" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ARCHETYPES_SCRIPT_DIR=${ARCHETYPES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "archetypesCsv: ARCHETYPES_SCRIPT_DIR=${ARCHETYPES_SCRIPT_DIR}"
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ARCHETYPES_SCRIPT_DIR}/../../scripts"} # Repository directory containing the shell scripts
# Get the "cypher" query directory for gathering features.
ARCHETYPES_FEATURE_CYPHER_DIR=${ARCHETYPES_FEATURE_CYPHER_DIR:-"${ARCHETYPES_SCRIPT_DIR}/features"}
ARCHETYPES_QUERY_CYPHER_DIR=${ARCHETYPES_QUERY_CYPHER_DIR:-"${ARCHETYPES_SCRIPT_DIR}/queries"}
ARCHETYPES_LABEL_CYPHER_DIR=${ARCHETYPES_LABEL_CYPHER_DIR:-"${ARCHETYPES_SCRIPT_DIR}/labels"}

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher" and "execute_cypher_summarized"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Query or recalculate features.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-archetypes"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
archetype_features() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    echo "archetypesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Collecting features for ${nodeLabel} nodes..."

    # Determine the Betweenness centrality (with the directed graph projection) if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Betweenness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Betweenness-Write.cypher" "${@}"
    # Determine the local clustering coefficient if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-LocalClusteringCoefficient-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-LocalClusteringCoefficient-Write.cypher" "${@}"
    # Determine the page rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageRank-Write.cypher" "${@}"
    # Determine the article rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-ArticleRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-ArticleRank-Write.cypher" "${@}"
    # Determine the normalized difference between Page Rank and Article Rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageToArticleRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageToArticleRank-Write.cypher" "${@}"
    # Determine the "abstractness" (interfaces = 100%, abstract classes = 70%, classes & functions = 0%)
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_Java.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_JavaType.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_TypeScriptModule.cypher" "${@}"
    # Determines strongly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-CreateNode.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-CreateDependency.cypher" "${@}"
    # Determines weakly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-CreateNode.cypher" "${@}"
    # Determines topological sort max distance from source for strongly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Delete-Projection.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Projection.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Write.cypher" "${@}"
}

# Run heuristic structural queries.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Default: "Java". Example: "Typescript"
archetype_queries() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    # Within the absolute (full) report directory for archetypes, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    echo "archetypesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Executing Queries for ${nodeLabel} nodes..."
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionProjectionStatistics.cypher" "${@}" > "${detail_report_directory}/Archetypes_GraphProjectionStatistics.csv"

    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionPotentialImbalancedRoles.cypher" "${@}" > "${detail_report_directory}/Archetypes_PotentialImbalancedRoles.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionPotentialOverEngineerOrIsolated.cypher" "${@}" > "${detail_report_directory}/Archetypes_PotentialOverEngineerOrIsolated.csv"

    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionHiddenBridgeNodes.cypher" "${@}" > "${detail_report_directory}/Archetypes_HiddenBridgeNodes.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionPopularBottlenecks.cypher" "${@}" > "${detail_report_directory}/Archetypes_PopularBottlenecks.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionSilentCoordinators.cypher" "${@}" > "${detail_report_directory}/Archetypes_SilentCoordinators.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionOverReferencesUtilities.cypher" "${@}" > "${detail_report_directory}/Archetypes_OverReferencesUtilities.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionFragileStructuralBridges.cypher" "${@}" > "${detail_report_directory}/Archetypes_FragileStructuralBridges.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionDependencyHungryOrchestrators.cypher" "${@}" > "${detail_report_directory}/Archetypes_DependencyHungryOrchestrators.csv"
    execute_cypher "${ARCHETYPES_QUERY_CYPHER_DIR}/AnomalyDetectionUnexpectedCentralNodes.cypher" "${@}" > "${detail_report_directory}/Archetypes_UnexpectedCentralNodes.csv"
}

# Label code units with top archetypes.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetype_labels() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    # Within the absolute (full) report directory for archetypes, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    echo "archetypesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Labelling ${language} ${nodeLabel} archetypes..."
    execute_cypher "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeRemoveLabels.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeAuthority-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeAuthority.cypher" "${@}" > "${detail_report_directory}/ArchetypeTopAuthority.csv"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeBottleneck-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeBottleneck.cypher" "${@}" > "${detail_report_directory}/ArchetypeTopBottleneck.csv"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeHub-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeHub.cypher" "${@}" > "${detail_report_directory}/ArchetypeTopHub.csv"
}

# Run the archetypes classification pipeline.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-archetypes"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetypes_csv_reports() {
    time archetype_features "${@}"
    time archetype_queries "${@}"
    time archetype_labels "${@}"
}

# Create report directory
REPORT_NAME="archetypes"
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

# -- Java Artifact Archetypes -------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=artifact-archetypes" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=artifact-archetypes-directed" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"
    archetypes_csv_reports "${ALGORITHM_PROJECTION}=artifact-archetypes" "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Java Package Archetypes --------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=package-archetypes" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=package-archetypes-directed" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"
    archetypes_csv_reports "${ALGORITHM_PROJECTION}=package-archetypes" "${ALGORITHM_NODE}=Package" "${ALGORITHM_WEIGHT}=weight25PercentInterfaces" "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Java Type Archetypes -----------------------------------

if createUndirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-archetypes"; then
    createDirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-archetypes-directed"
    archetypes_csv_reports "${ALGORITHM_PROJECTION}=type-archetypes" "${ALGORITHM_NODE}=Type" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Typescript Module Archetypes ---------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-archetypes" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-archetypes-directed" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"
    archetypes_csv_reports "${ALGORITHM_PROJECTION}=typescript-module-archetypes" "${ALGORITHM_NODE}=Module" "${ALGORITHM_WEIGHT}=lowCouplingElement25PercentWeight" "${ALGORITHM_LANGUAGE}=Typescript"
fi

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "archetypesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
