#!/usr/bin/env bash

# Looks for similarity using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/community.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "similarityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "similarityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "similarityCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="similarity-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
SIMILARITY_CYPHER_DIR="$CYPHER_DIR/Similarity"

# Preparation Similarity - Create package dependencies projection
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_0_Delete_Projection.cypher"
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_0b_Delete_Subgraph_Projection.cypher"
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1_Create_Projection.cypher"
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1b_Create_subgraph_without_empty_packages.cypher"

# Similarity using Node Similarity Algorithm with JACCARD metric - Query CSV
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_3_Estimate_Memory.cypher"
execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_4_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Similarity_Jaccard.csv"
