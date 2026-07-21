#!/usr/bin/env bash

# Tests convertScipIndexToCsvForNeo4jAdminImport.sh: validation, CSV columns, multi-file merge, admin-specific fields.
# Follows testConvertScipIndexToCsvForNeo4jImport.sh structure and assertion helpers.
# Requires jq to be installed for the core test cases.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/scip-index-import" directory if not already set
SCIP_ADMIN_TEST_SCRIPT_DIR=${SCIP_ADMIN_TEST_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPT="${SCIP_ADMIN_TEST_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jAdminImport.sh"

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
        echo "        Expected: ${expected}, got: ${actual}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Fixtures — minimal SCIP JSON documents for each test scenario
# ---------------------------------------------------------------------------

# Java class (semanticdb scheme), non-test path. Foo references String twice (external).
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

# Java interface (semanticdb scheme), non-test path. Used to verify isAbstract=true.
function create_interface_java_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/IService.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/IService#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/IService#",
          "kind": 21
        }
      ]
    }
  ]
}
EOF
}

# Java class at a test path. Used to verify isTest=true for test-path files.
function create_test_path_java_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/test/java/com/example/FooTest.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/FooTest#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/FooTest#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# TypeScript interface (scip-typescript scheme). Used to verify language=TypeScript.
function create_typescript_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/components/Button.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm react 18.0.0 Button#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "scip-typescript npm react 18.0.0 Button#",
          "kind": 21
        }
      ]
    }
  ]
}
EOF
}

# Second project referencing Foo from the first (3 references). Used for multi-file merge.
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
# Test setup helper
# ---------------------------------------------------------------------------

function run_script_with_env() {
    local indices_dir="${1}"
    local import_dir="${2}"
    set +e
    output=$(INDICES_DIRECTORY="${indices_dir}" IMPORT_DIRECTORY="${import_dir}" bash "${SCRIPT}" 2>&1)
    exit_code=$?
    set -e
}

# ---------------------------------------------------------------------------
# Test: missing INDICES_DIRECTORY exits non-zero
# ---------------------------------------------------------------------------

echo "Test 13: missing INDICES_DIRECTORY"
tmp_test_dir=$(mktemp -d)
trap 'rm -rf "${tmp_test_dir}"' EXIT

run_script_with_env "${tmp_test_dir}/nonexistent" "${tmp_test_dir}/import"
assert_exit_code "exits non-zero when INDICES_DIRECTORY missing" "1" "${exit_code}"
assert_contains "error mentions INDICES_DIRECTORY" "does not exist" "${output}"
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
# Set up a single-file test environment (Java fixture)
# ---------------------------------------------------------------------------

single_indices_dir="${tmp_test_dir}/single_indices"
single_import_dir="${tmp_test_dir}/single_import"
mkdir -p "${single_indices_dir}"
create_minimal_java_scip_json > "${single_indices_dir}/app.scip.json"

run_script_with_env "${single_indices_dir}" "${single_import_dir}"

nodes_csv="${single_import_dir}/scip_type_nodes_admin.csv"
edges_csv="${single_import_dir}/scip_type_edges_admin.csv"

# ---------------------------------------------------------------------------
# Test 1: node CSV header contains admin-specific columns
# ---------------------------------------------------------------------------

echo "Test 1: node CSV header columns"
assert_exit_code "exits 0 for valid single file" "0" "${exit_code}"
assert_file_exists "creates scip_type_nodes_admin.csv" "${nodes_csv}"
assert_file_exists "creates scip_type_edges_admin.csv" "${edges_csv}"

nodes_header=$(head -1 "${nodes_csv}")
assert_contains "node header has symbol:ID(ScipNode)"  "symbol:ID(ScipNode)"  "${nodes_header}"
assert_contains "node header has :LABEL"               ":LABEL"               "${nodes_header}"
assert_contains "node header has language"             '"language"'          "${nodes_header}"
assert_contains "node header has typeName"             '"typeName"'          "${nodes_header}"
assert_contains "node header has isTest:boolean"       "isTest:boolean"       "${nodes_header}"
assert_contains "node header has isAbstract:boolean"   "isAbstract:boolean"   "${nodes_header}"
assert_contains "node header has fqn"                  '"fqn"'               "${nodes_header}"
echo ""

# ---------------------------------------------------------------------------
# Test 2: edge CSV header contains admin-specific columns
# ---------------------------------------------------------------------------

