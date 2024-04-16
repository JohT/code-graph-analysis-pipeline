#!/usr/bin/env bash

# Executes "Artifact_Dependencies" Cypher queries to get the "artifact-dependencies-csv" CSV reports.
# It contains lists of dependencies across artifacts and hby ow many packages/types they are used by.

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
echo "ArtifactDependenciesCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "ArtifactDependenciesCsv SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "ArtifactDependenciesCsv CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="artifact-dependencies-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
ARTIFACT_DEPENDENCIES_CYPHER_DIR="${CYPHER_DIR}/Artifact_Dependencies"

# Preparation: Set number of packages and types per artifact
execute_cypher_expect_results "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Set_number_of_packages_and_types_on_artifacts.cypher"

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Most_used_internal_dependencies_acreoss_artifacts.cypher" > "${FULL_REPORT_DIRECTORY}/MostUsedDependenciesAcrossArtifacts.csv"
execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_dependencies_to_other_artifacts.cypher" > "${FULL_REPORT_DIRECTORY}/DependenciesAcrossArtifacts.csv"
execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_duplicate_packages.cypher" > "${FULL_REPORT_DIRECTORY}/DuplicatePackageNamesAcrossArtifacts.csv"

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/InternalArtifactUsageSpreadPerDependency.csv"
execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependents.cypher" > "${FULL_REPORT_DIRECTORY}/InternalArtifactUsageSpreadPerDependent.csv"

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"