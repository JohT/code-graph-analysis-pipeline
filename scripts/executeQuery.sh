#!/usr/bin/env bash

# Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format.
# Use it when "cypher-shell" is not present, not flexible enough or to avoid an additional dependency.

# It requires "cURL" ( https://curl.se ) and "jq" ( https://stedolan.github.io/jq ) to be installed.
# The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Using "cypher-shell" that comes with Neo4j server is much simpler to use:
# cat $cypher_query_file_name | $NEO4J_HOME/bin/cypher-shell -u neo4j -p password --format plain --param "number ⇒ 3"

# Note: These command line arguments are supported:
# -> "filename" of the cypher query file (required, unnamed first argument)
# -> "--no_source_reference" to not append the cypher query file name as last CSV column
# -> any following key=value arguments are used as query parameters

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/neo4j/tx/commit"} # Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "executeQuery requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'." >&2
    exit 1
fi

# Input Arguments: Initialize arguments and set default values for optional ones
cypher_query_file_name=""
no_source_reference=false
query_parameters=""

# Input Arguments: Function to print usage information
print_usage() {
    echo "executeQuery Usage: $0 <filename> [--no-source-reference-column]" >&2
    echo "Options:" >&2
    echo "  --no-source-reference-column: Exclude the source reference column" >&2
}

# Input Arguments: Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    arg="$1"

    case $arg in
        --no-source-reference-column)
            no_source_reference=true
            shift
            ;;
        *)
            if [[ -z "${cypher_query_file_name}" ]]; then
                # Input Arguments: Read the first unnamed input argument containing the name of the cypher file
                cypher_query_file_name="${arg}"
                #echo "Cypher File: $cypher_query_file_name"
                
                # Input Arguments: Check the first input argument to be a valid file
                if [ ! -f "${cypher_query_file_name}" ] ; then
                  echo "executeQuery Error: Invalid cypher query filename ${cypher_query_file_name}." >&2
                  print_usage
                  exit 1
                fi
            else
                # Convert key=value argument to JSON "key": "value" and strip all incoming quotes first
                json_parameter=$(echo "${arg}" | sed "s/[\"\']//g" | awk -F'='  '{ print "\""$1"\": \""$2"\""}'| grep -iv '\"#')
                if [[ -z "${query_parameters}" ]]; then
                  # Add first query parameter directly
                  query_parameters="${json_parameter}"
                else
                  # Append next query parameter separated by a comma and a space 
                  query_parameters="${query_parameters}, ${json_parameter}"
                fi
            fi
            shift
            ;;
    esac
done

#echo "executeQuery: query_parameters: ${query_parameters}"

# Read the file that contains the Cypher query
original_cypher_query=$(<"${cypher_query_file_name}")
#echo "executeQuery: Original Query: $original_cypher_query"

# Encode the string containing the Cypher query to be used inside JSON using jq ( https://stedolan.github.io/jq )
# Be sure to put double quotes around the original Cypher query to prevent newlines from beeing removed. 
# -R means "raw input"
# -s means "include linebreaks"
# -a means "ascii output"
# . means "output the root of the JSON document"
# Source: https://stackoverflow.com/questions/10053678/escaping-characters-in-bash-for-json
cypher_query=$(echo -n "${original_cypher_query}" | jq -Rsa .)
#echo "executeQuery: Cypher Query JSON Encoded: $cypher_query"

# Put the query inside the structure that is expected by the Neo4j HTTP API
cypher_query_for_api="{\"statements\":[{\"statement\":${cypher_query},\"parameters\":{${query_parameters}},\"includeStats\": false}]}"
#echo "executeQuery: Cypher Query for API: ${cypher_query_for_api}"

# Calls the Neo4j HTTP API using cURL ( https://curl.se )
if ! cypher_query_result=$(curl --silent -S --fail-with-body -H Accept:application/json -H Content-Type:application/json \
     -u neo4j:"${NEO4J_INITIAL_PASSWORD}" \
     "http://localhost:${NEO4J_HTTP_PORT}/${NEO4J_HTTP_TRANSACTION_ENDPOINT}" \
     -d "${cypher_query_for_api}" 2>&1) ;
then
  redColor='\033[0;31m'
  noColor='\033[0m'
  echo -e "${redColor}${cypher_query_file_name}: ${cypher_query_result}${noColor}" >&2
  echo -e "${redColor}Parameters: ${query_parameters}${noColor}" >&2
  exit 1
fi
#echo "executeQuery: Cypher Query OK Result: ${cypher_query_result}"

# If there is a error message print it to syserr >&2 in red color
error_message=$( echo "${cypher_query_result}" | jq -r '.errors[0] // empty' )
if [[ -n "${error_message}" ]]; then 
  redColor='\033[0;31m'
  noColor='\033[0m'
  echo -e "${redColor}${cypher_query_file_name}: ${error_message}${noColor}" >&2
  echo -e "${redColor}Parameters: ${query_parameters}${noColor}" >&2
  exit 1
fi

# Output results in CSV format
if [ "${no_source_reference}" = true ] ; then
  echo -n "${cypher_query_result}" | jq -r '(.results[0])? | .columns,(.data[].row)? | map(if type == "array" then join(",") else . end) | flatten | @csv'
else
  cypher_query_file_relative_name=${cypher_query_file_name#/**/cypher/}
  sourceFileReferenceInfo="Source Cypher File: ${cypher_query_file_relative_name}"
  echo -n "${cypher_query_result}" | jq -r --arg sourceReference "${sourceFileReferenceInfo}" '(.results[0])? | .columns + [$sourceReference], (.data[].row)? + [""]  | map(if type == "array" then join(",") else . end) | flatten | @csv'
fi