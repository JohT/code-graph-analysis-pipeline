#!/usr/bin/env bash

# Tests "cloneGitRepository.sh".

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
  local logFileName="${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log"
  if [ -f "${logFileName}" ]; then
    local logFileContent=$( cat "${logFileName}" )
    # Remove color codes from the output for better readability in test logs
    logFileContent=$(echo -e "${logFileContent}" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
    echo -e "${COLOR_DE_EMPHASIZED}${logFileContent}${COLOR_DEFAULT}"
  else
    echo -e "${COLOR_ERROR}No log file found at expected location: ${logFileName}${COLOR_DEFAULT}"
  fi
}

cloneGitRepositoryExpectingSuccessUnderTest() {
  local COLOR_DE_EMPHASIZED='\033[0;90m' # dark gray
  (
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/cloneGitRepository.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log"
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
  fi
  printTestLogFileContent
}

cloneGitRepositoryExpectingFailureUnderTest() {
  set +o errexit
  (
    cd "${temporaryTestDirectory}"; 
    source "${SCRIPTS_DIR}/cloneGitRepository.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
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
mkdir -p "${temporaryTestDirectory}"

# ------- Integration Test Case
test_case_number=1
echo ""
info "${test_case_number}.) Should clone a valid GitHub Repository successfully (real-run/integration)."

cloneGitRepositoryExpectingSuccessUnderTest --url "https://github.com/JohT/livecoding.git" --branch "main" --target "${temporaryTestDirectory}/livecoding"
if [ ! -f "${temporaryTestDirectory}/livecoding/README.md" ]; then
  fail "${test_case_number}.) Test failed: Expected 'README.md' in cloned repository 'livecoding'."
fi

# ------- Unit Test Case
test_case_number=2
echo ""
info "${test_case_number}.) Should fail when an unknown option is used (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --non-existing-parameter --dry-run

# ------- Unit Test Case
test_case_number=3
echo ""
info "${test_case_number}.) Should fail when --url is from a different domain than GitHub (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --url "https://example.com/JohT/livecoding.git" --dry-run

# ------- Unit Test Case
test_case_number=4
echo ""
info "${test_case_number}.) Should fail when --branch is empty (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --url "https://github.com/JohT/livecoding.git" --branch "" --dry-run

# ------- Unit Test Case
test_case_number=5
echo ""
info "${test_case_number}.) Should fail when --branch contains invalid characters (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --url "https://github.com/JohT/livecoding.git" --branch "main;" --dry-run

# ------- Unit Test Case
test_case_number=6
echo ""
info "${test_case_number}.) Should fail when --history-only is neither true nor false (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --url "https://github.com/JohT/livecoding.git" --history-only "invalid" --dry-run

# ------- Unit Test Case
test_case_number=7
echo ""
info "${test_case_number}.) Should fail when --target is empty (dry-run)."
cloneGitRepositoryExpectingFailureUnderTest --url "https://github.com/JohT/livecoding.git" --target "" --dry-run

# ------- Unit Test Case
test_case_number=8
echo ""
info "${test_case_number}.) Should include the bare option in git clone when --history-option is true (dry-run)."
output=$(cloneGitRepositoryExpectingSuccessUnderTest --url "https://github.com/JohT/livecoding.git" --history-only "true" --target "${temporaryTestDirectory}/livecoding" --dry-run)

if ! echo "${output}" | grep -q "git clone --bare"; then
  fail "${test_case_number}.) Test failed: Expected '--bare' option in git clone command."
fi

successful
return 0