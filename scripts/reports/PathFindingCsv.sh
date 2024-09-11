#!/usr/bin/env bash

# Uses path finding algorithms from the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/path-finding-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "pathFindingCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "pathFindingCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "pathFindingCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="path-finding-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Run the path finding algorithm "All Pairs Shortest Path".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-path-finding"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
allPairsShortestPath() {
    local PATH_FINDING_CYPHER_DIR="${CYPHER_DIR}/Path_Finding"
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    
    # Run the algorithm using "stream" and write the results into a CSV file
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_5_All_pairs_shortest_path_distribution_per_project.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_all_pairs_shortest_paths_distribution_per_project.csv"
}

# Run the path finding algorithm "Longest Path" (for directed acyclic graphs (DAG)).
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-path-finding"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
longestPath() {
    local PATH_FINDING_CYPHER_DIR="${CYPHER_DIR}/Path_Finding"
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )

    # Run the algorithm using "stream" and write the results into a CSV file
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_distribution_per_project.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_longest_paths_distribution.csv"
}

# Run all contained path finding algorithms.
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "artifact-path-finding"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Artifact"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
runPathFindingAlgorithms() {
    time allPairsShortestPath "${@}"
    time longestPath "${@}"
}

# -- Java Artifact Path Finding ------------------------------------

ARTIFACT_PROJECTION="dependencies_projection=artifact-path-finding" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    runPathFindingAlgorithms "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi

# -- Java Package Path Finding -------------------------------------

PACKAGE_PROJECTION="dependencies_projection=package-path-finding" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runPathFindingAlgorithms "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
fi

# -- Java Type Path Finding ----------------------------------------
# Note: This is deactivated for now. It might be too granular to be valuable and require too many resources,  

#TYPE_PROJECTION="dependencies_projection=type-path-finding" 
#TYPE_NODE="dependencies_projection_node=Type" 
#TYPE_WEIGHT="dependencies_projection_weight_property=weight" 
#
#if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"; then
#    runPathFindingAlgorithms "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
#fi

# -- Java Method Path Finding --------------------------------------
# Note: This is deactivated for now. It might be too granular to be valuable and require too many resources,  

#METHOD_PROJECTION="dependencies_projection=method-path-finding" 
#METHOD_NODE="dependencies_projection_node=Method" 
#METHOD_WEIGHT="dependencies_projection_weight_property=" 

#if createDirectedJavaMethodDependencyProjection "${METHOD_PROJECTION}"; then
#    runPathFindingAlgorithms "${METHOD_PROJECTION}" "${METHOD_NODE}" "${METHOD_WEIGHT}"
#fi

# -- Typescript Modules Path Finding -------------------------------

MODULE_LANGUAGE="dependencies_projection_language=Typescript" 
MODULE_PROJECTION="dependencies_projection=typescript-module-path-finding" 
MODULE_NODE="dependencies_projection_node=Module" 
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    runPathFindingAlgorithms "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
fi

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "pathFindingCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."