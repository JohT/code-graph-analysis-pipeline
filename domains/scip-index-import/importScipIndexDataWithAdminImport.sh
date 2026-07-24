#!/usr/bin/env bash

# Pre-start bulk SCIP import via "neo4j-admin database import full" before Neo4j starts.
# Sourced from analyze.sh before startNeo4j.sh when SCIP index files exist.
# On success, exports SCIP_ADMIN_IMPORT_DONE=true so importScipIndexData.sh skips LOAD CSV.
# Falls back silently to LOAD CSV on any failure or when conditions are not met:
#   - SCIP indices unchanged since last import
#   - Neo4j v4 (not supported)
#   - neo4j-admin binary absent or not executable
#   - Neo4j database already populated (not empty)
#   - CSV conversion or admin import command fails
# Requires convertScipIndexToCsvForNeo4jAdminImport.sh, detectChangedFiles.sh, operatingSystemFunctions.sh.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/scip-index-import" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCIP_ADMIN_IMPORT_SCRIPT_DIR=${SCIP_ADMIN_IMPORT_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${SCIP_ADMIN_IMPORT_SCRIPT_DIR}/../../scripts"}

# Variable defaults — settings profile is already sourced at this point in analyze.sh;
# these defaults handle edge cases and direct invocation.
NEO4J_EDITION=${NEO4J_EDITION:-"community"}
NEO4J_VERSION=${NEO4J_VERSION:-"2026.01.4"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"}
DATA_DIRECTORY=${DATA_DIRECTORY:-"$( pwd -P )/data"}
RUNTIME_DIRECTORY=${RUNTIME_DIRECTORY:-"$( pwd -P )/runtime"}
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"$( pwd -P )/import"}
INDICES_DIRECTORY=${INDICES_DIRECTORY:-"$( pwd -P )/indices"}

NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"

# Hash file for change detection — same path as used by importScipIndexData.sh
SCIP_INDEX_CHANGE_DETECTION_HASH_FILE="${INDICES_DIRECTORY}/scipIndexChangeDetection.sha"

# Source operatingSystemFunctions.sh for ifWindows(); compute scriptExtension after sourcing
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"
scriptExtension=$(ifWindows ".bat" "")

# Extract major version number for v4 guard and version-specific flags
NEO4J_MAJOR_VERSION_NUMBER=$(echo "${NEO4J_VERSION}" | cut -d'.' -f1)

# ---------------------------------------------------------------------------
# Attempt the admin import. Any guard failure returns 0 (LOAD CSV fallback).
# Called with "try_admin_import || true" to suppress any unhandled error.
# ---------------------------------------------------------------------------

function try_admin_import() {
    # Guard 1: skip if SCIP indices haven't changed since last successful import
    # Uses same source-in-subshell + stdout-capture pattern as importScipIndexData.sh
    local change_detection_output
    # shellcheck disable=SC1091
    change_detection_output=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --readonly --hashfile "${SCIP_INDEX_CHANGE_DETECTION_HASH_FILE}" --paths "${INDICES_DIRECTORY}" )
    if [ "${change_detection_output}" == "0" ]; then
        echo "importScipIndexDataWithAdminImport: SCIP indices unchanged. Skipping admin import."
        return 0
    fi

    # Guard 2: neo4j-admin database import full requires Neo4j v5 or higher
    if [[ "${NEO4J_MAJOR_VERSION_NUMBER}" -lt 5 ]]; then
        echo "importScipIndexDataWithAdminImport: Neo4j v4 not supported by admin import. Falling back to LOAD CSV."
        return 0
    fi

    # Guard 3: neo4j-admin binary must be present and executable
    local neo4j_admin_bin="${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin${scriptExtension}"
    if [ ! -x "${neo4j_admin_bin}" ]; then
        echo "importScipIndexDataWithAdminImport: neo4j-admin not found or not executable at '${neo4j_admin_bin}'. Falling back to LOAD CSV."
        return 0
    fi

    # Guard 4: database directory must be absent or empty (initial import only)
    local neo4j_db_dir="${DATA_DIRECTORY}/databases/neo4j"
    if [ -d "${neo4j_db_dir}" ]; then
        if find "${neo4j_db_dir}" -mindepth 1 -maxdepth 1 2>/dev/null | grep -q .; then
            echo "importScipIndexDataWithAdminImport: Neo4j database '${neo4j_db_dir}' is not empty. Falling back to LOAD CSV."
            return 0
        fi
    fi

    # Convert SCIP index files to neo4j-admin import CSVs
    echo "importScipIndexDataWithAdminImport: $(date +'%Y-%m-%dT%H:%M:%S%z') Converting SCIP index files to admin import CSV..."
    if ! ( INDICES_DIRECTORY="${INDICES_DIRECTORY}" IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" bash "${SCIP_ADMIN_IMPORT_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jAdminImport.sh" ); then
        echo "importScipIndexDataWithAdminImport: CSV conversion failed. Falling back to LOAD CSV." >&2
        return 0
    fi

    # Resolve IMPORT_DIRECTORY to absolute path (neo4j-admin requires absolute file paths)
    local absolute_import_dir
    absolute_import_dir=$( CDPATH=. cd -- "${IMPORT_DIRECTORY}" && pwd -P )
    local nodes_csv="${absolute_import_dir}/scip_type_nodes_admin.csv"
    local edges_csv="${absolute_import_dir}/scip_type_edges_admin.csv"
    local projects_csv="${absolute_import_dir}/scip_projects_admin.csv"
    local links_csv="${absolute_import_dir}/scip_type_project_links_admin.csv"

    # Ensure logs directory exists before neo4j-admin writes its report
    mkdir -p "${RUNTIME_DIRECTORY}/logs"

    # Build neo4j-admin command with absolute file paths
    # Note: We use concrete absolute paths, so regex pattern style (default) works fine.
    # The --path-pattern-style flag is only needed for pattern matching and is only
    # supported in Neo4j 2026.01+, so we omit it for compatibility.
    local neo4j_admin_import_command
    neo4j_admin_import_command="database import full --nodes=${nodes_csv} --nodes=${projects_csv} --relationships=${edges_csv} --relationships=${links_csv} --report-file=${RUNTIME_DIRECTORY}/logs/scip_admin_import.report neo4j"

    # Run neo4j-admin database import full
    echo "importScipIndexDataWithAdminImport: $(date +'%Y-%m-%dT%H:%M:%S%z') Running neo4j-admin database import full..."
    # Word splitting intentional: expand neo4j_admin_import_command arguments
    # shellcheck disable=SC2086
    if ! NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}" "${neo4j_admin_bin}" ${neo4j_admin_import_command}; then
        echo "importScipIndexDataWithAdminImport: neo4j-admin import failed. Falling back to LOAD CSV." >&2
        return 0
    fi

    echo "importScipIndexDataWithAdminImport: $(date +'%Y-%m-%dT%H:%M:%S%z') Admin import completed. Constraints and enrichment will run post-start."
    export SCIP_ADMIN_IMPORT_DONE=true
}

# Wrap in || true: any unhandled failure falls back to LOAD CSV rather than aborting analyze.sh
try_admin_import || true
