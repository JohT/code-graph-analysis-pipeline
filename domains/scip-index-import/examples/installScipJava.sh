#!/usr/bin/env bash

# Installs the scip-java CLI binary to BIN_DIR (default: ./tools/scip-java within analysis workspace).
# scip-java generates SCIP indices for Java/Maven projects.
# Uses Coursier bootstrap with artifact com.sourcegraph:scip-java_2.13:<version>.
# Idempotent: skips install if binary already exists.
# Requires Java 11+ and curl.
#
# WARNING: Upgrade requires verifying Coursier bash wrapper compatibility.
#   Version 0.13.x uses a different artifact (org.scip-code:scip-java) which triggered a
#   Coursier bash wrapper bug on Linux. Do not upgrade without verifying the bug is fixed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Upgrade requires verifying Coursier bash wrapper compatibility (see domains/scip-index-import/examples/ README).
SCIP_JAVA_VERSION=${SCIP_JAVA_VERSION:-"0.12.3"}

TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"./tools"}
BIN_DIR=${BIN_DIR:-"${TOOLS_DIRECTORY}/scip-java"}

SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

function usage() {
    local exit_code="${1:-1}"
    echo "Usage: ${SCRIPT_NAME} [--version X.Y.Z] [--bin-dir <path>] [--help]"
    echo ""
    echo "Options:"
    echo "  --version X.Y.Z   scip-java version to install (default: ${SCIP_JAVA_VERSION})"
    echo "  --bin-dir <path>  Directory to install the scip-java binary (default: ${TOOLS_DIRECTORY}/scip-java)"
    echo "  --help            Print this usage and exit 0"
    echo ""
    echo "Environment variables:"
    echo "  SCIP_JAVA_VERSION   scip-java version (default: ${SCIP_JAVA_VERSION})"
    echo "  TOOLS_DIRECTORY     Base directory for tools (default: ./tools)"
    echo "  BIN_DIR             Installation directory (default: \${TOOLS_DIRECTORY}/scip-java)"
    echo ""
    echo "Examples:"
    echo "  ${SCRIPT_NAME}"
    echo "    # Install scip-java ${SCIP_JAVA_VERSION} to ./tools/scip-java/"
    echo "  ${SCRIPT_NAME} --version 0.12.3 --bin-dir /usr/local/bin"
    exit "${exit_code}"
}

while [ $# -gt 0 ]; do
    case "${1}" in
        --version)
            SCIP_JAVA_VERSION="${2:-}"
            shift 2 || { echo "${SCRIPT_NAME}: Error: --version requires a value." >&2; usage 1; }
            ;;
        --bin-dir)
            BIN_DIR="${2:-}"
            shift 2 || { echo "${SCRIPT_NAME}: Error: --bin-dir requires a value." >&2; usage 1; }
            ;;
        --help) usage 0 ;;
        *) echo "${SCRIPT_NAME}: Error: Unknown option: ${1}" >&2; usage 1 ;;
    esac
done

function check_java() {
    if ! command -v java >/dev/null 2>&1; then
        echo "${SCRIPT_NAME}: Error: Java not found in PATH. Install Java 11+." >&2
        exit 1
    fi
    local java_major
    java_major=$(java -version 2>&1 | head -1 | sed 's/.*version "\([0-9]*\)[^"]*".*/\1/')
    if [ "${java_major}" -lt 11 ]; then
        echo "${SCRIPT_NAME}: Error: Java 11+ required. Found: Java ${java_major}." >&2
        exit 1
    fi
}

function check_curl() {
    if ! command -v curl >/dev/null 2>&1; then
        echo "${SCRIPT_NAME}: Error: curl is required but not found in PATH." >&2
        exit 1
    fi
}

function install_scip_java() {
    local scip_java_bin="${BIN_DIR}/scip-java"

    if [ -f "${scip_java_bin}" ]; then
        echo "${SCRIPT_NAME}: scip-java already installed at ${scip_java_bin}. Skipping."
        return 0
    fi

    check_java
    check_curl

    local tmp_dir
    tmp_dir=$(mktemp -d)
    # shellcheck disable=SC2064
    # Note: SC2064 is disabled intentionally. Variable expansion in trap must occur at trap set time,
    # not at trap execution time. This ensures the correct tmp_dir is cleaned up even if tmp_dir
    # is reassigned in nested contexts.
    trap "rm -rf '${tmp_dir}'" EXIT

    local coursier_launcher="${tmp_dir}/coursier"
    echo "${SCRIPT_NAME}: Downloading Coursier launcher..."
    curl --silent --show-error --fail --location \
        "https://github.com/coursier/launchers/raw/master/coursier" \
        --output "${coursier_launcher}"

    local artifact="com.sourcegraph:scip-java_2.13:${SCIP_JAVA_VERSION}"
    mkdir -p "${BIN_DIR}"
    echo "${SCRIPT_NAME}: Bootstrapping scip-java ${SCIP_JAVA_VERSION} from ${artifact}..."
    java -jar "${coursier_launcher}" bootstrap \
        -q \
        "${artifact}" \
        --output "${scip_java_bin}" \
        --standalone \
        --main com.sourcegraph.scip_java.ScipJava

    chmod +x "${scip_java_bin}"
    echo "${SCRIPT_NAME}: scip-java ${SCIP_JAVA_VERSION} installed → ${scip_java_bin}"
}

install_scip_java
