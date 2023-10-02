#!/usr/bin/env bash

# Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph.

# CAUTION: This script deletes all relationships and nodes in the Neo4j Graph Database. 
# Note: The environment variable NEO4J_INITIAL_PASSWORD is required to login to Neo4j.

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.0.8"} # 2.0.3 is the newest version (june 2023) compatible with Neo4j v5,  Version 1.12.2 is compatible with Neo4j v4
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-distribution"} #  Neo4j v5: "jqassistant-commandline-distribution", Neo4j v4: "jqassistant-commandline-neo4jv3"
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4jv5-jqassistant.yaml"} #  Neo4j v5: "template-neo4jv5-jqassistant.yaml", Neo4j v4: "template-neo4jv4-jqassistant.yaml"

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.10.0"}
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"} # Neo4j's own "Bolt Protocol" port
NEO4J_BOLT_URI=${NEO4J_BOLT_URI:-"bolt://localhost:${NEO4J_BOLT_PORT}"} # Neo4j's own "Bolt Protocol" address
NEO4J_USER=${NEO4J_USER:-"neo4j"} # Neo4j login user
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
#JQASSISTANT_NEO4J_OPTIONS="-D jqassistant.store.uri=${NEO4J_BOLT_URI} -D jqassistant.store.remote.username=${NEO4J_USER} -D jqassistant.store.remote.password=${NEO4J_INITIAL_PASSWORD}"
#JQASSISTANT_NEO4J_OPTIONS=-configurationLocations "${JQASSISTANT_CONFIG}/.jqassistant.yaml"

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
    echo "resetAndScan: Error: ${JQASSISTANT_BIN} doesnt exist. Please run setupJQAssistant first."
    exit 1
else
    echo "resetAndScan: Using jQAssistant binary directory ${JQASSISTANT_BIN}"
fi

# Create jQAssistant configuration YAML file by copying a template for it
mkdir -p "./.jqassistant" || exit 1
cp "${SCRIPTS_DIR}/configuration/${JQASSISTANT_CONFIG_TEMPLATE}" "./.jqassistant/" || exit 1

# Use jQAssistant to scan the downloaded artifacts and write the results into the separate, local Neo4j Graph Database
echo "resetAndScan: Scanning ${ARTIFACTS_DIRECTORY} with jQAssistant CLI version ${JQASSISTANT_CLI_VERSION}"

"${JQASSISTANT_BIN}"/jqassistant.sh scan -f ./${ARTIFACTS_DIRECTORY} || exit 1

# Use jQAssistant to add dependencies between artifacts, package dependencies, artifact dependencies and the java version to the Neo4j Graph Database
echo "resetAndScan: Analyzing ${ARTIFACTS_DIRECTORY} with jQAssistant CLI version ${JQASSISTANT_CLI_VERSION}"

"${JQASSISTANT_BIN}"/jqassistant.sh analyze