echo "Test 2: edge CSV header columns"
edges_header=$(head -1 "${edges_csv}")
assert_contains "edge header has :START_ID(ScipNode)"  ":START_ID(ScipNode)"  "${edges_header}"
assert_contains "edge header has :END_ID(ScipNode)"    ":END_ID(ScipNode)"    "${edges_header}"
assert_contains "edge header has :TYPE"                ":TYPE"                "${edges_header}"
assert_contains "edge header has referenceCount:int"   "referenceCount:int"   "${edges_header}"
echo ""

# ---------------------------------------------------------------------------
# Test 3: internal type node has SCIP;SemanticCodeIndexInternalType label
# ---------------------------------------------------------------------------

echo "Test 3: internal type :LABEL"
nodes_content=$(cat "${nodes_csv}")
assert_contains "Foo node has internal type label" "SCIP;SemanticCodeIndexInternalType" "${nodes_content}"
echo ""

# ---------------------------------------------------------------------------
# Test 4: external type node has SCIP;SemanticCodeIndexExternalType label
# ---------------------------------------------------------------------------

echo "Test 4: external type :LABEL"
assert_contains "String node has external type label" "SCIP;SemanticCodeIndexExternalType" "${nodes_content}"
echo ""

# ---------------------------------------------------------------------------
# Test 5: language computed from scheme (semanticdb → Java)
# ---------------------------------------------------------------------------

echo "Test 5: language computed from scheme"
foo_row=$(echo "${nodes_content}" | grep "com/example/Foo#" | head -1)
assert_contains "semanticdb scheme produces language=Java" '"Java"' "${foo_row}"
echo ""

# ---------------------------------------------------------------------------
# Test 6: fqn column equals symbol:ID column value
# ---------------------------------------------------------------------------

echo "Test 6: fqn equals symbol:ID"
# symbol:ID is col 1, fqn is col 2 — both should have the same short_symbol value
# Use awk to compare first and second CSV fields for the Foo row
foo_fields=$(echo "${foo_row}" | awk -F'","' '{gsub(/^"/,"",$1); gsub(/"$/,"",$2); print $1 "==" $2}')
if [[ "${foo_fields}" == *"=="* ]]; then
    local_symbol=$(echo "${foo_fields}" | cut -d'=' -f1)
    local_fqn=$(echo "${foo_fields}" | cut -d'=' -f3)
    assert_equals "fqn column equals symbol:ID column" "${local_symbol}" "${local_fqn}"
else
    echo "  FAIL: fqn vs symbol:ID — could not parse row fields"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Test 7: Interface kind → isAbstract:boolean = true
# ---------------------------------------------------------------------------

echo "Test 7: Interface → isAbstract:boolean=true"
iface_indices_dir="${tmp_test_dir}/iface_indices"
iface_import_dir="${tmp_test_dir}/iface_import"
mkdir -p "${iface_indices_dir}"
create_interface_java_scip_json > "${iface_indices_dir}/iface.scip.json"

run_script_with_env "${iface_indices_dir}" "${iface_import_dir}"
assert_exit_code "exits 0 for interface fixture" "0" "${exit_code}"

iface_nodes=$(cat "${iface_import_dir}/scip_type_nodes_admin.csv")
iface_row=$(echo "${iface_nodes}" | grep "IService" | head -1)
assert_contains "Interface row has isAbstract:boolean=true" '"true"' "${iface_row}"
echo ""

# ---------------------------------------------------------------------------
# Test 8: test-path file → isTest:boolean = true; non-test file → false
# ---------------------------------------------------------------------------

echo "Test 8: isTest:boolean based on file path"
test_path_indices_dir="${tmp_test_dir}/testpath_indices"
test_path_import_dir="${tmp_test_dir}/testpath_import"
mkdir -p "${test_path_indices_dir}"
create_minimal_java_scip_json     > "${test_path_indices_dir}/app.scip.json"
create_test_path_java_scip_json   > "${test_path_indices_dir}/test.scip.json"

run_script_with_env "${test_path_indices_dir}" "${test_path_import_dir}"
assert_exit_code "exits 0 for test-path fixture" "0" "${exit_code}"

