#!/usr/bin/env bash

# Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph.

# CAUTION: This script deletes all relationships and nodes in the Neo4j Graph Database. 
# Note: The environment variable NEO4J_INITIAL_PASSWORD is required to login to Neo4j.

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"1.12.2"} # Version 1.12.2 is the current version (april 2023)

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (april 2023)
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"}
NEO4J_BOLT_URI=${NEO4J_BOLT_URI:-"bolt://localhost:${NEO4J_BOLT_PORT}"}
NEO4J_USER=${NEO4J_USER:-"neo4j"}
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Directory with the Java artifacts to scan and analyze
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")

# Internal constants
JQASSISTANT_BIN="${TOOLS_DIRECTORY}/jqassistant-commandline-neo4jv3-${JQASSISTANT_CLI_VERSION}/bin"
JQASSISTANT_NEO4J_OPTIONS="-storeUri ${NEO4J_BOLT_URI} -storeUsername ${NEO4J_USER} -storePassword ${NEO4J_INITIAL_PASSWORD}"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your password'."
    exit 1
fi

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Check if jQAssistant is installed
if [ ! -d "${JQASSISTANT_BIN}" ] ; then
    echo "${JQASSISTANT_BIN} doesnt exist. Please run setupJQAssistant first."
    exit 1
else
    echo "Using jQAssistant binary directory ${JQASSISTANT_BIN}"
fi

# Use jQAssistant to scan the downloaded artifacts and write the results into the separate, local Neo4j Graph Database
"${JQASSISTANT_BIN}"/jqassistant.sh scan ${JQASSISTANT_NEO4J_OPTIONS} -reset -f ./${ARTIFACTS_DIRECTORY}

# Use jQAssistant to add dependencies between artifacts, package dependencies, artifact dependencies and the java version to the Neo4j Graph Database
"${JQASSISTANT_BIN}"/jqassistant.sh analyze ${JQASSISTANT_NEO4J_OPTIONS} \
                                   -reportDirectory ./runtime/jqassistant/report \
                                   -concepts classpath:Resolve,dependency:Package,dependency:Artifact,java:JavaVersion