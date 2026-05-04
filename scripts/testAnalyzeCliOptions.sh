#!/usr/bin/env bash

# Tests "--exclude-domain" and "--help" command line options of "analyze.sh".

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
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
# Derive the "scripts/analysis" directory always from this test's own path to avoid environment pollution.
ANALYSIS_SCRIPTS_DIR=$( CDPATH=. cd -- "${SCRIPTS_DIR}/analysis" && pwd -P )

tearDown() {
  # echo "${SCRIPT_NAME}: Tear down tests...."
  rm -rf "${temporaryTestDirectory}"
}

successful() {
  echo ""
  echo -e "${COLOR_DE_EMPHASIZED}${SCRIPT_NAME}:${COLOR_DEFAULT} ${COLOR_SUCCESSFUL}✅ Tests finished successfully.${COLOR_DEFAULT}"
  tearDown

  # If sourced, return to caller; if executed directly, exit.
  if [ "${BASH_SOURCE[0]}" != "$0" ]; then
    return 0
  else
    exit 0
  fi
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
    local logFileContent
    logFileContent=$( cat "${logFileName}" )
    # Remove color codes from the output for better readability in test logs
    logFileContent=$(echo -e "${logFileContent}" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
    echo -e "${COLOR_DE_EMPHASIZED}${logFileContent}${COLOR_DEFAULT}"
  else
    echo -e "${COLOR_ERROR}No log file found at expected location: ${logFileName}${COLOR_DEFAULT}"
  fi
}

analyzeExpectingFailureUnderTest() {
  set +o errexit
  (
    cd "${temporaryTestDirectory}"
    ARTIFACTS_DIRECTORY="${temporaryArtifactsDirectory}"
    SCRIPTS_DIR="${temporaryMinimalScriptsDirectory}"
    DOMAINS_DIRECTORY="${temporaryDomainsDirectory}"
    export ARTIFACTS_DIRECTORY SCRIPTS_DIR DOMAINS_DIRECTORY
    source "${ANALYSIS_SCRIPTS_DIR}/analyze.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  set -o errexit
  if [ ${exitCode} -eq 0 ]; then
    fail "❌ Test failed: Script exited with zero exit code but was expected to fail."
  fi
  printTestLogFileContent
}

analyzeExpectingSuccessUnderTest() {
  (
    cd "${temporaryTestDirectory}"
    ARTIFACTS_DIRECTORY="${temporaryArtifactsDirectory}"
    SCRIPTS_DIR="${temporaryMinimalScriptsDirectory}"
    DOMAINS_DIRECTORY="${temporaryDomainsDirectory}"
    export ARTIFACTS_DIRECTORY SCRIPTS_DIR DOMAINS_DIRECTORY
    source "${ANALYSIS_SCRIPTS_DIR}/analyze.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
  fi
  printTestLogFileContent
}

analyzeExpectingExitCodeUnderTest() {
  local expectedExitCode="${1}"
  shift
  set +o errexit
  (
    cd "${temporaryTestDirectory}"
    ARTIFACTS_DIRECTORY="${temporaryArtifactsDirectory}"
    SCRIPTS_DIR="${temporaryMinimalScriptsDirectory}"
    DOMAINS_DIRECTORY="${temporaryDomainsDirectory}"
    export ARTIFACTS_DIRECTORY SCRIPTS_DIR DOMAINS_DIRECTORY
    source "${ANALYSIS_SCRIPTS_DIR}/analyze.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  set -o errexit
  if [ ${exitCode} -ne "${expectedExitCode}" ]; then
    fail "❌ Test failed: Expected exit code ${expectedExitCode} but got ${exitCode}."
  fi
  printTestLogFileContent
}

info "Starting tests...."

# Create test resources
temporaryTestDirectory=$(mktemp -d 2>/dev/null || mktemp -d -t 'temporaryTestDirectory')
mkdir -p "${temporaryTestDirectory}"

# Create minimal artifacts directory so the "no artifacts" check in analyze.sh passes
temporaryArtifactsDirectory="${temporaryTestDirectory}/artifacts"
mkdir -p "${temporaryArtifactsDirectory}"

# Create domains directory with some valid test domain subdirectories
temporaryDomainsDirectory="${temporaryTestDirectory}/domains"
mkdir -p "${temporaryDomainsDirectory}/valid-test-domain"
mkdir -p "${temporaryDomainsDirectory}/another-test-domain"

# Create a minimal scripts directory structure to satisfy all file-existence checks in analyze.sh.
temporaryMinimalScriptsDirectory="${temporaryTestDirectory}/scripts"
mkdir -p "${temporaryMinimalScriptsDirectory}/reports/compilations"
mkdir -p "${temporaryMinimalScriptsDirectory}/profiles"
for placeholderScriptFile in \
    "reports/compilations/AllReports.sh" \
    "profiles/Default.sh" \
    "setupJQAssistant.sh" \
    "resetAndScanChanged.sh" \
    "prepareAnalysis.sh"; do
    printf '#!/usr/bin/env bash\n# Minimal placeholder script for testing - does nothing\n' \
        > "${temporaryMinimalScriptsDirectory}/${placeholderScriptFile}"
done

# Create placeholder scripts for the neo4j-management domain scripts sourced from DOMAINS_DIRECTORY.
mkdir -p "${temporaryDomainsDirectory}/neo4j-management"
for placeholderDomainScriptFile in \
    "setupNeo4j.sh" \
    "startNeo4j.sh" \
    "stopNeo4j.sh"; do
    printf '#!/usr/bin/env bash\n# Minimal placeholder script for testing - does nothing\n' \
        > "${temporaryDomainsDirectory}/neo4j-management/${placeholderDomainScriptFile}"
done

# -------- Test case 1 --------
test_case_number=1
echo ""
info "${test_case_number}.) --help should print usage and exit 0."

analyzeExpectingExitCodeUnderTest 0 --help
if ! grep -q "Usage:" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected usage output to contain 'Usage:' but it did not."
fi
if ! grep -q "\-\-exclude-domain" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected usage output to document --exclude-domain but it did not."
fi

# -------- Test case 2 --------
test_case_number=2
echo ""
info "${test_case_number}.) No flags: ANALYSIS_DOMAINS_TO_SKIP should default to anomaly-detection,node-embeddings,graph-algorithms."

analyzeExpectingSuccessUnderTest --explore
if ! grep -q "ANALYSIS_DOMAINS_TO_SKIP=anomaly-detection,node-embeddings,graph-algorithms" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected default ANALYSIS_DOMAINS_TO_SKIP but got different output."
fi

# -------- Test case 3 --------
test_case_number=3
echo ""
info "${test_case_number}.) --domain alone (no --exclude-domain): ANALYSIS_DOMAINS_TO_SKIP should be empty."

analyzeExpectingSuccessUnderTest --domain "valid-test-domain" --explore
if grep -q "ANALYSIS_DOMAINS_TO_SKIP=[^[:space:]]" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected ANALYSIS_DOMAINS_TO_SKIP to be empty when only --domain is given."
fi

# -------- Test case 4 --------
test_case_number=4
echo ""
info "${test_case_number}.) --exclude-domain with valid value: ANALYSIS_DOMAINS_TO_SKIP should reflect that value."

analyzeExpectingSuccessUnderTest --exclude-domain "valid-test-domain" --explore
if ! grep -q "ANALYSIS_DOMAINS_TO_SKIP=valid-test-domain" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected ANALYSIS_DOMAINS_TO_SKIP=valid-test-domain in the log output."
fi

# -------- Test case 5 --------
test_case_number=5
echo ""
info "${test_case_number}.) --exclude-domain \"\" (empty string): ANALYSIS_DOMAINS_TO_SKIP should be empty."

analyzeExpectingSuccessUnderTest --exclude-domain "" --explore
if grep -q "ANALYSIS_DOMAINS_TO_SKIP=[^[:space:]]" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected ANALYSIS_DOMAINS_TO_SKIP to be empty when --exclude-domain is given as empty string."
fi

# -------- Test case 6 --------
test_case_number=6
echo ""
info "${test_case_number}.) --exclude-domain with invalid characters (spaces) should fail with exit code 1."

analyzeExpectingFailureUnderTest --exclude-domain "invalid domain!"
if ! grep -q "can only contain letters" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error about invalid characters in excluded domain name."
fi

# -------- Test case 7 --------
test_case_number=7
echo ""
info "${test_case_number}.) --exclude-domain with trailing comma (empty segment) should fail."

analyzeExpectingFailureUnderTest --exclude-domain "valid-test-domain,"
if ! grep -q "empty segment" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error about empty segment from trailing comma."
fi

# -------- Test case 8 --------
test_case_number=8
echo ""
info "${test_case_number}.) --exclude-domain with leading comma (empty segment) should fail."

analyzeExpectingFailureUnderTest --exclude-domain ",valid-test-domain"
if ! grep -q "empty segment" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error about empty segment from leading comma."
fi

# -------- Test case 9 --------
test_case_number=9
echo ""
info "${test_case_number}.) --exclude-domain without a value (missing argument) should fail."

analyzeExpectingFailureUnderTest --exclude-domain
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error about --exclude-domain requiring a value."
fi

# -------- Test case 10 --------
test_case_number=10
echo ""
info "${test_case_number}.) --exclude-domain followed by another option (no value) should fail."

analyzeExpectingFailureUnderTest --exclude-domain --explore
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error about --exclude-domain requiring a value when followed by another flag."
fi

# -------- Test case 11 --------
test_case_number=11
echo ""
info "${test_case_number}.) --exclude-domain with nonexistent domain should fail (fail-fast like --domain)."

analyzeExpectingFailureUnderTest --exclude-domain "nonexistent-domain"
if ! grep -q "Error" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error for unknown excluded domain 'nonexistent-domain'."
fi

# -------- Test case 12 --------
test_case_number=12
echo ""
info "${test_case_number}.) --domain and --exclude-domain listing the same domain should warn."

analyzeExpectingSuccessUnderTest --domain "valid-test-domain" --exclude-domain "valid-test-domain" --explore
if ! grep -q "Warning" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected a warning when --domain and --exclude-domain list the same domain."
fi

# -------- Test case 13 --------
test_case_number=13
echo ""
info "${test_case_number}.) --exclude-domain with comma-separated list including an unknown domain should fail."

analyzeExpectingFailureUnderTest --exclude-domain "valid-test-domain,nonexistent-domain"
if ! grep -q "Error" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected error for unknown excluded domain 'nonexistent-domain' in list."
fi

successful
