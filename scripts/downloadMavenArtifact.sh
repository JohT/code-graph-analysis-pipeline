#!/usr/bin/env bash

# Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central)
# Note: These command line arguments are required:
# -g Maven Group ID
# -a Maven Artifact Name
# -v Maven Artifact Version
# -t Maven Artifact Type (defaults to jar)
# -d Target directory for the downloaded file

# Requires download.sh

# Overrideable constants
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

# Default and initial values for command line options
groupId=""
artifactId=""
version=""
artifactType="jar"
targetDirectory="${ARTIFACTS_DIRECTORY}"

# Read  command line options
USAGE="downloadMavenArtifact: Usage: $0 [-g group_id] [-a artifact_id] [-v version] [-t type (default=jar)] [-d targetDirectory (default=${ARTIFACTS_DIRECTORY})]"
OPTIND=1
while getopts "g:a:v:t:d:" opt; do
  case ${opt} in
    g )
      groupId=${OPTARG}
      ;;
    a )
      artifactId=${OPTARG}
      ;;
    v )
      version=${OPTARG}
      ;;
    t )
      artifactType=${OPTARG}
      ;;
    d )
      targetDirectory=${OPTARG}
      ;;
    \? )
      echo "${USAGE}"
      exit 1
      ;;
  esac
done

if [[ -z ${groupId} || -z ${artifactId} || -z ${version} || -z ${artifactType} || -z ${targetDirectory} ]]; then
  echo "${USAGE}"
  exit 1
fi

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}

# Internal constants
BASE_URL="https://repo1.maven.org/maven2"
ARTIFACT_FILENAME="${artifactId}-${version}.${artifactType}"
GROUP_ID_FOR_API="$(echo "${groupId}" | tr '.' '/')"
DOWNLOAD_URL="${BASE_URL}/${GROUP_ID_FOR_API}/${artifactId}/${version}/${ARTIFACT_FILENAME}"

# Download Maven Artifact into the "targetDirectory"
if [ ! -f "./${targetDirectory}/${ARTIFACT_FILENAME}" ] ; then
    source ${SCRIPTS_DIR}/download.sh --url "${DOWNLOAD_URL}" || exit 1

    # Create artifacts targetDirectory if it doen't exist
    mkdir -p "./${targetDirectory}" || exit 1

    # Delete already existing older versions of the artifact
    rm -f "./${targetDirectory}/${artifactId}"* || exit 1

    # Copy artifact into artifacts targetDirectory
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${ARTIFACT_FILENAME}" "./${targetDirectory}" || exit 1
else
    echo "downloadMavenArtifact: ${ARTIFACT_FILENAME} already downloaded into target directory ${targetDirectory}"
fi

# Fail if Maven Download failed
if [ ! -f "${targetDirectory}/${ARTIFACT_FILENAME}" ] ; then
    echo "downloadMavenArtifact: Error: Failed to download ${ARTIFACT_FILENAME}"
    exit 1
fi