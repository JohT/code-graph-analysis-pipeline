#!/usr/bin/env bash

# Tests formatting of Cypher query results as Markdown table.

# Requires formatQueryResultAsMarkdownTable.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
#echo "testFormatQueryResultAsMarkdownTable: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

tearDown() {
  # echo "testFormatQueryResultAsMarkdownTable: Tear down tests...."
  rm -rf "${temporaryTestDirectory}"
}

successful() {
  local COLOR_SUCCESSFUL="\033[0;32m" # green 
  local COLOR_DEFAULT='\033[0m'

  echo -e "testFormatQueryResultAsMarkdownTable: ${COLOR_SUCCESSFUL}Tests finished successfully.${COLOR_DEFAULT}"

  tearDown
}

fail() {
  local COLOR_ERROR='\033[0;31m' # red
  local COLOR_DEFAULT='\033[0m'

  local errorMessage="${1}"

  echo -e "testFormatQueryResultAsMarkdownTable: ${COLOR_ERROR}${errorMessage}${COLOR_DEFAULT}"
  tearDown
  return 1
}

echo "testFormatQueryResultAsMarkdownTable: Starting tests...."

# Create testing resources
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t 'temporaryTestDirectory')

# ------------------------------------------------------------
# Test case                                                 --
# ------------------------------------------------------------
echo "testFormatQueryResultAsMarkdownTable: 1.) Convert a simple query result to a Markdown table."

# Read expected result from test_data_cypher_query_result_simple_expected
expected_result=$(<"${MARKDOWN_SCRIPTS_DIR}/test_data_cypher_query_result_simple_expected.md")

# - Execute script under test
embeddedContent=$(cd "${temporaryTestDirectory}"; cat "${MARKDOWN_SCRIPTS_DIR}/test_data_cypher_query_result_simple.json" | "${MARKDOWN_SCRIPTS_DIR}/formatQueryResultAsMarkdownTable.sh")

# - Verify results
if [ "${embeddedContent}" != "${expected_result}" ]; then
  fail "1.) Test failed: Expected Markdown table to be \n${expected_result}, but got:\n${embeddedContent}"
fi


echo "testFormatQueryResultAsMarkdownTable: 2.) Convert an array query result to a Markdown table."

# Read expected result from test_data_cypher_query_result_simple_expected
expected_result=$(<"${MARKDOWN_SCRIPTS_DIR}/test_data_cypher_query_result_with_array_expected.md")

# - Execute script under test
embeddedContent=$(cd "${temporaryTestDirectory}"; cat "${MARKDOWN_SCRIPTS_DIR}/test_data_cypher_query_result_with_array.json" | "${MARKDOWN_SCRIPTS_DIR}/formatQueryResultAsMarkdownTable.sh")

# - Verify results
if [ "${embeddedContent}" != "${expected_result}" ]; then
  fail "2.) Test failed: Expected Markdown table to be \n${expected_result}, but got:\n${embeddedContent}"
fi

successful
return 0