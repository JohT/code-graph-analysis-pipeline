#!/usr/bin/env bash

# Initializes a new analysis project by creating all necessary directories based on the given input parameter with the analysis name. 

# Note: This script needs to be executed in the root of this directory (= same directory as this file)

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

# Read the first (and only) parameter containing the name of the analysis.
analysisName="${1}"
if [ -z "${analysisName}" ]; then
    echo "init: Error: Missing parameter <analysisName>." >&2
    echo "init: Usage example: ${0} <analysisName>" >&2
    exit 1
fi

nameOfThisScript=$(basename "${0}")
if [ ! -f "./${nameOfThisScript}" ]; then
    echo "init: Error: Please execute the script in the root directory of the code-graph-analysis-pipeline repository." >&2
    echo "init:        Change to the directory of this ${nameOfThisScript} script and execute it from there." >&2
    exit 1
fi

# Check if initial password environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "init: Error: Environment variable NEO4J_INITIAL_PASSWORD is recommended to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Create the temporary directory for all analysis projects if it hadn't been created yet.
mkdir -p ./temp
cd ./temp

# Create the analysis directory inside the temp directory using the given parameter if it hadn't been created yet.
mkdir -p "./${analysisName}"
cd "./${analysisName}"

# Create the artifacts directory inside the analysis directory for e.g. Java jar/ear files if it hadn't been created yet.
mkdir -p "./${ARTIFACTS_DIRECTORY}"

# Create the source directory inside the analysis directory for source code projects/repositories if it hadn't been created yet.
mkdir -p "./${SOURCE_DIRECTORY}"

# Create symbolic links to the most common scripts for code analysis.
ln -s "./../../scripts/analysis/analyze.sh" .
ln -s "./../../scripts/startNeo4j.sh" .
ln -s "./../../scripts/stopNeo4j.sh" .

echo "init: Successfully initialized analysis project ${analysisName}" >&2