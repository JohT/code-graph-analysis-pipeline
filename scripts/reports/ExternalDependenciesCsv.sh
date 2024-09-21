#!/usr/bin/env bash

# Executes "External_Dependencies" Cypher queries to get the "external-dependencies-csv" CSV reports.
# They list external library package usage like how often a external package is called.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "ExternalDependenciesCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "ExternalDependenciesCsv SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "ExternalDependenciesCsv CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="external-dependencies-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
EXTERNAL_DEPENDENCIES_CYPHER_DIR="${CYPHER_DIR}/External_Dependencies"

# Check if there are already labels for external Java types and create them otherwise
execute_cypher_queries_until_results "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/List_external_Java_types_used.cypher" \
                                     "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Label_external_types_and_annotations.cypher" >/dev/null

# CSV reports for Java Packages

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_overall.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_overall.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_spread.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_spread.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_second_level_package_usage_overall.cypher" > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_overall.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_second_level_package_usage_spread.cypher" > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_spread.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_type.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_type.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_sorted_top.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_sorted_top.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_distribution.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_distribution.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_package_aggregated.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_package_aggregated.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_and_package.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_package.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_and_external_package.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_external_package.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_second_level_package_usage_per_artifact_and_external_package.cypher" > "${FULL_REPORT_DIRECTORY}/External_second_level_package_usage_per_artifact_and_external_package.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Maven_POMs_and_their_declared_dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/Maven_POM_dependencies.csv"

# CSV reports for Typescript Modules

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_module_usage_overall_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_module_usage_overall_for_Typescript.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_module_usage_spread_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_module_usage_spread_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_namespace_usage_overall_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_overall_for_Typescript.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_namespace_usage_spread_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_spread_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_module_usage_per_internal_module_sorted_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_sorted_for_Typescript.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_namespace_usage_per_internal_module_sorted_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_namespace_usage_per_internal_module_sorted_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_module_usage_per_internal_module_aggregated_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_aggregated_for_Typescript.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_module_usage_per_internal_module_distribution_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_module_usage_per_internal_module_distribution_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/List_external_modules_resolved_to_internal_ones_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/External_modules_resolved_to_internal_ones_for_Typescript.csv"

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Package_json_dependencies_occurrence.cypher" > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_occurrence.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Package_json_dependencies_combinations.cypher" > "${FULL_REPORT_DIRECTORY}/Package_json_dependencies_combinations.csv"

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"