#!/usr/bin/env bash

# Tests "--domain" command line option of "analyze.sh".

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
    source "${ANALYSIS_SCRIPTS_DIR}/analyze.sh" "$@" > "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>&1
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
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

# Create domains directory with one valid test domain subdirectory
temporaryDomainsDirectory="${temporaryTestDirectory}/domains"
mkdir -p "${temporaryDomainsDirectory}/valid-test-domain"

# Create a minimal scripts directory structure to satisfy all file-existence checks in analyze.sh.
# The placeholder scripts are empty (no-op) bash scripts since analyze.sh sources them.
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

# Create placeholder scripts for the neo4j-management domain scripts now sourced from DOMAINS_DIRECTORY.
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
info "${test_case_number}.) Should fail when --domain contains characters that are not letters, numbers, or hyphens."

analyzeExpectingFailureUnderTest --domain "../../etc"
if ! grep -q "can only contain letters" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about invalid domain characters but got different output."
fi

# -------- Test case 2 --------
test_case_number=2
echo ""
info "${test_case_number}.) Should fail when --domain is a valid name but does not match any subdirectory in the domains directory."

analyzeExpectingFailureUnderTest --domain "nonexistent-domain"
if ! grep -q "does not match" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about a non-existing domain but got different output."
fi

# -------- Test case 3 --------
test_case_number=3
echo ""
info "${test_case_number}.) Should pass domain validation when --domain matches an existing subdirectory and set ANALYSIS_DOMAIN accordingly."

analyzeExpectingSuccessUnderTest --domain "valid-test-domain" --explore
if ! grep -q "ANALYSIS_DOMAIN=valid-test-domain" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected ANALYSIS_DOMAIN to be set to 'valid-test-domain' in the log output."
fi

# -------- Test case 4 --------
test_case_number=4
echo ""
info "${test_case_number}.) Should run unchanged (without domain filtering) when no --domain option is given."

analyzeExpectingSuccessUnderTest --explore
if grep -q "ANALYSIS_DOMAIN=[^[:space:]]" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected ANALYSIS_DOMAIN to be empty when no domain option is given, but found a non-empty value in the log."
fi

# -------- Test case 5 --------
test_case_number=5
echo ""
info "${test_case_number}.) Should fail when --domain is given as the last argument without a value."

analyzeExpectingFailureUnderTest --domain
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about --domain requiring a value but got different output."
fi

# -------- Test case 6 --------
test_case_number=6
echo ""
info "${test_case_number}.) Should fail when --domain is followed by another option instead of a value."

analyzeExpectingFailureUnderTest --domain --explore
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about --domain requiring a value but got different output."
fi

# -------- Test case 7 --------
test_case_number=7
echo ""
info "${test_case_number}.) Should fail when --report is given as the last argument without a value."

analyzeExpectingFailureUnderTest --report
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about --report requiring a value but got different output."
fi

# -------- Test case 8 --------
test_case_number=8
echo ""
info "${test_case_number}.) Should fail when --profile is given as the last argument without a value."

analyzeExpectingFailureUnderTest --profile
if ! grep -q "requires a value" "${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log" 2>/dev/null; then
  fail "${test_case_number}.) Test failed: Expected an error message about --profile requiring a value but got different output."
fi

successful
