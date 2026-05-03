#!/usr/bin/env bash

# Executes "Overview" Cypher queries to generate CSV reports for node labels, relationship types,
# Java artifact type composition, package counts, TypeScript module elements, and method metrics.
# Results are written to reports/overview/.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# If no data is present, cleanupAfterReportGeneration.sh removes empty CSV files.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/overview" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "overviewCsv: OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${OVERVIEW_SCRIPT_DIR}/../../scripts"}

# Domain-local query directory within this domain
OVERVIEW_QUERIES_DIR="${OVERVIEW_SCRIPT_DIR}/queries/overview"

# Function to display script usage
usage() {
    echo "Usage: $0 [--help]" >&2
    echo "" >&2
    echo "Executes Overview Cypher queries and writes CSV reports to reports/overview/." >&2
    echo "" >&2
    echo "Flags:" >&2
    echo "  --help     Print this usage message and exit" >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REPORTS_DIRECTORY  Output directory (default: reports)" >&2
    echo "  NEO4J_INITIAL_PASSWORD  Neo4j password (required by executeQueryFunctions.sh)" >&2
    echo "" >&2
    echo "Examples:" >&2
    echo "  $0              # Execute all queries and write CSV files" >&2
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            usage
            exit 0
            ;;
        *)
            echo "overviewCsv: Error: Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
    shift
done

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create main report directory
REPORT_NAME="overview"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "overviewCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting overview CSV report generation..."

# For Java
execute_cypher "${OVERVIEW_QUERIES_DIR}/Overview_size.cypher" > "${FULL_REPORT_DIRECTORY}/Overview_size.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Cyclomatic_Method_Complexity_Distribution.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclomatic_Method_Complexity.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Effective_lines_of_method_code_per_package.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_lines_of_method_code_per_package.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Effective_lines_of_method_code_per_type.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_lines_of_method_code_per_type.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Effective_Method_Line_Count_Distribution.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_Method_Line_Count.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Number_of_packages_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/Number_of_packages_per_artifact.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Number_of_types_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/Number_of_types_per_artifact.csv"

# For TypeScript
execute_cypher "${OVERVIEW_QUERIES_DIR}/Number_of_elements_per_module_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/Number_of_elements_per_module_for_Typescript.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Overview_size_for_Typescript.cypher" > "${FULL_REPORT_DIRECTORY}/Overview_size_for_Typescript.csv"

# In general
execute_cypher "${OVERVIEW_QUERIES_DIR}/Node_label_count.cypher" > "${FULL_REPORT_DIRECTORY}/Node_label_count.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Node_label_combination_count.cypher" > "${FULL_REPORT_DIRECTORY}/Node_label_combination_count.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Relationship_type_count.cypher" > "${FULL_REPORT_DIRECTORY}/Relationship_type_count.csv"
execute_cypher "${OVERVIEW_QUERIES_DIR}/Dependency_node_labels.cypher" > "${FULL_REPORT_DIRECTORY}/Dependency_node_labels.csv"

execute_cypher "${OVERVIEW_QUERIES_DIR}/Node_labels_and_their_relationships.cypher" > "${FULL_REPORT_DIRECTORY}/Node_labels_and_their_relationships.csv"

# Clean-up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "overviewCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
