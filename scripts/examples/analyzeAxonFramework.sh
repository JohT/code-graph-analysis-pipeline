#!/usr/bin/env bash

# This is an example for an analysis of AxonFramework 
# including the creation of the temporary directory, the working directory, the artifacts download and the analysis itself.

# Note: The first (and only) parameter is the version of AxonFramework to analyze.
# Note: This script is meant to be started in the root directory of this repository.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

artifactsVersion=$1
if [ -z "${artifactsVersion}" ]; then
  echo "analyzeAxonFramework: Optional parameter <version> is not specified. Detecting latest version..." >&2
  echo "analyzeAxonFramework: Usage example: $0 <version>" >&2
  artifactsVersion=$( ./../../scripts/examples/detectLatestGitTag.sh --url "https://github.com/AxonFramework/AxonFramework.git" --prefix "axon-")
  echo "analyzeAxonFramework: Using latest version: ${artifactsVersion}" >&2
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "analyzeAxonFramework: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'." >&2
    exit 1
fi

# Create the temporary directory for all analysis projects.
mkdir -p ./temp
cd ./temp

# Create the working directory for this specific analysis.
mkdir -p "./AxonFramework-${artifactsVersion}"
cd "./AxonFramework-${artifactsVersion}" 

# Create the artifacts directory that will contain the code to be analyzed.
mkdir -p ./artifacts

# Download AxonFramework artifacts (jar files) from Maven
./../../scripts/downloader/downloadAxonFramework.sh "${artifactsVersion}"

# Start the analysis
./../../scripts/analysis/analyze.sh