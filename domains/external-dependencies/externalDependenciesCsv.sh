#!/usr/bin/env bash

# Executes Cypher queries to generate external dependency CSV reports.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/external-dependencies.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Specifically, type labels (ExternalType, ExternalAnnotation) and weight properties on DEPENDS_ON
# relationships must already exist. See README.md for the full prerequisites list.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/external-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
EXTERNAL_DEPENDENCIES_SCRIPT_DIR=${EXTERNAL_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "externalDependenciesCsv: EXTERNAL_DEPENDENCIES_SCRIPT_DIR=${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Cypher query directory within this domain
EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR=${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR:-"${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries"}

# Define functions to execute a cypher query from within a given file like "execute_cypher" and "execute_cypher_queries_until_results"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="external-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "externalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting external dependencies CSV reports..."

# Ensure ExternalType and ExternalAnnotation labels exist on Java types.
# If they already exist, the labelling query is skipped.
execute_cypher_queries_until_results \
    "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/List_external_Java_types_used.cypher" \
    "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Label_external_types_and_annotations.cypher" > /dev/null

# -- Java Package Reports --------------------------------------------------

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_overall.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_overall.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_spread.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_spread.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_second_level_package_usage_overall.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_overall.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_second_level_package_usage_spread.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_spread.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_type.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_type.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_sorted.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_sorted.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_sorted_top.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_sorted_top.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_distribution.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_distribution.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_package_aggregated.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_package_aggregated.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_and_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_package.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_and_external_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_external_package.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_second_level_package_usage_per_artifact_and_external_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_per_artifact_and_external_package.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_internal_package_count.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_internal_package_count.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_and_package_with_annotations.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_package_with_annotations.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_type_distribution_with_annotations.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_type_distribution_with_annotations.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_levels.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_levels.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_name_elements.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_package_name_elements.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_types_per_artifact_using_requires.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_types_per_artifact_using_requires.csv"

# -- Maven POM Reports -----------------------------------------------------

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Maven_POMs_and_their_declared_dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Maven_POM_dependencies.csv"

# -- TypeScript Module Reports ---------------------------------------------

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_overall_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_module_usage_overall_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_spread_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_module_usage_spread_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_namespace_usage_overall_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_overall_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_namespace_usage_spread_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_spread_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_per_internal_module_sorted_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_sorted_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_namespace_usage_per_internal_module_sorted_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_per_internal_module_sorted_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_per_internal_module_aggregated_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_aggregated_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_per_internal_module_distribution_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_distribution_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/List_external_modules_resolved_to_internal_ones_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/External_modules_resolved_to_internal_ones_for_Typescript.csv"

# -- Package Management Reports --------------------------------------------

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Package_json_dependencies_occurrence.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_occurrence.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Package_json_dependencies_by_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_by_package.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Package_json_dependencies_combinations.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_combinations.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Package_json_dependencies_combinations_with_versions.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_combinations_with_versions.csv"

# --------------------------------------------------------------------------

# Clean up: delete empty CSV files that were generated when no data was available
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "externalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
