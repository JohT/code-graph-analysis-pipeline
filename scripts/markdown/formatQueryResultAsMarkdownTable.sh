#!/usr/bin/env bash

# Takes the input stream (Cypher query result in JSON format) and formats it as a Markdown table.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts for markdown
#echo "formatQueryResultAsMarkdownTable: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

# Read all input (including multiline) into cypher_query_result
cypher_query_result=$(cat)

echo -n "${cypher_query_result}" | jq -r '
  # Take the first query result
  .results[0] as $result

  # Extract the column names
  | $result.columns as $columns

  # Build the Markdown header row
  | ( "| " + ( $columns | join(" | ") ) + " |" )

  # Build the Markdown separator row
  , ( "| " + ( $columns | map("---") | join(" | ") ) + " |" )

  # Build one row for each data entry
  , ( $result.data[].row
      | map(tostring)
      | "| " + ( join(" | ") ) + " |"
    )
'

#echo "formatQueryResultAsMarkdownTable: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished." >&2