#!/usr/bin/env bash

# Tests template processing for markdown by embedding includes.

# Requires embedMarkdownIncludes.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts for markdown
echo "testEmbedMarkdownIncludes: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

tearDown() {
  # echo "testEmbedMarkdownIncludes: Tear down tests...."
  rm -rf "${temporaryTestDirectory}"
}

successful() {
  local COLOR_SUCCESSFUL="\033[0;32m" # green 
  local COLOR_DEFAULT='\033[0m'

  echo -e "testEmbedMarkdownIncludes: ${COLOR_SUCCESSFUL}Tests finished successfully.${COLOR_DEFAULT}"

  tearDown
}

fail() {
  local COLOR_ERROR='\033[0;31m' # red
  local COLOR_DEFAULT='\033[0m'

  local errorMessage="${1}"

  echo -e "testEmbedMarkdownIncludes: ${COLOR_ERROR}${errorMessage}${COLOR_DEFAULT}"
  tearDown
  return 1
}

echo "testEmbedMarkdownIncludes: Starting tests...."

# Create testing resources
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t 'temporaryTestDirectory')

testMarkdownTemplate="${temporaryTestDirectory}/testMarkdownTemplate.md"
echo "<!-- include:testInclude.md -->" > "${testMarkdownTemplate}"

# Setup test files
mkdir -p "${temporaryTestDirectory}/includes"

# ------------------------------------------------------------
# Test case                                                 --
# ------------------------------------------------------------
echo "testEmbedMarkdownIncludes: 1.) An existing include file is correctly embedded."

# - Setup
testIncludeFile="includes/testInclude.md"
expected_test_include_content="This is the included content for the test."
echo "${expected_test_include_content}" > "${temporaryTestDirectory}/${testIncludeFile}"

# - Execute script under test
embeddedContent=$(cd "${temporaryTestDirectory}"; "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${testMarkdownTemplate}" )

# - Verify results
if [ "${embeddedContent}" != "${expected_test_include_content}" ]; then
  fail "1.) Test failed: Expected embedded content to be '${expected_test_include_content}', but got '${embeddedContent}'."
fi

# ------------------------------------------------------------
# Test case                                                 --
# ------------------------------------------------------------
echo "testEmbedMarkdownIncludes: 2.) A missing include file results in an error."

# - Setup
testMarkdownTemplateMissingInclude="testMarkdownTemplateMissingInclude.md"
echo "<!-- include:nonExistentFile.md -->" > "${temporaryTestDirectory}/${testMarkdownTemplateMissingInclude}"

# - Execute script under test
set +o errexit
errorOutput=$(cd "${temporaryTestDirectory}"; { "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${testMarkdownTemplateMissingInclude}" 2>&1 1>/dev/null; } )
exitCode=$?
set -o errexit

# - Verify results
if [ ${exitCode} -eq 0 ]; then
  fail "2.) Test failed: Expected an error due to missing include file, but the script succeeded."
fi
if [[ "${errorOutput}" != *"ERROR: missing file"* ]]; then
  fail "2.) Test failed: Expected error message to contain 'ERROR: missing file', but got '${errorOutput}'."
fi

successful
return 0