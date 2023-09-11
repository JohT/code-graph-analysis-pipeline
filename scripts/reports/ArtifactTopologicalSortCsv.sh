#!/usr/bin/env bash

# Applies the Topological Sorting algorithm to order the artifacts by their artifacts (build order/level) using Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/artifact-topology-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "artifactTopologicalSortCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "artifactTopologicalSortCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "artifactTopologicalSortCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="artifact-topology-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
TOPOLOGICAL_SORT_DIR="$CYPHER_DIR/Topological_Sort_Artifacts"

# Preparation for Topological Sort - Create artifact dependencies projections
execute_cypher "${TOPOLOGICAL_SORT_DIR}/0_Delete_Projections_for_directed_artifact_dependencies.cypher"
execute_cypher "${TOPOLOGICAL_SORT_DIR}/0b_Delete_Projections_for_directed_artifact_dependencies.cypher"
execute_cypher "${TOPOLOGICAL_SORT_DIR}/1_Create_directed_Projection.cypher"
execute_cypher "${TOPOLOGICAL_SORT_DIR}/2_Create_directed_subgraph_without_empty_artifacts.cypher"

# Topological Sort Artifacts
execute_cypher "${TOPOLOGICAL_SORT_DIR}/3_Topological_Sort_Artifacts.cypher"

# Query topological sorted Artifacts (CSV)
execute_cypher "${TOPOLOGICAL_SORT_DIR}/4_Query_artifacts_in_topological_order.cypher" > "${FULL_REPORT_DIRECTORY}/TopologicalSortedArtifacts.csv"