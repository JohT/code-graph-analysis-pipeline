#!/usr/bin/env bash

# Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central)
# Note: These command line arguments are required:
# -g Maven Group ID
# -a Maven Artifact Name
# -v Maven Artifact Version
# -t Maven Artifact Type (defaults to jar)

# Read options
ARTIFACT_TYPE="jar"
OPTIND=1
while getopts "g:a:v:t:" opt; do
  case ${opt} in
    g )
      GROUP_ID=${OPTARG}
      ;;
    a )
      ARTIFACT_ID=${OPTARG}
      ;;
    v )
      VERSION=${OPTARG}
      ;;
    t )
      ARTIFACT_TYPE=${OPTARG}
      ;;
    \? )
      echo "Usage: $0 [-g group_id] [-a artifact_id] [-v version] [-t type (default=jar)]"
      exit 1
      ;;
  esac
done

if [[ -z ${GROUP_ID} || -z ${ARTIFACT_ID} || -z ${VERSION} || -z ${ARTIFACT_TYPE} ]]; then
  echo "Usage: $0 [-g group_id] [-a artifact_id] [-v version] [-t type (default=jar)]"
  exit 1
fi

# Overrideable constants
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}

# Internal constants
BASE_URL="https://repo1.maven.org/maven2"
ARTIFACT_FILENAME="${ARTIFACT_ID}-${VERSION}.${ARTIFACT_TYPE}"
GROUP_ID_FOR_API="$(echo "${GROUP_ID}" | tr '.' '/')"
DOWNLOAD_URL="${BASE_URL}/${GROUP_ID_FOR_API}/${ARTIFACT_ID}/${VERSION}/${ARTIFACT_FILENAME}"

# Download Maven Artifact into the ARTIFACTS_DIRECTORY
if [ ! -f "${ARTIFACTS_DIRECTORY}/${ARTIFACT_FILENAME}" ] ; then
    echo "Downloading ${DOWNLOAD_URL}"

    # Download Maven Artifact
    curl -L --fail-with-body -O "${DOWNLOAD_URL}"

    # Create artifacts directory if it doen't exist
    mkdir -p "${ARTIFACTS_DIRECTORY}"

    # Delete already existing older versions of the artifact
    rm -f "${ARTIFACTS_DIRECTORY}/${ARTIFACT_ID}"*

    # Move artifact to artifacts directory
    mv "${ARTIFACT_FILENAME}" "${ARTIFACTS_DIRECTORY}"
else
    echo "${ARTIFACT_FILENAME} already downloaded"
fi

# Fail if Maven Download failed
if [ ! -f "${ARTIFACTS_DIRECTORY}/${ARTIFACT_FILENAME}" ] ; then
    echo "Failed to download ${ARTIFACT_FILENAME}"
    exit 1
fi