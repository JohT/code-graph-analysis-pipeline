#!/usr/bin/env bash

# Starts the local Neo4j Graph Database. 

# Note: Does nothing if the database is already running.
# Note: It requires Neo4j to be installed in the TOOLS_DIRECTORY.

# Requires waitForNeo4jHttp.sh,operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"2025.07.0"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "startNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "startNeo4j: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Detect Neo4j directory within the "tools" directory
neo4j_directory="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}" # Default directory using environment variables
if [ ! -d "${TOOLS_DIRECTORY}/${neo4j_directory}" ] ; then
    # Default directory doesn't exist. Try to find one with another version.
    # This usually happens when Neo4j had been updated while a local project is still using an older version.
    neo4j_directories=$(find "./${TOOLS_DIRECTORY}" -type d -name "neo4j-${NEO4J_EDITION}-*" | sort -r | head -n 1) 
    neo4j_directory=$(basename -- "$neo4j_directories")
    echo "startNeo4j: Auto detected Neo4j directory within the tools directory: ${neo4j_directory}"
fi

# Internal Constants
NEO4J_DIR="${TOOLS_DIRECTORY}/${neo4j_directory}"
NEO4J_DIR_WINDOWS="${TOOLS_DIRECTORY}\\${neo4j_directory}"
NEO4J_BIN="${NEO4J_DIR}/bin"
NEO4J_BIN_WINDOWS="${NEO4J_DIR_WINDOWS}\bin"

# Check if Neo4j is installed
if [ -d "${NEO4J_BIN}" ] ; then
    echo "startNeo4j: Using Neo4j binary directory ${NEO4J_BIN}"
else
    echo "startNeo4j: Directory ${NEO4J_BIN} doesn't exist. Please run setupNeo4j.sh first."
    exit 1
fi

# Include operation system function to for example detect Windows.
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

# Include functions to check or wait for the database to be ready
source "${SCRIPTS_DIR}/waitForNeo4jHttpFunctions.sh"

# Check if Neo4j is stopped (not running) using a temporary NEO4J_HOME environment variable that points to the current installation
isDatabaseReady=$(isDatabaseQueryable)
if [[ ${isDatabaseReady} == "false" ]]; then
    echo "startNeo4j: Starting ${neo4j_directory} in ${NEO4J_DIR}"

    # Check if there is already a process that listens to the Neo4j HTTP port
    if isWindows; then
        echo "startNeo4j: Skipping detection of processes listening to port ${NEO4J_HTTP_PORT} on Windows"
    else
        port_listener_process_id=$( lsof -t -i:"${NEO4J_HTTP_PORT}" -sTCP:LISTEN || true )
        if [ -n "${port_listener_process_id}" ]; then
            echo "startNeo4j: There is already a process that listens to port ${NEO4J_HTTP_PORT}"
            ps -p "${port_listener_process_id}"
            echo "startNeo4j: Use this command to stop it: kill -9 \$( lsof -t -i:${NEO4J_HTTP_PORT} -sTCP:LISTEN )"
            exit 1
        fi
    fi

    # Start Neo4j using a temporary NEO4J_HOME environment variable that points to the current installation
    if isWindows; then
        neo4jStartCommand="${NEO4J_BIN_WINDOWS}\neo4j.bat console --verbose"
        # On Windows it is necessary to take the absolute full qualified path to Neo4j for the environment variable NEO4J_HOME.
        # It also works without any environment variable but this would likely lead to ambiguity problems when there are multiple Neo4j instances installed.
        # If the path is wrong content-wise this leads to a ClassNotFoundException.
        # If the path is wrong syntactically there is an error while reading the plugins directory.
        windowsCommandEnvironment="set NEO4J_HOME=%cd%\\${NEO4J_DIR_WINDOWS}&& echo NEO4J_HOME=!NEO4J_HOME!"
        windowsCommand="${windowsCommandEnvironment}&&${neo4jStartCommand}"
        
        echo "startNeo4j: Starting Neo4j on Windows in a separate console window..."
        echo "startNeo4j: The following Windows command is used: ${windowsCommand}"
        echo "startNeo4j: IMPORTANT: Only close the console window when the scripts and your work is finished !"

        cmd //c start cmd //v //k "${windowsCommand}"
    else
        NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j start --verbose
    fi

   waitUntilDatabaseIsQueryable
   
else
    echo "startNeo4j: ${neo4j_directory} already started"
fi