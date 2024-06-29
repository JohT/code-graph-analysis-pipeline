#!/usr/bin/env bash

# Downloads react-router (https://github.com/remix-run/react-router) from GitHub using git clone.
# The source files are written into the "source" directory of the current analysis directory.
# After scanning it with jQAssistant Typescript Plugin the resulting JSON will be moved into the "artifacts" directory.

# Note: The #-framed blocks are those that are specific to this download.
#       The other parts of the script can be reused/copied as a reference to write other download scripts.

# Note: This script is meant to be started within the temporary analysis directory (e.g. "temp/AnalysisName/")

# Note: react-router uses pnpm as package manager which needs to be installed

# Fail on any error (errexit = exit on first error, errtrace = error inherited from sub-shell ,pipefail exist on errors within piped commands)
set -o errexit -o errtrace -o pipefail

# Get the analysis name from the middle part of the current file name (without prefix "download" and without extension)
SCRIPT_FILE_NAME="$(basename -- "${BASH_SOURCE[0]}")"
SCRIPT_FILE_NAME_WITHOUT_EXTENSION="${SCRIPT_FILE_NAME%%.*}"
SCRIPT_FILE_NAME_WITHOUT_PREFIX_AND_EXTENSION="${SCRIPT_FILE_NAME_WITHOUT_EXTENSION##download}"
ANALYSIS_NAME="${SCRIPT_FILE_NAME_WITHOUT_PREFIX_AND_EXTENSION}"
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")

echo "download${ANALYSIS_NAME}: SCRIPT_FILE_NAME=${SCRIPT_FILE_NAME}"
echo "download${ANALYSIS_NAME}: SCRIPT_FILE_NAME_WITHOUT_EXTENSION=${SCRIPT_FILE_NAME_WITHOUT_EXTENSION}"
echo "download${ANALYSIS_NAME}: ANALYSIS_NAME=${ANALYSIS_NAME}"

# Read the first input argument containing the version(s) of the artifact(s)
if [ "$#" -ne 1 ]; then
  echo "Error (download${ANALYSIS_NAME}): Usage: $0 <version>" >&2
  exit 1
fi
PROJECT_VERSION=$1
echo "download${ANALYSIS_NAME}: PROJECT_VERSION=${PROJECT_VERSION}"

# Create runtime logs directory if it hasn't existed yet
mkdir -p ./runtime/logs

################################################################
# Download react-router source files to be analyzed
################################################################
git clone https://github.com/remix-run/react-router.git "${SOURCE_DIRECTORY}"
(
  cd "${SOURCE_DIRECTORY}" || exit
  git checkout "react-router@${PROJECT_VERSION}" || exit
  pnpm install --frozen-lockfile || exit
  npx --yes @jqassistant/ts-lce >./../runtime/logs/jqassistant-typescript-scan.log 2>&1 || exit
)
mkdir -p artifacts
mv -nv "${SOURCE_DIRECTORY}/.reports/jqa/ts-output.json" "artifacts/ts-react-router-${PROJECT_VERSION}.json"
################################################################