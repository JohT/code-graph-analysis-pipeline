#!/usr/bin/env bash

# Stops the local Neo4j Graph Database. 

# Note: Does nothing if the database is already stopped.

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (april 2023)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

# Internal Constants
NEO4J_DIR="${TOOLS_DIRECTORY}/neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_BIN="${NEO4J_DIR}/bin"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "stopNeo4j: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
fi

# Check if Neo4j is installed
if [ -d "${NEO4J_BIN}" ] ; then
    echo "stopNeo4j: Using Neo4j binary directoy ${NEO4J_BIN}"
else
    echo "stopNeo4j: Directory ${NEO4J_BIN} doesn't exist. Please run setupNeo4j.sh first."
    exit 1
fi

# Check if Neo4j is stopped (not running) using a temporary NEO4J_HOME environment variable that points to the current installation
if NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status 2>&1 | grep -q "not running" ; then
    echo "stopNeo4j: neo4j-${NEO4J_EDITION}-${NEO4J_VERSION} aleady stopped"
    exit 0
else
    # Stop Neo4j using a temporary NEO4J_HOME environment variable that points to the current installation
    NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j stop
fi

# Check if Neo4j is still not running using a temporary NEO4J_HOME environment variable that points to the current installation
if NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status 2>&1 | grep -q "not running" ; then
    echo "stopNeo4j: Successfully stopped neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
else
    echo "stopNeo4j: neo4j-${NEO4J_EDITION}-${NEO4J_VERSION} still running. Something went wrong. Details see 'NEO4J_HOME=${NEO4J_DIR} ${NEO4J_BIN}/neo4j status'."
    exit 1
fi

# Check if there are still processes running that listen to the Neo4j HTTP port
port_listener_process_id=$( lsof -t -i:"${NEO4J_HTTP_PORT}" -sTCP:LISTEN )
if echo -n "${port_listener_process_id}" | grep -q ".*"; then
    echo "stopNeo4j: Terminating the following process that still listens to port ${NEO4J_HTTP_PORT}"
    ps -p "${port_listener_process_id}"
    # Terminate the process that is listening to the Neo4j HTTP port
    kill -9 "${port_listener_process_id}"
fi
