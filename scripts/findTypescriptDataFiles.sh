#!/usr/bin/env bash

# Echoes a list of Typescript analysis data json files in the directory "artifacts/typescript" or subdirectories and having extension "json". 
# Each name will be prefixed by "typescript:project::"and separated by one space character.
# This list is meant to be used after the "-f" line command option for the jQAssistant scan command to include Typescript data files.
# Note: The directory name "typescript" (env TYPESCRIPT_ARTIFACTS_DIRECTORY) within "artifacts" is a convention 
#       that is then also used to exclude those json files from being analyzed by the json plugin.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Working directory containing the artifacts to be analyzed
TYPESCRIPT_ARTIFACTS_DIRECTORY=${TYPESCRIPT_ARTIFACTS_DIRECTORY:-"typescript"} # Subdirectory of "artifacts" containing the typescript analysis result json files for import

# Check if the artifacts directory exists
if [ ! -d "./${ARTIFACTS_DIRECTORY}" ] ; then
    echo "findTypescriptDataFiles: No files to analyze because of missing directory ${ARTIFACTS_DIRECTORY}" >&2
    echo "" # The artifact directory doesn't exist. There is no file to analyze.
    return 0
fi

# Check if there is a typescript directory within the artifacts directory
if [ ! -d "./${ARTIFACTS_DIRECTORY}/${TYPESCRIPT_ARTIFACTS_DIRECTORY}" ] ; then
    echo "findTypescriptDataFiles: No files to analyze because of missing directory ${ARTIFACTS_DIRECTORY}/${TYPESCRIPT_ARTIFACTS_DIRECTORY}" >&2
    echo "" # The directory artifact/typescript doesn't exist. There is no file to analyze.
    return 0
fi

find "./${ARTIFACTS_DIRECTORY}/${TYPESCRIPT_ARTIFACTS_DIRECTORY}" -type f -name '*.json' -exec echo {} \; | sed 's/^/typescript:project::/' | tr '\n' ' ' 