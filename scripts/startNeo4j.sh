#!/usr/bin/env bash

# Starts the local Neo4j Graph Database. 

# Note: Does nothing if the database is already running.
# Note: It requires Neo4j to be installed in the TOOLS_DIRECTORY.

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (april 2023)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

# Internal Constants
NEO4J_DIR="${TOOLS_DIRECTORY}/neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_BIN="${NEO4J_DIR}/bin"
WAIT_TIMES="1 2 4 8 16"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "startNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "startNeo4j: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Check if Neo4j is installed
if [ -d "${NEO4J_BIN}" ] ; then
    echo "startNeo4j: Using Neo4j binary directory ${NEO4J_BIN}"
else
    echo "startNeo4j: Directory ${NEO4J_BIN} doesn't exist. Please run setupNeo4j.sh first."
    exit 1
fi

# Check if Neo4j is stopped (not running) using a temporary NEO4J_HOME environment variable that points to the current installation
if NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status | grep -q "not" ; then
    echo "startNeo4j: Starting neo4j-${NEO4J_EDITION}-${NEO4J_VERSION} in ${NEO4J_DIR}"

    # Check if there is already a process that listens to the Neo4j HTTP port
    port_listener_process_id=$( lsof -t -i:"${NEO4J_HTTP_PORT}" -sTCP:LISTEN )
    if echo -n "${port_listener_process_id}" | grep -q ".*"; then
        echo "startNeo4j: There is already a process that listens to port ${NEO4J_HTTP_PORT}"
        ps -p "${port_listener_process_id}"
        echo "startNeo4j: Use this command to stop it: kill -9 \$( lsof -t -i:${NEO4J_HTTP_PORT} -sTCP:LISTEN )"
        exit 1
    fi

    # Start Neo4j using a temporary NEO4J_HOME environment variable that points to the current installation
    NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j start
    
    # Wait some time for the start of the database
    echo "${WAIT_TIMES}" | tr ' ' '\n' | while read waitTime; do
        echo "startNeo4j: Waiting for ${waitTime} second(s)"
        sleep ${waitTime}

        if ! NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status | grep -q "not" ; then
            echo "startNeo4j: Successfully started neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
            exit 0
        fi
    done
else
    echo "startNeo4j: neo4j-${NEO4J_EDITION}-${NEO4J_VERSION} already started"
fi

# Check if Neo4j is still not running using a temporary NEO4J_HOME environment variable that points to the current installation
if NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status | grep -q "not" ; then
    echo "startNeo4j: neo4j-${NEO4J_EDITION}-${NEO4J_VERSION} still not running. Something went wrong. Details see 'NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status'."
    exit 1
fi

source ${SCRIPTS_DIR}/waitForNeo4jHttp.sh || exit 1