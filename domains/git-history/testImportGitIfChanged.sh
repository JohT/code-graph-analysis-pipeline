#!/usr/bin/env bash

# Tests importGitIfChanged.sh: skip conditions, change detection, --dry-run, and SHA file lifecycle.
# Does not require Neo4j or git repositories. Uses a mock importGit.sh to avoid a real import.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/git-history" directory if not already set
GIT_HISTORY_TEST_DIR=${GIT_HISTORY_TEST_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPT="${GIT_HISTORY_TEST_DIR}/import/importGitIfChanged.sh"
# shellcheck disable=SC2034
SCRIPTS_DIR="${GIT_HISTORY_TEST_DIR}/../../scripts"

PASS_COUNT=0
FAIL_COUNT=0

# ---------------------------------------------------------------------------
# Assertion helpers
# ---------------------------------------------------------------------------

function assert_contains() {
    local description="${1}"
    local needle="${2}"
    local haystack="${3}"
    if echo "${haystack}" | grep -qF "${needle}"; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected to find: ${needle}"
        echo "        In output: ${haystack}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_not_contains() {
    local description="${1}"
    local needle="${2}"
    local haystack="${3}"
    if ! echo "${haystack}" | grep -qF "${needle}"; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected NOT to find: ${needle}"
        echo "        In output: ${haystack}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_file_exists() {
    local description="${1}"
    local file="${2}"
    if [ -f "${file}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        File not found: ${file}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_file_not_exists() {
    local description="${1}"
    local file="${2}"
    if [ ! -f "${file}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        File should not exist: ${file}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

TEMP_DIR=$(mktemp -d)
# shellcheck disable=SC2064
# intentional: TEMP_DIR is fixed at trap registration time
trap "rm -rf '${TEMP_DIR}'" EXIT

# Mock importGit.sh: records that it was called, no real import
MOCK_IMPORT_DIR="${TEMP_DIR}/mock_import"
mkdir -p "${MOCK_IMPORT_DIR}"
cat > "${MOCK_IMPORT_DIR}/importGit.sh" << 'MOCK_EOF'
echo "importGit: mock called"
MOCK_EOF

# Runs importGitIfChanged.sh in an isolated subshell with controlled env vars.
# Captures stdout+stderr. Passes remaining args to the script.
run_import_if_changed() {
    local source_dir="${1}"
    local import_mode="${2}"
    shift 2
    (
        # shellcheck disable=SC2034
        SOURCE_DIRECTORY="${source_dir}"
        # shellcheck disable=SC2034
        GIT_HISTORY_IMPORT_DIR="${MOCK_IMPORT_DIR}"
        # shellcheck disable=SC2034
        IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="${import_mode}"
        # shellcheck disable=SC1090
        source "${SCRIPT}" "$@"
    ) 2>&1 || true
}

echo ""
echo "=== testImportGitIfChanged.sh ==="
echo ""

# ---------------------------------------------------------------------------
# Test: skip when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=none
# ---------------------------------------------------------------------------
echo "--- Test: skip when mode=none ---"
test_source="${TEMP_DIR}/source_none"
mkdir -p "${test_source}"
output=$(run_import_if_changed "${test_source}" "none")
assert_contains "mode=none skips import" "Skipped" "${output}"
assert_contains "mode=none shows reason" "none" "${output}"

# ---------------------------------------------------------------------------
# Test: skip when source directory does not exist
# ---------------------------------------------------------------------------
echo "--- Test: skip when source/ missing ---"
output=$(run_import_if_changed "${TEMP_DIR}/nonexistent_source" "full")
assert_contains "missing source skips" "not found" "${output}"

# ---------------------------------------------------------------------------
# Test: dry-run reports change on first call but does not import or write SHA
# ---------------------------------------------------------------------------
echo "--- Test: dry-run on first call ---"
test_source="${TEMP_DIR}/source_dryrun"
mkdir -p "${test_source}"
sha_file="${test_source}/gitImportChangeDetection.sha"
output=$(run_import_if_changed "${test_source}" "full" "--dry-run")
assert_contains "dry-run detects change" "changed" "${output}"
assert_contains "dry-run skips import" "dry-run active" "${output}"
assert_not_contains "dry-run does not run import" "mock called" "${output}"
assert_file_not_exists "dry-run does not write SHA" "${sha_file}"

# ---------------------------------------------------------------------------
# Test: real run imports and writes SHA on first call
# ---------------------------------------------------------------------------
echo "--- Test: real run on first call ---"
test_source="${TEMP_DIR}/source_realrun"
mkdir -p "${test_source}"
sha_file="${test_source}/gitImportChangeDetection.sha"
output=$(run_import_if_changed "${test_source}" "full")
assert_contains "first run triggers import" "mock called" "${output}"
assert_file_exists "first run writes SHA" "${sha_file}"

# ---------------------------------------------------------------------------
# Test: second call skips when source unchanged
# ---------------------------------------------------------------------------
echo "--- Test: second call skips when source unchanged ---"
output=$(run_import_if_changed "${test_source}" "full")
assert_contains "unchanged source skips" "unchanged" "${output}"
assert_not_contains "unchanged source does not re-import" "mock called" "${output}"

# ---------------------------------------------------------------------------
# Test: re-imports when source changes after SHA written
# ---------------------------------------------------------------------------
echo "--- Test: re-imports after source changes ---"
touch "${test_source}/new_file.txt"
output=$(run_import_if_changed "${test_source}" "full")
assert_contains "source change triggers re-import" "changed" "${output}"
assert_contains "source change runs import" "mock called" "${output}"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
if [ "${FAIL_COUNT}" -gt 0 ]; then
    echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} FAILED."
    exit 1
fi
echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed."
