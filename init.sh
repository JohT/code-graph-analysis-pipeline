#!/usr/bin/env bash

# Initializes a new analysis project by creating all necessary directories based on the given input parameter with the analysis name. 

# Note: This script needs to be executed in the root of this directory (= same directory as this file)

# Requires analyze.sh, startNeo4j.sh, stopNeo4j.sh, checkCompatibility.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts

# Local constants
SCRIPT_NAME=$(basename "${0}")
ERROR_COLOR='\033[0;31m'
NO_COLOR='\033[0m'

fail() {
    echo -e "${ERROR_COLOR}${SCRIPT_NAME}: ${1}${NO_COLOR}" >&2
    if [ -n "${2}" ]; then
        echo -e "${ERROR_COLOR}${SCRIPT_NAME}: ${2}${NO_COLOR}" >&2
    fi
    exit 1
}

# Validate the first (and only) parameter containing the name of the analysis.
analysisName="${1}"
if [ -z "${analysisName}" ]; then
    fail "Please specify the name of the project you want to analyze." "Example: ${0} my-project"
fi
if [ -d "./temp/${analysisName}" ]; then
    fail "Analysis project '${analysisName}' already exists in './temp/${analysisName}' directory." "Choose another name or delete it using 'rm -rf ./temp/${analysisName}' first and re-run the script."
fi

# Validate the execution directory
if [ ! -f "./${SCRIPT_NAME}" ]; then
    fail "Please re-execute the script in the root directory of the repository." "Use 'cd <path-to-repo>' and re-run the script."
fi

# Assure that the environment variable containing the Neo4j password is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    fail "Please set NEO4J_INITIAL_PASSWORD before running this script to avoid Neo4j startup issues later." "Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>' and re-run the script."
fi

createForwardingScript() {
    local originalScript="${1}"
    local scriptName;scriptName=$(basename "$originalScript")

    cp -n "${originalScript}" .
    echo "#!/usr/bin/env bash" > "./${scriptName}"
    # shellcheck disable=SC2016
    echo "${originalScript} \"\${@}\"" >> "./${scriptName}"
}

# Create the temporary directory for all analysis projects if it hadn't been created yet.
mkdir -p ./temp
cd ./temp

# Create the analysis directory inside the temp directory using the given parameter if it hadn't been created yet.
mkdir -p "./${analysisName}"
cd "./${analysisName}"

# Create the artifacts directory inside the analysis directory for e.g. Java jar/ear files if it hadn't been created yet.
mkdir -p "./${ARTIFACTS_DIRECTORY}"

# Create the source directory inside the analysis directory for source code projects/repositories if it hadn't been created yet.
mkdir -p "./${SOURCE_DIRECTORY}"

# Create forwarding scripts for the most important commands
createForwardingScript "./../../scripts/analysis/analyze.sh"
createForwardingScript "./../../scripts/startNeo4j.sh"
createForwardingScript "./../../scripts/stopNeo4j.sh"

source "${SCRIPTS_DIR}/scripts/checkCompatibility.sh"

echo ""
echo "${SCRIPT_NAME}: Successfully initialized analysis project ${analysisName}"
echo ""
echo "${SCRIPT_NAME}: Next steps:"
echo "${SCRIPT_NAME}:   1) Place your artifacts (e.g., Java jar/ear files) into this directory:"
echo "${SCRIPT_NAME}:      $(pwd)/${ARTIFACTS_DIRECTORY}"
echo "${SCRIPT_NAME}:   2) (Optional) Place your source code projects/repositories into this directory:"
echo "${SCRIPT_NAME}:      $(pwd)/${SOURCE_DIRECTORY}"
echo "${SCRIPT_NAME}:   3) Run './analyze.sh' inside 'temp/${analysisName}' to start the analysis."
echo ""