#!/usr/bin/env bash

# Sourced library: provides functions to create per-module SCIP indices for Java Maven projects.
# This file must be sourced, not executed directly. The caller is responsible for strict mode.
#
# Required env vars (must be set by caller before sourcing):
#   PROJECT_ROOT  — path to the Maven project root (absolute or relative; will be resolved to absolute)
#
# Overrideable env vars:
#   SCIP_JAVA     — path to scip-java binary (default: ./tools/scip-java/scip-java)
#   SCIP          — path to scip CLI binary (default: ./tools/scip-cli/scip)
#   OUTPUT_DIR    — directory for generated .scip.json files (default: ${PROJECT_ROOT}/target/scip-indices-per-module)

# Resolve PROJECT_ROOT to an absolute path if it's relative
if [[ "${PROJECT_ROOT}" != /* ]]; then
    PROJECT_ROOT="$( cd -- "${PROJECT_ROOT}" >/dev/null 2>&1 && pwd -P )" || {
        echo "Error: PROJECT_ROOT '${PROJECT_ROOT}' does not exist" >&2
        exit 1
    }
fi
readonly PROJECT_ROOT

SCIP_JAVA=${SCIP_JAVA:-"./tools/scip-java/scip-java"}
SCIP=${SCIP:-"./tools/scip-cli/scip"}
OUTPUT_DIR=${OUTPUT_DIR:-"${PROJECT_ROOT}/target/scip-indices-per-module"}

# Resolve OUTPUT_DIR to an absolute path to prevent scip-java from resolving it relative to --cwd.
# If OUTPUT_DIR is relative, prepend PROJECT_ROOT (which is now guaranteed to be absolute).
if [[ "${OUTPUT_DIR}" != /* ]]; then
    OUTPUT_DIR="${PROJECT_ROOT%/}/${OUTPUT_DIR}"
fi
readonly OUTPUT_DIR

# Detect Maven wrapper or fall back to system mvn
if [ -f "${PROJECT_ROOT}/mvnw" ]; then
    # Resolve to an absolute path; resolve_placeholders_in_json runs "cd ${PROJECT_ROOT}" first,
    # which would otherwise invalidate a relative "${PROJECT_ROOT}/mvnw" path.
    MVNW="$( CDPATH=. cd -- "${PROJECT_ROOT}" >/dev/null && pwd -P )/mvnw"
else
    MVNW="mvn"
fi
readonly MVNW

# Runs scip-java to index a single Maven module and converts the binary SCIP output to JSON.
# Arguments:
#   $1  Maven module name to index (e.g. "common" for the "common" directory in a multi-module project)
function index_module() {
    local module_name="${1}"
    local scip_output="${OUTPUT_DIR}/${module_name}.scip"
    local json_output="${OUTPUT_DIR}/${module_name}.scip.json"

    mkdir -p "${OUTPUT_DIR}"

    "${SCIP_JAVA}" index \
        --build-tool maven \
        --cwd "${PROJECT_ROOT}" \
        --output "${scip_output}" \
        -- \
        clean verify \
        -pl "${module_name}" \
        -DskipTests \
        --no-transfer-progress

    echo "Converting ${scip_output} to JSON..."
    "${SCIP}" print --json "${scip_output}" > "${json_output}"
    rm -f "${scip_output}"
    echo "Created ${json_output}"
}

# Replaces a Maven property placeholder (e.g. ${revision}) in all .scip.json files in OUTPUT_DIR.
# The actual value is resolved by running mvn help:evaluate on the project.
# Cross-platform: uses "sed -i ''" on macOS and "sed -i" on Linux.
# Arguments:
#   $1  Maven property name (e.g. "revision")
function resolve_placeholders_in_json() {
    local placeholder_name="${1}"

    local actual_value
    actual_value=$(
        cd "${PROJECT_ROOT}" || exit 1
        "${MVNW}" help:evaluate \
            -Dexpression="${placeholder_name}" \
            -q \
            -DforceStdout \
            --no-transfer-progress
    )

    echo "resolve_placeholders_in_json: Replacing \${${placeholder_name}} with ${actual_value} in ${OUTPUT_DIR}/*.scip.json"

    local json_file
    for json_file in "${OUTPUT_DIR}"/*.scip.json; do
        [ -f "${json_file}" ] || continue
        if [ "$(uname -s)" = "Darwin" ]; then
            sed -i '' "s/\${${placeholder_name}}/${actual_value}/g" "${json_file}"
        else
            sed -i "s/\${${placeholder_name}}/${actual_value}/g" "${json_file}"
        fi
    done
}
