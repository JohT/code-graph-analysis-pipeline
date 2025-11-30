#!/usr/bin/env bash

# Tests "downloadMavenArtifacts.sh".

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
  local logFileContent=$( cat "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" )
  # Remove color codes from the output for better readability in test logs
  logFileContent=$(echo -e "${logFileContent}" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
  echo -e "${COLOR_DE_EMPHASIZED}${logFileContent}${COLOR_DEFAULT}"
}

downloadMavenArtifactsExpectingSuccessUnderTest() {
  local COLOR_DE_EMPHASIZED='\033[0;90m' # dark gray
  ( 
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/downloadMavenArtifacts.sh" "$@" >"${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
  fi
  printTestLogFileContent
}

downloadMavenArtifactsExpectingFailureUnderTest() {
  set +o errexit
  (
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/downloadMavenArtifacts.sh" "$@" >"${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
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
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t 'temporaryTestDirectory_${SCRIPT_NAME}')
mkdir -p "${temporaryTestDirectory}/artifacts"

# ------- Integration Test Case
test_case_number=1
echo ""
info "${test_case_number}.) Should download existing Maven artifacts with correct coordinates successfully (real-run/integration)."

output=$(downloadMavenArtifactsExpectingSuccessUnderTest "org.apache.commons:commons-lang3:3.12.0,com.google.guava:guava:31.1-jre")
if [ ! -f "${temporaryTestDirectory}/artifacts/commons-lang3-3.12.0.jar" ]; then
  fail "${test_case_number}.) Test failed: Expected artifact 'commons-lang3-3.12.0.jar' not found in artifacts directory."
fi
if [ ! -f "${temporaryTestDirectory}/artifacts/guava-31.1-jre.jar" ]; then
  fail "${test_case_number}.) Test failed: Expected artifact 'guava-31.1-jre.jar' not found in artifacts directory."
fi

# ------- Integration Test Case
test_case_number=2
echo ""
info "${test_case_number}.) Should download a single Maven artifact successfully even if it had already been downloaded (real-run/integration)."

output=$(downloadMavenArtifactsExpectingSuccessUnderTest "org.apache.commons:commons-lang3:3.12.0")
if [ ! -f "${temporaryTestDirectory}/artifacts/commons-lang3-3.12.0.jar" ]; then
  fail "${test_case_number}.) Test failed: Expected artifact 'commons-lang3-3.12.0.jar' not found in artifacts directory."
fi

# ------- Integration Test Case
test_case_number=3
echo ""
info "${test_case_number}.) Should fail when downloading non-existing Maven artifact (real-run/integration)."
downloadMavenArtifactsExpectingFailureUnderTest "org.nonexistent:nonexistent-artifact:0.0.1"

# ------- Unit Test Case
test_case_number=4
echo ""
info "${test_case_number}.) Should fail when no input is specified (dry-run)."
downloadMavenArtifactsExpectingFailureUnderTest "--dry-run"

# ------- Unit Test Case
test_case_number=5
echo ""
info "${test_case_number}.) Should fail when input is empty (dry-run)."
downloadMavenArtifactsExpectingFailureUnderTest "--dry-run"

# ------- Unit Test Case
test_case_number=6
echo ""
info "${test_case_number}.) Should fail on unknown arguments."
downloadMavenArtifactsExpectingFailureUnderTest "--dry-run --unknown-argument"

# ------- Unit Test Case
test_case_number=7
echo ""
info "${test_case_number}.) Should fail when artifacts directory is missing (dry-run)."
# Rename artifacts directory to simulate missing directory
mv "${temporaryTestDirectory}/artifacts" "${temporaryTestDirectory}/artifacts_backup"

downloadMavenArtifactsExpectingFailureUnderTest "--dry-run"

# Restore artifacts directory
mv "${temporaryTestDirectory}/artifacts_backup" "${temporaryTestDirectory}/artifacts"

# ------- Unit Test Case
test_case_number=8
echo ""
info "${test_case_number}.) Should fail when the artifact coordinate has a wrong format (dry-run)."
downloadMavenArtifactsExpectingFailureUnderTest "--dry-run" "org.apache.commons:commons-lang3-3.12.0"

successful
return 0