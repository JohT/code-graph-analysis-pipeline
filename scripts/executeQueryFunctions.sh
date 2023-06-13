#!/usr/bin/env bash

# Provides functions to execute Cypher queries using either "executeQuery.sh" or Neo4j's "cypher-shell". 

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}

# Function to execute a cypher query from the given file (first and only argument) with the default method (HTTP)
execute_cypher() { 
    execute_cypher_http "${1}"
}

# Function to execute a cypher query from the given file (first and only argument) with the default method (HTTP)
execute_cypher_summarized() { 
   execute_cypher_http_summarized "${1}"
}

# Function to execute a cypher query from the given file (first and only argument) using Neo4j's HTTP API
execute_cypher_http() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"

    # (Neo4j HTTP API Script) Execute the Cyper query contained in the file and print the results as CSV
    source $SCRIPTS_DIR/executeQuery.sh "${cypherFileName}" || exit 1
}

# Function to execute a cypher query from the given file (first and only argument) with a summarized (console) output using Neo4j's HTTP API
execute_cypher_http_summarized() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"

    results=$( execute_cypher_http ${cypherFileName} | wc -l )
    results=$((results - 2))
    echo "$(basename -- "${cypherFileName}") (http) result lines: ${results}"
}

# Function to execute a cypher query from the given file (first and only argument) using "cypher-shell" provided by Neo4j
execute_cypher_shell() { 
    # Get the Cypher file name from the first argument
    cypherFileName=$1

    # Check if NEO4J_DIRECTORY exists
    if [ ! -d "${NEO4J_DIRECTORY}" ] ; then
        echo "Neo4j Installation Directory <${NEO4J_DIRECTORY}> doesn't exist. Please run setupNeo4j.sh first."
        exit 1
    fi

    # Check if NEO4J_BIN exists
    if [ ! -d "${NEO4J_BIN}" ] ; then
        echo "Neo4j Binary Directory <${NEO4J_BIN}> doesn't exist. Please run setupNeo4j.sh first."
        exit 1
    fi

    # (Neo4j Cyper Shell CLI) Execute the Cyper query contained in the file and print the results as CSV
    cat $cypherFileName | NEO4J_HOME="${NEO4J_DIRECTORY}" ${NEO4J_BIN}/cypher-shell -u neo4j -p "${NEO4J_INITIAL_PASSWORD}" --format plain || exit 1

    # Display the name of the Cypher file without its path at the bottom of the CSV (or console) separated by an empty line
    # TODO Find a solution to move the source reference to the last column name
    echo ""
    echo "\"Source Cypher File:\",\"$(basename -- "${cypherFileName}")\""
}

# Function to execute a cypher query from the given file (first and only argument) with a summarized (console) output using "cypher-shell" provided by Neo4j
execute_cypher_summarized_shell() { 
    # Get the Cypher file name from the first argument
    cypherFileName=$1

    results=$( execute_cypher_shell ${cypherFileName} | wc -l )
    results=$((results - 2))
    echo "$(basename -- "${cypherFileName}") (cypher-shell) result lines: ${results}" || exit 1
}