#!/usr/bin/env bash

# Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports.
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
echo "communityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "communityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "communityCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="community-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
LOUVAIN_CYPHER_DIR="$CYPHER_DIR/Community_Detection_Louvain"
LEIDEN_CYPHER_DIR="$CYPHER_DIR/Community_Detection_Leiden"

# Preparation for Community Detection - Create package dependencies projections
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_0_Delete_Projection.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_0b_Delete_Projection.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_1_Create_undirected_Projection.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_1b_Create_subgraph_without_empty_packages.cypher"

# Community Detection using the Louvain Algorithm - Query CSV
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_2_Louvain_Estimate_Memory.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_3_Louvain_Statistics.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_4_Louvain_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Louvain_Communities.csv"

# Community Detection using the Louvain Algorithm - Update Graph
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_5c_Louvain_Write_louvainCommunity25PercentInterfaces.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_6_Louvain_Delete_Existing_Labels.cypher"
execute_cypher "${LOUVAIN_CYPHER_DIR}/Community_Detection_7_Add_LouvainCommunity_Id_label_to_packages.cypher"

# Community Detection using the Leiden Algorithm - Query CSV
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_2_Leiden_Estimate_Memory.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_3_Leiden_Statistics.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_4_Leiden_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Leiden_Communities.csv"

# Community Detection using the Leiden Algorithm - Update Graph
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_5_Leiden_Write_property_leidenCommunityIdGamma114With25PercentInterfaces.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_6_Delete_Existing_Labels.cypher"
execute_cypher "${LEIDEN_CYPHER_DIR}/Community_Detection_7_Add_LeidenCommunity_Id_label_to_packages.cypher"

# Community Detection using the Leiden Algorithm - Query CSV after update
execute_cypher "${LEIDEN_CYPHER_DIR}/Which_package_community_spans_several_artifacts_and_how_are_the_packages_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Leiden_Communities_That_Span_Multiple_Artifacts.csv"