testpath_nodes=$(cat "${test_path_import_dir}/scip_type_nodes_admin.csv")
foo_test_row=$(echo "${testpath_nodes}"  | grep "FooTest"                 | head -1)
foo_main_row=$(echo "${testpath_nodes}"  | grep "com/example/Foo#" | head -1)
assert_contains     "test-path node has isTest:boolean=true"  '"true"'  "${foo_test_row}"
assert_not_contains "non-test node does not have isTest=true" '"true","' "${foo_main_row}"
echo ""

# ---------------------------------------------------------------------------
# Test 9: external type → isTest:boolean = false
# ---------------------------------------------------------------------------

echo "Test 9: external type isTest:boolean=false"
string_row=$(echo "${nodes_content}" | grep "java/lang/String#" | head -1)
assert_contains "external String node has isTest:boolean=false" '"false"' "${string_row}"
echo ""

# ---------------------------------------------------------------------------
# Test 10: edge :TYPE = DEPENDS_ON; referenceCount:int is a valid integer
# ---------------------------------------------------------------------------

echo "Test 10: edge :TYPE and referenceCount:int"
edges_content=$(cat "${edges_csv}")
assert_contains "edge :TYPE is DEPENDS_ON"      '"DEPENDS_ON"' "${edges_content}"
# referenceCount:int for Foo→String is 2 (two references); appears unquoted as integer
assert_contains "referenceCount:int is integer" ',2'           "${edges_content}"
echo ""

# ---------------------------------------------------------------------------
# Test 11: :START_ID(ScipNode) values in edges match nodes in node CSV
# ---------------------------------------------------------------------------

echo "Test 11: edge :START_ID matches node ID"
# Extract the :START_ID from the first edge data row (col 1, quoted)
first_edge_row=$(grep "DEPENDS_ON" "${edges_csv}" | head -1)
start_id=$(echo "${first_edge_row}" | awk -F'","' '{gsub(/^"/,"",$1); print $1}')
# The start_id should appear as a symbol:ID in the node CSV
assert_contains "edge :START_ID found in node CSV" "${start_id}" "${nodes_content}"
echo ""

# ---------------------------------------------------------------------------
# Test 5b: scip-typescript scheme → language = TypeScript
# ---------------------------------------------------------------------------

echo "Test 5b: scip-typescript scheme → language=TypeScript"
ts_indices_dir="${tmp_test_dir}/ts_indices"
ts_import_dir="${tmp_test_dir}/ts_import"
mkdir -p "${ts_indices_dir}"
create_typescript_scip_json > "${ts_indices_dir}/ts.scip.json"

run_script_with_env "${ts_indices_dir}" "${ts_import_dir}"
assert_exit_code "exits 0 for TypeScript fixture" "0" "${exit_code}"

ts_nodes=$(cat "${ts_import_dir}/scip_type_nodes_admin.csv")
button_row=$(echo "${ts_nodes}" | grep "Button" | head -1)
assert_contains "scip-typescript scheme produces language=TypeScript" '"TypeScript"' "${button_row}"
echo ""

# ---------------------------------------------------------------------------
# Test 12: multi-file merge — deduplication and referenceCount:int summing
# ---------------------------------------------------------------------------

echo "Test 12: multi-file merge"
multi_indices_dir="${tmp_test_dir}/multi_indices"
multi_import_dir="${tmp_test_dir}/multi_import"
mkdir -p "${multi_indices_dir}"

create_minimal_java_scip_json > "${multi_indices_dir}/app1.scip.json"
create_second_java_scip_json  > "${multi_indices_dir}/app2.scip.json"

run_script_with_env "${multi_indices_dir}" "${multi_import_dir}"
assert_exit_code "exits 0 for valid multi-file input" "0" "${exit_code}"

multi_nodes=$(cat "${multi_import_dir}/scip_type_nodes_admin.csv")
assert_contains "merged nodes contain Foo from project A" "com/example/Foo#"  "${multi_nodes}"
assert_contains "merged nodes contain Bar from project B" "com/other/Bar#"    "${multi_nodes}"

foo_count=$(echo "${multi_nodes}" | grep -c "com/example/Foo#" || true)
assert_equals "Foo deduplicated to single occurrence" "1" "${foo_count}"

multi_edges=$(cat "${multi_import_dir}/scip_type_edges_admin.csv")
# Bar (project B) references Foo (external from B) 3 times → referenceCount:int=3
assert_contains "Bar→Foo edge exists in merged edges" "com/other/Bar#" "${multi_edges}"
assert_contains "Bar→Foo referenceCount:int summed to 3" ',3' "${multi_edges}"
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
