#!/usr/bin/env bash

# Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central)
# Note: These command line arguments are required:
# -g Maven Group ID
# -a Maven Artifact Name
# -v Maven Artifact Version
# -t Maven Artifact Type (defaults to jar)
# -d Target directory for the downloaded file

# Overrideable constants
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}

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

# Internal constants
BASE_URL="https://repo1.maven.org/maven2"
ARTIFACT_FILENAME="${artifactId}-${version}.${artifactType}"
GROUP_ID_FOR_API="$(echo "${groupId}" | tr '.' '/')"
DOWNLOAD_URL="${BASE_URL}/${GROUP_ID_FOR_API}/${artifactId}/${version}/${ARTIFACT_FILENAME}"

# Download Maven Artifact into the "targetDirectory"
if [ ! -f "./${targetDirectory}/${ARTIFACT_FILENAME}" ] ; then
    echo "downloadMavenArtifact: Downloading ${DOWNLOAD_URL} into target directory ${targetDirectory}"

    # Download Maven Artifact
    if ! curl -L --fail-with-body -O "${DOWNLOAD_URL}"; then
        echo "downloadMavenArtifact: Error: Failed to download ${ARTIFACT_FILENAME}"
        rm -f "${ARTIFACT_FILENAME}"
        exit 1
    fi

    # Check downloaded file size to be at least 100 bytes
    downloaded_file_size=$(wc -c "${ARTIFACT_FILENAME}" | awk '{print $1}')
    if [[ "${downloaded_file_size}" -le 600 ]]; then
        echo "downloadMavenArtifact: Error: Failed to download ${ARTIFACT_FILENAME}: Invalid Filesize: ${downloaded_file_size} bytes"
        rm -f "${ARTIFACT_FILENAME}"
        exit 1
    fi

    # Create artifacts targetDirectory if it doen't exist
    mkdir -p "./${targetDirectory}" || exit 1

    # Delete already existing older versions of the artifact
    rm -f "./${targetDirectory}/${artifactId}"* || exit 1

    # Move artifact to artifacts targetDirectory
    mv "${ARTIFACT_FILENAME}" "./${targetDirectory}" || exit 1
else
    echo "downloadMavenArtifact: ${ARTIFACT_FILENAME} already downloaded into target directory ${targetDirectory}"
fi

# Fail if Maven Download failed
if [ ! -f "${targetDirectory}/${ARTIFACT_FILENAME}" ] ; then
    echo "downloadMavenArtifact: Error: Failed to download ${ARTIFACT_FILENAME}"
    exit 1
fi