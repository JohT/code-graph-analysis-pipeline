#!/usr/bin/env bash

# Pipeline that coordinates internal dependency analysis using Cypher queries and the
# Graph Data Science Library of Neo4j. It covers internal dependencies, cyclic dependencies,
# path finding, and topological sort across multiple abstraction levels.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/internal-dependencies.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/internal-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
INTERNAL_DEPENDENCIES_SCRIPT_DIR=${INTERNAL_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "internalDependenciesCsv: INTERNAL_DEPENDENCIES_SCRIPT_DIR=${INTERNAL_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Cypher query directories within this domain
INTERNAL_DEPS_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/internal-dependencies"
CYCLIC_DEPS_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/cyclic-dependencies"
PATH_FINDING_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/path-finding"
TOPOLOGICAL_SORT_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/topological-sort"
OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/object-oriented-design-metrics"
VISIBILITY_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries/visibility"

# Define functions to execute a cypher query from within a given file like "execute_cypher" and "execute_cypher_queries_until_results"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create main report directory and abstraction-level subdirectories
REPORT_NAME="internal-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Artifact"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Package"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Type"
mkdir -p "${FULL_REPORT_DIRECTORY}/Typescript_Module"
mkdir -p "${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage"
mkdir -p "${FULL_REPORT_DIRECTORY}/NPM_DevPackage"

# ── Internal Dependencies ─────────────────────────────────────────────────────

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Calculating distance between dependent files..."
execute_cypher_queries_until_results \
    "${INTERNAL_DEPS_CYPHER_DIR}/Get_file_distance_as_shortest_contains_path_for_dependencies.cypher" \
    "${INTERNAL_DEPS_CYPHER_DIR}/Set_file_distance_as_shortest_contains_path_for_dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Distance_distribution_between_dependent_files.csv"

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing internal dependencies for Java..."

execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown_Backward_Only.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/CyclicArtifactDependenciesUnwinded.csv"

execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/Candidates_for_Interface_Segregation.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/InterfaceSegregationCandidates.csv"

execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/List_all_Java_artifacts.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/List_all_Java_artifacts.csv"
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/List_types_that_are_used_by_many_different_packages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/WidelyUsedTypes.csv"
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/ArtifactPackageUsage.csv"
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/ClassesPerPackageUsageAcrossArtifacts.csv"

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing internal dependencies for TypeScript..."

execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv"

execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/List_all_Typescript_modules.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/List_all_Typescript_modules.csv"
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/WidelyUsedTypescriptElements.csv"
execute_cypher "${INTERNAL_DEPS_CYPHER_DIR}/How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/ModuleElementsUsageTypescript.csv"

# ── Path Finding ──────────────────────────────────────────────────────────────

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting path finding..."

# Run the path finding algorithm "All Pairs Shortest Path" for a single node label.
#
# Required Parameters:
# - dependencies_projection=...   Name prefix for the in-memory projection. Example: "artifact-path-finding"
# - dependencies_projection_node=...   Node label. Example: "Artifact"
# - dependencies_projection_weight_property=...   Weight property name. Example: "weight"
allPairsShortestPath() {
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_5_All_pairs_shortest_path_distribution_per_project.cypher" "${@}" \
        > "${CURRENT_LEVEL_DIR}/${nodeLabel}_all_pairs_shortest_paths_distribution_per_project.csv"
}

# Run the path finding algorithm "Longest Path" (for directed acyclic graphs).
#
# Required Parameters:
# - dependencies_projection=...   Name prefix for the in-memory projection. Example: "artifact-path-finding"
# - dependencies_projection_node=...   Node label. Example: "Artifact"
# - dependencies_projection_weight_property=...   Weight property name. Example: "weight"
longestPath() {
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_distribution_per_project.cypher" "${@}" \
        > "${CURRENT_LEVEL_DIR}/${nodeLabel}_longest_paths_distribution.csv"
}

# Run all path finding algorithms for the current abstraction level.
runPathFindingAlgorithms() {
    time allPairsShortestPath "${@}"
    time longestPath "${@}"
}

# -- Java Artifact Path Finding --------------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Artifact"
ARTIFACT_PROJECTION="dependencies_projection=artifact-path-finding"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    runPathFindingAlgorithms "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi

# -- Java Package Path Finding ---------------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Package"
PACKAGE_PROJECTION="dependencies_projection=package-path-finding"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runPathFindingAlgorithms "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
fi

# -- Java Type Path Finding (deactivated — too granular, too resource-intensive) --------
#TYPE_PROJECTION="dependencies_projection=type-path-finding"
#TYPE_NODE="dependencies_projection_node=Type"
#TYPE_WEIGHT="dependencies_projection_weight_property=weight"
#if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"; then
#    CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Type"
#    runPathFindingAlgorithms "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
#fi

# -- TypeScript Module Path Finding ----------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Typescript_Module"
MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-path-finding"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    runPathFindingAlgorithms "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
fi

# -- Non-Dev NPM Package Path Finding --------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage"
NPM_LANGUAGE="dependencies_projection_language=NPM"
NPM_PROJECTION="dependencies_projection=npm-non-dev-package-path-finding"
NPM_NODE="dependencies_projection_node=NpmNonDevPackage"
NPM_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    runPathFindingAlgorithms "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"
fi

# -- Dev NPM Package Path Finding ------------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/NPM_DevPackage"
NPM_DEV_PROJECTION="dependencies_projection=npm-dev-package-path-finding"
NPM_DEV_NODE="dependencies_projection_node=NpmDevPackage"
NPM_DEV_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"; then
    runPathFindingAlgorithms "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"
fi

# ── Topological Sort ──────────────────────────────────────────────────────────

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting topological sort..."

# Apply the algorithm "Topological Sort" and write results to the current level directory.
#
# Required Parameters:
# - dependencies_projection=...   Name prefix for the in-memory projection. Example: "package-topology"
# - dependencies_projection_node=...   Node label. Example: "Package"
# - dependencies_projection_weight_property=...   Weight property name. Example: "weight"
topologicalSort() {
    local nodeLabel; nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )

    # Write topological sort level as a node property (required for graph visualizations)
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Write.cypher" "${@}"

    # Stream to CSV
    execute_cypher "${TOPOLOGICAL_SORT_CYPHER_DIR}/Topological_Sort_Query.cypher" "${@}" \
        > "${CURRENT_LEVEL_DIR}/${nodeLabel}_Topological_Sort.csv"
}

