#!/usr/bin/env bash

# Downloads AxonFramework (https://developer.axoniq.io/axon-framework) artifacts from Maven Central.
# The files are written into the "artifacts" directory of the current analysis directory.

# Note: The #-framed blocks are those that are specific to this download.
#       The other parts of the script can be reused/copied as a reference to write other download scripts.

# Note: This script is meant to be started within the temporary analysis directory (e.g. "temp/AnalysisName/")

# Requires downloadMavenArtifact.sh

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
  echo "Error (download${ANALYSIS_NAME}): Usage: $0 <version> (e.g. 4.9.3)" >&2
  exit 1
fi
ARTIFACTS_VERSION=$1
echo "download${ANALYSIS_NAME}: ARTIFACTS_VERSION=${ARTIFACTS_VERSION}"

## Get this "scripts/downloader" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
DOWNLOADER_SCRIPTS_DIR=${DOWNLOADER_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "download${ANALYSIS_NAME}: DOWNLOADER_SCRIPTS_DIR=${DOWNLOADER_SCRIPTS_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${DOWNLOADER_SCRIPTS_DIR}")} # Repository directory containing the shell scripts
echo "download${ANALYSIS_NAME}: SCRIPTS_DIR=${SCRIPTS_DIR}"

################################################################
# Download Artifacts that will be analyzed
ARTIFACTS_GROUP="org.axonframework"
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-configuration" -v"${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-disruptor" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-eventsourcing" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-messaging" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-modelling" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-test" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-server-connector" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-spring-boot-autoconfigure" -v "${ARTIFACTS_VERSION}" || exit 2
source "${SCRIPTS_DIR}/downloadMavenArtifact.sh" -g "${ARTIFACTS_GROUP}" -a "axon-tracing-opentelemetry" -v "${ARTIFACTS_VERSION}" || exit 2

# Download the git history (bare clone without working tree) into the "source" folder.
# This makes it possible to additionally import the git log into the graph
if [ ! -d "${SOURCE_DIRECTORY}/AxonFramework-${ARTIFACTS_VERSION}/.git" ]; then
  echo "download${ANALYSIS_NAME}: Getting bare git history of source code repository..."
  git clone --bare https://github.com/AxonFramework/AxonFramework.git --branch "axon-${ARTIFACTS_VERSION}" --single-branch "${SOURCE_DIRECTORY}/AxonFramework-${ARTIFACTS_VERSION}/.git"
fi
################################################################