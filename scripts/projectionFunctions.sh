#!/usr/bin/env bash

# Provides functions to create and delete Graph Projections for Neo4j Graph Data Science.
# A Projection contains only selected nodes, relationships and properties of the main Graph 
# and is stored using compressed data structures for optimized in-memory processing.
# By selecting only one Node and Relationship type, algorithms for homogeneous Graphs can be applied
# that wouldn't lead to useable results using the whole heterogenous main Graph.

# References:
#  - Native Projection: https://neo4j.com/docs/graph-data-science/current/management-ops/graph-creation/graph-project
#  - Graph management: https://neo4j.com/docs/graph-data-science/current/management-ops

# Requires executeQueryFunctions.sh, parseCsvFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts

# Get the "cypher" directory by taking the path of this script and going up one directory and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}

# Get the directory within the "cypher" directory that contains the Cypher queries for projection management.
PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
echo "projectionFunctions: PROJECTION_CYPHER_DIR=${PROJECTION_CYPHER_DIR}"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define function(s) (e.g. is_csv_column_greater_zero) to parse CSV format strings from Cypher query results.
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

# Creates a directed Graph projection for dependencies between nodes specified by the parameter "dependencies_projection_node".
# Nodes without incoming and outgoing dependencies will be filtered out using a subgraph.
#
# Returns true  (=0) if the projection has been created successfully.
# Returns false (=1) if the projection couldn't be created because of missing data.
# Exits with an error if there are technical issues.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
createDirectedDependencyProjection() {
    local projectionResult

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_0_Check_Projectable.cypher" "${@}"
    projectionCheckResult=$( execute_cypher_http_number_of_lines_in_result "${PROJECTION_CYPHER_DIR}/Dependencies_0_Check_Projectable.cypher" "${@}" )
    if [[ "${projectionCheckResult}" -lt 1 ]]; then
        return 1
    fi
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_1_Delete_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_3_Create_Projection.cypher" "${@}"
    projectionResult=$( execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_5_Create_Subgraph.cypher" "${@}")
    is_csv_column_greater_zero "${projectionResult}" "relationshipCount"
}

# Creates an undirected Graph projection for dependencies between nodes specified by the parameter "dependencies_projection_node".
# Nodes without incoming and outgoing dependencies will be filtered out using a subgraph.
#
# Returns true  (=0) if the projection has been created successfully.
# Returns false (=1) if the projection couldn't be created because of missing data.
# Exits with an error if there are technical issues.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
createUndirectedDependencyProjection() {
    local projectionResult

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_0_Check_Projectable.cypher" "${@}"
    projectionCheckResult=$( execute_cypher_http_number_of_lines_in_result "${PROJECTION_CYPHER_DIR}/Dependencies_0_Check_Projectable.cypher" "${@}" )
    if [[ "${projectionCheckResult}" -lt 1 ]]; then
        return 1
    fi
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_1_Delete_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_4_Create_Undirected_Projection.cypher" "${@}"
    projectionResult=$( execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_5_Create_Subgraph.cypher" "${@}")
    is_csv_column_greater_zero "${projectionResult}" "relationshipCount"
}

# Creates a directed Graph projection specialized on Java Type dependencies. 
# Zero-degree nodes, external types, java types and duplicates are filtered out using a Cypher projection.
#
# Returns true  (=0) if the projection has been created successfully.
# Returns false (=1) if the projection couldn't be created because of missing data.
# Exits with an error if there are technical issues.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
createDirectedJavaTypeDependencyProjection() {
    local projectionResult

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    projectionResult=$( execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_3c_Create_Java_Type_Projection.cypher" "${@}")
    is_csv_column_greater_zero "${projectionResult}" "relationshipCount"
}

# Creates an undirected Graph projection specialized on Java Type dependencies. 
# Zero-degree nodes, external types, java types and duplicates are filtered out using a Cypher projection.
#
# Returns true  (=0) if the projection has been created successfully.
# Returns false (=1) if the projection couldn't be created because of missing data.
# Exits with an error if there are technical issues.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
createUndirectedJavaTypeDependencyProjection() {
    local projectionResult

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    projectionResult=$( execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_4c_Create_Undirected_Type_Projection.cypher" "${@}")
    is_csv_column_greater_zero "${projectionResult}" "relationshipCount"
}

# Creates a directed Graph projection specialized on Java Method dependencies. 
# Nodes without incoming and outgoing dependencies will be filtered out with a subgraph.
#
# Returns true  (=0) if the projection has been created successfully.
# Returns false (=1) if the projection couldn't be created because of missing data.
# Exits with an error if there are technical issues.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
createDirectedJavaMethodDependencyProjection() {
    local projectionResult

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    projectionResult=$( execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_3d_Create_Java_Method_Projection.cypher" "${@}")
    is_csv_column_greater_zero "${projectionResult}" "relationshipCount"
}

