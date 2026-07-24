#!/usr/bin/env bash

# Imports SCIP type-graph CSV data into Neo4j and enriches it for projection compatibility.
# Creates SemanticCodeIndexInternalType, SemanticCodeIndexExternalType, SemanticCodeIndexArtifact, and SemanticCodeIndexModule nodes.
# Also creates structural CONTAINS links between artifacts, modules, and types.
# Skips import and enrichment if indices/ hasn't changed since last successful import (change detection via hash file).
# Assumes scip_type_nodes.csv and scip_type_edges.csv are already placed in the Neo4j import directory.
# Requires executeQueryFunctions.sh, detectChangedFiles.sh

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

# Cypher query subdirectories organized by function
IMPORT_QUERIES_DIR="${QUERIES_DIR}/import"
ENRICHMENT_QUERIES_DIR="${QUERIES_DIR}/enrichment"
STRUCTURE_QUERIES_DIR="${QUERIES_DIR}/structure"

# Dependency enrichment queries in the shared cypher directory
DEPENDENCY_ENRICHMENT_CYPHER_DIR="${SCRIPTS_DIR}/../cypher/Dependency_Enrichment"

# Change detection for SCIP indices (stored in indices directory alongside source files)
SCIP_INDEX_CHANGE_DETECTION_HASH_FILE="${INDICES_DIRECTORY}/scipIndexChangeDetection.sha"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Check if indices have changed since last import
is_scip_index_change_detected() {
    local change_detection_return_code
    change_detection_return_code=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --readonly --hashfile "${SCIP_INDEX_CHANGE_DETECTION_HASH_FILE}" --paths "${INDICES_DIRECTORY}" )
    
    if [ "${change_detection_return_code}" == "0" ] ; then
        false # No change detected (hash matches)
    else
        true # Change detected or first run (hash mismatch or file missing)
    fi
}

# Write the change detection hash file after successful import
write_scip_index_change_detection_file() {
    local change_detection_return_code
    change_detection_return_code=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${SCIP_INDEX_CHANGE_DETECTION_HASH_FILE}" --paths "${INDICES_DIRECTORY}" ) || true
}

# Check if indices have changed before proceeding
if ! is_scip_index_change_detected; then
    echo "importScipIndexData: SCIP indices unchanged. Import and enrichment skipped."
    unset SCIP_ADMIN_IMPORT_DONE
    return 0
fi

# Fast path: admin import already populated the database — skip CSV conversion and LOAD CSV.
# Constraints are still required before enrichment queries can run.
if [[ "${SCIP_ADMIN_IMPORT_DONE:-false}" == "true" ]]; then
    echo "importScipIndexData: Admin import completed. Running constraints and enrichment only."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"
else
    # LOAD CSV path: convert, clean up, apply constraints, then import nodes and edges
    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Converting SCIP index files to CSV..."
    ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" bash "${SCIP_INDEX_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jImport.sh" )

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Cleaning up existing SCIP type nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Cleanup_SCIP_Type_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP type uniqueness constraints..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP internal type nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Internal_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP external type nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_External_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP type dependency edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Edges.cypher"
fi

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP type project name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Type_Project_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting incoming SCIP type dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Incoming_SCIP_Type_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting outgoing SCIP type dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Outgoing_SCIP_Type_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP type test marker integers..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Type_Test_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP module nodes..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Create_SCIP_Module_Nodes_For_Internal_Types.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP artifact nodes..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Create_SCIP_Artifact_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP modules to their contained internal types..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained modules..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained external types..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts directly to their contained internal types..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_InternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating module-level dependencies from type dependencies..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Module_DEPENDS_ON_SCIP_Module.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating artifact-level dependencies from module dependencies..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_DEPENDS_ON_SCIP_Artifact.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP module test markers..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Module_Is_Test_And_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP artifact test markers..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Artifact_Is_Test_And_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP artifact external marker..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Artifact_Is_External.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP module project name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Module_Project_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting incoming SCIP module dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Incoming_SCIP_Module_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting outgoing SCIP module dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Outgoing_SCIP_Module_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting incoming SCIP artifact dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Incoming_SCIP_Artifact_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting outgoing SCIP artifact dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Outgoing_SCIP_Artifact_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting dependency degree..."
execute_cypher_summarized "${DEPENDENCY_ENRICHMENT_CYPHER_DIR}/Set_Dependency_Degree.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting dependency degree rank..."
execute_cypher_summarized "${DEPENDENCY_ENRICHMENT_CYPHER_DIR}/Set_Dependency_Degree_Rank.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') SCIP index import complete."

# Write change detection hash file after successful import
write_scip_index_change_detection_file
unset SCIP_ADMIN_IMPORT_DONE
