#!/usr/bin/env bash

# Detect changed files in the artifacts directory with a text file containing the last hash code of the contents.
# The hash value is generated based on all files (their names and properties) within the artifacts directory.
# A change is detected when the current hash and the stored one differ.

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
ARTIFACTS_CHANGE_DETECTION_HASH_FILE=${ARTIFACTS_CHANGE_DETECTION_HASH_FILE:-"artifactsChangeDetectionHash.txt"}
ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH="./${ARTIFACTS_DIRECTORY}/$ARTIFACTS_CHANGE_DETECTION_HASH_FILE"

# Check if the artifacts directory exists
if [ ! -d "./${ARTIFACTS_DIRECTORY}" ] ; then
    echo 0 # The artifact directory doesn't exist. There is nothing to compare. Therefore assume that there are no changes.
    exit 0
fi

# Use find to list all files in the directory with their properties,
# sort the output, and pipe it to md5 to create a hash
CURRENT_ARTIFACTS_HASH="$( find "./$ARTIFACTS_DIRECTORY" -type f -not -name "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE}" -exec stat -f "%N %p %z" {} + | sort | md5 -r )"

# Assume that the files where changed if the file containing the hash of the file list does not exist yet.
if [ ! -f "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}" ] ; then
    # Create the file containing the hash of the files list to a new file for the next call
    echo "${CURRENT_ARTIFACTS_HASH}" > "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}"
    echo 1
    exit 0
fi

# Assume that there is no change if the saved hash is equal to the current one.
# Otherwise assume that the files where changed and overwrite the hash with the current one for the next call
if [[ $(< "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}") == "$CURRENT_ARTIFACTS_HASH" ]] ; then
    echo 0
else
    # Write the updated hash into the file containing the hash of the files list for the next call
    echo "$CURRENT_ARTIFACTS_HASH" > "${ARTIFACTS_CHANGE_DETECTION_HASH_FILE_PATH}"
    echo 2
fi
