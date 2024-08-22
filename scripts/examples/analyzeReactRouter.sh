#!/usr/bin/env bash

# This is an example for the analysis of a the Typescript project "react-router".
# It includes the creation of the temporary directory, the working directory, the artifacts download and the analysis itself.

# Note: The first (and only) parameter is the version of "react-router" to analyze.
# Note: This script is meant to be started in the root directory of this repository.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Read the first input argument containing the version of the project
projectVersion=$1
if [ -z "${projectVersion}" ]; then
  echo "analyzerReactRouter: Optional parameter <version> is not specified. Detecting latest version..." >&2
  echo "analyzerReactRouter: Usage example: $0 <version>" >&2
  projectVersion=$( ./../../scripts/examples/detectLatestGitTag.sh --url "https://github.com/remix-run/react-router.git" )
  echo "analyzerReactRouter: Using latest version: ${projectVersion}" >&2
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "analyzerReactRouter: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Create the temporary directory for all analysis projects.
mkdir -p ./temp
cd ./temp

# Create the working directory for this specific analysis.
mkdir -p "./react-router-${projectVersion}"
cd "./react-router-${projectVersion}" 

# Create the artifacts directory that will contain the code to be analyzed.
mkdir -p ./artifacts

# Download AxonFramework artifacts (jar files) from Maven
./../../scripts/downloader/downloadReactRouter.sh "${projectVersion}"

# Start the analysis
./../../scripts/analysis/analyze.sh