#!/usr/bin/env bash

# Analyzes the TypeScript project "react-router" using SCIP-based type graph analysis.
# Downloads react-router source, generates a SCIP index, and runs the full analysis pipeline.

# Note: The first parameter is the version of "react-router" to analyze.
#       All following parameters are forwarded to the "analyze" command.
# Note: This script is meant to be started in the root directory of this repository.
# Note: Requires Node.js 18+, npm, curl, jq, and the scip CLI (installed automatically).

# Requires: init.sh, downloadReactRouter.sh, domains/scip-index-import/installScipCli.sh, createScipIndexTypescript.sh, analyze.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Local constants
SCRIPT_NAME=$(basename "${0}")

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}
INDICES_DIRECTORY=${INDICES_DIRECTORY:-"indices"}

## Get this "scripts/examples" directory if not already set
EXAMPLE_SCRIPTS_DIR=${EXAMPLE_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${0}")" >/dev/null && pwd -P )}

function usage() {
    local exit_code="${1:-1}"
    echo "Usage: ${SCRIPT_NAME} [<version>] [--help] [-- <analyze.sh options>]"
    echo ""
    echo "Arguments:"
    echo "  <version>   react-router version to analyze (e.g. 7.6.0). Auto-detects latest if omitted."
    echo ""
    echo "Prerequisites:"
    echo "  Node.js 18+, npm, curl, jq"
    echo "  (scip CLI is downloaded automatically if not present)"
    echo ""
    echo "Environment variables:"
    echo "  SOURCE_DIRECTORY    Source directory name (default: source)"
    echo "  INDICES_DIRECTORY   SCIP index directory name (default: indices)"
    echo "  NEO4J_INITIAL_PASSWORD  Required for Neo4j"
    echo ""
    echo "Examples:"
    echo "  ${SCRIPT_NAME}"
    echo "    # Analyze latest react-router version"
    echo "  ${SCRIPT_NAME} 7.6.0"
    echo "    # Analyze react-router 7.6.0"
    echo "  ${SCRIPT_NAME} 7.6.0 --report Csv --keep-running"
    echo "    # Analyze with specific report type, keeping Neo4j running"
    exit "${exit_code}"
}

# Read the first unnamed argument as project version (if not a flag)
projectVersion=""
case "${1:-}" in
    --help) usage 0 ;;
    "--"*) ;; # Named option — forward to analyze.sh
    *)
        projectVersion="${1:-}"
        [ $# -gt 0 ] && shift || true
        ;;
esac

if [ -z "${projectVersion}" ]; then
    echo "${SCRIPT_NAME}: Optional parameter <version> is not specified. Detecting latest version..." >&2
    projectVersion=$( "${EXAMPLE_SCRIPTS_DIR}/detectLatestGitTag.sh" --url "https://github.com/remix-run/react-router.git" --prefix "react-router@")
    echo "${SCRIPT_NAME}: Using latest version: ${projectVersion}" >&2
fi

if [ -z "${NEO4J_INITIAL_PASSWORD:-}" ]; then
    echo "${SCRIPT_NAME}: Error: NEO4J_INITIAL_PASSWORD must be set." >&2
    echo "${SCRIPT_NAME}: Use 'export NEO4J_INITIAL_PASSWORD=<your-password>' and re-run." >&2
    exit 1
fi

readonly WORKSPACE_NAME="react-router-scip-${projectVersion}"
readonly SOURCE_SUB_DIRECTORY="${SOURCE_DIRECTORY}/react-router-${projectVersion}"

echo "${SCRIPT_NAME}: Project version: ${projectVersion}"
echo "${SCRIPT_NAME}: Workspace: temp/${WORKSPACE_NAME}"

# Initialize analysis workspace
./init.sh "${WORKSPACE_NAME}"
cd "temp/${WORKSPACE_NAME}"

# Download react-router source into source/
./../../scripts/downloader/downloadReactRouter.sh "${projectVersion}"

# Set up nvm if available (for consistent Node.js version)
if [ -f "./${SOURCE_SUB_DIRECTORY}/.nvmrc" ]; then
    echo "${SCRIPT_NAME}: Setting up Node.js via nvm..."
    if [ -f "${HOME}/.nvm/nvm.sh" ]; then
        # shellcheck source=/dev/null
        . "${HOME}/.nvm/nvm.sh"
        nvm use || nvm install
    else
        echo "${SCRIPT_NAME}: Warning: nvm not found. Proceeding with current Node.js version."
    fi
fi

# Install JavaScript dependencies (pnpm, npm, yarn) so scip-typescript can index TypeScript
echo "${SCRIPT_NAME}: Installing JavaScript dependencies for react-router ${projectVersion}..."
./../../scripts/installJavaScriptDependencies.sh

# Install scip CLI if not already present (needed to convert binary → JSON)
./../../domains/scip-index-import/installScipCli.sh

# Generate SCIP index — pass --pnpm-workspaces since react-router uses a pnpm workspace
"${EXAMPLE_SCRIPTS_DIR}/createScipIndexTypescript.sh" "${SOURCE_SUB_DIRECTORY}" --pnpm-workspaces

# Copy the generated JSON index into the indices/ directory
mkdir -p "./${INDICES_DIRECTORY}"
cp "${SOURCE_SUB_DIRECTORY}/index.scip.json" "./${INDICES_DIRECTORY}/react-router-${projectVersion}.scip.json"
echo "${SCRIPT_NAME}: SCIP index copied to ${INDICES_DIRECTORY}/react-router-${projectVersion}.scip.json"

# Run the full analysis pipeline (analyze.sh picks up indices/ automatically)
./../../scripts/analysis/analyze.sh "${@}"
