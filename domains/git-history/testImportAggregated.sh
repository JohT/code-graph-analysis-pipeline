#!/usr/bin/env bash

# Tests aggregated git log import: validation CSV parsing, query file existence, and gitHistoryCsv.sh suffix logic.
# Does not require Neo4j or git repositories.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/git-history" directory if not already set
GIT_HISTORY_TEST_DIR=${GIT_HISTORY_TEST_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPTS_DIR="${GIT_HISTORY_TEST_DIR}/../../scripts"
ENRICHMENT_CYPHER_DIR="${GIT_HISTORY_TEST_DIR}/queries/enrichment"
VALIDATION_CYPHER_DIR="${GIT_HISTORY_TEST_DIR}/queries/validation"
STATISTICS_CYPHER_DIR="${GIT_HISTORY_TEST_DIR}/queries/statistics"

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

function assert_equals() {
    local description="${1}"
    local expected="${2}"
    local actual="${3}"
    if [ "${actual}" = "${expected}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected: ${expected}"
        echo "        Actual:   ${actual}"
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

function assert_file_contains() {
    local description="${1}"
    local needle="${2}"
    local file="${3}"
    if grep -qF "${needle}" "${file}" 2>/dev/null; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected to find '${needle}' in: ${file}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Load parseCsvFunctions.sh (required by verification functions)
# ---------------------------------------------------------------------------
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

echo ""
echo "=== testImportAggregated.sh ==="
echo ""

# ---------------------------------------------------------------------------
# Test: Query file existence — enrichment queries
# ---------------------------------------------------------------------------
echo "--- Test: enrichment Cypher query files exist ---"

assert_file_exists "Import_aggregated_git_log_csv_data.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"

assert_file_exists "Set_number_of_aggregated_git_commits.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Set_number_of_aggregated_git_commits.cypher"

assert_file_exists "Set_number_of_aggregated_git_log_file_update_commits.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Set_number_of_aggregated_git_log_file_update_commits.cypher"

assert_file_exists "Add_CHANGED_TOGETHER_WITH_relationships_to_aggregated_git_files.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Add_CHANGED_TOGETHER_WITH_relationships_to_aggregated_git_files.cypher"

assert_file_exists "Index_author_email.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Index_author_email.cypher"

assert_file_exists "Index_change_span_month.cypher exists" \
    "${ENRICHMENT_CYPHER_DIR}/Index_change_span_month.cypher"

# ---------------------------------------------------------------------------
# Test: Query file existence — validation queries
# ---------------------------------------------------------------------------
echo "--- Test: validation Cypher query files exist ---"

assert_file_exists "Query_count_aggregated_git_log_authors.cypher exists" \
    "${VALIDATION_CYPHER_DIR}/Query_count_aggregated_git_log_authors.cypher"

assert_file_exists "Query_count_aggregated_git_log_change_spans.cypher exists" \
    "${VALIDATION_CYPHER_DIR}/Query_count_aggregated_git_log_change_spans.cypher"

# ---------------------------------------------------------------------------
# Test: Query file existence — statistics queries
# ---------------------------------------------------------------------------
echo "--- Test: statistics Cypher query files exist ---"

assert_file_exists "Words_for_git_author_Wordcloud_with_frequency_aggregated.cypher exists" \
    "${STATISTICS_CYPHER_DIR}/Words_for_git_author_Wordcloud_with_frequency_aggregated.cypher"

assert_file_exists "List_git_files_per_commit_distribution_aggregated.cypher exists" \
    "${STATISTICS_CYPHER_DIR}/List_git_files_per_commit_distribution_aggregated.cypher"

assert_file_exists "List_git_files_with_commit_statistics_by_author_aggregated.cypher exists" \
    "${STATISTICS_CYPHER_DIR}/List_git_files_with_commit_statistics_by_author_aggregated.cypher"

# ---------------------------------------------------------------------------
# Test: Import query uses correct MERGE key (includes author)
# ---------------------------------------------------------------------------
echo "--- Test: Import_aggregated_git_log_csv_data.cypher uses author-keyed MERGE ---"

assert_file_contains "Import query MERGE includes authorName" \
    "authorName:" \
    "${ENRICHMENT_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"

assert_file_contains "Import query MERGE includes authorEmail" \
    "authorEmail:" \
    "${ENRICHMENT_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"

assert_file_contains "Import query sets commits on relationship" \
    "rel.commits" \
    "${ENRICHMENT_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"

# ---------------------------------------------------------------------------
# Test: CSV parsing of author count validation result
# ---------------------------------------------------------------------------
echo "--- Test: parse author count CSV result ---"

author_result="authorCount
42"
actual_count=$(get_csv_column_value "${author_result}" "authorCount")
assert_equals "author count parsed correctly from CSV" "42" "${actual_count}"

author_result_zero="authorCount
0"
actual_zero=$(get_csv_column_value "${author_result_zero}" "authorCount")
assert_equals "zero author count parsed correctly" "0" "${actual_zero}"

if ! is_csv_column_greater_zero "${author_result}" "authorCount"; then
    echo "  FAIL: non-zero author count should be greater_zero"
    FAIL_COUNT=$((FAIL_COUNT + 1))
else
    echo "  PASS: non-zero author count detected as greater_zero"
    PASS_COUNT=$((PASS_COUNT + 1))
fi

if is_csv_column_greater_zero "${author_result_zero}" "authorCount"; then
    echo "  FAIL: zero author count should NOT be greater_zero"
    FAIL_COUNT=$((FAIL_COUNT + 1))
else
    echo "  PASS: zero author count correctly detected as not greater_zero"
    PASS_COUNT=$((PASS_COUNT + 1))
fi

# ---------------------------------------------------------------------------
# Test: CSV parsing of change span count validation result
# ---------------------------------------------------------------------------
echo "--- Test: parse change span count CSV result ---"

span_result="changeSpanCount
1234"
actual_spans=$(get_csv_column_value "${span_result}" "changeSpanCount")
assert_equals "change span count parsed correctly from CSV" "1234" "${actual_spans}"

# ---------------------------------------------------------------------------
# Test: gitHistoryCsv.sh uses _aggregated suffix for aggregated mode
# ---------------------------------------------------------------------------
echo "--- Test: gitHistoryCsv.sh aggregated suffix logic ---"

CSV_SCRIPT="${GIT_HISTORY_TEST_DIR}/gitHistoryCsv.sh"
assert_file_exists "gitHistoryCsv.sh exists" "${CSV_SCRIPT}"

suffix_output=$(IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated" bash -c "
    source_file=\"${CSV_SCRIPT}\"
    content=\$(cat \"\${source_file}\")
    echo \"\${content}\" | grep -A5 'CSV_QUERY_SUFFIX'
" 2>&1 || true)
assert_contains "gitHistoryCsv.sh has aggregated branch" "aggregated" "${suffix_output}"
assert_contains "gitHistoryCsv.sh sets _aggregated suffix" "_aggregated" "${suffix_output}"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
if [ "${FAIL_COUNT}" -gt 0 ]; then
    echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} FAILED."
    exit 1
fi
echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed."