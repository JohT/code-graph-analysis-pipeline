#!/usr/bin/env bash

# This is an example for the analysis of the Java event-sourcing library "AxonFramework". 
# It includes the creation of the temporary directory, the working directory, the artifacts download and the analysis itself.

# Note: The first parameter is the version of "AxonFramework" to analyze.
#       All following parameters are forwarded to the "analyze" command.
# Note: This script is meant to be started in the root directory of this repository.
# Note: This script requires "cURL" ( https://curl.se ) to be installed.

# Requires: init.sh, downloadAxonFramework.sh, analyze.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Local constants
SCRIPT_NAME=$(basename "${0}")

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
EXAMPLE_SCRIPTS_DIR=${EXAMPLE_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
#echo "${SCRIPT_NAME}: EXAMPLE_SCRIPTS_DIR=${EXAMPLE_SCRIPTS_DIR}"

# Read the first unnamed input argument containing the version of the project
artifactsVersion=""
case "${1}" in
  "--"*) ;; # Skipping named command line options to forward them later to the "analyze" command
  *) 
    artifactsVersion="${1}" 
    echo "${SCRIPT_NAME}: Artifact version set to ${artifactsVersion}"
    shift || true
    ;;
esac

if [ -z "${artifactsVersion}" ]; then
  echo "${SCRIPT_NAME}: Optional parameter <version> is not specified. Detecting latest version..." >&2
  echo "${SCRIPT_NAME}: Usage example: $0 <version> <optional analysis parameter>" >&2
  artifactsVersion=$( "${EXAMPLE_SCRIPTS_DIR}/detectLatestGitTag.sh" --url "https://github.com/AxonFramework/AxonFramework.git" --prefix "axon-")
  echo "${SCRIPT_NAME}: Using latest version: ${artifactsVersion}" >&2
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "${SCRIPT_NAME}: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'." >&2
    exit 1
fi

# Initialize the analysis project
./init.sh "AxonFramework-${artifactsVersion}"
cd "./temp/AxonFramework-${artifactsVersion}"

# Download AxonFramework artifacts (jar files) from Maven
./../../scripts/downloader/downloadAxonFramework.sh "${artifactsVersion}"

# Start the analysis
./../../scripts/analysis/analyze.sh "${@}"