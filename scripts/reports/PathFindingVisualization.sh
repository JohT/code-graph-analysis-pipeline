#!/usr/bin/env bash

# Executes selected "Path_Finding" Cypher queries for GraphViz visualization.
# Visualizes Java Artifact, TypeScript Module and NPM Package dependencies with their longest paths.
#
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv, dot and svg files) will be written into the sub directory reports/path-finding-visualization.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, visualizeQueryResults.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
SCRIPT_NAME="PathFindingVisualization"
## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "${SCRIPT_NAME}: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "${SCRIPT_NAME}: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization
echo "${SCRIPT_NAME}: VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "${SCRIPT_NAME}: CYPHER_DIR=${CYPHER_DIR}"

PATH_FINDINGS_CYPHER_DIR="${CYPHER_DIR}/Path_Finding"
TOPOLOGICAL_SORT_CYPHER_DIR="${CYPHER_DIR}/Topological_Sort"

# Define functions to execute cypher queries from within a given file like execute_cypher and execute_cypher_queries_until_results
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="path-finding-visualization"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Java Artifacts: Longest Paths Visualization
ARTIFACT_PROJECTION="dependencies_projection=artifact-path-finding"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    # Determines topological sort max distance from source if not already done for level info in visualization.
    execute_cypher_queries_until_results "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
                                         "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}"
    
    reportName="JavaArtifactLongestPathsIsolated"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    
    reportName="JavaArtifactLongestPaths"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
fi

# TypeScript Modules: Longest Paths Visualization
MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-path-finding"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    # Determines topological sort max distance from source if not already done for level info in visualization.
    execute_cypher_queries_until_results "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
                                         "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${MODULE_PROJECTION}" "${MODULE_NODE}"
    
    reportName="TypeScriptModuleLongestPathsIsolated"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    
    reportName="TypeScriptModuleLongestPaths"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
fi

# Non Dev NPM Packages: Longest Paths Visualization
NPM_LANGUAGE="dependencies_projection_language=NPM"
NPM_PROJECTION="dependencies_projection=npm-non-dev-package-path-finding"
NPM_NODE="dependencies_projection_node=NpmNonDevPackage"
NPM_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    # Determines topological sort max distance from source if not already done for level info in visualization.
    execute_cypher_queries_until_results "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
                                         "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${NPM_PROJECTION}" "${NPM_NODE}"
    
    reportName="NpmNonDevPackageLongestPathsIsolated"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    
    reportName="NpmNonDevPackageLongestPaths"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
fi

# Dev NPM Packages: Longest Paths Visualization

NPM_DEV_LANGUAGE="dependencies_projection_language=NPM"
NPM_DEV_PROJECTION="dependencies_projection=npm-dev-package-path-finding"
NPM_DEV_NODE="dependencies_projection_node=NpmDevPackage"
NPM_DEV_WEIGHT="dependencies_projection_weight_property=weightByDependencyType" 

if createDirectedDependencyProjection "${NPM_DEV_LANGUAGE}" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"; then
    # Determines topological sort max distance from source if not already done for level info in visualization.
    execute_cypher_queries_until_results "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
                                         "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}"
    
    reportName="NpmDevPackageLongestPathsIsolated"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    
    reportName="NpmDevPackageLongestPaths"
    echo "${SCRIPT_NAME}: Creating visualization ${reportName}..."
    execute_cypher "${PATH_FINDINGS_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}" > "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${FULL_REPORT_DIRECTORY}/${reportName}.csv"
fi

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"