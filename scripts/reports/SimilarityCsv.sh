#!/usr/bin/env bash

# Looks for similarity using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/similarity-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "similarityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
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

# Similarity Preparation
# Selects the nodes and relationships for the algorithm and creates an in-memory projection.
# Nodes without incoming and outgoing dependencies will be filtered out with a subgraph.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
createProjection() {
    PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_1_Delete_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_3_Create_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_5_Create_Subgraph.cypher" "${@}"
}

# Apply the similarity algorithm "Similarity".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
similarity() {
    local SIMILARITY_CYPHER_DIR="$CYPHER_DIR/Similarity"

    # Statistics
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1a_Estimate.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1b_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1c_Mutate.cypher" "${@}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1d_Stream_Mutated.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Similarity.csv"
    #execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1e_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Similarity.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1f_Delete_Relationships.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1g_Write_Mutated.cypher" "${@}"
    #execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1h_Write.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1i_Write_Node_Properties.cypher" "${@}"
}

# ---------------------------------------------------------------

# Artifact Query Parameters
ARTIFACT_PROJECTION="dependencies_projection=artifact-similarity" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 

# Artifact Similarity
echo "similarityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing artifact dependencies..."
createProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time similarity "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"

# ---------------------------------------------------------------

# Package Query Parameters
PACKAGE_PROJECTION="dependencies_projection=package-similarity" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 

# Package Similarity
echo "similarityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing package dependencies..."
createProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time similarity "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"

# ---------------------------------------------------------------

# Type Query Parameters
TYPE_PROJECTION="dependencies_projection=type-similarity" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 

# Type Similarity
echo "similarityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing type dependencies..."
createProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time similarity "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"