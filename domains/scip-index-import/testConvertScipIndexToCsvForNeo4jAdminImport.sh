#!/usr/bin/env bash

# Tests convertScipIndexToCsvForNeo4jAdminImport.sh: validation, CSV columns, multi-file merge, admin-specific fields, anonymous inner classes.
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
        echo "  FAIL: exits ${expected_exit} for ${description}" >&2
        echo "        Expected exit code: ${expected_exit}, got: ${actual_exit}" >&2
        echo "        Script output (first 50 lines):" >&2
        echo "${output:-<empty>}" | head -50 | sed 's/^/        /' >&2
        test_failed
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
function assert_no_duplicate_nodes() {
    local description="${1}"
    local node_csv="${2}"
    if [[ ! -f "${node_csv}" ]]; then
        return  # Skip if file doesn't exist
    fi
    local total_nodes=$(tail -n +2 "${node_csv}" 2>/dev/null | wc -l || echo 0)
    local unique_nodes=$(tail -n +2 "${node_csv}" 2>/dev/null | cut -d',' -f1 | sort -u | wc -l || echo 0)
    if [[ ${total_nodes} -eq ${unique_nodes} ]]; then
        echo "  PASS: ${description} (${unique_nodes} unique nodes)"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}"
        echo "        Found ${total_nodes} total nodes but only ${unique_nodes} unique (${((total_nodes - unique_nodes))} duplicates)"
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

