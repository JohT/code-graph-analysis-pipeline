#!/usr/bin/env bash

# Sets the initial password for the local Neo4j Graph Database (https://neo4j.com/download-center/#community).

# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.10.0"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Check if Neo4j is installed. Exit if not.
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
    echo "Neo4j not found in ${NEO4J_INSTALLATION_DIRECTORY}. Please run setupNeo4j.sh first."
    exit 1
fi

# Print the environment variable NEO4J_HOME that is used to execute the command
echo "setupNeo4jInitialPassword: Using ${NEO4J_INSTALLATION_DIRECTORY} as NEO4J_HOME"

# Extract the first component of the version number (=major version number)
NEO4J_MAJOR_VERSION_NUMBER=$(echo "$NEO4J_VERSION" | cut -d'.' -f1)

# Check if the first component is greater than or equal to 5
if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
    echo "setupNeo4jInitialPassword: Neo4j v5 or higher detected"
    # Neo4j version < 5
    # Set the initial password using a temporary NEO4J_HOME environment variable pointing to the current setup
    NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}" ${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin dbms set-initial-password "${NEO4J_INITIAL_PASSWORD}"
else
    echo "setupNeo4jInitialPassword: Neo4j v4 or lower detected"
    # Neo4j version >= 5
    # Set the initial password using a temporary NEO4J_HOME environment variable pointing to the current setup
    NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}" ${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin set-initial-password "${NEO4J_INITIAL_PASSWORD}"
fi

echo "setupNeo4jInitialPassword: Initial password set sucessfully"
