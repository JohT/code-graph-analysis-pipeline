#!/usr/bin/env bash

# This is an example for the analysis of a the Typescript project "ant-design".
# It includes the creation of the temporary directory, the working directory, the artifacts download and the analysis itself.

# Note: The first (and only) parameter is the version of "ant-design" to analyze.
# Note: This script is meant to be started in the root directory of this repository.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Read the first input argument containing the version of the artifacts
if [ "$#" -ne 1 ]; then
  echo "analyzerAntDesign Error: Usage: $0 <version>" >&2
  exit 1
fi
projectVersion=$1

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "analyzerAntDesign: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Create the temporary directory for all analysis projects.
mkdir -p ./temp
cd ./temp

# Create the working directory for this specific analysis.
mkdir -p "./ant-design-${projectVersion}"
cd "./ant-design-${projectVersion}" 

# Create the artifacts directory that will contain the code to be analyzed.
mkdir -p ./artifacts

# Download AxonFramework artifacts (jar files) from Maven
./../../scripts/downloader/downloadAntDesign.sh "${projectVersion}"

# Start the analysis
./../../scripts/analysis/analyze.sh