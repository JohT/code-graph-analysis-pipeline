#!/usr/bin/env bash

# Stops the local Neo4j Graph Database. 

# Note: Does nothing if the database is already stopped.

# Requires waitForNeo4jHttp.sh,operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"2025.05.1"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "stopNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "stopNeo4j: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Detect Neo4j directory within the "tools" directory
# If the version had been updated and a local project still uses the 
neo4j_directory="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}" # Default directory using environment variables
if [ ! -d "${TOOLS_DIRECTORY}/${neo4j_directory}" ] ; then
    # Default directory doesn't exist. Try to find one with another version.
    # This usually happens when Neo4j had been updated while a local project is still using an older version.
    neo4j_directories=$(find "./${TOOLS_DIRECTORY}" -type d -name "neo4j-${NEO4J_EDITION}-*" | sort -r | head -n 1) 
    neo4j_directory=$(basename -- "$neo4j_directories")
    echo "stopNeo4j: Auto detected Neo4j directory within the tools directory: ${neo4j_directory}"
fi

# Internal Constants
NEO4J_DIR="${TOOLS_DIRECTORY}/${neo4j_directory}"
NEO4J_BIN="${NEO4J_DIR}/bin"

# Check if Neo4j is installed
if [ -d "${NEO4J_BIN}" ] ; then
    echo "stopNeo4j: Using Neo4j binary directory ${NEO4J_BIN}"
else
    echo "stopNeo4j: Directory ${NEO4J_BIN} doesn't exist. Please run setupNeo4j.sh first."
    exit 1
fi

# Include operation system function to for example detect Windows.
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

# Include functions to check or wait for the database to be ready
source "${SCRIPTS_DIR}/waitForNeo4jHttpFunctions.sh"

# Check if Neo4j is stopped (not running) using a temporary NEO4J_HOME environment variable that points to the current installation
isDatabaseReady=$(isDatabaseQueryable)
if [[ ${isDatabaseReady} == "false" ]]; then
    echo "stopNeo4j: ${neo4j_directory} already stopped"
    exit 0
else
    if isWindows; then
        echo "stopNeo4j: IMPORTANT on Windows: Please close the console window or stop the service manually where ${neo4j_directory} is running."
    else
        # Stop Neo4j using a temporary NEO4J_HOME environment variable that points to the current installation
        NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j stop
    fi
fi

# Check if Neo4j is still not running using a temporary NEO4J_HOME environment variable that points to the current installation
isDatabaseReady=$(isDatabaseQueryable)
if [[ ${isDatabaseReady} == "false" ]]; then
    echo "stopNeo4j: Successfully stopped ${neo4j_directory}"
else
    if ! isWindows; then
        echo "stopNeo4j: ${neo4j_directory} still running. Something went wrong. Details see 'NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j${scriptExtension} status'."
        exit 1
    fi
fi

# Check if there are still processes running that listen to the Neo4j HTTP port
if isWindows; then
    echo "stopNeo4j: Skipping detection of processes listening to port ${NEO4J_HTTP_PORT} on Windows"
else
    port_listener_process_id=$( lsof -t -i:"${NEO4J_HTTP_PORT}" -sTCP:LISTEN || true )
    if [ -n "${port_listener_process_id}" ]; then
        echo "stopNeo4j: Terminating the following process that still listens to port ${NEO4J_HTTP_PORT}"
        ps -p "${port_listener_process_id}"
        # Terminate the process that is listening to the Neo4j HTTP port
        kill -9 "${port_listener_process_id}"
    fi
fi