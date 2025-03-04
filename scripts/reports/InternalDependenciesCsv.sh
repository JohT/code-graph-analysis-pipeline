#!/usr/bin/env bash

# Executes "Internal_Dependencies" Cypher queries to get the "internal-dependencies-csv" CSV reports.
# It contains lists of e.g. incoming and outgoing package dependencies,
# abstractness, instability and the distance to the so called "main sequence".

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
echo "InternalDependenciesCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "InternalDependenciesCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "InternalDependenciesCsv: CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="internal-dependencies-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
CYCLIC_DEPENDENCIES_CYPHER_DIR="${CYPHER_DIR}/Cyclic_Dependencies"
INTERNAL_DEPENDENCIES_CYPHER_DIR="${CYPHER_DIR}/Internal_Dependencies"

# Calculate the fewest number of change directory commands needed between dependent files as a distance metric
echo "InternalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Calculating distance between dependent files..."
execute_cypher_queries_until_results "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/Get_file_distance_as_shortest_contains_path_for_dependencies.cypher" \
                                     "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/Set_file_distance_as_shortest_contains_path_for_dependencies.cypher" \
                                     > "${FULL_REPORT_DIRECTORY}/Distance_distribution_between_dependent_files.csv"

# Internal Dependencies for Java
echo "InternalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing internal dependencies for Java..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies_Breakdown.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies_Breakdown_Backward_Only.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher" > "${FULL_REPORT_DIRECTORY}/CyclicArtifactDependenciesUnwinded.csv"

execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/Candidates_for_Interface_Segregation.cypher" > "${FULL_REPORT_DIRECTORY}/InterfaceSegregationCandidates.csv"

execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/List_all_Java_artifacts.cypher" > "${FULL_REPORT_DIRECTORY}/List_all_Java_artifacts.csv"
execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/List_types_that_are_used_by_many_different_packages.cypher" > "${FULL_REPORT_DIRECTORY}/WidelyUsedTypes.csv"
execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher" > "${FULL_REPORT_DIRECTORY}/ArtifactPackageUsage.csv"
execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher" > "${FULL_REPORT_DIRECTORY}/ClassesPerPackageUsageAcrossArtifacts.csv"

# Internal Dependencies for TypeScript
echo "InternalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing internal dependencies for TypeScript..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies_Breakdown_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv"

execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/List_all_Typescript_modules.cypher" > "${FULL_REPORT_DIRECTORY}/List_all_Typescript_modules.csv"
execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/WidelyUsedTypescriptElements.csv"
execute_cypher "${INTERNAL_DEPENDENCIES_CYPHER_DIR}/How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/ModuleElementsUsageTypescript.csv"

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "InternalDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."