# -- Java Artifact Topological Sort ----------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Artifact"
ARTIFACT_PROJECTION="dependencies_projection=artifact-topology"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    time topologicalSort "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi

# -- Java Package Topological Sort -----------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Package"
PACKAGE_PROJECTION="dependencies_projection=package-topology"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    time topologicalSort "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
fi

# -- Java Type Topological Sort --------------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Java_Type"
TYPE_PROJECTION="dependencies_projection=type-topology"
TYPE_NODE="dependencies_projection_node=Type"
TYPE_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"; then
    time topologicalSort "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
fi

# -- TypeScript Module Topological Sort ------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/Typescript_Module"
MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-topology"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    time topologicalSort "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
fi

# -- Non-Dev NPM Package Topological Sort ----------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage"
NPM_LANGUAGE="dependencies_projection_language=NPM"
NPM_PROJECTION="dependencies_projection=npm-non-dev-package-topology"
NPM_NODE="dependencies_projection_node=NpmNonDevPackage"
NPM_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    time topologicalSort "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"
fi

# -- Dev NPM Package Topological Sort --------------------------------------

CURRENT_LEVEL_DIR="${FULL_REPORT_DIRECTORY}/NPM_DevPackage"
NPM_DEV_PROJECTION="dependencies_projection=npm-dev-package-topology"
NPM_DEV_NODE="dependencies_projection_node=NpmDevPackage"
NPM_DEV_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"; then
    time topologicalSort "${NPM_DEV_PROJECTION}" "${NPM_DEV_NODE}" "${NPM_DEV_WEIGHT}"
fi

# ── Object-Oriented Design Metrics ───────────────────────────────────────────────────────

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing Object-Oriented design metrics..."

# Prerequisite: count and set abstract type flags before running abstractness queries.
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Count_and_set_abstract_types.cypher"

# -- Java Packages without sub-packages --------------------------------------

execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Incoming_Java_Package_Dependencies.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Incoming_Java_Package_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/IncomingPackageDependenciesJava.csv"
execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Outgoing_Java_Package_Dependencies.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Outgoing_Java_Package_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/OutgoingPackageDependenciesJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Java.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/InstabilityJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Java.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/AbstractnessJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Java.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/MainSequenceAbstractnessInstabilityDistanceJava.csv"

# -- Java Packages including sub-packages ------------------------------------

execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Incoming_Java_Package_Dependencies_Including_Subpackages.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Incoming_Java_Package_Dependencies_Including_Subpackages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/IncomingPackageDependenciesIncludingSubpackagesJava.csv"
execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Outgoing_Java_Package_Dependencies_Including_Subpackages.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Outgoing_Java_Package_Dependencies_Including_Subpackages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/OutgoingPackageDependenciesIncludingSubpackagesJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Java_Including_Subpackages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/InstabilityIncludingSubpackagesJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Java_including_Subpackages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/AbstractnessIncludingSubpackagesJava.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Java_including_subpackages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/MainSequenceAbstractnessInstabilityDistanceIncludingSubpackagesJava.csv"

# -- TypeScript Modules -------------------------------------------------------

execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Incoming_Typescript_Module_Dependencies.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Incoming_Typescript_Module_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/IncomingPackageDependenciesTypescript.csv"
execute_cypher_queries_until_results \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Get_Outgoing_Typescript_Module_Dependencies.cypher" \
    "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Set_Outgoing_Typescript_Module_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/OutgoingPackageDependenciesTypescript.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Instability_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/InstabilityTypescript.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_and_set_Abstractness_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/AbstractnessTypescript.csv"
execute_cypher "${OBJECT_ORIENTED_DESIGN_METRICS_CYPHER_DIR}/Calculate_distance_between_abstractness_and_instability_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/MainSequenceAbstractnessInstabilityDistanceTypescript.csv"

# ── Visibility Metrics ────────────────────────────────────────────────────────

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing visibility metrics..."

# Java
execute_cypher "${VISIBILITY_CYPHER_DIR}/Global_relative_visibility_statistics_for_types.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/RelativeVisibilityPerArtifact.csv"
execute_cypher "${VISIBILITY_CYPHER_DIR}/Relative_visibility_public_types_to_all_types_per_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/RelativeVisibilityPerPackage.csv"

# TypeScript
execute_cypher "${VISIBILITY_CYPHER_DIR}/Global_relative_visibility_statistics_for_elements_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/RelativeVisibilityPerTypescriptProject.csv"
execute_cypher "${VISIBILITY_CYPHER_DIR}/Relative_visibility_exported_elements_to_all_elements_per_module_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/RelativeVisibilityPerTypescriptModule.csv"

# ── Final clean-up ────────────────────────────────────────────────────────────

source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Artifact"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Package"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Type"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Typescript_Module"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/NPM_NonDevPackage"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/NPM_DevPackage"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "internalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
