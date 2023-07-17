#!/usr/bin/env bash

# Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports.
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
echo "centralityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "centralityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "centralityCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="centrality-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

# Preparation for Centrality - Create package dependencies projection
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_0_Delete_Projection.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_0b_Delete_Subraph_Projection.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1_Create_Projection.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1b_Create_Subgraph_Without_Empty_Packages.cypher"

# Centrality using the Page Rank Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2a_Page_Rank_Estimate_Memory.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2b_Page_Rank_Statistics.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3c_Page_Rank_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Page_Rank.csv"

# Centrality using the Page Rank Algorithm - Update Graph
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3d_Page_Rank_Write.cypher"

# Centrality using the Article Rank Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4a_Article_Rank_Estimate_Memory.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4b_Article_Rank_Statistics.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4c_Article_Rank_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Article_Rank.csv"

# Centrality using the Article Rank Algorithm - Update Graph
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4d_Article_Rank_Write.cypher"

# Centrality using the Betweeness Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5a_Betweeness_Estimate.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5b_Betweeness_Statistics.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5c_Betweeness_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Betweeness.csv"

# Centrality using the Betweeness Algorithm - Update Graph
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5d_Betweeness_Write.cypher"

# Centrality using the Cost Effective Lazy Formward (CELF) Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6c_Cost_effective_Lazy_Forward_CELF_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Cost_Effective_Lazy_Forward.csv"

# Centrality using the Harmonic Closeness Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7a_Harmonic_Closeness_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Harmonic.csv"

# Centrality using the Harmonic Closeness Algorithm - Update Graph
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7b_Harmonic_Closeness_Write.cypher"

# Centrality using the Closeness Algorithm - Query CSV
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8a_Closeness_Statistics.cypher"
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8b_Closeness_Stream.cypher" > "${FULL_REPORT_DIRECTORY}/Centrality_Closeness.csv"

# Centrality using the Closeness Algorithm - Update Graph
execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8c_Closeness_Write.cypher"