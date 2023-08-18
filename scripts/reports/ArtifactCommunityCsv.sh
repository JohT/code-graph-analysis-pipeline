#!/usr/bin/env bash

# Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/artifact-community-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "artifactCommunityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "artifactCommunityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "artifactCommunityCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="artifact-community-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
LEIDEN_CYPHER_DIR="$CYPHER_DIR/Community_Detection_Leiden_for_Artifacts"

# Preparation for Community Detection - Create package dependencies projections
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_0_Delete_Projection.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_0b_Delete_Projection.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_1_Create_undirected_Projection.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_1b_Create_subgraph_without_empty_artifacts.cypher"

# Community Detection using the Leiden Algorithm - Query CSV
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_2_Leiden_Estimate_Memory.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_3_Leiden_Statistics.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_4_Leiden_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Leiden_Communities.csv"

# Community Detection using the Leiden Algorithm - Update Graph
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_5_Leiden_Write_property_leidenCommunityId.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_6_Delete_Existing_Labels.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_7_Add_ArtifactLeidenCommunity_Id_label_to_artifacts.cypher"