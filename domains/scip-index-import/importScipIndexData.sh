#!/usr/bin/env bash

# Imports SCIP type-graph CSV data into Neo4j and enriches it for projection compatibility.
# Creates SCIPType, SCIPInternalType, SCIPExternalType, SCIPArtifact, and SCIPModule nodes.
# Also creates structural CONTAINS links between artifacts, modules, and types.
# Assumes scip_type_nodes.csv and scip_type_edges.csv are already placed in the Neo4j import directory.
# Requires executeQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/scip-index-import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCIP_INDEX_IMPORT_SCRIPT_DIR=${SCIP_INDEX_IMPORT_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "importScipIndexData: SCIP_INDEX_IMPORT_SCRIPT_DIR=${SCIP_INDEX_IMPORT_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${SCIP_INDEX_IMPORT_SCRIPT_DIR}/../../scripts"}

# Cypher query directory within this domain
QUERIES_DIR="${SCIP_INDEX_IMPORT_SCRIPT_DIR}/queries"

# Dependency enrichment queries in the shared cypher directory
DEPENDENCY_ENRICHMENT_CYPHER_DIR="${SCRIPTS_DIR}/../cypher/Dependency_Enrichment"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Cleaning up existing SCIP type nodes..."
execute_cypher "${QUERIES_DIR}/Cleanup_SCIP_Type_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP type uniqueness constraint..."
execute_cypher "${QUERIES_DIR}/Create_SCIP_Type_Constraint.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP internal type nodes..."
execute_cypher "${QUERIES_DIR}/Import_SCIP_Type_Internal_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP external type nodes..."
execute_cypher "${QUERIES_DIR}/Import_SCIP_Type_External_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP type dependency edges..."
execute_cypher "${QUERIES_DIR}/Import_SCIP_Type_Edges.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP type project name..."
execute_cypher "${QUERIES_DIR}/Set_SCIP_Type_Project_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting incoming SCIP type dependencies..."
execute_cypher "${QUERIES_DIR}/Set_Incoming_SCIP_Type_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting outgoing SCIP type dependencies..."
execute_cypher "${QUERIES_DIR}/Set_Outgoing_SCIP_Type_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP type test marker integers..."
execute_cypher "${QUERIES_DIR}/Set_SCIP_Type_Test_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP module nodes..."
execute_cypher "${QUERIES_DIR}/Create_SCIP_Module_Nodes_For_Internal_Types.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP artifact nodes..."
execute_cypher "${QUERIES_DIR}/Create_SCIP_Artifact_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP modules to their contained internal types..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained modules..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained external types..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP module test markers..."
execute_cypher "${QUERIES_DIR}/Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting dependency degree..."
execute_cypher "${DEPENDENCY_ENRICHMENT_CYPHER_DIR}/Set_Dependency_Degree.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting dependency degree rank..."
execute_cypher "${DEPENDENCY_ENRICHMENT_CYPHER_DIR}/Set_Dependency_Degree_Rank.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP artifact nodes..."
execute_cypher "${QUERIES_DIR}/Create_SCIP_Artifact_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP module nodes for internal types..."
execute_cypher "${QUERIES_DIR}/Create_SCIP_Module_Nodes_For_Internal_Types.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP modules to internal types..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to modules..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to external types..."
execute_cypher "${QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') SCIP index import complete."
