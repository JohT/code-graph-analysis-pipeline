#!/usr/bin/env bash

# Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph.

# CAUTION: This script deletes all relationships and nodes in the Neo4j Graph Database. 
# Note: The environment variable NEO4J_INITIAL_PASSWORD is required to login to Neo4j.

# Requires importGit.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.3.1"} # 2.0.3 is the newest version (june 2023) compatible with Neo4j v5,  Version 1.12.2 is compatible with Neo4j v4
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-neo4jv5"} #  Neo4j v5: "jqassistant-commandline-neo4jv5", Neo4j v4: "jqassistant-commandline-neo4jv4"
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4jv5-jqassistant.yaml"} #  Neo4j v5: "template-neo4jv5-jqassistant.yaml", Neo4j v4: "template-neo4jv4-jqassistant.yaml"

NEO4J_INITIAL_PASSWORD=${NEO4J_INITIAL_PASSWORD:-""} # Neo4j login password that was set to replace the temporary initial password
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Directory with the Java artifacts to scan and analyze
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")

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

# -- Collect all files and directories to scan ---------------------
directoriesAndFilesToScan=""

# Scan all files in the artifacts directory (e.g. *.ear, *.war, *.jar for Java)
if [ -d "${ARTIFACTS_DIRECTORY}" ] ; then
    directoriesAndFilesToScan="${directoriesAndFilesToScan},./${ARTIFACTS_DIRECTORY}"
fi

if [ -d "${SOURCE_DIRECTORY}" ] ; then
    # Scan Typescript analysis json data files in the source directory
    typescriptAnalysisFiles="$(find "${SOURCE_DIRECTORY}" -type f -path "*/.reports/jqa/ts-output.json" -exec echo typescript:project::{} \; | tr '\n' ',' | sed 's/,$/\n/')"
    if [ -n "${typescriptAnalysisFiles}" ]; then
        directoriesAndFilesToScan="${directoriesAndFilesToScan},${typescriptAnalysisFiles}"
    fi
    # Scan package.json files for npm (nodes package manager) in the source directory
    npmPackageJsonFiles="$(find "${SOURCE_DIRECTORY}" -type d -name node_modules -prune -o -name 'package.json' -print0 | xargs -0 -r -I {} | tr '\n' ',' | sed 's/,$/\n/')"
    if [ -n "${npmPackageJsonFiles}" ]; then
        directoriesAndFilesToScan="${directoriesAndFilesToScan},${npmPackageJsonFiles}"
    fi
fi

# ------------------------------------------------------------------

# Use jQAssistant to scan the downloaded artifacts and write the results into the separate, local Neo4j Graph Database
echo "resetAndScan: Using jQAssistant CLI version ${JQASSISTANT_CLI_VERSION} to scan the following files and directories:"
for directoryOrFileToScan in ${directoriesAndFilesToScan//,/ }; do
    echo " - ${directoryOrFileToScan}"
done

"${JQASSISTANT_BIN}"/jqassistant.sh scan -f "${directoriesAndFilesToScan}"

# Use jQAssistant to add dependencies between artifacts, package dependencies, artifact dependencies and the java version to the Neo4j Graph Database
echo "resetAndScan: Analyzing using jQAssistant CLI version ${JQASSISTANT_CLI_VERSION}"

"${JQASSISTANT_BIN}"/jqassistant.sh analyze

# Scan all git repositories within the "source" (default) folder, scan their git log (history) and import it.
source "${SCRIPTS_DIR}/importGit.sh"