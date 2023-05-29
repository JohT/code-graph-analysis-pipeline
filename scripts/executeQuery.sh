#!/usr/bin/env bash

# Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format.
# Use it when "cypher-shell" is not present or not flexible enough.

# It requires "cURL" ( https://curl.se ) and "jq" ( https://stedolan.github.io/jq ) to be installed.
# The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Using "cypher-shell" that comes with Neo4j server is much simpler to use:
# cat $cypher_query_file_name | $NEO4J_HOME/bin/cypher-shell -u neo4j -p password --format plain

# Overrideable Defaults
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your password'."
    exit 1
fi

# Read the first input argument containing the name of the cypher file
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <cypher file>" >&2
  exit 1
fi

# Check the first input argument to be a valid file
if [ ! -f "$1" ] ; then
    echo "$1 not found" >&2
    exit 1
fi

cypher_query_file_name=$1
#echo "Cypher File: $cypher_query_file_name"

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
cypher_query_for_api="{\"statements\":[{\"statement\":${cypher_query},\"includeStats\": true}]}"
#echo "Cypher Query for API: ${cypher_query_for_api}"

# Calls the Neo4j HTTP API using cURL ( https://curl.se )
cyper_query_result=$(curl --silent -S --fail-with-body -H Accept:application/json -H Content-Type:application/json \
     -u neo4j:"${NEO4J_INITIAL_PASSWORD}" \
     "http://localhost:${NEO4J_HTTP_PORT}/db/data/transaction/commit" \
     -d "${cypher_query_for_api}")
#echo "Cypher Query Result: $cyper_query_result"

# If there is a error message print it to syserr >&2 in red color
error_message=$( echo "${cyper_query_result}" | jq -r '.errors[0] // empty' )
if [[ -n "${error_message}" ]]; then 
  redColor='\033[0;31m'
  noColor='\033[0m' # No Color
  echo -e "${redColor}${error_message}${noColor}" >&2
fi

# Output results iun CSV format
echo -n "${cyper_query_result}" | jq -r '(.results[0])? | .columns,(.data[].row)?|flatten | @csv'