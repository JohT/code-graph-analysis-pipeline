#!/usr/bin/env bash

# Waits until the HTTP Transactions API of Neo4j Graph Database is available.
# It queries the number of nodes and relationships to assert the connection.

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "waitForNeo4jHttp: SCRIPTS_DIR=$SCRIPTS_DIR"

# List of wait times in seconds per retry
WAIT_TIMES="1 1 2 4 8 16 32 64"

count_elements_cypher_query="\"MATCH (n)-[r]-(m) RETURN COUNT(DISTINCT n) AS nodeCount, COUNT(DISTINCT r) AS relationshipCount\""
count_elements_query_request="{\"statements\":[{\"statement\":${count_elements_cypher_query},\"includeStats\": true}]}"

# Wait until the HTTP endpoint is up and a cypher query can be executed
echo "${WAIT_TIMES}" | tr ' ' '\n' | while read -r waitTime; do
    echo "waitForNeo4jHttp: Waiting for ${waitTime} second(s)"
    sleep "${waitTime}"

    # Calls the Neo4j HTTP API using cURL ( https://curl.se )
    if ! cyper_elements_query_result=$(curl --silent -S --fail-with-body -H Accept:application/json -H Content-Type:application/json \
                                        -u neo4j:"${NEO4J_INITIAL_PASSWORD}" \
                                        "http://localhost:${NEO4J_HTTP_PORT}/db/data/transaction/commit" \
                                        -d "${count_elements_query_request}");
    then
        continue; # query failed -> try again
    fi
    
    cyper_elements_query_error=$( echo "${cyper_elements_query_result}" | jq -r '.errors[0] // empty' )
    if [[ -n "${cyper_elements_query_error}" ]]; then 
        continue; # query returned an error message -> try again
    fi

    cyper_elements_query_success=$( echo "${cyper_elements_query_result}" | jq -r '.results[0] // empty' )
    if [[ -n "${cyper_elements_query_success}" ]]; then 
        echo "waitForNeo4jHttp: Successfully reached Neo4j HTTP API."
        echo -n "${cyper_elements_query_result}" | jq -r '(.results[0])? | .columns,(.data[].row)?|flatten | @csv'
        exit 0
    fi
done
