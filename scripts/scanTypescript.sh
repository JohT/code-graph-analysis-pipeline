#!/usr/bin/env bash

# Executes the npm package @jqassistant/ts-lc using npx to scan the Typescript projects in the source directory and create an intermediate json data file for the jQAssistant Typescript plugin.

# Uses: patchJQAssistantTypescriptPlugin.sh, detectChangedFiles.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "scanTypescript SCRIPTS_DIR=${SCRIPTS_DIR}" >&2

if [ ! -d "./${SOURCE_DIRECTORY}" ] ; then
    echo "scanTypescript: Source directory '${SOURCE_DIRECTORY}' doesn't exist. The scan will therefore be skipped." >&2
    return 0
fi

if ! command -v "npx" &> /dev/null ; then
    echo "scanTypescript Error: Command npx not found. It's needed to execute @jqassistant/ts-lce to scan Typescript projects." >&2
    exit 1
fi

# Scan and analyze Artifacts when they were changed
changeDetectionHashFilePath="./${SOURCE_DIRECTORY}/typescriptFileChangeDetectionHashFile.txt"
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --readonly --hashfile "${changeDetectionHashFilePath}" --paths "./${SOURCE_DIRECTORY}")

if [ "${changeDetectionReturnCode}" == "0" ] ; then
    echo "scanTypescript: Files unchanged. Scan skipped."
else
    echo "scanTypescript: Detected change (${changeDetectionReturnCode}). Scanning Typescript source using @jqassistant/ts-lce."
    
    mkdir -p "./runtime/logs"
    LOG_DIRECTORY="$(pwd)/runtime/logs"
    echo "scanTypescript: LOG_DIRECTORY=${LOG_DIRECTORY}" >&2

    source_directories=$( find -L "./${SOURCE_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d  -print0 | xargs -0 -r -I {} echo {} )
    total_directories=$(echo "${source_directories}" | wc -l | awk '{print $1}')
    processed_directories=0

    for directory in ${source_directories}; do
        directory_name=$(basename "${directory}");
        # Note: This script must not output anything except for the return code to stdout,
        #       all output of the scanning needs to be redirected to stderr using ">&2".
        #       For later troubleshooting, the output is also copied to a dedicated log file using "tee".
        # Note: Don't worry about the hardcoded version number. It will be updated by Renovate using a custom Manager.
        # Note: NODE_OPTIONS --max-old-space-size=4096 increases the memory for larger projects to scan
        NODE_OPTIONS="${NODE_OPTIONS} --max-old-space-size=4096" npx --yes @jqassistant/ts-lce@1.3.0 "${directory}" --extension React 2>&1 | tee "${LOG_DIRECTORY}/jqassistant-typescript-scan-${directory_name}.log" >&2
        processed_directories=$((processed_directories + 1))
        echo "" >&2
        echo "scanTypescript: Scanned ${directory_name} (${processed_directories}/${total_directories}) ----------------------" >&2
        echo "" >&2
    done

    changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${changeDetectionHashFilePath}" --paths "./${SOURCE_DIRECTORY}")
fi