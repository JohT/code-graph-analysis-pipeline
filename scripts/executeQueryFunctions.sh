#!/usr/bin/env bash

# Provides functions to execute Cypher queries using either "executeQuery.sh" or Neo4j's "cypher-shell". 

# Requires executeQuery.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts

# Extract the value of one key out of a "key=value" array e.g. for query parameters. 
# The first argument is the name of the target key.
# All following arguments are the "key=value" parameters.
# Example: `extractQueryParameter "b" "a=1" "b=2" "c=3"` returns `2`
extractQueryParameter() {
    target_key=${1}
    shift # ignore first argument containing the query file name

    for arg in "${@}"; do
        key=$(echo "$arg" | cut -d'=' -f1)
        value=$(echo "$arg" | cut -d'=' -f2)
        if [ "${key}" = "${target_key}" ]; then
            echo "${value}"
            break
        fi
    done
}

# Function to execute a cypher query from the given file (first argument) with the default method
execute_cypher() { 
    execute_cypher_http "${@}" # "${@}": Get all function arguments and forward them
}

# Function to execute a cypher query from the given file (first argument) with the default method and just return the number of results
execute_cypher_summarized() { 
    execute_cypher_http_summarized "${@}" # "${@}": Get all function arguments and forward them
}

# Function to execute a cypher query from the given file (first argument) with the default method and fail if there is no result
execute_cypher_expect_results() { 
    execute_cypher_http_expect_results "${@}" # "${@}": Get all function arguments and forward them
}

# Function to execute a cypher query from the given file (first and only argument) using Neo4j's HTTP API
execute_cypher_http() { 
    # (Neo4j HTTP API Script) Execute the Cypher query contained in the file and print the results as CSV
    source "${SCRIPTS_DIR}/executeQuery.sh" "${@}" # "${@}": Get all function arguments and forward them
}

# Function to execute a cypher query from the given file (first and only argument) with a summarized (console) output using Neo4j's HTTP API
execute_cypher_http_summarized() { 
    results=$( execute_cypher_http "${@}" | wc -l ) # "${@}": Get all function arguments and forward them
    results=$((results - 2))
    echo "$(basename -- "${cypherFileName}") (via http) result lines: ${results}"
}

# Function to execute a cypher query from the given file (first and only argument) that fails on no result using Neo4j's HTTP API
execute_cypher_http_expect_results() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"
    results=$( execute_cypher_http "${cypherFileName}" | wc -l )
    results=$((results - 1))
    if [[ "$results" -lt 1 ]]; then
        echo "$(basename -- "${cypherFileName}") (via http) Error: Expected at least one entry but was ${results}" >&2
        exit 1
    fi
}

cypher_shell_query_parameters() {
    query_parameters=""
    shift # ignore first argument containing the query file name

    while [[ $# -gt 0 ]]; do
        arg="${1}"
        # Convert key=value argument to JSON "key": "value"
        json_parameter=$(echo "${arg}" | sed "s/[\"\']//g" | awk -F'='  '{print ""$1": \""$2"\""}'| grep -iv '\"#')
        if [[ -z "${query_parameters}" ]]; then
            # Add first query parameter directly
            query_parameters="${json_parameter}"
        else
            # Append next query parameter separated by a comma and a space 
            query_parameters="${query_parameters}, ${json_parameter}"
        fi
        shift # iterate to next argument
    done
    echo "{${query_parameters}}"
}

# Function to execute a cypher query from the given file (first and only argument) using "cypher-shell" provided by Neo4j
execute_cypher_shell() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"

    # Check if NEO4J_BIN exists
    if [ ! -d "${NEO4J_BIN}" ] ; then
        echo "executeQuery: Error: Neo4j Binary Directory <${NEO4J_BIN}> doesn't exist. Please run setupNeo4j.sh first." >&2
        exit 1
    fi

    # Extract query parameters out of the key=value pair arguments that follow the first argument (query filename)
    query_parameters=$(cypher_shell_query_parameters "${@}")
    echo "executeQuery: query_parameters=${query_parameters}"

    # (Neo4j Cypher Shell CLI) Execute the Cypher query contained in the file and print the results as CSV
    cat $cypherFileName | NEO4J_HOME="${NEO4J_DIRECTORY}" ${NEO4J_BIN}/cypher-shell -u neo4j -p "${NEO4J_INITIAL_PASSWORD}" --format plain --param "${query_parameters}" || exit 1

    # Display the name of the Cypher file without its path at the bottom of the CSV (or console) separated by an empty line
    echo ""
    echo "\"Source Cypher File:\",\"$(basename -- "${cypherFileName}")\""
}

# Function to execute a cypher query from the given file (first and only argument) with a summarized (console) output using "cypher-shell" provided by Neo4j
execute_cypher_shell_summarized() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"

    results=$( execute_cypher_shell ${cypherFileName} | wc -l )
    results=$((results - 2))
    echo "$(basename -- "${cypherFileName}") (via cypher-shell) result lines: ${results}"
}

# Function to execute a cypher query from the given file (first and only argument) that fails on no result using "cypher-shell" provided by Neo4j
execute_cypher_shell_expect_results() { 
    # Get the Cypher file name from the first argument
    cypherFileName="${1}"

    results=$( execute_cypher_shell ${cypherFileName} | wc -l )
    results=$((results - 2))
    if [[ "$results" -lt 1 ]]; then
        echo "$(basename -- "${cypherFileName}") (via cypher-shell) Error: Expected at least one entry but was ${results}" >&2
        exit 1
    fi
}