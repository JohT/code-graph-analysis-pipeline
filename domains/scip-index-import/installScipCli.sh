#!/usr/bin/env bash

# Downloads the scip CLI binary to BIN_DIR (default: TOOLS_DIRECTORY/scip-cli within analysis workspace).
# The scip CLI is required to convert binary SCIP index files to JSON format:
#   scip print --json index.scip > index.scip.json
# Supports macOS (arm64, x86_64) and Linux (arm64, x86_64).
# This script is meant to be run from within an analysis workspace directory (temp/<name-of-project>).
# For usage from other locations, set BIN_DIR explicitly.

# Requires download.sh.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable defaults
SCIP_VERSION=${SCIP_VERSION:-"0.9.0"}

# Use analysis workspace TOOLS_DIRECTORY/scip-cli as default
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"./tools"}
BIN_DIR=${BIN_DIR:-"${TOOLS_DIRECTORY}/scip-cli"}

SCRIPT_NAME=$(basename "${BASH_SOURCE[0]}")

## Get the "scripts" directory relative to this domain script
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." >/dev/null && pwd -P )/scripts}

# Shared downloads directory for caching across analysis workspaces (consistent with scripts/download.sh default)
SHARED_DOWNLOADS_DIRECTORY=${SHARED_DOWNLOADS_DIRECTORY:-"$(dirname "$(pwd)")/downloads"}
export SHARED_DOWNLOADS_DIRECTORY

function usage() {
    local exit_code="${1:-1}"
    echo "Usage: ${SCRIPT_NAME} [--version X.Y.Z] [--bin-dir <path>] [--help]"
    echo ""
    echo "Options:"
    echo "  --version X.Y.Z   scip CLI version to download (default: ${SCIP_VERSION})"
    echo "  --bin-dir <path>  Directory to install the scip binary (default: ${TOOLS_DIRECTORY}/scip-cli)"
    echo "  --help            Print this usage and exit 0"
    echo ""
    echo "Environment variables:"
    echo "  SCIP_VERSION          scip CLI version (overrideable, default: ${SCIP_VERSION})"
    echo "  TOOLS_DIRECTORY       Base directory for tools (default: ./tools in analysis workspace)"
    echo "  BIN_DIR               Installation directory (overrideable, default: \${TOOLS_DIRECTORY}/scip-cli)"
    echo "  SHARED_DOWNLOADS_DIRECTORY  Shared download cache directory (default: ../downloads relative to cwd)"
    echo ""
    echo "Examples:"
    echo "  ${SCRIPT_NAME}"
    echo "    # Install scip ${SCIP_VERSION} to ./tools/scip-cli in analysis workspace"
    echo "  ${SCRIPT_NAME} --version 0.8.0 --bin-dir /usr/local/bin"
    exit "${exit_code}"
}

# Parse arguments
while [ $# -gt 0 ]; do
    case "${1}" in
        --version)
            SCIP_VERSION="${2:-}"
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

# Detects the operating system (macOS, Linux, or Windows via Git Bash/WSL)
# Sets SCIP_OS global variable to: darwin, linux
function detect_os() {
    local os
    os=$(uname -s)

    case "${os}" in
        Darwin) SCIP_OS="darwin" ;;
        Linux)  SCIP_OS="linux"  ;;
        CYGWIN* | MINGW* | MSYS* | Win*)
            # Git Bash, WSL, or native Windows
            SCIP_OS="linux"  # Use Linux binary on Windows via Git Bash/WSL
            ;;
        *) echo "${SCRIPT_NAME}: Error: Unsupported OS '${os}'. Supports macOS, Linux, and Windows (Git Bash/WSL)." >&2; exit 1 ;;
    esac
}

# Detects the CPU architecture
# Sets SCIP_ARCH global variable to: amd64 or arm64
function detect_architecture() {
    local arch
    arch=$(uname -m)

    case "${arch}" in
        x86_64|amd64) SCIP_ARCH="amd64" ;;
        arm64|aarch64) SCIP_ARCH="arm64" ;;
        *) echo "${SCRIPT_NAME}: Error: Unsupported architecture '${arch}'. Supports x86_64 and arm64." >&2; exit 1 ;;
    esac
}

function check_dependencies() {
    if ! command -v tar >/dev/null 2>&1; then
        echo "${SCRIPT_NAME}: Error: 'tar' is required but not found in PATH." >&2
        exit 1
    fi
}

function install_scip_cli() {
    local scip_bin="${BIN_DIR}/scip"

    # Check if scip is already installed globally
    if command -v scip >/dev/null 2>&1; then
        local existing_version
        existing_version=$(scip --version 2>&1 | head -1 || true)
        echo "${SCRIPT_NAME}: scip CLI already available globally (${existing_version}). Skipping download."
        return 0
    fi

    # Check if scip is already installed in BIN_DIR
    if [ -f "${scip_bin}" ]; then
        local existing_version
        existing_version=$("${scip_bin}" --version 2>&1 | head -1 || true)
        echo "${SCRIPT_NAME}: scip CLI already installed (${existing_version}). Skipping download."
        return 0
    fi

    detect_os
    detect_architecture
    check_dependencies

    local tarball="scip-${SCIP_OS}-${SCIP_ARCH}.tar.gz"
    local download_url="https://github.com/scip-code/scip/releases/download/v${SCIP_VERSION}/${tarball}"
    local tmp_dir
    tmp_dir=$(mktemp -d)
    
    # shellcheck disable=SC2064
    # Note: SC2064 is disabled intentionally. Variable expansion in trap must occur at trap set time,
    # not at trap execution time. This ensures the correct tmp_dir is cleaned up even if tmp_dir
    # is reassigned in nested contexts.
    trap "rm -rf '${tmp_dir}'" EXIT

    # Download tarball (cached in SHARED_DOWNLOADS_DIRECTORY) with SHA256 verification on fresh downloads
    "${SCRIPTS_DIR}/download.sh" --url "${download_url}" --sha256-url "${download_url}.sha256"

    echo "${SCRIPT_NAME}: Extracting scip binary..."
    if ! tar -xzf "${SHARED_DOWNLOADS_DIRECTORY}/${tarball}" -C "${tmp_dir}" scip 2>/dev/null; then
        echo "${SCRIPT_NAME}: Error: Failed to extract 'scip' from archive." >&2
        echo "${SCRIPT_NAME}: The release tarball format may have changed." >&2
        exit 1
    fi

    mkdir -p "${BIN_DIR}"
    cp "${tmp_dir}/scip" "${scip_bin}"
    chmod +x "${scip_bin}"

    local installed_version
    installed_version=$("${scip_bin}" --version 2>&1 | head -1 || true)
    echo "${SCRIPT_NAME}: scip CLI installed → ${scip_bin} (${installed_version})"
}

install_scip_cli
