#!/usr/bin/env bash

# Tests convertScipIndexToCsvForNeo4jImport.sh: validation, CSV columns, multi-file merge.
# Adapted from getting-started-with-scip/type-graph/create-type-graph-csv-test.sh.
# Requires jq to be installed for the core test cases.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/scip-index-import" directory if not already set
SCIP_TEST_SCRIPT_DIR=${SCIP_TEST_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPT="${SCIP_TEST_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jImport.sh"

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
        echo "        Expected exit code: ${expected_exit}, got: ${actual_exit}"
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

function assert_equals() {
    local description="${1}"
    local expected="${2}"
    local actual="${3}"
    if [[ "${expected}" == "${actual}" ]]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Expected: ${expected}, got: ${actual}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Minimal valid SCIP JSON for Java-like project
# ---------------------------------------------------------------------------

# Creates a minimal SCIP JSON index with one internal class and one external reference.
function create_minimal_java_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Foo.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven jdk 11 java/lang/String#",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven jdk 11 java/lang/String#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# Creates a second minimal SCIP JSON for a different project referencing types from the first.
function create_second_java_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/other/Bar.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.other/lib 2.0 com/other/Bar#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.other/lib 2.0 com/other/Bar#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test setup helpers
# ---------------------------------------------------------------------------

function run_script_with_env() {
    local indices_dir="${1}"
    local import_dir="${2}"
    shift 2
    set +e
    output=$(INDICES_DIRECTORY="${indices_dir}" IMPORT_DIRECTORY="${import_dir}" bash "${SCRIPT}" 2>&1)
    exit_code=$?
    set -e
}

# ---------------------------------------------------------------------------
# Test: INDICES_DIRECTORY does not exist
# ---------------------------------------------------------------------------

echo "Test: missing INDICES_DIRECTORY"
tmp_test_dir=$(mktemp -d)
trap 'rm -rf "${tmp_test_dir}"' EXIT

run_script_with_env "${tmp_test_dir}/nonexistent" "${tmp_test_dir}/import"
assert_exit_code "exits non-zero when INDICES_DIRECTORY missing" "1" "${exit_code}"
assert_contains "error mentions INDICES_DIRECTORY" "does not exist" "${output}"
echo ""

# ---------------------------------------------------------------------------
# Test: non-.scip.json file in INDICES_DIRECTORY
# ---------------------------------------------------------------------------

echo "Test: non-.scip.json file rejected"
bad_indices_dir="${tmp_test_dir}/bad_indices"
mkdir -p "${bad_indices_dir}"
echo "binary" > "${bad_indices_dir}/index.scip"

run_script_with_env "${bad_indices_dir}" "${tmp_test_dir}/import"
assert_exit_code "exits non-zero for binary .scip file" "1" "${exit_code}"
assert_contains "error mentions unsupported files" "Only .scip.json files are supported" "${output}"
assert_contains "error lists the offending file" "index.scip" "${output}"
echo ""

# ---------------------------------------------------------------------------
# Test: empty INDICES_DIRECTORY (no .scip.json files)
# ---------------------------------------------------------------------------

echo "Test: empty INDICES_DIRECTORY"
empty_indices_dir="${tmp_test_dir}/empty_indices"
mkdir -p "${empty_indices_dir}"

run_script_with_env "${empty_indices_dir}" "${tmp_test_dir}/import"
assert_exit_code "exits non-zero when no .scip.json files" "1" "${exit_code}"
assert_contains "error mentions no .scip.json files" "No *.scip.json files found" "${output}"
echo ""

# ---------------------------------------------------------------------------
# Skip remaining tests if jq is not installed
# ---------------------------------------------------------------------------

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not found — skipping CSV content tests"
    echo ""
    echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed (jq tests skipped)"
    exit $((FAIL_COUNT > 0 ? 1 : 0))
fi

# ---------------------------------------------------------------------------
# Test: single file — node CSV headers and content
# ---------------------------------------------------------------------------

echo "Test: single file - node CSV"
single_indices_dir="${tmp_test_dir}/single_indices"
single_import_dir="${tmp_test_dir}/single_import"
mkdir -p "${single_indices_dir}"

create_minimal_java_scip_json > "${single_indices_dir}/app.scip.json"

run_script_with_env "${single_indices_dir}" "${single_import_dir}"
assert_exit_code "exits 0 for valid single file" "0" "${exit_code}"

nodes_csv="${single_import_dir}/scip_type_nodes.csv"
edges_csv="${single_import_dir}/scip_type_edges.csv"

assert_file_exists "creates scip_type_nodes.csv" "${nodes_csv}"
assert_file_exists "creates scip_type_edges.csv" "${edges_csv}"

nodes_content=$(cat "${nodes_csv}")
assert_contains "nodes CSV has correct header" \
    '"symbol","display_name","scheme","type_name","file","package_id","package_manager","version","module","is_abstract"' \
    "${nodes_content}"

assert_contains "internal type Foo appears as a node" "com/example/Foo#" "${nodes_content}"
assert_contains "external type String appears as an external node" "java/lang/String#" "${nodes_content}"

edges_content=$(cat "${edges_csv}")
assert_contains "edges CSV has correct header" \
    '"source_symbol","target_symbol","reference_count"' \
    "${edges_content}"

# Foo references String twice → reference_count should be 2
assert_contains "edge from Foo to String has reference_count 2" ",2" "${edges_content}"
echo ""

# ---------------------------------------------------------------------------
# Test: multi-file merge — node deduplication and edge reference_count sum
# ---------------------------------------------------------------------------

echo "Test: multi-file merge - deduplication and edge sum"
multi_indices_dir="${tmp_test_dir}/multi_indices"
multi_import_dir="${tmp_test_dir}/multi_import"
mkdir -p "${multi_indices_dir}"

create_minimal_java_scip_json  > "${multi_indices_dir}/app1.scip.json"
create_second_java_scip_json   > "${multi_indices_dir}/app2.scip.json"

run_script_with_env "${multi_indices_dir}" "${multi_import_dir}"
assert_exit_code "exits 0 for valid multi-file input" "0" "${exit_code}"

multi_nodes_csv="${multi_import_dir}/scip_type_nodes.csv"
multi_edges_csv="${multi_import_dir}/scip_type_edges.csv"

assert_file_exists "creates merged scip_type_nodes.csv" "${multi_nodes_csv}"
assert_file_exists "creates merged scip_type_edges.csv" "${multi_edges_csv}"

multi_nodes=$(cat "${multi_nodes_csv}")
# Foo from project A, Bar from project B — both should appear
assert_contains "merged nodes contain Foo from project A" "com/example/Foo#" "${multi_nodes}"
assert_contains "merged nodes contain Bar from project B" "com/other/Bar#" "${multi_nodes}"

# Foo should appear exactly once (both files reference it; file 1 defines it internally, file 2 as external)
foo_count=$(echo "${multi_nodes}" | grep -c "com/example/Foo#" || true)
assert_equals "Foo deduplicated to single occurrence" "1" "${foo_count}"

multi_edges=$(cat "${multi_edges_csv}")
# Bar (project B) references Foo (project A, external from B) 3 times
assert_contains "Bar→Foo edge exists in merged edges" "com/other/Bar#" "${multi_edges}"
assert_contains "Bar→Foo reference_count is 3" ",3" "${multi_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: .sha change-detection file ignored (created by change detection)
# ---------------------------------------------------------------------------

echo "Test: .sha file tolerance (change detection)"
sha_indices_dir="${tmp_test_dir}/sha_indices"
sha_import_dir="${tmp_test_dir}/sha_import"
mkdir -p "${sha_indices_dir}"

create_minimal_java_scip_json > "${sha_indices_dir}/app.scip.json"
echo "abc123def456" > "${sha_indices_dir}/scipIndexChangeDetection.sha"

run_script_with_env "${sha_indices_dir}" "${sha_import_dir}"
assert_exit_code "exits 0 with .sha file present" "0" "${exit_code}"

sha_nodes_csv="${sha_import_dir}/scip_type_nodes.csv"
assert_file_exists "creates scip_type_nodes.csv despite .sha file" "${sha_nodes_csv}"
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
