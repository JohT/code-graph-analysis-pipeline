#!/usr/bin/env bash

# Executes "Package_Usage" Cypher queries to get the "external-dependencies-csv" CSV reports.
# They list external library package usage like how often a external package is called.

# Requires executeQueryFunctions.sh

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

if ! execute_cypher_expect_results "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/List_external_types_used.cypher"; then
    echo "Please execute 'prepareAnalysis.sh' with 'Label_external_types_and_annotations.cypher' first."
    exit 1
fi

execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_overall.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_overall.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_type.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_type.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_type_distribution.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_type_distribution.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/External_package_usage_per_artifact_and_package.cypher" > "${FULL_REPORT_DIRECTORY}/External_package_usage_per_artifact_and_package.csv"
execute_cypher "${EXTERNAL_DEPENDENCIES_CYPHER_DIR}/Maven_POMs_and_their_declared_dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/Maven_POM_dependencies.csv"