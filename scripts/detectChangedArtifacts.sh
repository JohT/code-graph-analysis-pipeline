#!/usr/bin/env bash

# Detect changed files in the artifacts directory with a text file containing the last hash code of the contents.
# The hash value is generated based on all files (their names and properties) within the artifacts directory.
# A change is detected when the current hash and the stored differ.
#
# Command line options:
# --readonly Detect changes without creating or updating the change detection file (stateless).
#            A second call without this option will be needed for the change detection to work.
#            This is helpful to decide if an operation should be done based on changes while waiting for its success to finally save the change state.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Function to display script usage
usage() {
  echo "Usage: $0 [--readonly]"
  exit 1
}

# Default values
readonlyMode=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --readonly)
      readonlyMode=true
      shift
      ;;
    *)
      echo "detectChangedArtifacts: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

if ${readonlyMode}; then
  echo "detectChangedArtifacts: Readonly mode activated. Change detection file won't be created." >&2
fi

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
ARTIFACTS_CHANGE_DETECTION_HASH_FILE=${ARTIFACTS_CHANGE_DETECTION_HASH_FILE:-"artifactsChangeDetectionHash.txt"} # Name of the file that contains the hash code of the file list for change detection
ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH="./${ARTIFACTS_DIRECTORY}/$ARTIFACTS_CHANGE_DETECTION_HASH_FILE"

# Check if the artifacts directory exists
if [ ! -d "./${ARTIFACTS_DIRECTORY}" ] ; then
    echo 0 # The artifact directory doesn't exist. There is nothing to compare. Therefore assume that there are no changes.
    exit 0
fi

# Use find to list all files in the directory with their properties,
# sort the output, and pipe it to md5 to create a hash
# Use openssl md5 that is at least available on Mac and Linux. 
# See: https://github.com/TRON-US/go-btfs/issues/90#issuecomment-517409369
CURRENT_ARTIFACTS_HASH="$( find "./$ARTIFACTS_DIRECTORY" -type f -not -name "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE}" -exec openssl md5 -binary {} + | openssl md5 | awk '{print $2}' )"

# Assume that the files where changed if the file containing the hash of the file list does not exist yet.
if [ ! -f "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}" ] ; then
    if ! ${readonlyMode}; then
        # Create the file containing the hash of the files list to a new file for the next call
        echo "${CURRENT_ARTIFACTS_HASH}" > "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}"
        echo "detectChangedArtifacts: Change detection file created" >&2
    fi
    echo 1
    exit 0
fi

# Assume that there is no change if the saved hash is equal to the current one.
# Otherwise assume that the files where changed and overwrite the hash with the current one for the next call
if [[ $(< "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}") == "$CURRENT_ARTIFACTS_HASH" ]] ; then
    echo 0
else
    if ! ${readonlyMode}; then
        # Write the updated hash into the file containing the hash of the files list for the next call
        echo "$CURRENT_ARTIFACTS_HASH" > "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}"
        echo "detectChangedArtifacts: Change detection file updated" >&2
    fi
    echo 2
fi