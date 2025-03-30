#!/usr/bin/env bash

# Runs all test scripts (no Python and Chromium required).
# It only considers scripts in the "scripts" directory.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"} # Prefix to start a log group. Defaults to GitHub Actions log group start command.
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"} # Prefix to end a log group. Defaults to GitHub Actions log group end command.

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "runTests: SCRIPTS_DIR=${SCRIPTS_DIR}" >&2

# Run all report scripts
for test_script_file in "${SCRIPTS_DIR}"/test*.sh; do
    test_script_filename=$(basename -- "${test_script_file}");
    test_script_filename="${test_script_filename%.*}" # Remove file extension

    echo "${LOG_GROUP_START}Run ${test_script_filename}";
    echo "runTests: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting ${test_script_filename}...";

    source "${test_script_file}"

    echo "runTests: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished ${test_script_filename}";
    echo "${LOG_GROUP_END}";
done