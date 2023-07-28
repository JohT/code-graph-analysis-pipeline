#!/usr/bin/env bash

# Executes "Overview" Cypher queries to get the "overview-csv" CSV reports.
# It contains the numbers of packages, types, methods, cyclic complexity, etc.

# Requires executeQueryFunctions.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "OverviewCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "OverviewCsv SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "OverviewCsv CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="overview-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
OVERVIEW_CYPHER_DIR="${CYPHER_DIR}/Overview"

execute_cypher "${OVERVIEW_CYPHER_DIR}/Cyclomatic_Method_Complexity_Distribution.cypher" > "${FULL_REPORT_DIRECTORY}/Cyclomatic_Method_Complexity.csv"
execute_cypher "${OVERVIEW_CYPHER_DIR}/Effective_lines_of_method_code_per_package.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_lines_of_method_code_per_package.csv"
execute_cypher "${OVERVIEW_CYPHER_DIR}/Effective_lines_of_method_code_per_type.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_lines_of_method_code_per_type.csv"
execute_cypher "${OVERVIEW_CYPHER_DIR}/Effective_Method_Line_Count_Distribution.cypher" > "${FULL_REPORT_DIRECTORY}/Effective_Method_Line_Count.csv"
execute_cypher "${OVERVIEW_CYPHER_DIR}/Number_of_packages_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/Number_of_packages_per_artifact.csv"
execute_cypher "${OVERVIEW_CYPHER_DIR}/Number_of_types_per_artifact.cypher" > "${FULL_REPORT_DIRECTORY}/Number_of_types_per_artifact.csv"