#!/usr/bin/env bash

# Downloads react-router (https://github.com/remix-run/react-router) from GitHub using git clone.
# The source files are written into the "source" directory of the current analysis directory.
# After scanning it with jQAssistant Typescript Plugin the resulting JSON will be moved into the "artifacts" directory.

# Note: This script is meant to be started within the temporary analysis directory (e.g. "temp/AnalysisName/")
# Note: react-router uses pnpm as package manager which needs to be installed first

# Requires downloadTypescriptProject.sh

# Fail on any error (errexit = exit on first error, errtrace = error inherited from sub-shell ,pipefail exist on errors within piped commands)
set -o errexit -o errtrace -o pipefail

# Read the first input argument containing the version(s) of the artifact(s)
if [ "$#" -ne 1 ]; then
  echo "downloadAntDesign: Error: Usage: $0 <version>" >&2
  exit 1
fi
projectVersion="${1}"
echo "downloadAntDesign: projectVersion=${projectVersion}"

## Get the directory of this script if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
DOWNLOADER_SCRIPTS_DIR=${DOWNLOADER_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "downloadReactRouter: DOWNLOADER_SCRIPTS_DIR=${DOWNLOADER_SCRIPTS_DIR}"

source "${DOWNLOADER_SCRIPTS_DIR}/downloadTypescriptProject.sh" \
  --url https://github.com/remix-run/react-router.git \
  --version "${projectVersion}" \
  --tag "react-router@${projectVersion}" \
  --packageManager pnpm