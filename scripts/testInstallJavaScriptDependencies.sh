#!/usr/bin/env bash

# Tests "installJavaScriptDependencies.sh".

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Local constants
SCRIPT_NAME=$(basename "${0}")
COLOR_ERROR='\033[0;31m' # red
COLOR_DE_EMPHASIZED='\033[0;90m' # dark gray
COLOR_SUCCESSFUL="\033[0;32m" # green 
COLOR_DEFAULT='\033[0m'

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts

tearDown() {
  # echo "${SCRIPT_NAME}: Tear down tests...."
  rm -rf "${temporaryTestDirectory}"
}

successful() {
  echo ""
  echo -e "${COLOR_DE_EMPHASIZED}${SCRIPT_NAME}:${COLOR_DEFAULT} ${COLOR_SUCCESSFUL}✅ Tests finished successfully.${COLOR_DEFAULT}"
  tearDown
}

info() {
  local infoMessage="${1}"
  echo -e "${COLOR_DE_EMPHASIZED}${SCRIPT_NAME}:${COLOR_DEFAULT} ${infoMessage}"
}

fail() {
  local errorMessage="${1}"
  echo -e "${COLOR_DE_EMPHASIZED}${SCRIPT_NAME}: ${COLOR_ERROR}${errorMessage}${COLOR_DEFAULT}"
  tearDown
  return 1
}

printTestLogFileContent() {
  local logFileContent
  logFileContent=$( cat "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" )
  # Remove color codes from the output for better readability in test logs
  logFileContent=$(echo -e "${logFileContent}" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
  echo -e "${COLOR_DE_EMPHASIZED}${logFileContent}${COLOR_DEFAULT}"
}

installJavaScriptDependenciesExpectingSuccessUnderTest() {
  local COLOR_DE_EMPHASIZED='\033[0;90m' # dark gray
  ( 
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/installJavaScriptDependencies.sh" "$@" >"${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
  fi
  printTestLogFileContent
}

installJavaScriptDependenciesExpectingFailureUnderTest() {
  set +o errexit
  (
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/installJavaScriptDependencies.sh" "$@" >"${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
    exitCode=$?
    if [ ${exitCode} -eq 0 ]; then
      fail "❌ Test failed: Script exited with zero exit code but was expected to fail."
    fi
  )
  set -o errexit
  printTestLogFileContent
}

info "Starting tests...."

# Create testing resources
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t "temporaryTestDirectory_${SCRIPT_NAME}")
mkdir -p "${temporaryTestDirectory}/source"

# ------- Unit Test Case
test_case_number=1
echo ""
info "${test_case_number}.) Should do nothing if the source folder is empty (dry-run)."
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
echo "${result}"
if [[ "${result}" == *"Installing"* ]]; then
  fail "❌ Test failed: Expected no installation attempts, but some were found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=2
echo ""
info "${test_case_number}.) Should do nothing when the source folder contains no JavaScript projects (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/non-javascript-project"
echo "This is a text file." > "${temporaryTestDirectory}/source/non-javascript-project/README.md"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ "${result}" == *"Installing"* ]]; then
  fail "❌ Test failed: Expected no installation attempts, but some were found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=3
echo ""
info "${test_case_number}.) Should do nothing when the source folder contains a private npm project (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/private-npm-project"
echo "{ \"name\": \"private-npm-project\" }" > "${temporaryTestDirectory}/source/private-npm-project/package-lock.json"
echo "{ \"name\": \"private-npm-project\", \"private\": true }" > "${temporaryTestDirectory}/source/private-npm-project/package.json"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ "${result}" == *"Installing"* ]]; then
  fail "❌ Test failed: Expected no installation attempts, but some were found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=4
echo ""
info "${test_case_number}.) Should do nothing when the source folder contains a private yarn project (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/private-yarn-project"
echo "{ \"name\": \"private-yarn-project\" }" > "${temporaryTestDirectory}/source/private-yarn-project/package-lock.json"
echo "{ \"name\": \"private-yarn-project\", \"private\": true }" > "${temporaryTestDirectory}/source/private-yarn-project/package.json"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ "${result}" == *"Installing"* ]]; then
  fail "❌ Test failed: Expected no installation attempts, but some were found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=5
echo ""
info "${test_case_number}.) Should install npm dependencies for a npm project (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/npm-project"
echo "{ \"name\": \"npm-project\" }" > "${temporaryTestDirectory}/source/npm-project/package-lock.json"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ ! "${result}" == *"Installing JavaScript dependencies with npm in"* ]]; then
  fail "❌ Test failed: Expected npm installation attempt, but none was found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=6
echo ""
info "${test_case_number}.) Should install pnpm dependencies for a pnpm project (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/pnpm-project"
echo "name: pnpm-project" > "${temporaryTestDirectory}/source/pnpm-project/pnpm-lock.yaml"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ ! "${result}" == *"Installing JavaScript dependencies with pnpm in"* ]]; then
  fail "❌ Test failed: Expected pnpm installation attempt, but none was found:\n${result}"
fi

# ------- Unit Test Case
test_case_number=7
echo ""
info "${test_case_number}.) Should install yarn dependencies for a yarn project (dry-run)."
mkdir -p "${temporaryTestDirectory}/source/yarn-project"
echo "name: yarn-project" > "${temporaryTestDirectory}/source/yarn-project/yarn.lock"
result=$(installJavaScriptDependenciesExpectingSuccessUnderTest "--dry-run")
if [[ ! "${result}" == *"Installing JavaScript dependencies with yarn in"* ]]; then
  fail "❌ Test failed: Expected yarn installation attempt, but none was found:\n${result}"
fi

successful
return 0