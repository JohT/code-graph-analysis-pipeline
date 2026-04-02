#!/usr/bin/env bash

# Executes internal dependency and path finding Cypher queries for GraphViz visualization.
# Visualizes Java Artifact, TypeScript Module, and NPM Package dependencies with build levels
# and longest paths.
#
# Build level graphs use the topological sort level to colour nodes (showing dependency hierarchy).
# Longest path graphs highlight the worst-case dependency chains.
#
# The reports (csv, dot and svg files) will be written into
#   reports/internal-dependencies/{abstraction_level}/Graph_Visualizations/

# Requires executeQueryFunctions.sh, projectionFunctions.sh, visualizeQueryResults.sh,
#           cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
SCRIPT_NAME="internalDependenciesGraphs"

## Get this "domains/internal-dependencies/graphs" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
INTERNAL_DEPENDENCIES_GRAPHS_DIR=${INTERNAL_DEPENDENCIES_GRAPHS_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "${SCRIPT_NAME}: INTERNAL_DEPENDENCIES_GRAPHS_DIR=${INTERNAL_DEPENDENCIES_GRAPHS_DIR}"

# Get the "scripts" directory by navigating three levels up from this graphs directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${INTERNAL_DEPENDENCIES_GRAPHS_DIR}/../../../scripts"}

# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"}

# Cypher query directories
INTERNAL_DEPS_CYPHER_DIR="${INTERNAL_DEPENDENCIES_GRAPHS_DIR}/../queries/internal-dependencies"
PATH_FINDING_CYPHER_DIR="${INTERNAL_DEPENDENCIES_GRAPHS_DIR}/../queries/path-finding"
TOPOLOGICAL_SORT_CYPHER_DIR="${INTERNAL_DEPENDENCIES_GRAPHS_DIR}/../queries/topological-sort"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Main report directory
REPORT_NAME="internal-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# ── Java Artifact Visualizations ──────────────────────────────────────────────

ARTIFACT_GRAPH_VIZ_DIR="${FULL_REPORT_DIRECTORY}/Java_Artifact/Graph_Visualizations"
mkdir -p "${ARTIFACT_GRAPH_VIZ_DIR}"

# Build levels graph (from internal dependencies build level query)
echo "${SCRIPT_NAME}: Creating visualization JavaArtifactBuildLevels..."
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/Java_Artifact_build_levels_for_graphviz.cypher" \
    > "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactBuildLevels.csv"
source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactBuildLevels.csv"

ARTIFACT_PROJECTION="dependencies_projection=artifact-path-finding"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    # Ensure topological sort level exists on nodes (required for level coloring in graph).
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}"

    echo "${SCRIPT_NAME}: Creating visualization JavaArtifactLongestPathsIsolated..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" \
        "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" \
        > "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactLongestPathsIsolated.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactLongestPathsIsolated.csv"

    echo "${SCRIPT_NAME}: Creating visualization JavaArtifactLongestPaths..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" \
        "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" \
        > "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactLongestPaths.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${ARTIFACT_GRAPH_VIZ_DIR}/JavaArtifactLongestPaths.csv"
fi

# Clean-up Java Artifact graph visualizations
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${ARTIFACT_GRAPH_VIZ_DIR}"

# ── TypeScript Module Visualizations ──────────────────────────────────────────

MODULE_GRAPH_VIZ_DIR="${FULL_REPORT_DIRECTORY}/Typescript_Module/Graph_Visualizations"
mkdir -p "${MODULE_GRAPH_VIZ_DIR}"

# Build levels graph (from internal dependencies build level query)
echo "${SCRIPT_NAME}: Creating visualization TypeScriptModuleBuildLevels..."
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/Typescript_Module_build_levels_for_graphviz.cypher" \
    > "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleBuildLevels.csv"
source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleBuildLevels.csv"

MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-path-finding"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    # Ensure topological sort level exists on nodes.
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${MODULE_PROJECTION}" "${MODULE_NODE}"

    echo "${SCRIPT_NAME}: Creating visualization TypeScriptModuleLongestPathsIsolated..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" \
        "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" \
        > "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleLongestPathsIsolated.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleLongestPathsIsolated.csv"

    echo "${SCRIPT_NAME}: Creating visualization TypeScriptModuleLongestPaths..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" \
        "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" \
        > "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleLongestPaths.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${MODULE_GRAPH_VIZ_DIR}/TypeScriptModuleLongestPaths.csv"
fi

# Clean-up TypeScript Module graph visualizations
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${MODULE_GRAPH_VIZ_DIR}"

# ── NPM Non-Dev Package Visualizations ────────────────────────────────────────

NPM_GRAPH_VIZ_DIR="${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage/Graph_Visualizations"
mkdir -p "${NPM_GRAPH_VIZ_DIR}"

# Build levels graph (from internal dependencies build level query)
echo "${SCRIPT_NAME}: Creating visualization NpmPackageBuildLevels..."
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/NPM_Package_build_levels_for_graphviz.cypher" \
    > "${NPM_GRAPH_VIZ_DIR}/NpmPackageBuildLevels.csv"
source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${NPM_GRAPH_VIZ_DIR}/NpmPackageBuildLevels.csv"

NPM_LANGUAGE="dependencies_projection_language=NPM"
NPM_PROJECTION="dependencies_projection=npm-non-dev-package-path-finding"
NPM_NODE="dependencies_projection_node=NpmNonDevPackage"
NPM_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    # Ensure topological sort level exists on nodes.
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${NPM_PROJECTION}" "${NPM_NODE}"

    echo "${SCRIPT_NAME}: Creating visualization NpmNonDevPackageLongestPathsIsolated..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" \
        "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}" \
        > "${NPM_GRAPH_VIZ_DIR}/NpmNonDevPackageLongestPathsIsolated.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${NPM_GRAPH_VIZ_DIR}/NpmNonDevPackageLongestPathsIsolated.csv"

    echo "${SCRIPT_NAME}: Creating visualization NpmNonDevPackageLongestPaths..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" \
        "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}" \
        > "${NPM_GRAPH_VIZ_DIR}/NpmNonDevPackageLongestPaths.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${NPM_GRAPH_VIZ_DIR}/NpmNonDevPackageLongestPaths.csv"
fi

# Clean-up NPM Non-Dev Package graph visualizations
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${NPM_GRAPH_VIZ_DIR}"

# ── NPM Dev Package Visualizations ────────────────────────────────────────────

NPM_DEV_GRAPH_VIZ_DIR="${FULL_REPORT_DIRECTORY}/NPM_DevPackage/Graph_Visualizations"
mkdir -p "${NPM_DEV_GRAPH_VIZ_DIR}"

NPM_DEV_PROJECTION="dependencies_projection=npm-dev-package-path-finding"
NPM_DEV_NODE="dependencies_projection_node=NpmDevPackage"
NPM_DEV_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"; then
    # Ensure topological sort level exists on nodes.
    execute_cypher_queries_until_results \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Exists.cypher" \
        "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}"

    echo "${SCRIPT_NAME}: Creating visualization NpmDevPackageLongestPathsIsolated..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_for_graphviz.cypher" \
        "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}" \
        > "${NPM_DEV_GRAPH_VIZ_DIR}/NpmDevPackageLongestPathsIsolated.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${NPM_DEV_GRAPH_VIZ_DIR}/NpmDevPackageLongestPathsIsolated.csv"

    echo "${SCRIPT_NAME}: Creating visualization NpmDevPackageLongestPaths..."
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher" \
        "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}" \
        > "${NPM_DEV_GRAPH_VIZ_DIR}/NpmDevPackageLongestPaths.csv"
    source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${NPM_DEV_GRAPH_VIZ_DIR}/NpmDevPackageLongestPaths.csv"
fi

# Clean-up NPM Dev Package graph visualizations
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${NPM_DEV_GRAPH_VIZ_DIR}"

# Clean-up empty level directories.
# These may have been recreated by mkdir -p above even if there was no data,
# in which case cleanupAfterReportGeneration.sh deletes them since they are empty.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Artifact"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Typescript_Module"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/NPM_DevPackage"

echo "${SCRIPT_NAME}: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
