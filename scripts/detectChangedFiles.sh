#!/usr/bin/env bash

# Detect changed files in the artifacts directory or in a given list of paths 
# using a text file containing the last hash code of the contents.
# The hash value is generated based on all files (their names and properties) within the artifacts directory.
# A change is detected when the current hash and the stored differ.
#
# Command line options:
# --readonly Detect changes without creating or updating the change detection file (stateless).
#            A second call without this option will be needed for the change detection to work.
#            This is helpful to decide if an operation should be done based on changes while waiting for its success to finally save the change state.
# --paths Comma-separated list of file- and directory-names that are used for calculating the hash based on their name and size.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable defaults
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
ARTIFACTS_CHANGE_DETECTION_HASH_FILE=${ARTIFACTS_CHANGE_DETECTION_HASH_FILE:-"artifactsChangeDetectionHash.txt"} # !DEPRECATED! Use CHANGE_DETECTION_HASH_FILE.
CHANGE_DETECTION_HASH_FILE=${CHANGE_DETECTION_HASH_FILE:-"${ARTIFACTS_CHANGE_DETECTION_HASH_FILE}"} # Name of the file that contains the hash code of the file list for change detection
CHANGE_DETECTION_HASH_FILE_PATH=${CHANGE_DETECTION_HASH_FILE_PATH:-"./${ARTIFACTS_DIRECTORY}/${CHANGE_DETECTION_HASH_FILE}"} # Default path of the file that contains the hash code of the file list for change detection. Can be overridden by a command line option.

# Function to display script usage
usage() {
  echo "Usage: $0 [--readonly]"
  echo "          [--paths <comma separated list of file and directory names> (default=artifacts)]"
  echo "          [--hashfile <path to the file that contains the hash for change detection> (default=env var CHANGE_DETECTION_HASH_FILE_PATH)]"
  exit 1
}

# Default values
readonlyMode=false
paths="./${ARTIFACTS_DIRECTORY}"
hashFilePath="${CHANGE_DETECTION_HASH_FILE_PATH}"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  value="${2}"

  case ${key} in
    --readonly)
      readonlyMode=true
      ;;
    --paths)
      paths="${value}"
      shift
      ;;
    --hashfile)
      hashFilePath="${value}"
      shift
      ;;
    *)
      echo "detectChangedFiles: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

if ${readonlyMode}; then
  echo "detectChangedFiles: Readonly mode activated. Change detection file won't be created." >&2
else
  echo "detectChangedFiles: ${hashFilePath} will be used as change detection file." >&2
fi

# Check if the paths parameter exist
if [ -z "${paths}" ] ; then
    echo 0 # 0=No change detected. The path list is empty. There is nothing to compare. Therefore assume that there are no changes.
    exit 0
fi

# Function to get file size
get_file_size() {
    if [ -f "$1" ]; then
        wc -c < "$1" | tr -d ' '
    else
        echo 0
    fi
}

# Function to process a single path
file_names_and_sizes() {
    if [ -d "$1" ]; then
        # If it's a directory, list all files inside 
        # except for "node_modules", "target", "temp" and the change detection file itself
        find "$1" \
          -type d -name "node_modules" -prune -o \
          -type d -name "target" -prune -o \
          -type d -name "temp" -prune -o \
          -not -path "${hashFilePath}" \
          -type f \
          -exec stat -f "%N %z" {} + \
        | sort 
    elif [ -f "$1" ]; then
        # If it's a file, just echo the file path
        stat -f "%N %z" < "$1"
    fi
}

# Function that takes a comma-separated list of file- and directory-names, 
# finds all files in the directories 
# and calculates the md5 hash for every of these .
get_md5_checksum_of_all_file_names_and_sizes() {
  local paths=${1}
  local total_paths; total_paths=$(echo "${paths}" | awk -F '[\t,]' '{print NF}')
  local all_files_and_sizes=""
  local processed_paths=0

  for path in ${paths//,/ }; do
      local files_and_their_size; files_and_their_size=$(file_names_and_sizes "${path}")
      all_files_and_sizes="${all_files_and_sizes}${files_and_their_size}"
      processed_paths=$((processed_paths + 1))
      echo -ne "detectChangedFiles: Calculate checksum progress: ($processed_paths/$total_paths)\r" >&2
  done
  echo "" >&2
  echo "${all_files_and_sizes}" | openssl md5 | awk '{print $2}'
}

# Use find to list all files in the directory with their properties,
# sort the output, and pipe it to md5 to create a hash
# Use openssl md5 that is at least available on Mac and Linux. 
# See: https://github.com/TRON-US/go-btfs/issues/90#issuecomment-517409369
CURRENT_FILES_HASH=$(get_md5_checksum_of_all_file_names_and_sizes "${paths}")

# Assume that the files where changed if the file containing the hash of the file list does not exist yet.
if [ ! -f "${hashFilePath}" ] ; then
    if [ "${readonlyMode}" = false ] ; then
        # Create the directory for the hash file if it hadn't existed yet.
        hash_file_directory=$(dirname "${hashFilePath}")
        mkdir -p "${hash_file_directory}"
        # Create the file containing the hash of the files list to a new file for the next call
        echo "${CURRENT_FILES_HASH}" > "${hashFilePath}"
        echo "detectChangedFiles: Change detection file created" >&2
    else
        echo "detectChangedFiles: Skipping file creation with content (=hash) ${CURRENT_FILES_HASH}" >&2
    fi
    echo 1 # 1=Change detected and change detection file created
    exit 0
fi

# Assume that there is no change if the saved hash is equal to the current one.
# Otherwise assume that the files where changed and overwrite the hash with the current one for the next call
if [[ $(< "${hashFilePath}") == "${CURRENT_FILES_HASH}" ]] ; then
    echo 0 # 0=No change detected
else
    if ! ${readonlyMode}; then
        # Write the updated hash into the file containing the hash of the files list for the next call
        echo "${CURRENT_FILES_HASH}" > "${hashFilePath}"
        echo "detectChangedFiles: Change detection file updated" >&2
    else
        echo "detectChangedFiles: Skipping file update with content (=hash) ${CURRENT_FILES_HASH}" >&2
    fi
    echo 2 # 2=Change detected and change detection file updated
fi