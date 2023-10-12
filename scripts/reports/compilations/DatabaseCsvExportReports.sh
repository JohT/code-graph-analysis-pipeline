#!/usr/bin/env bash

# Exports the whole graph database as a CSV file using the APOC procedure "apoc.export.csv.all"
# The exported file can be found in the subdirectory "import" inside the tools/neo4j.. directory.

# Note: This is a special case. It is treated as a compilation even if it is just a single cypher execution. 
#       The reason for that is that it exports the whole graph database. This should only be done intentionally
#       and not within a default "AllReports.sh" run because it is performance intense and could raise security concerns.

# Requires repexecuteQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "DatabaseCsvExportReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/../.."} # Repository directory containing the shell scripts
echo "DatabaseCsvExportReports: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}
echo "DatabaseCsvExportReports: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Execute Database Export Procedure in background
# The exported file can then be found in the subdirectory "import" inside the tools/neo4j.. directory.
execute_cypher "${CYPHER_DIR}/Export_the_whole_database_as_CSV.cypher"