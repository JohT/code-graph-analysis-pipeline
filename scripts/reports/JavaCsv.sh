#!/usr/bin/env bash

# Executes "Java" Cypher queries to get the "java-csv" CSV reports.
# It contains lists of e.g. reflection usage, annotated language elements and usage of deprecated elements.

# Requires executeQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "JavaCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "JavaCsv SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "JavaCsv CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="java-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
JAVA_CYPHER_DIR="${CYPHER_DIR}/Java"

echo "JavaCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Executing Queries..."

execute_cypher "${JAVA_CYPHER_DIR}/Java_Reflection_usage.cypher" > "${FULL_REPORT_DIRECTORY}/ReflectionUsage.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Java_Reflection_usage_detailed.cypher" > "${FULL_REPORT_DIRECTORY}/ReflectionUsageDetailed.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Java_deprecated_element_usage.cypher" > "${FULL_REPORT_DIRECTORY}/DeprecatedElementUsage.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Java_deprecated_element_usage_detailed.cypher" > "${FULL_REPORT_DIRECTORY}/DeprecatedElementUsageDetailed.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Annotated_code_elements.cypher" > "${FULL_REPORT_DIRECTORY}/AnnotatedCodeElements.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Annotated_code_elements_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/AnnotatedCodeElementsPerArtifact.csv"

execute_cypher "${JAVA_CYPHER_DIR}/JakartaEE_REST_Annotations.cypher" > "${FULL_REPORT_DIRECTORY}/JakartaEE_REST_Annotations.csv"
execute_cypher "${JAVA_CYPHER_DIR}/Spring_Web_Request_Annotations.cypher" > "${FULL_REPORT_DIRECTORY}/Spring_Web_Request_Annotations.csv"

echo "JavaCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished"