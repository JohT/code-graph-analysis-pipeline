#!/usr/bin/env bash

# Runs "appendEnvironmentVariables.sh" for every script file in all directories and subdirectories.
# Note: This script is intended to be run from the repository root.

# Requires appendEnvironmentVariables.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/documentation" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPT_NAME="generateEnvironmentVariableReference"
DOCUMENTATION_SCRIPTS_DIR=${DOCUMENTATION_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the documentation generation scripts
# echo "${SCRIPT_NAME}: DOCUMENTATION_SCRIPTS_DIR=${DOCUMENTATION_SCRIPTS_DIR}"

echo "${SCRIPT_NAME}: Generating ENVIRONMENT_VARIABLES.md..."

# Clear existing markdown document
if ! source "${DOCUMENTATION_SCRIPTS_DIR}/appendEnvironmentVariables.sh" "clear"; then
  echo "generateEnvironmentVariableReference: Error: Failed to clear existing ENVIRONMENT_VARIABLES.md."
  exit 1
fi

# Loop through all script files in the current directory and all subdirectories
find . -type d -name "temp" -prune -o -type f -name "*.sh" -print | sort | while read -r scriptFile; do
  # echo "${SCRIPT_NAME}: Searching for environment variables in ${scriptFile}"
  if ! source "${DOCUMENTATION_SCRIPTS_DIR}/appendEnvironmentVariables.sh" "${scriptFile}" 2>&1; then
    echo "generateEnvironmentVariableReference: Error: Failed to extract environment variables from ${scriptFile}."
    exit 1
  fi
done

echo "${SCRIPT_NAME}: Successfully generated ENVIRONMENT_VARIABLES.md."