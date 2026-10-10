#!/usr/bin/env bash

# Tests createGitLogData.sh: CSV header, change types (A/M/D/R), merge commit inclusion,
# bot-author pass-through, multiple files per commit, message escaping, empty repository.
# Does not require Neo4j. Each test case creates an isolated temporary git repository.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/git-history" directory if not already set
GIT_HISTORY_TEST_DIR=${GIT_HISTORY_TEST_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPT="${GIT_HISTORY_TEST_DIR}/import/createGitLogData.sh"

PASS_COUNT=0
FAIL_COUNT=0

# ---------------------------------------------------------------------------
# Assertion helpers
# ---------------------------------------------------------------------------

function assert_exit_code() {
    local description="${1}"
    local expected_exit="${2}"
    local actual_exit="${3}"
    if [[ "${expected_exit}" == "${actual_exit}" ]]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected exit code ${expected_exit}, got ${actual_exit}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_file_exists() {
    local description="${1}"
    local file="${2}"
    if [[ -f "${file}" ]]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        File not found: ${file}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

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
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_equals() {
    local description="${1}"
    local expected="${2}"
    local actual="${3}"
    if [[ "${expected}" == "${actual}" ]]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected: ${expected}"
        echo "        Got:      ${actual}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_line_count() {
    local description="${1}"
    local expected="${2}"
    local file="${3}"
    local actual
    actual=$(wc -l < "${file}" | tr -d ' ')
    if [[ "${expected}" == "${actual}" ]]; then
        echo "  PASS: ${description} (${actual} lines)"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected ${expected} lines, got ${actual}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

function assert_csv_row_count() {
    local description="${1}"
    local expected="${2}"
    local file="${3}"
    local actual
    actual=$(tail -n +2 "${file}" | wc -l | tr -d ' ')
    if [[ "${expected}" == "${actual}" ]]; then
        echo "  PASS: ${description} (${actual} data rows)"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected ${expected} data rows, got ${actual}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Git repository helpers
# ---------------------------------------------------------------------------

function init_test_repo() {
    local repo_dir="${1}"
    git -C "${repo_dir}" init --quiet
    git -C "${repo_dir}" config user.email "test@example.com"
    git -C "${repo_dir}" config user.name "Test User"
}

function run_script_in_repo() {
    local repo_dir="${1}"
    local csv_log_file="${2}"
    local csv_commits_file="${3}"
    # source inside a subshell so 'return' statements exit cleanly without affecting this script
    # shellcheck disable=SC1090
    (cd "${repo_dir}" && source "${SCRIPT}" "${csv_log_file}" "${csv_commits_file}")
}

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

TEMP_DIR=$(mktemp -d)
# shellcheck disable=SC2064
# intentional: TEMP_DIR is fixed at trap registration time
trap "rm -rf '${TEMP_DIR}'" EXIT

echo ""
echo "=== testCreateGitLogData.sh ==="
echo ""

# ---------------------------------------------------------------------------
# Test: CSV header matches exact schema
# ---------------------------------------------------------------------------

echo "--- CSV header ---"
REPO="${TEMP_DIR}/test_header"
CSV_LOG="${TEMP_DIR}/header_log.csv"
CSV_COMMITS="${TEMP_DIR}/header_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"
echo "file" > "${REPO}/a.txt"
git -C "${REPO}" add a.txt
git -C "${REPO}" commit --quiet -m "add a"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_equals "gitLogCommits.csv header matches schema" \
    "hash,parent,author,email,timestamp_unix,message" \
    "$(head -1 "${CSV_COMMITS}")"
assert_equals "gitLog.csv header matches schema" \
    "hash,filename,change_type,old_filename" \
    "$(head -1 "${CSV_LOG}")"

# ---------------------------------------------------------------------------
# Test: add, modify, delete produce correct change_type values
# ---------------------------------------------------------------------------

echo "--- Change types A/M/D ---"
REPO="${TEMP_DIR}/test_amd"
CSV_LOG="${TEMP_DIR}/amd_log.csv"
CSV_COMMITS="${TEMP_DIR}/amd_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "content" > "${REPO}/file.txt"
git -C "${REPO}" add file.txt
git -C "${REPO}" commit --quiet -m "add"

echo "changed" > "${REPO}/file.txt"
git -C "${REPO}" add file.txt
git -C "${REPO}" commit --quiet -m "modify"

git -C "${REPO}" rm --quiet file.txt
git -C "${REPO}" commit --quiet -m "delete"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

CSV_CONTENT=$(cat "${CSV_LOG}")
assert_contains "A-type row present" '"A"' "${CSV_CONTENT}"
assert_contains "M-type row present" '"M"' "${CSV_CONTENT}"
assert_contains "D-type row present" '"D"' "${CSV_CONTENT}"
assert_csv_row_count "three data rows (one per change)" 3 "${CSV_LOG}"

# ---------------------------------------------------------------------------
# Test: rename produces R-type row with filename=new and old_filename=old
# ---------------------------------------------------------------------------

echo "--- Rename (R-type) ---"
REPO="${TEMP_DIR}/test_rename"
CSV_LOG="${TEMP_DIR}/rename_log.csv"
CSV_COMMITS="${TEMP_DIR}/rename_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "content" > "${REPO}/old.txt"
git -C "${REPO}" add old.txt
git -C "${REPO}" commit --quiet -m "add old"

git -C "${REPO}" mv old.txt new.txt
git -C "${REPO}" commit --quiet -m "rename"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

CSV_CONTENT=$(cat "${CSV_LOG}")
assert_contains "R-type row present" '"R"' "${CSV_CONTENT}"
assert_contains "new filename in filename column" '"new.txt"' "${CSV_CONTENT}"
assert_contains "old filename in old_filename column" '"old.txt"' "${CSV_CONTENT}"

# verify the rename row ends with ,"R","old.txt"
assert_contains "rename row has correct column order" '"new.txt","R","old.txt"' "${CSV_CONTENT}"

# ---------------------------------------------------------------------------
# Test: merge commits are not filtered; parent hashes captured correctly
# Note: git log --name-status combined diff is empty for clean merges (no
# file changes relative to all parents simultaneously). This is expected
# behavior. We verify the script does not use --no-merges, and that parent
# hashes are correctly written for regular commits in a repo with merges.
# ---------------------------------------------------------------------------

echo "--- Merge commits not filtered, parent hashes ---"
REPO="${TEMP_DIR}/test_merge"
CSV_LOG="${TEMP_DIR}/merge_log.csv"
CSV_COMMITS="${TEMP_DIR}/merge_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "a" > "${REPO}/a.txt"
git -C "${REPO}" add a.txt
git -C "${REPO}" commit --quiet -m "first"
FIRST_HASH=$(git -C "${REPO}" rev-parse HEAD)
INITIAL_BRANCH=$(git -C "${REPO}" rev-parse --abbrev-ref HEAD)

git -C "${REPO}" checkout --quiet -b feature
echo "b" > "${REPO}/b.txt"
git -C "${REPO}" add b.txt
git -C "${REPO}" commit --quiet -m "feature"
FEATURE_HASH=$(git -C "${REPO}" rev-parse HEAD)

git -C "${REPO}" checkout --quiet "${INITIAL_BRANCH}"
echo "c" > "${REPO}/c.txt"
git -C "${REPO}" add c.txt
git -C "${REPO}" commit --quiet -m "second"
SECOND_HASH=$(git -C "${REPO}" rev-parse HEAD)
git -C "${REPO}" merge --quiet --no-ff feature -m "merge feature"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

CSV_CONTENT=$(cat "${CSV_COMMITS}")

# --no-merges must not be present in the script
assert_not_contains "--no-merges not in script" "--no-merges" "$(cat "${SCRIPT}")"

# Regular commits must appear in the CSV
assert_contains "first commit appears in CSV" "${FIRST_HASH}" "${CSV_CONTENT}"
assert_contains "feature commit appears in CSV" "${FEATURE_HASH}" "${CSV_CONTENT}"
assert_contains "second commit appears in CSV" "${SECOND_HASH}" "${CSV_CONTENT}"

# Parent hashes are correctly captured for commits with a single parent
SECOND_ROW=$(grep "^${SECOND_HASH}," "${CSV_COMMITS}")
SECOND_PARENT=$(echo "${SECOND_ROW}" | cut -d',' -f2)
assert_equals "second commit has first commit as parent" "${FIRST_HASH}" "${SECOND_PARENT}"

FEATURE_ROW=$(grep "^${FEATURE_HASH}," "${CSV_COMMITS}")
FEATURE_PARENT=$(echo "${FEATURE_ROW}" | cut -d',' -f2)
assert_equals "feature commit has first commit as parent" "${FIRST_HASH}" "${FEATURE_PARENT}"

# ---------------------------------------------------------------------------
# Test: bot-author commits are NOT filtered (Cypher handles classification)
# ---------------------------------------------------------------------------

echo "--- Bot author not filtered ---"
REPO="${TEMP_DIR}/test_bot"
CSV_LOG="${TEMP_DIR}/bot_log.csv"
CSV_COMMITS="${TEMP_DIR}/bot_commits.csv"
mkdir -p "${REPO}"
git -C "${REPO}" init --quiet
git -C "${REPO}" config user.email "bot@github.com"
git -C "${REPO}" config user.name "dependabot[bot]"

echo "dep" > "${REPO}/deps.txt"
git -C "${REPO}" add deps.txt
git -C "${REPO}" commit --quiet -m "bump dependency"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_contains "bot author row present in CSV" '"dependabot[bot]"' "$(cat "${CSV_COMMITS}")"

# ---------------------------------------------------------------------------
# Test: multiple files in one commit produce one CSV row per file
# ---------------------------------------------------------------------------

echo "--- Multiple files per commit ---"
REPO="${TEMP_DIR}/test_multifile"
CSV_LOG="${TEMP_DIR}/multifile_log.csv"
CSV_COMMITS="${TEMP_DIR}/multifile_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "a" > "${REPO}/a.txt"
echo "b" > "${REPO}/b.txt"
echo "c" > "${REPO}/c.txt"
git -C "${REPO}" add a.txt b.txt c.txt
git -C "${REPO}" commit --quiet -m "add three"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_csv_row_count "three rows for three files in one commit" 3 "${CSV_LOG}"

# ---------------------------------------------------------------------------
# Test: comma in commit message is properly CSV-quoted
# ---------------------------------------------------------------------------

echo "--- Comma in commit message ---"
REPO="${TEMP_DIR}/test_comma"
CSV_LOG="${TEMP_DIR}/comma_log.csv"
CSV_COMMITS="${TEMP_DIR}/comma_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "x" > "${REPO}/x.txt"
git -C "${REPO}" add x.txt
git -C "${REPO}" commit --quiet -m "fix: add x, remove y"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_contains "message with comma quoted" '"fix: add x, remove y"' "$(cat "${CSV_COMMITS}")"

# ---------------------------------------------------------------------------
# Test: double quotes in commit message are escaped as ""
# ---------------------------------------------------------------------------

echo "--- Double quotes in commit message ---"
REPO="${TEMP_DIR}/test_quotes"
CSV_LOG="${TEMP_DIR}/quotes_log.csv"
CSV_COMMITS="${TEMP_DIR}/quotes_commits.csv"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

echo "y" > "${REPO}/y.txt"
git -C "${REPO}" add y.txt
git -C "${REPO}" commit --quiet -m 'add "quoted" word'

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_contains "double quotes escaped as double-double-quotes" '"add ""quoted"" word"' "$(cat "${CSV_COMMITS}")"

# ---------------------------------------------------------------------------
# Test: empty repository (no commits) produces only the header line
# ---------------------------------------------------------------------------

echo "--- Empty repository ---"
REPO="${TEMP_DIR}/test_empty"
CSV_LOG="${TEMP_DIR}/empty_log.csv"
CSV_COMMITS="${TEMP_DIR}/empty_commits.csv"
mkdir -p "${REPO}"
git -C "${REPO}" init --quiet

EMPTY_EXIT=0
run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}" || EMPTY_EXIT=$?
assert_exit_code "empty repo exits without error" 0 "${EMPTY_EXIT}"
assert_file_exists "gitLog.csv file created for empty repo" "${CSV_LOG}"
assert_file_exists "gitLogCommits.csv file created for empty repo" "${CSV_COMMITS}"
assert_line_count "empty repo gitLog.csv has only header (1 line)" 1 "${CSV_LOG}"
assert_line_count "empty repo gitLogCommits.csv has only header (1 line)" 1 "${CSV_COMMITS}"

# ---------------------------------------------------------------------------
# Test: missing output path exits without error
# ---------------------------------------------------------------------------

echo "--- Missing output path ---"
REPO="${TEMP_DIR}/test_nopath"
mkdir -p "${REPO}"
init_test_repo "${REPO}"

NOPATH_EXIT=0
run_script_in_repo "${REPO}" "" "" || NOPATH_EXIT=$?
assert_exit_code "missing output paths exits without error" 0 "${NOPATH_EXIT}"

# ---------------------------------------------------------------------------
# Test: running outside a git repository exits without error
# ---------------------------------------------------------------------------

echo "--- Non-git directory ---"
NONGIT="${TEMP_DIR}/test_nongit"
CSV_LOG="${TEMP_DIR}/nongit_log.csv"
CSV_COMMITS="${TEMP_DIR}/nongit_commits.csv"
mkdir -p "${NONGIT}"

NONGIT_EXIT=0
run_script_in_repo "${NONGIT}" "${CSV_LOG}" "${CSV_COMMITS}" || NONGIT_EXIT=$?
assert_exit_code "non-git directory exits without error" 0 "${NONGIT_EXIT}"

# ---------------------------------------------------------------------------
# Test: author email is extracted from git log
# ---------------------------------------------------------------------------

echo "--- Author email ---"
REPO="${TEMP_DIR}/test_email"
CSV_LOG="${TEMP_DIR}/email_log.csv"
CSV_COMMITS="${TEMP_DIR}/email_commits.csv"
mkdir -p "${REPO}"
git -C "${REPO}" init --quiet
git -C "${REPO}" config user.email "alice@example.com"
git -C "${REPO}" config user.name "Alice"

echo "z" > "${REPO}/z.txt"
git -C "${REPO}" add z.txt
git -C "${REPO}" commit --quiet -m "add z"

run_script_in_repo "${REPO}" "${CSV_LOG}" "${CSV_COMMITS}"

assert_contains "author email in CSV" '"alice@example.com"' "$(cat "${CSV_COMMITS}")"
assert_contains "author name in CSV"  '"Alice"' "$(cat "${CSV_COMMITS}")"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
if [ "${FAIL_COUNT}" -gt 0 ]; then
    echo "=== Results: ${PASS_COUNT} passed, ${FAIL_COUNT} FAILED ==="
    exit 1
else
    echo "=== Results: ${PASS_COUNT} passed, 0 failed ==="
fi
