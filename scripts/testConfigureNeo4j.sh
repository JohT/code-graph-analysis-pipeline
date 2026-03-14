#!/usr/bin/env bash

# Tests "configureNeo4j.sh".
#
# Usage
#   # Run full test suite using a deterministic temporary directory:
#   TEST_TMPDIR=./tmp/tmpdir bash scripts/testConfigureNeo4j.sh
#
#   # Capture console output to a log file (recommended for CI or debugging):
#   TEST_TMPDIR=./tmp/tmpdir bash scripts/testConfigureNeo4j.sh &> test_run.log || true
#
# Troubleshooting
#   - To enable a shell trace: run with `bash -x`:
#       TEST_TMPDIR=./tmp/tmpdir bash -x scripts/testConfigureNeo4j.sh &> trace.log || true
#   - The harness writes per-test logs into the test tempdir as:
#       $TEST_TMPDIR/$(basename scripts/testConfigureNeo4j.sh)-<case>.log
#     (If you redirect console output to a file, those per-test logs are preserved
#     inside the test_run.log capture and can also be inspected directly while the
#     test is running.)
#   - The test harness will remove the temporary directory on successful completion.
#     To preserve artifacts for manual inspection, capture console output to a file
#     as shown above (the per-test logs will be visible there), or run the script
#     interactively and copy the tempdir path printed in the logs before it is deleted.
#
# Environment / options
#   - `TEST_TMPDIR` : location for temporary test workspace (default: system temp)
#   - Integration tests run by default; no separate switch required.
#
# Notes
#   - The script runs each test in an isolated temp workspace and asserts expected
#     success/failure. Use the logs to diagnose failures; grep for "Error:" or
#     inspect the per-test log files.


# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Local constants
SCRIPT_NAME=$(basename "${0}")
COLOR_ERROR='\033[0;31m' # red
COLOR_DE_EMPHASIZED='\033[0;90m' # dark gray
COLOR_SUCCESSFUL="\033[0;32m" # green 
COLOR_DEFAULT='\033[0m'

## Get this "scripts" directory if not already set
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}

tearDown() {
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
  return 1
}

printTestLogFileContent() {
  local logFile="${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log"
  if [ ! -f "${logFile}" ]; then
    echo -e "${COLOR_DE_EMPHASIZED}(no log produced)${COLOR_DEFAULT}"
    return 0
  fi
  local logFileContent
logFileContent=$( cat "${logFile}" )
  # Remove color codes from the output for better readability in test logs
  logFileContent=$(echo -e "${logFileContent}" | sed -r "s/\x1B\[[0-9;]*[mK]//g")
  echo -e "${COLOR_DE_EMPHASIZED}${logFileContent}${COLOR_DEFAULT}"
}

configureNeo4jExpectingSuccessUnderTest() {
  (
    cd "${temporaryTestDirectory}";
    # Export a SCRIPTS_DIR that points to the test's helper stubs so the sourced script will use those
    # shellcheck disable=SC2030
    export SCRIPTS_DIR="${temporaryTestDirectory}/scripts"
    # Create a small wrapper that exports the test env and sources the configure script.
    # Run configureNeo4j.sh in a clean bash via stdin so environment is well-controlled
    # Ensure log file exists
    logFile="${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log"
    : >"${logFile}"
    # Run configure in a clean bash with controlled env; redirect all output to the log file.
    env SCRIPTS_DIR="${temporaryTestDirectory}/scripts" \
      TOOLS_DIRECTORY="${TOOLS_DIRECTORY}" \
      SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY}" \
      DATA_DIRECTORY="${DATA_DIRECTORY}" \
      RUNTIME_DIRECTORY="${RUNTIME_DIRECTORY}" \
      IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" \
      bash -c "exec >'${logFile}' 2>&1; source '${REPO_CONFIGURE_SCRIPT}'"
  )
  exitCode=$?
  if [ ${exitCode} -ne 0 ]; then
    fail "❌ Test failed: Script exited with non-zero exit code ${exitCode}."
  fi
  printTestLogFileContent
}

