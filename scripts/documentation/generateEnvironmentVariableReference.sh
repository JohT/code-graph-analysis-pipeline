#!/usr/bin/env bash

# Runs "appendEnvironmentVariable.sh" for every script file in the current directory and its sub directories.

# Requires appendEnvironmentVariable.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
DOCUMENTATION_SCRIPTS_DIR=${DOCUMENTATION_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the documentation generation scripts
echo "generateEnvironmentVariablesReference: DOCUMENTATION_SCRIPTS_DIR=${DOCUMENTATION_SCRIPTS_DIR}"

# Clear existing markdown document
source "${DOCUMENTATION_SCRIPTS_DIR}/appendEnvironmentVariables.sh" "clear" || exit 1

# Loop through all script files in the current directory
find . -type f -name "*.sh" | sort | while read -r scriptFile; do
  echo "generateEnvironmentVariablesReference: Searching for environment variables in ${scriptFile}"
  source "${DOCUMENTATION_SCRIPTS_DIR}/appendEnvironmentVariables.sh" "${scriptFile}" || exit 1
done