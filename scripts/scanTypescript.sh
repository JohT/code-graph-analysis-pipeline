#!/usr/bin/env bash

# Executes the npm package @jqassistant/ts-lc using npx to scan the Typescript projects in the source directory and create an intermediate json data file for the jQAssistant Typescript plugin.

# Uses: patchJQAssistantTypescriptPlugin.sh, detectChangedFiles.sh

# Note: This script must not output anything except for the return code to stdout.
#       All output of the scanning needs to be redirected to stderr using ">&2".

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

TYPESCRIPT_SCAN_HEAP_MEMORY=${TYPESCRIPT_SCAN_HEAP_MEMORY:-"4096"} # Heap memory in megabytes for Typescript scanning with (Node.js process). Defaults to 4096 MB.
echo "scanTypescript: TYPESCRIPT_SCAN_HEAP_MEMORY=${TYPESCRIPT_SCAN_HEAP_MEMORY}" >&2

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "scanTypescript: SCRIPTS_DIR=${SCRIPTS_DIR}" >&2

# Dry run for internal testing (not intended to be accessible from the outside)
TYPESCRIPT_SCAN_DRY_RUN=false 
if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = true ] ; then
    echo "scanTypescript: -> DRY RUN <- Scanning will only be logged, not executed." >&2
fi

if [ ! -d "./${SOURCE_DIRECTORY}" ] ; then
    echo "scanTypescript: Source directory '${SOURCE_DIRECTORY}' doesn't exist. The scan will therefore be skipped." >&2
    return 0
fi

if ! command -v "npx" &> /dev/null ; then
    echo "scanTypescript Error: Command npx not found. It's needed to execute @jqassistant/ts-lce to scan Typescript projects." >&2
    exit 1
fi

# Takes one parameter containing the directory to search.
# Returns all directories (multi-line) that contain a "package.json" file within the given base directory.
find_directories_with_package_json_file() {
    find -L "${1}" \
        -type d -name "node_modules" -prune -o \
        -type d -name "dist" -prune -o \
        -type d -name ".yalc" -prune -o \
        -type d -name "lib" -prune -o \
        -type d -name "libs" -prune -o \
        -type d -name "*test" -prune -o \
        -type d -name "*tests" -prune -o \
        -name "package.json" \
        -print0 \
        | xargs -0 -r -I {} dirname {}
}

# Takes one parameter containing the directory to scan for Typescript projects and the second one containing progress information.
# Executes the Typescript scan for the given base directory including subdirectories.
# Skips the scan in case of a dry run
scan_directory() {
    local source_directory_name; source_directory_name=$(basename "${1}");
    local progress_information; progress_information="${2}"

    echo "" >&2 # Output an empty line to have a clearer separation between each scan
    
    if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = false ] ; then
        echo "scanTypescript: $(date +'%Y-%m-%dT%H:%M:%S%z') Scanning ${source_directory_name} (${progress_information}) -----------------" >&2
        # Note: For later troubleshooting, the output is also copied to a dedicated log file using "tee".
        # Note: Don't worry about the hardcoded version number. It will be updated by Renovate using a custom Manager.
        # Note: NODE_OPTIONS --max-old-space-size=4096 increases the memory for scanning larger projects
        NODE_OPTIONS="${NODE_OPTIONS} --max-old-space-size=${TYPESCRIPT_SCAN_HEAP_MEMORY}" npx --yes @jqassistant/ts-lce@1.3.0 "${1}" --extension React 2>&1 | tee "${LOG_DIRECTORY}/jqassistant-typescript-scan-${directory_name}.log" >&2
    else
        echo "scanTypescript: Skipping scan of ${source_directory_name} (${progress_information}) -----------------" >&2
    fi
}

# Takes one parameter containing the directory to scan for Typescript projects.
# Returns true (=0) when the given directory contains a valid (existing and reasonable size) scan result file.
# Otherwise returns false
is_valid_scan_result() {
    if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = true ] ; then
        echo "scanTypescript: Info: No scan result expected in dry run mode." >&2
        return 1 # (false) Since dry run mode won't produce a scan result. Additionally, its intended to also dry-run the individual package scans.
    fi

    local scan_result_file="${1}/.reports/jqa/ts-output.json"
    if [ ! -f "${scan_result_file}" ] ; then
        echo "scanTypescript: Info: The scanned file ${scan_result_file} doesn't exist" >&2
        return 1 # (false) Since the file doesn't exist it is considered empty.
    fi

    local scan_file_size; scan_file_size=$(wc -c "${scan_result_file}" | awk '{print $1}')
    if [ "${scan_file_size}" -le "900" ]; then
        echo "scanTypescript: Info: The scanned file ${scan_result_file} is too small: ${scan_file_size} < 900" >&2
        false
    else
        echo "scanTypescript: The scanned file size: ${scan_file_size}" >&2
        true
    fi
}

# Scan and analyze Artifacts when they were changed
changeDetectionHashFilePath="./${SOURCE_DIRECTORY}/typescriptFileChangeDetectionHashFile.txt"
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --readonly --hashfile "${changeDetectionHashFilePath}" --paths "./${SOURCE_DIRECTORY}")

if [ "${changeDetectionReturnCode}" == "0" ]; then
    echo "scanTypescript: Files unchanged. Scan skipped."
fi

if [ "${changeDetectionReturnCode}" != "0" ] || [ "${TYPESCRIPT_SCAN_DRY_RUN}" = true ]; then
    echo "scanTypescript: Detected change (${changeDetectionReturnCode}). Scanning Typescript source using @jqassistant/ts-lce."
    
    mkdir -p "./runtime/logs"
    LOG_DIRECTORY="$(pwd)/runtime/logs"
    echo "scanTypescript: LOG_DIRECTORY=${LOG_DIRECTORY}" >&2

    source_directories=$( find -L "./${SOURCE_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d  -print0 | xargs -0 -r -I {} echo {} )   
    total_source_directories=$(echo "${source_directories}" | wc -l | awk '{print $1}')
    processed_source_directories=0

    for source_directory in ${source_directories}; do
        processed_source_directories=$((processed_source_directories + 1))
        progress_info_source_dirs="${processed_source_directories}/${total_source_directories}"
        if scan_directory "${source_directory}" "${progress_info_source_dirs}" && is_valid_scan_result "${source_directory}"; then
            continue # successful scan, proceed to next one.
        fi

        echo "scanTypescript: Info: Unsuccessful source directory scan. Trying to scan all contained packages individually." >&2
        contained_package_directories=$( find_directories_with_package_json_file "${source_directory}" )
        total_package_directories=$(echo "${contained_package_directories}" | wc -l | awk '{print $1}')
        processed_package_directories=0

        for contained_package_directory in ${contained_package_directories}; do
            processed_package_directories=$((processed_package_directories + 1))
            progress_info_package_dirs="${progress_info_source_dirs}: ${processed_package_directories}/${total_package_directories}"
            scan_directory "${contained_package_directory}" "${progress_info_package_dirs}"
        done
    done

    if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = false ] ; then
        changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${changeDetectionHashFilePath}" --paths "./${SOURCE_DIRECTORY}")
    fi
fi