# Creates SCIP JSON with method-suffixed type references (var-inferred dependencies).
# Tests that references like "TypeName#methodName()." are properly normalized and create edges.
function create_method_reference_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Handler.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Handler#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#handle().",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#process().",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Handler#",
          "kind": 7
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#",
          "kind": 7
        }
      ]
    },
    {
      "relative_path": "src/main/java/com/example/Interceptor.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#handle().",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#process().",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Interceptor#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# Creates SCIP JSON with field-suffixed type references.
# Tests that field references like "TypeName#fieldName." are properly normalized.
function create_field_reference_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Config.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Config#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#provider.",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#cache.",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Config#",
          "kind": 7
        }
      ]
    },
    {
      "relative_path": "src/main/java/com/example/Factory.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#provider.",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#cache.",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Factory#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# Creates SCIP JSON with same-type method references to test self-loop filtering.
# Tests that references from a type to its own methods do not create self-loop edges.
function create_self_loop_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Service.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#execute().",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#execute().",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#validate().",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#validate().",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Service#",
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
# Test: method-suffixed references (var-inferred dependencies)
# ---------------------------------------------------------------------------

echo "Test: method-suffixed type references (admin import)"
method_ref_indices_dir="${tmp_test_dir}/method_ref_indices"
method_ref_import_dir="${tmp_test_dir}/method_ref_import"
mkdir -p "${method_ref_indices_dir}"

create_method_reference_scip_json > "${method_ref_indices_dir}/method_refs.scip.json"

run_script_with_env "${method_ref_indices_dir}" "${method_ref_import_dir}"
assert_exit_code "exits 0 for method-suffixed references" "0" "${exit_code}"

method_ref_edges_admin_csv="${method_ref_import_dir}/scip_type_edges_admin.csv"
assert_file_exists "creates admin edge CSV with method references" "${method_ref_edges_admin_csv}"

method_ref_edges=$(cat "${method_ref_edges_admin_csv}")
# Handler references Interceptor methods (handle(), process()) and type
# All should normalize to base type Interceptor# and create edges
assert_contains "edge from Handler to Interceptor" "com/example/Handler#" "${method_ref_edges}"
assert_contains "target is Interceptor base type" "com/example/Interceptor#" "${method_ref_edges}"

# Verify admin-specific fields (relationship type, isInternal, language)
assert_contains "edge has DEPENDS_ON relationship type" "DEPENDS_ON" "${method_ref_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: field-suffixed references (var-inferred field dependencies)
# ---------------------------------------------------------------------------

echo "Test: field-suffixed type references (admin import)"
field_ref_indices_dir="${tmp_test_dir}/field_ref_indices"
field_ref_import_dir="${tmp_test_dir}/field_ref_import"
mkdir -p "${field_ref_indices_dir}"

create_field_reference_scip_json > "${field_ref_indices_dir}/field_refs.scip.json"

run_script_with_env "${field_ref_indices_dir}" "${field_ref_import_dir}"
assert_exit_code "exits 0 for field-suffixed references" "0" "${exit_code}"

field_ref_edges_admin_csv="${field_ref_import_dir}/scip_type_edges_admin.csv"
assert_file_exists "creates admin edge CSV with field references" "${field_ref_edges_admin_csv}"

field_ref_edges=$(cat "${field_ref_edges_admin_csv}")
# Config references Factory fields (provider., cache.) and type
# All should normalize to base type Factory# and create edges
assert_contains "edge from Config to Factory (from field ref .provider)" "com/example/Config#" "${field_ref_edges}"
assert_contains "target is Factory base type" "com/example/Factory#" "${field_ref_edges}"

# Verify admin-specific fields
assert_contains "edge has relationship type" "DEPENDS_ON" "${field_ref_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: self-loop filtering (method refs within same type should not create edges)
# ---------------------------------------------------------------------------

echo "Test: self-loop filtering for same-type method references (admin import)"
self_loop_indices_dir="${tmp_test_dir}/self_loop_indices"
self_loop_import_dir="${tmp_test_dir}/self_loop_import"
mkdir -p "${self_loop_indices_dir}"

create_self_loop_scip_json > "${self_loop_indices_dir}/self_loop.scip.json"

run_script_with_env "${self_loop_indices_dir}" "${self_loop_import_dir}"
assert_exit_code "exits 0 for self-loop test" "0" "${exit_code}"

self_loop_edges_admin_csv="${self_loop_import_dir}/scip_type_edges_admin.csv"
assert_file_exists "creates admin edge CSV" "${self_loop_edges_admin_csv}"

self_loop_edges=$(cat "${self_loop_edges_admin_csv}")
# Service defines methods execute() and validate(), and has internal references to them
# These should NOT create self-loop edges (Service → Service)
self_loop_count=$(echo "${self_loop_edges}" | grep "com/example/Service#" | grep "com/example/Service#" || true)
if [[ -z "${self_loop_count}" ]]; then
    echo "  PASS: self-loops (Service→Service) are filtered out"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "  FAIL: self-loops should be filtered, but found: ${self_loop_count}"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# Test: node deduplication
echo "Test: node deduplication (no duplicate base types, admin import)"
node_dedup_indices_dir="${tmp_test_dir}/node_dedup_indices"
node_dedup_import_dir="${tmp_test_dir}/node_dedup_import"
mkdir -p "${node_dedup_indices_dir}"

# Use method_reference fixture which has potential for duplicate nodes if filtering is wrong
create_method_reference_scip_json > "${node_dedup_indices_dir}/method_ref.scip.json"

run_script_with_env "${node_dedup_indices_dir}" "${node_dedup_import_dir}"
assert_exit_code "exits 0 for node dedup test" "0" "${exit_code}"

node_dedup_nodes_csv="${node_dedup_import_dir}/scip_type_nodes_admin.csv"
assert_file_exists "creates admin node CSV" "${node_dedup_nodes_csv}"
assert_no_duplicate_nodes "no duplicate nodes (base types only, admin)" "${node_dedup_nodes_csv}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: Java class with one anonymous inner class implementing Callback.
# local 3 has enclosing_symbol + relationships.is_implementation to verify
# anonymous class node creation and DEPENDS_ON edge generation.
# ---------------------------------------------------------------------------

function create_anonymous_class_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///tmp/test-anon-project",
    "tool_info": {"name": "test-indexer", "version": "1.0"}
  },
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Manager.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Manager#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven jdk 11 com/example/Callback#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Manager#",
          "kind": 7
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Manager#execute().",
          "kind": 26
        },
        {
          "symbol": "local 0",
          "kind": null,
          "enclosing_symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Manager#execute()."
        },
        {
          "symbol": "local 3",
          "display_name": "run",
          "kind": 26,
          "enclosing_symbol": "local 0",
          "relationships": [
            {
              "symbol": "semanticdb maven jdk 11 com/example/Callback#run().",
              "is_implementation": true
            }
          ]
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: anonymous inner class node creation (admin import)
# ---------------------------------------------------------------------------

echo "Test: anonymous inner class node (admin import)"
anon_indices_dir="${tmp_test_dir}/anon_indices"
anon_import_dir="${tmp_test_dir}/anon_import"
mkdir -p "${anon_indices_dir}"
create_anonymous_class_scip_json > "${anon_indices_dir}/manager.scip.json"

run_script_with_env "${anon_indices_dir}" "${anon_import_dir}"
if [ "${exit_code}" -ne 0 ]; then
    echo "❌ Script failed with exit code ${exit_code}. Output:"
    echo "${output}"
fi
assert_exit_code "exits 0 for anonymous class fixture" "0" "${exit_code}"

anon_nodes_csv="${anon_import_dir}/scip_type_nodes_admin.csv"
assert_file_exists "creates admin node CSV for anonymous class fixture" "${anon_nodes_csv}"

anon_nodes=$(cat "${anon_nodes_csv}")
assert_contains "anonymous class node has \$anonymous in ID"          '$anonymous'                                              "${anon_nodes}"
assert_contains "anonymous class node has typeName=AnonymousClass"    '"AnonymousClass"'                                        "${anon_nodes}"
assert_contains "anonymous class node has AnonymousType label"        "SemanticCodeIndexAnonymousType"                          "${anon_nodes}"
assert_contains "anonymous class node has InternalType label"         "SemanticCodeIndexInternalType"                           "${anon_nodes}"
assert_contains "anonymous class node has language=Java"              '"Java"'                                                  "${anon_nodes}"
assert_contains "anonymous class node has isAbstract:boolean=false"   '"false"'                                                 "${anon_nodes}"
assert_contains "enclosing class Manager also exists as node"         "com/example/Manager#"                                    "${anon_nodes}"
assert_no_duplicate_nodes "no duplicate nodes with anonymous class"   "${anon_nodes_csv}"
echo ""

# ---------------------------------------------------------------------------
# Test: anonymous inner class DEPENDS_ON edge to implemented interface (admin)
# ---------------------------------------------------------------------------

echo "Test: anonymous inner class DEPENDS_ON edge (admin import)"
anon_edges_csv="${anon_import_dir}/scip_type_edges_admin.csv"
assert_file_exists "creates admin edge CSV for anonymous class fixture" "${anon_edges_csv}"

anon_edges=$(cat "${anon_edges_csv}")
assert_contains "anonymous class depends on Callback interface" '$anonymous'              "${anon_edges}"
assert_contains "anonymous DEPENDS_ON edge targets Callback#"  "com/example/Callback#"  "${anon_edges}"
assert_contains "edge has DEPENDS_ON relationship type"        "DEPENDS_ON"              "${anon_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: anonymous inner class BELONGS_TO project link (admin import)
# ---------------------------------------------------------------------------

echo "Test: anonymous inner class BELONGS_TO link (admin import)"
anon_links_csv="${anon_import_dir}/scip_type_project_links_admin.csv"
assert_file_exists "creates admin link CSV for anonymous class fixture" "${anon_links_csv}"

anon_links=$(cat "${anon_links_csv}")
assert_contains "anonymous class node has BELONGS_TO link" '$anonymous' "${anon_links}"
echo ""

# ---------------------------------------------------------------------------
# Test: local symbol without methods inside must NOT produce anonymous class node
# Covers the false-positive case: local variables with enclosing_symbol but no
# methods (kind=26/66/67/80) nested inside them. Only true anonymous inner classes
# (with methods inside) should be detected.
# ---------------------------------------------------------------------------

echo "Test: no anonymous class node for local symbol without methods (admin)"
no_anon_indices_dir="${tmp_test_dir}/no_anon_indices"
no_anon_import_dir="${tmp_test_dir}/no_anon_import"
mkdir -p "${no_anon_indices_dir}"
cat << 'EOF' > "${no_anon_indices_dir}/constructor.scip.json"
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/MyException.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyException#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyException#",
          "kind": 7
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyException#`<init>`(+1).",
          "kind": 26
        },
        {
          "symbol": "local 1",
          "display_name": "message",
          "kind": 13,
          "enclosing_symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyException#`<init>`(+1)."
        }
      ]
    }
  ]
}
EOF

run_script_with_env "${no_anon_indices_dir}" "${no_anon_import_dir}"
assert_exit_code "exits 0 for no-is_implementation fixture" "0" "${exit_code}"

no_anon_nodes_csv="${no_anon_import_dir}/scip_type_nodes_admin.csv"
assert_file_exists "creates admin node CSV" "${no_anon_nodes_csv}"

no_anon_nodes=$(cat "${no_anon_nodes_csv}")
if echo "${no_anon_nodes}" | grep -qF '$anonymous'; then
    echo "  FAIL: local symbol without methods inside should NOT create anonymous class node"
    FAIL_COUNT=$((FAIL_COUNT + 1))
else
    echo "  PASS: no anonymous class node for local symbol without methods"
    PASS_COUNT=$((PASS_COUNT + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