configureNeo4jExpectingFailureUnderTest() {
  set +o errexit
  (
    cd "${temporaryTestDirectory}";
    # shellcheck disable=SC2031
    export SCRIPTS_DIR="${temporaryTestDirectory}/scripts"
    # Ensure log file exists
    logFile="${temporaryTestDirectory}/${SCRIPT_NAME}-${test_case_number}.log"
    : >"${logFile}"
    env SCRIPTS_DIR="${temporaryTestDirectory}/scripts" \
      TOOLS_DIRECTORY="${TOOLS_DIRECTORY}" \
      SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY}" \
      DATA_DIRECTORY="${DATA_DIRECTORY}" \
      RUNTIME_DIRECTORY="${RUNTIME_DIRECTORY}" \
      IMPORT_DIRECTORY="${IMPORT_DIRECTORY}" \
      bash -c "exec >'${logFile}' 2>&1; source '${REPO_CONFIGURE_SCRIPT}'"
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
temporaryTestDirectory=${TEST_TMPDIR:-$(mktemp -d 2>/dev/null || mktemp -d -t "temporaryTestDirectory_${SCRIPT_NAME}")}
if [ -n "${TEST_TMPDIR}" ]; then
  mkdir -p "${temporaryTestDirectory}"
fi
# Normalize to absolute path to avoid relative-path duplication when cd'ing into it
temporaryTestDirectory=$(cd "${temporaryTestDirectory}" && pwd -P)

# The test will source the repository's configureNeo4j.sh but override SCRIPTS_DIR so that the script
# picks up test-provided helper files (operatingSystemFunctions.sh) and template files from the temp dir.
# Compute repository scripts dir explicitly and path to the configure script.
REPO_SCRIPTS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
REPO_CONFIGURE_SCRIPT="${REPO_SCRIPTS_DIR}/configureNeo4j.sh"

mkdir -p "${temporaryTestDirectory}/scripts/configuration"

# Use the real operatingSystemFunctions.sh from the repo but disable its
# interactive/stderr print (printWindows) to avoid noisy output during tests.
if [ -r "${REPO_SCRIPTS_DIR}/operatingSystemFunctions.sh" ]; then
  mkdir -p "${temporaryTestDirectory}/scripts"
  if sed -e 's/^printWindows\s*$/#printWindows/' "${REPO_SCRIPTS_DIR}/operatingSystemFunctions.sh" > "${temporaryTestDirectory}/scripts/operatingSystemFunctions.sh" 2>/dev/null; then
    :
  else
    # fallback to a minimal copy if sed failed for some reason
    cp "${REPO_SCRIPTS_DIR}/operatingSystemFunctions.sh" "${temporaryTestDirectory}/scripts/operatingSystemFunctions.sh" 2>/dev/null || true
  fi
else
  # Fallback: minimal implementation if the repo file is missing
  cat > "${temporaryTestDirectory}/scripts/operatingSystemFunctions.sh" <<'EOF'
#!/usr/bin/env bash
convertPosixToWindowsPathIfNecessary() { echo "$1"; }
EOF
fi

# Helper to create a minimal neo4j.conf for tests with two separator lines so insert_hint is exercised
create_base_neo4j_configuration() {
  local configurationPath="$1"
  mkdir -p "$(dirname "${configurationPath}")"
  cat > "${configurationPath}" <<'EOF'
#*************
# Base configuration for tests
#*************
# Some existing entry
dbms.memory.pagecache.size=512M
EOF
}

## Run integration + validation tests by default.

# ------- Integration Test Case (v5)
test_case_number=1
echo ""
info "${test_case_number}.) it should append template and update neo4j config for Neo4j v5."

mkdir -p "${temporaryTestDirectory}/tools"
mkdir -p "${temporaryTestDirectory}/downloads"

# Provide minimal neo4j installation dir expected by the script
NEO4J_INSTALLATION_NAME="neo4j-community-2026.01.4"
  mkdir -p "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf"
  create_base_neo4j_configuration "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf"

# Create template with minimal entries expected by tests (v5 entries)
cat > "${temporaryTestDirectory}/scripts/configuration/template-neo4j.conf" <<'EOF'
# Template for tests
server.directories.import=/some/import/path
db.tx_log.rotation.retention_policy=7 days
# End of configuration from template-neo4j.conf
EOF

# Export env so that the sourced script uses the test directories
export TOOLS_DIRECTORY="${temporaryTestDirectory}/tools"
export SHARED_DOWNLOADS_DIRECTORY="${temporaryTestDirectory}/downloads"
export DATA_DIRECTORY="${temporaryTestDirectory}/data"
export RUNTIME_DIRECTORY="${temporaryTestDirectory}/runtime"
export IMPORT_DIRECTORY="${temporaryTestDirectory}/import"

configureNeo4jExpectingSuccessUnderTest

# Validate that backup had been created and template entries appended
if [ ! -f "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf.original.backup" ]; then
  fail "${test_case_number}.) Test failed: Expected original backup file not found."
fi
if ! grep -q "server.directories.import=" "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf"; then
  fail "${test_case_number}.) Test failed: Expected 'server.directories.import' entry not found in neo4j.conf."
fi
if ! grep -q "server.bolt.listen_address" "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf"; then
  fail "${test_case_number}.) Test failed: Expected 'server.bolt.listen_address' entry not found in neo4j.conf (v5 entries)."
fi

# ------- Failure Cases: missing or empty TOOLS_DIRECTORY
test_case_number=2
echo ""
info "${test_case_number}.) it should fail when TOOLS_DIRECTORY is unset or empty."

export TOOLS_DIRECTORY=""
configureNeo4jExpectingFailureUnderTest

# ------- Failure Cases: TOOLS_DIRECTORY does not exist
test_case_number=3
echo ""
info "${test_case_number}.) it should fail when TOOLS_DIRECTORY does not exist."

export TOOLS_DIRECTORY="${temporaryTestDirectory}/tools_missing"
configureNeo4jExpectingFailureUnderTest

# ------- Failure Cases: missing or empty SHARED_DOWNLOADS_DIRECTORY
test_case_number=4
echo ""
info "${test_case_number}.) it should fail when SHARED_DOWNLOADS_DIRECTORY is unset or empty."

export TOOLS_DIRECTORY="${temporaryTestDirectory}/tools"
export SHARED_DOWNLOADS_DIRECTORY=""
configureNeo4jExpectingFailureUnderTest

# ------- Failure Cases: SHARED_DOWNLOADS_DIRECTORY does not exist
test_case_number=5
echo ""
info "${test_case_number}.) it should fail when SHARED_DOWNLOADS_DIRECTORY does not exist."

export SHARED_DOWNLOADS_DIRECTORY="${temporaryTestDirectory}/missing_downloads_dir"
configureNeo4jExpectingFailureUnderTest

# ------- Failure Case: Neo4j installation dir missing
test_case_number=6
echo ""
info "${test_case_number}.) it should fail when neo4j installation directory is missing."

# create tools dir but remove installation dir
mkdir -p "${temporaryTestDirectory}/tools"
rm -rf "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}"
export SHARED_DOWNLOADS_DIRECTORY="${temporaryTestDirectory}/downloads"
configureNeo4jExpectingFailureUnderTest

# ------- Failure Case: configuration template missing
test_case_number=7
echo ""
info "${test_case_number}.) it should fail when the configuration template file is missing."

# Recreate the installation and conf
  mkdir -p "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf"
  create_base_neo4j_configuration "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf"
rm -f "${temporaryTestDirectory}/scripts/configuration/${NEO4J_CONFIG_TEMPLATE:-template-neo4j.conf}"
configureNeo4jExpectingFailureUnderTest

# ------- Integration Test Case: re-configuration path (backup exists)
test_case_number=8
echo ""
info "${test_case_number}.) it should re-configure (append/replace template) when original backup exists."

# Create template again
cat > "${temporaryTestDirectory}/scripts/configuration/template-neo4j.conf" <<'EOF'
# Template for re-configuration test
server.directories.import=/another/import
db.tx_log.rotation.retention_policy=14 days
# End of configuration from template-neo4j.conf
EOF

# Ensure original backup file exists to trigger reconfiguration branch
touch "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf.original.backup"

export TOOLS_DIRECTORY="${temporaryTestDirectory}/tools"
export SHARED_DOWNLOADS_DIRECTORY="${temporaryTestDirectory}/downloads"
export DATA_DIRECTORY="${temporaryTestDirectory}/data"
export RUNTIME_DIRECTORY="${temporaryTestDirectory}/runtime"
export IMPORT_DIRECTORY="${temporaryTestDirectory}/import"

configureNeo4jExpectingSuccessUnderTest

if ! grep -q "The following configuration entries were taken from" "${temporaryTestDirectory}/tools/${NEO4J_INSTALLATION_NAME}/conf/neo4j.conf"; then
  fail "${test_case_number}.) Test failed: Eye-catcher comment from template append not found."
fi

# ------- Small check for Neo4j v4 related formatting (unit)
test_case_number=9
echo ""
info "${test_case_number}.) it should write v4 style properties when NEO4J_VERSION is v4 (minimal check)."

# Prepare environment for v4 run
export NEO4J_VERSION="4.4.0"
export TOOLS_DIRECTORY="${temporaryTestDirectory}/tools"
mkdir -p "${temporaryTestDirectory}/tools/neo4j-community-4.4.0/conf"
  create_base_neo4j_configuration "${temporaryTestDirectory}/tools/neo4j-community-4.4.0/conf/neo4j.conf"
touch "${temporaryTestDirectory}/tools/neo4j-community-4.4.0/conf/neo4j.conf.original.backup"

# Use a template that contains dbms.* keys
cat > "${temporaryTestDirectory}/scripts/configuration/template-neo4j.conf" <<'EOF'
# v4 template
dbms.directories.import=/v4/import
dbms.tx_log.rotation.retention_policy=10 days
# End of configuration from template-neo4j.conf
EOF

configureNeo4jExpectingSuccessUnderTest

if ! grep -q "dbms.directories.import=" "${temporaryTestDirectory}/tools/neo4j-community-4.4.0/conf/neo4j.conf"; then
  fail "${test_case_number}.) Test failed: Expected 'dbms.directories.import' entry not found in neo4j.conf for v4."
fi

successful
exit 0
