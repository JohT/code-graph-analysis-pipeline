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

# ------ Switches for internal testing and debugging ------------
# - Dry run for internal testing (for now not intended to be accessible from the outside)
TYPESCRIPT_SCAN_DRY_RUN=false # Default = false

if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = true ] ; then
    echo "scanTypescript: -> DRY RUN <- Scanning will only be logged, not executed." >&2
fi

# - Change detection for internal testing (for now not intended to be accessible from the outside)
TYPESCRIPT_SCAN_CHANGE_DETECTION=true # Default = true
if [ "${TYPESCRIPT_SCAN_CHANGE_DETECTION}" = false ] ; then
    echo "scanTypescript: -> CHANGE_DETECTION OFF <- Scanning will also be done for unchanged sources." >&2
fi
# ---------------------------------------------------------------

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
        -path "${1}/package.json" -prune -o \
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
    local COLOR_DARK_GREY='\033[0;30m'
    local COLOR_DEFAULT='\033[0m'

    echo "" >&2 # Output an empty line to have a clearer separation between each scan
    
    if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = false ] ; then
        echo "scanTypescript: $(date +'%Y-%m-%dT%H:%M:%S%z') Scanning ${source_directory_name} (${progress_information}) -----------------" >&2
        # Note: For later troubleshooting, the output is also copied to a dedicated log file using "tee".
        # Note: Don't worry about the hardcoded version number. It will be updated by Renovate using a custom Manager.
        # Note: NODE_OPTIONS --max-old-space-size=4096 increases the memory for scanning larger projects
        echo -e "${COLOR_DARK_GREY}"
        NODE_OPTIONS="${NODE_OPTIONS} --max-old-space-size=${TYPESCRIPT_SCAN_HEAP_MEMORY}" npx --yes @jqassistant/ts-lce@1.3.2 "${1}" --extension React 2>&1 | tee "${LOG_DIRECTORY}/jqassistant-typescript-scan-${source_directory_name}.log" >&2
        echo -e "${COLOR_DEFAULT}"
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

is_change_detected() {
    local COLOR_DARK_GREY='\033[0;30m'
    local COLOR_DEFAULT='\033[0m'    
    local source_directory_name; source_directory_name=$(basename "${source_directory}");

    echo -e "${COLOR_DARK_GREY}"
    changeDetectionHashFilePath="./${SOURCE_DIRECTORY}/typescriptScanChangeDetection-${source_directory_name}.sha"
    changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --readonly --hashfile "${changeDetectionHashFilePath}" --paths "${source_directory}")
    echo -e "${COLOR_DEFAULT}"
    
    if [ "${changeDetectionReturnCode}" == "0" ] && [ "${TYPESCRIPT_SCAN_CHANGE_DETECTION}" = true ]; then
        true
    else
        false
    fi
}

write_change_detection_file() {
    # The dry-run shouldn't write anything. Therefore, writing the change detection file is skipped regardless of TYPESCRIPT_SCAN_CHANGE_DETECTION.
    if [ "${TYPESCRIPT_SCAN_DRY_RUN}" = false ] ; then
        changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedFiles.sh" --hashfile "${changeDetectionHashFilePath}" --paths "${source_directory}")
    fi    
}

mkdir -p "./runtime/logs"
LOG_DIRECTORY="$(pwd)/runtime/logs"
echo "scanTypescript: LOG_DIRECTORY=${LOG_DIRECTORY}" >&2

source_directories=$( find -L "./${SOURCE_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d -print0 | xargs -0 -r -I {} echo {} )   
total_source_directories=$(echo "${source_directories}" | wc -l | awk '{print $1}')
processed_source_directories=0

for source_directory in ${source_directories}; do
    processed_source_directories=$((processed_source_directories + 1))
    progress_info_source_dirs="${processed_source_directories}/${total_source_directories}"

    # Scan and analyze Typescript sources only when they had been changed
    if is_change_detected; then
        echo "scanTypescript: Files in ${source_directory} unchanged. Scan skipped."
        continue # skipping scan since it had already be done according to change detection.
    fi

    #Debugging log for change detection. "scan_directory" already logs scanning and the source directory.
    #echo "scanTypescript: Detected change (${changeDetectionReturnCode}) in ${source_directory}. Scanning Typescript source using @jqassistant/ts-lce."

    if [ -f "${source_directory}/tsconfig.json" ] \
    && scan_directory "${source_directory}" "${progress_info_source_dirs}" \
    && is_valid_scan_result "${source_directory}"
    then
        write_change_detection_file   
        continue # successfully scanned a standard Typescript project (with tsconfig.json file). proceed with next one.
    fi

    echo "scanTypescript: Info: Unsuccessful or skipped source directory scan. Scan all contained packages individually." >&2
    contained_package_directories=$( find_directories_with_package_json_file "${source_directory}" )
    #Debugging: List all package directories.
    #echo "scanTypescript: contained_package_directories:" >&2
    #echo "${contained_package_directories}" >&2
    total_package_directories=$(echo "${contained_package_directories}" | wc -l | awk '{print $1}')
    processed_package_directories=0

    main_source_directory_name=$(basename "${source_directory}");

    for contained_package_directory in ${contained_package_directories}; do
        processed_package_directories=$((processed_package_directories + 1))
        progress_info_package_dirs="${main_source_directory_name} ${progress_info_source_dirs}: ${processed_package_directories}/${total_package_directories}"
        scan_directory "${contained_package_directory}" "${progress_info_package_dirs}"
    done

    write_change_detection_file
done
