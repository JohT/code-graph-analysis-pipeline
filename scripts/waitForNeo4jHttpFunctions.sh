#!/usr/bin/env bash

# Waits until the HTTP Transactions API of Neo4j Graph Database is available.
# It queries the number of nodes and relationships to assert the connection.

# Requires executeQueryFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "waitForNeo4jHttp: SCRIPTS_DIR=$SCRIPTS_DIR"

# Get the "cypher" directory by taking the path of this script and going one directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}
echo "waitForNeo4jHttp: CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute a Cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

testDatabase() { 
    execute_cypher "${CYPHER_DIR}/Count_nodes_and_relationships.cypher" "--no-source-reference-column" "--omit-query-error-highlighting"
}

isDatabaseQueryable() { 
    local cypher_elements_query_result
    if cypher_elements_query_result=$(testDatabase);
    then
        echo "true"
     else
        echo "false"
    fi
}

waitUntilDatabaseIsQueryable() { 
    # List of wait times in seconds per retry
    local WAIT_TIMES="4 1 1 1 1 2 2 4 8 16 32"
    local retries=0
    local isDatabaseReady="false"

    # Wait until the HTTP endpoint is up and a cypher query can be executed
    echo "${WAIT_TIMES}" | tr ' ' '\n' | while read -r waitTime; do
        echo "waitForNeo4jHttp: Waiting for ${waitTime} second(s) before retry ${retries}"
        sleep "${waitTime}"

        # Queries node and relationship count as a basic validation
        isDatabaseReady=$(isDatabaseQueryable)
        if [[ ${isDatabaseReady} == "false" ]]; then
            retries=$((retries+1))
            continue; # query failed -> try again
        fi
        
        local queryResult=$(testDatabase || true)
        if [[ -n "${queryResult}" ]]; then 
            echo "waitForNeo4jHttp: Successfully accessed Neo4j HTTP API."
            echo "${queryResult}"
            exit 0
        fi
    done

    isDatabaseReady=$(isDatabaseQueryable)
    if [[ ${isDatabaseReady} == "false" ]]; then
        # Error: Couldn't access HTTP after all wait iterations
        echo "waitForNeo4jHttp: Error: Failed to access Neo4j HTTP API"
        exit 1
    fi
}