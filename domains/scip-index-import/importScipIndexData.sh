#!/usr/bin/env bash

# Imports SCIP CSV data into Neo4j and enriches it for projection compatibility.
# Supports two import modes controlled by SCIP_IMPORT_MODE:
#   kind-level (default): imports scip_type_nodes.csv, scip_function_nodes.csv, scip_variable_nodes.csv,
#     scip_field_nodes.csv and their corresponding edge CSVs. Filters by SCIP kind numbers.
#   cross-file: imports scip_symbol_nodes.csv (all cross-file internal symbols),
#     scip_external_symbol_nodes.csv, and scip_symbol_edges.csv.
#     Filters by occurrence-based cross-file reference detection, not by kind numbers.
# Both modes create SemanticCodeIndexArtifact and SemanticCodeIndexModule nodes and structural CONTAINS links.
# Skips import and enrichment if indices/ hasn't changed since last successful import (change detection via hash file).
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

# Directory for Neo4j CSV import files (defaults to ./import in working directory)
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"./import"}

# Controls which SCIP extraction strategy to use.
# kind-level: filters symbols by SCIP kind numbers (default, existing behavior).
# cross-file: filters by occurrence-based cross-file reference detection (new approach).
SCIP_IMPORT_MODE=${SCIP_IMPORT_MODE:-"kind-level"}

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to parse CSV format strings from Cypher query results
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

# Logging functions for import status and warnings
logWarning() {
    local warningMessage="${1}"
    local COLOR_WARNING='\033[0;33m' # yellow
    local COLOR_DEFAULT='\033[0m'
    echo -e "${COLOR_WARNING}importScipIndexData: Warning: ${warningMessage}${COLOR_DEFAULT}" >&2
}

# Verifies that SCIP type symbols don't contain unresolved placeholders like ${...}. These indicate version mismatches between defining and consuming modules during multi-module SCIP merges. Logs a non-fatal warning if found.
verify_scip_placeholder_symbols() {
    echo "importScipIndexData: Verifying SCIP type symbols for unresolved placeholders..."

    local dataVerificationResult
    dataVerificationResult=$( execute_cypher "${IMPORT_QUERIES_DIR}/Verify_SCIP_Placeholder_Symbols.cypher")

    if is_csv_column_greater_zero "${dataVerificationResult}" "nodeCount"; then
        # Warning: Unresolved placeholders indicate multi-module SCIP merges with version mismatches.
        #          Does not affect analysis. Logged as informational only.
        local nodeCount
        nodeCount=$(get_csv_column_value "${dataVerificationResult}" "nodeCount")
        logWarning "SCIP type symbols with unresolved build placeholders (e.g., \${revision}, \${project.version}) detected in ${nodeCount} nodes. This indicates version mismatches in multi-module SCIP merges. Analysis is not affected. To resolve, verify your SCIP merge configuration and module version consistency."
    fi
}

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
    if [ "${SCIP_IMPORT_MODE}" = "cross-file" ]; then
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_External_Symbol_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Project_Constraint.cypher"
        # Kind-specific labels must be applied before shadow-type handling runs below
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Function_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Internal_Type_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Variable_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Field_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Constructor_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_EnumMember_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_File_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Getter_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Property_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_TypeAlias_Label.cypher"
        execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_External_Type_Label.cypher"
    else
        # kind-level mode
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Project_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Function_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Variable_Constraint.cypher"
        execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Field_Constraint.cypher"
    fi
elif [ "${SCIP_IMPORT_MODE}" = "cross-file" ]; then
    # Cross-file LOAD CSV path: convert using occurrence-based filtering, then import
    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Converting SCIP index files to CSV (cross-file mode)..."
    ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" bash "${SCIP_INDEX_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jCrossFileImport.sh" )

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Cleaning up existing SCIP nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Cleanup_All_SCIP_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP cross-file symbol uniqueness constraints..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_Internal_Symbol_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Cross_File_External_Symbol_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP project uniqueness constraint..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Project_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP project nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Project_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP cross-file internal symbol nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_Internal_Symbol_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP cross-file external symbol nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_External_Symbol_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP symbol index..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Symbol_Index.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP cross-file symbol edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Cross_File_Symbol_Edges.cypher"

    # Kind-specific labels must be applied before shadow-type handling runs below
    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Adding cross-file kind-specific labels..."
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Function_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Internal_Type_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Variable_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Field_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Constructor_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_EnumMember_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Getter_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_Property_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_TypeAlias_Label.cypher"
    execute_cypher "${ENRICHMENT_QUERIES_DIR}/Add_SCIP_Cross_File_External_Type_Label.cypher"
else
    # Kind-level LOAD CSV path (default): convert, clean up, apply constraints, then import nodes and edges
    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Converting SCIP index files to CSV (kind-level mode)..."
    ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" bash "${SCIP_INDEX_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jImport.sh" )

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Cleaning up existing SCIP nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Cleanup_All_SCIP_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP type uniqueness constraints..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Internal_Type_Constraint.cypher"
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_External_Type_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP project uniqueness constraint..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Project_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP function uniqueness constraint..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Function_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP variable uniqueness constraint..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Variable_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP field uniqueness constraint..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Create_SCIP_Field_Constraint.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP project nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Project_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP internal type nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Internal_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP external type nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_External_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP type dependency edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Type_Edges.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP function nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Function_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP function dependency edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Function_Edges.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP variable nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Variable_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP variable dependency edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Variable_Edges.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP field nodes..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Field_Nodes.cypher"

    echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Importing SCIP field dependency edges..."
    execute_cypher "${IMPORT_QUERIES_DIR}/Import_SCIP_Field_Edges.cypher"
fi

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Redirecting SCIP shadow type edges to internal types..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Redirect_SCIP_Shadow_Type_Edges_To_Internal.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Deleting SCIP shadow external types..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Delete_SCIP_Shadow_External_Types.cypher"

verify_scip_placeholder_symbols

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP project short name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Project_Short_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP external type project name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_External_Type_Project_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP external type test marker integers..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_External_Type_Test_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting incoming SCIP symbol dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Incoming_SCIP_Symbol_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting outgoing SCIP symbol dependencies..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_Outgoing_SCIP_Symbol_Dependencies.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP symbol test marker integers..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Symbol_Test_Marker_Integer.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP symbol project name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Symbol_Project_Name.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP file nodes..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Create_SCIP_File_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP types to their source files..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Symbol_SOURCE_FILE_SCIP_File.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP module nodes..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Create_SCIP_Module_Nodes_For_Internal_Types.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating SCIP artifact nodes..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Create_SCIP_Artifact_Nodes.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP modules to all of their contained internal symbols..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Module_CONTAINS_SCIP_InternalSymbol.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained modules..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts to their contained external types..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_ExternalType.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP artifacts directly to their contained internal types..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Artifact_CONTAINS_SCIP_InternalSymbol.cypher"

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Linking SCIP projects to their contained artifacts..."
execute_cypher_summarized "${STRUCTURE_QUERIES_DIR}/Link_SCIP_Project_CONTAINS_SCIP_Artifact.cypher"

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

echo "importScipIndexData: $(date +'%Y-%m-%dT%H:%M:%S%z') Setting SCIP artifact project name..."
execute_cypher_summarized "${ENRICHMENT_QUERIES_DIR}/Set_SCIP_Artifact_Project_Name.cypher"

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
