#!/usr/bin/env bash

# Sets the initial password for the local Neo4j Graph Database (https://neo4j.com/download-center/#community).

# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (april 2023)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your password'."
    exit 1
fi

# Check if Neo4j is installed. Exit if not.
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
    echo "Neo4j not found in ${NEO4J_INSTALLATION_DIRECTORY}. Please run setupNeo4j.sh first."
    exit 1
fi

# Set the initial password using a temporary NEO4J_HOME environment variable pointing to the current setup
echo "setupNeo4jInitialPassword: Using ${NEO4J_INSTALLATION_DIRECTORY} as NEO4J_HOME"
NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}" ${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin set-initial-password "${NEO4J_INITIAL_PASSWORD}"