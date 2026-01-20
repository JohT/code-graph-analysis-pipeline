#!/usr/bin/env bash

# Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph.

# CAUTION: This script deletes all relationships and nodes in the Neo4j Graph Database. 
# Note: The environment variable NEO4J_INITIAL_PASSWORD is required to login to Neo4j.

# Command line options:
#   This script takes one parameter that contains the comma-separated list of paths to scan

# Requires importGit.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.9.0-RC1"} # Version number of the jQAssistant command line interface. Version 1.12.2 is compatible with Neo4j v4
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-neo4jv5"} # Name of the jQAssistant Maven artifact
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4j-remote-jqassistant.yaml"} # Name of the template file for the jqassistant configuration. Neo4j >= 2025.x: "template-neo4j-remote-jqassistant.yaml",  Neo4j v5: "template-neo4jv5-jqassistant.yaml", Neo4j v4: "template-neo4jv4-jqassistant.yaml"

NEO4J_INITIAL_PASSWORD=${NEO4J_INITIAL_PASSWORD:-""} # Neo4j login password that was set to replace the temporary initial password
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Directory with the Java artifacts to scan and analyze
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "resetAndScan: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Internal constants
JQASSISTANT_DIRECTORY="${TOOLS_DIRECTORY}/${JQASSISTANT_CLI_ARTIFACT}-${JQASSISTANT_CLI_VERSION}"
JQASSISTANT_BIN="${JQASSISTANT_DIRECTORY}/bin"
JQASSISTANT_CONFIG_TEMPLATE_PATH="${SCRIPTS_DIR}/configuration/${JQASSISTANT_CONFIG_TEMPLATE}"

# Parse the single parameter that contains the comma-separated file and directory names to scan.
if [ "$#" -eq 0 ]; then
    echo "resetAndScan: Skipping reset and scan since no paths to scan were passed."
    return 0
else
    directoriesAndFilesToScan="$1"
    shift
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "resetAndScan: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "resetAndScan: Error: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Check if jQAssistant is installed
if [ ! -d "${JQASSISTANT_BIN}" ] ; then
    echo "resetAndScan: Error: ${JQASSISTANT_BIN} doesn't exist. Please run setupJQAssistant first."
    exit 1
else
    echo "resetAndScan: Using jQAssistant binary directory ${JQASSISTANT_BIN}"
fi

# Create jQAssistant configuration YAML file by copying it from a corresponding template
mkdir -p "./.jqassistant"

if [ ! -f "./.jqassistant/${JQASSISTANT_CONFIG_TEMPLATE}" ]; then
    cp "${JQASSISTANT_CONFIG_TEMPLATE_PATH}" "./.jqassistant/"
    echo "resetAndScan: jQAssistant configuration copied from configuration template"
else
    echo "resetAndScan: jQAssistant configuration won't be changed since it already exists."
fi

# Use jQAssistant to scan the downloaded artifacts and stores the results into the local Neo4j Graph Database
echo "resetAndScan: Using jQAssistant CLI version ${JQASSISTANT_CLI_VERSION} to scan the following files and directories:"
for directoryOrFileToScan in ${directoriesAndFilesToScan//,/ }; do
    echo " - ${directoryOrFileToScan}"
done

"${JQASSISTANT_BIN}"/jqassistant.sh scan -f "${directoriesAndFilesToScan}"

# Use jQAssistant to add dependencies between artifacts, package dependencies, artifact dependencies and the java version to the Neo4j Graph Database
echo "resetAndScan: Analyzing using jQAssistant CLI version ${JQASSISTANT_CLI_VERSION}"

"${JQASSISTANT_BIN}"/jqassistant.sh analyze

# Scan all git repositories within the "source" (default) folder and import their git log (history) if configured.
time source "${SCRIPTS_DIR}/importGit.sh"