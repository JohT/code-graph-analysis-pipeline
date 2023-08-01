#!/usr/bin/env bash

# Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format.
# Use it when "cypher-shell" is not present or not flexible enough.

# It requires "cURL" ( https://curl.se ) and "jq" ( https://stedolan.github.io/jq ) to be installed.
# The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Using "cypher-shell" that comes with Neo4j server is much simpler to use:
# cat $cypher_query_file_name | $NEO4J_HOME/bin/cypher-shell -u neo4j -p password --format plain

# Note: These command line arguments are supported:
# -> "filename" of the cypher query file (required, unnamed first argument)
# -> "--no_source_reference" to not append the cypher query file name as last CSV column

# Overrideable Defaults
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/neo4j/tx/commit"} # Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Input Arguments: Initialize arguments and set default values for optional ones
cypher_query_file_name=""
no_source_reference=false

# Input Arguments: Function to print usage information
print_usage() {
    echo "Usage: $0 <filename> [--no-source-reference-column]"
    echo "Options:"
    echo "  --no-source-reference-column: Exclude the source reference column"
}

# Input Arguments: Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --no-source-reference-column)
            no_source_reference=true
            shift
            ;;
        *)
            if [[ -z "$cypher_query_file_name" ]]; then
                # Input Arguments: Read the first unnamed input argument containing the name of the cypher file
                cypher_query_file_name="$key"
                #echo "Cypher File: $cypher_query_file_name"
                
                # Input Arguments: Check the first input argument to be a valid file
                if [ ! -f "${cypher_query_file_name}" ] ; then
                  echo "Error: Please provide a valid filename."
                  print_usage
                  exit 1
                fi
            else
                echo "Error: Unknown option: $key"
                print_usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Read the file that contains the Cypher query
original_cypher_query=$(<"${cypher_query_file_name}")
#echo "Original Query: $original_cypher_query"

# Encode the string containing the Cypher query to be used inside JSON using jq ( https://stedolan.github.io/jq )
# Be sure to put double quotes around the original Cypher query to prevent newlines from beeing removed. 
# -R means "raw input"
# -s means "include linebreaks"
# -a means "ascii output"
# . means "output the root of the JSON document"
# Source: https://stackoverflow.com/questions/10053678/escaping-characters-in-bash-for-json
cypher_query=$(echo -n "${original_cypher_query}" | jq -Rsa .)
#echo "Cypher Query: $cypher_query"

# Put the query inside the structure that is expected by the Neo4j HTTP API
cypher_query_for_api="{\"statements\":[{\"statement\":${cypher_query},\"includeStats\": false}]}"
#echo "Cypher Query for API: ${cypher_query_for_api}"

# Calls the Neo4j HTTP API using cURL ( https://curl.se )
cyper_query_result=$(curl --silent -S --fail-with-body -H Accept:application/json -H Content-Type:application/json \
     -u neo4j:"${NEO4J_INITIAL_PASSWORD}" \
     "http://localhost:${NEO4J_HTTP_PORT}/${NEO4J_HTTP_TRANSACTION_ENDPOINT}" \
     -d "${cypher_query_for_api}")
#echo "executeQuery: Cypher Query Result: ${cyper_query_result}"

# If there is a error message print it to syserr >&2 in red color
error_message=$( echo "${cyper_query_result}" | jq -r '.errors[0] // empty' )
if [[ -n "${error_message}" ]]; then 
  redColor='\033[0;31m'
  noColor='\033[0m' # No Color
  echo -e "${redColor}${cypher_query_file_name}: ${error_message}${noColor}" >&2
fi

# Output results in CSV format
if [ "${no_source_reference}" = true ] ; then
  echo -n "${cyper_query_result}" | jq -r '(.results[0])? | .columns,(.data[].row)? | map(if type == "array" then join(",") else . end) | flatten | @csv'
else
  cypher_query_file_relative_name=${cypher_query_file_name#/**/cypher/}
  sourceFileReferenceInfo="Source Cypher File: ${cypher_query_file_relative_name}"
  echo -n "${cyper_query_result}" | jq -r --arg sourceReference "${sourceFileReferenceInfo}" '(.results[0])? | .columns + [$sourceReference], (.data[].row)? + [""]  | map(if type == "array" then join(",") else . end) | flatten | @csv'
fi