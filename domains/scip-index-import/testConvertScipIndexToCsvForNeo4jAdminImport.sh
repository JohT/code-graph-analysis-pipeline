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
assert_contains "node header has descriptor"           '"descriptor"'        "${nodes_header}"
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
# Test 9b: descriptor property — internal and external nodes carry their SCIP descriptor
# ---------------------------------------------------------------------------

echo "Test 9b: descriptor property"
foo_row=$(echo "${nodes_content}" | grep "com/example/Foo#" | head -1)
assert_contains "internal Foo node has descriptor com/example/Foo#" '"com/example/Foo#"' "${foo_row}"
assert_contains "external String node has descriptor java/lang/String#" '"java/lang/String#"' "${string_row}"
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
# Fixture: outer interface with inner interface, and a class referencing the inner.
# Models the AxonFramework Cache#EntryListener# pattern:
#   - Cache.java defines Cache# (outer) and Cache#EntryListener# (inner interface)
#   - WeakReferenceCache.java references Cache#EntryListener# (null role = reference)
#     and calls a method Cache#EntryListener#onEntryExpired(). (role 0 = usage)
# The admin is_type_descriptor only matches endswith("#"), so the method call is
# filtered out. After the normalize_symbol fix, count is 1 (bare type reference only).
# ---------------------------------------------------------------------------

function create_inner_type_reference_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/org/example/Cache.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven . . org/example/Cache#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven . . org/example/Cache#EntryListener#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven . . org/example/Cache#",
          "kind": 21
        },
        {
          "symbol": "semanticdb maven . . org/example/Cache#EntryListener#",
          "kind": 21
        }
      ]
    },
    {
      "relative_path": "src/main/java/org/example/WeakReferenceCache.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven . . org/example/WeakReferenceCache#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven . . org/example/Cache#EntryListener#"
        },
        {
          "symbol": "semanticdb maven . . org/example/Cache#EntryListener#onEntryExpired().",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven . . org/example/WeakReferenceCache#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: inner type references (e.g. Cache#EntryListener#) create edges to the
# inner type itself, not the outer type.
# Regression test for normalize_symbol incorrectly stripping inner type paths.
# Admin import: method call is filtered by is_type_descriptor, count is 1.
# ---------------------------------------------------------------------------

echo "Test: inner type reference creates edge to inner type, not outer type (admin)"
inner_type_ref_indices_dir="${tmp_test_dir}/inner_type_ref_indices"
inner_type_ref_import_dir="${tmp_test_dir}/inner_type_ref_import"
mkdir -p "${inner_type_ref_indices_dir}"

create_inner_type_reference_scip_json > "${inner_type_ref_indices_dir}/inner_type_ref.scip.json"

run_script_with_env "${inner_type_ref_indices_dir}" "${inner_type_ref_import_dir}"
assert_exit_code "exits 0 for inner type reference fixture (admin)" "0" "${exit_code}"

inner_type_nodes_csv="${inner_type_ref_import_dir}/scip_type_nodes_admin.csv"
inner_type_edges_csv="${inner_type_ref_import_dir}/scip_type_edges_admin.csv"
assert_file_exists "creates admin node CSV for inner type fixture" "${inner_type_nodes_csv}"
assert_file_exists "creates admin edge CSV for inner type fixture" "${inner_type_edges_csv}"

inner_type_nodes=$(cat "${inner_type_nodes_csv}")
assert_contains "inner interface Cache#EntryListener# is a node (admin)" "Cache#EntryListener#" "${inner_type_nodes}"

inner_type_edges=$(cat "${inner_type_edges_csv}")
# WeakReferenceCache references Cache#EntryListener# (null role only; method call filtered by is_type_descriptor).
# count is 1 — only the bare type reference with null role passes the admin filter.
assert_contains "WeakReferenceCache depends on inner type Cache#EntryListener# (admin)" "Cache#EntryListener#" "${inner_type_edges}"
# The full target symbol '. . org/example/Cache#' (closed by quote + comma) must not appear:
# 'WeakReferenceCache#"' contains 'Cache#"' as a substring, but not '"Cache#",' (full quoted value).
assert_not_contains "inner type Cache#EntryListener# not collapsed to outer Cache# (admin)" '". . org/example/Cache#",' "${inner_type_edges}"
assert_contains "edge has DEPENDS_ON relationship type (inner type)" "DEPENDS_ON" "${inner_type_edges}"

inner_edge=$(echo "${inner_type_edges}" | grep "WeakReferenceCache#" | grep "Cache#EntryListener#" || true)
assert_contains "WeakReferenceCache→Cache#EntryListener# reference count is 1 (admin)" ",1" "${inner_edge}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: sibling inner types in the same file (BUG 1 regression test for admin).
# ---------------------------------------------------------------------------

function create_sibling_inner_type_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/org/example/Outer.java",
      "occurrences": [
        {"symbol": "semanticdb maven . . org/example/Outer#", "symbol_roles": 1},
        {"symbol": "semanticdb maven . . org/example/Outer#InnerA#", "symbol_roles": 1},
        {"symbol": "semanticdb maven . . org/example/Outer#InnerB#", "symbol_roles": 1},
        {"symbol": "semanticdb maven . . org/example/Outer#InnerB#"}
      ],
      "symbols": [
        {"symbol": "semanticdb maven . . org/example/Outer#", "kind": 7},
        {"symbol": "semanticdb maven . . org/example/Outer#InnerA#", "kind": 7},
        {"symbol": "semanticdb maven . . org/example/Outer#InnerB#", "kind": 7}
      ]
    }
  ]
}
EOF
}

echo "Test: sibling inner types in same file create edges between each other (admin)"
sibling_inner_indices_dir="${tmp_test_dir}/sibling_inner_indices"
sibling_inner_import_dir="${tmp_test_dir}/sibling_inner_import"
mkdir -p "${sibling_inner_indices_dir}"

create_sibling_inner_type_scip_json > "${sibling_inner_indices_dir}/sibling_inner.scip.json"
run_script_with_env "${sibling_inner_indices_dir}" "${sibling_inner_import_dir}"
assert_exit_code "exits 0 for sibling inner type fixture (admin)" "0" "${exit_code}"

sibling_inner_edges=$(cat "${sibling_inner_import_dir}/scip_type_edges_admin.csv")
assert_contains "InnerA depends on sibling InnerB (same-file edge, admin)" \
    '. . org/example/Outer#InnerA#' "${sibling_inner_edges}"
assert_contains "InnerB is the target of the sibling edge (admin)" \
    '. . org/example/Outer#InnerB#' "${sibling_inner_edges}"
assert_not_contains "no InnerB self-loop (admin)" \
    '". . org/example/Outer#InnerB#",". . org/example/Outer#InnerB#"' "${sibling_inner_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: class implementing an interface via symbols[].relationships (BUG 2 regression test for admin).
# ---------------------------------------------------------------------------

function create_relationship_dependency_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/org/example/MyInterface.java",
      "occurrences": [
        {"symbol": "semanticdb maven . . org/example/MyInterface#", "symbol_roles": 1}
      ],
      "symbols": [
        {"symbol": "semanticdb maven . . org/example/MyInterface#", "kind": 21}
      ]
    },
    {
      "relative_path": "src/main/java/org/example/MyImpl.java",
      "occurrences": [
        {"symbol": "semanticdb maven . . org/example/MyImpl#", "symbol_roles": 1}
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven . . org/example/MyImpl#",
          "kind": 7,
          "relationships": [
            {"symbol": "semanticdb maven . . org/example/MyInterface#", "is_implementation": true}
          ]
        }
      ]
    }
  ]
}
EOF
}

echo "Test: symbols.relationships with is_implementation creates edge to implemented interface (admin)"
rel_dep_indices_dir="${tmp_test_dir}/rel_dep_indices"
rel_dep_import_dir="${tmp_test_dir}/rel_dep_import"
mkdir -p "${rel_dep_indices_dir}"

create_relationship_dependency_scip_json > "${rel_dep_indices_dir}/rel_dep.scip.json"
run_script_with_env "${rel_dep_indices_dir}" "${rel_dep_import_dir}"
assert_exit_code "exits 0 for relationship dependency fixture (admin)" "0" "${exit_code}"

rel_dep_edges=$(cat "${rel_dep_import_dir}/scip_type_edges_admin.csv")
assert_contains "MyImpl depends on MyInterface via relationship (admin)" \
    '. . org/example/MyInterface#' "${rel_dep_edges}"
assert_contains "MyImpl is the source of the relationship edge (admin)" \
    '. . org/example/MyImpl#' "${rel_dep_edges}"
assert_contains "relationship edge has DEPENDS_ON type (admin)" "DEPENDS_ON" "${rel_dep_edges}"
rel_dep_edge=$(echo "${rel_dep_edges}" | grep "MyImpl#" | grep "MyInterface#" || true)
assert_contains "relationship edge has count 1 (admin)" ",1" "${rel_dep_edge}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: cross-module is_implementation relationship (two separate SCIP files)
# Models the real-world case: class in module B implements interface from module A.
# The interface appears as both an occurrence (role=0) and a relationship target
# in module B's SCIP. The relationship edge must be created even though the
# interface's definition is in a different SCIP file.
# ---------------------------------------------------------------------------

function create_cross_module_relationship_module_a_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/api/MyInterface.java",
      "occurrences": [
        {"symbol": "semanticdb maven maven/com.example/module-a 1.0 com/example/api/MyInterface#", "symbol_roles": 1}
      ],
      "symbols": [
        {"symbol": "semanticdb maven maven/com.example/module-a 1.0 com/example/api/MyInterface#", "kind": 21}
      ]
    }
  ]
}
EOF
}

function create_cross_module_relationship_module_b_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/impl/MyImpl.java",
      "occurrences": [
        {"symbol": "semanticdb maven maven/com.example/module-b 2.0 com/example/impl/MyImpl#", "symbol_roles": 1},
        {"symbol": "semanticdb maven maven/com.example/module-a 1.0 com/example/api/MyInterface#", "symbol_roles": 0}
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/module-b 2.0 com/example/impl/MyImpl#",
          "kind": 7,
          "relationships": [
            {"symbol": "semanticdb maven maven/com.example/module-a 1.0 com/example/api/MyInterface#", "is_implementation": true}
          ]
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Fixture: cross-module relationship where target appears ONLY in relationships
# (never as an occurrence). The target node must be created from the relationship.
# Models JDK super-types, inherited external library interfaces, or AxonFramework
# types that are implemented but never explicitly referenced in the implementing
# module's source code.
# ---------------------------------------------------------------------------

function create_cross_module_relationship_relationship_only_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/impl/MyImpl.java",
      "occurrences": [
        {"symbol": "semanticdb maven maven/com.example/module-b 2.0 com/example/impl/MyImpl#", "symbol_roles": 1}
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/module-b 2.0 com/example/impl/MyImpl#",
          "kind": 7,
          "relationships": [
            {"symbol": "semanticdb maven jdk 21 java/io/Serializable#", "is_implementation": true}
          ]
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: cross-module is_implementation creates edge to interface in other module
# ---------------------------------------------------------------------------

echo "Test: cross-module is_implementation creates edge to interface in other module (admin)"
xmod_rel_indices_dir="${tmp_test_dir}/xmod_rel_indices"
xmod_rel_import_dir="${tmp_test_dir}/xmod_rel_import"
mkdir -p "${xmod_rel_indices_dir}"

create_cross_module_relationship_module_a_scip_json > "${xmod_rel_indices_dir}/module_a.scip.json"
create_cross_module_relationship_module_b_scip_json > "${xmod_rel_indices_dir}/module_b.scip.json"

run_script_with_env "${xmod_rel_indices_dir}" "${xmod_rel_import_dir}"
assert_exit_code "exits 0 for cross-module relationship fixture (admin)" "0" "${exit_code}"

xmod_rel_edges=$(cat "${xmod_rel_import_dir}/scip_type_edges_admin.csv")
assert_contains "DEPENDS_ON edge from MyImpl to cross-module MyInterface (admin)" \
    "maven/com.example/module-b 2.0 com/example/impl/MyImpl#" "${xmod_rel_edges}"
assert_contains "cross-module MyInterface is the target (admin)" \
    "maven/com.example/module-a 1.0 com/example/api/MyInterface#" "${xmod_rel_edges}"
assert_contains "cross-module relationship edge has DEPENDS_ON type (admin)" "DEPENDS_ON" "${xmod_rel_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: relationship-only target (no occurrence) creates node and edge (admin)
# ---------------------------------------------------------------------------

echo "Test: relationship-only cross-module target creates node and edge (admin)"
rel_only_indices_dir="${tmp_test_dir}/rel_only_indices"
rel_only_import_dir="${tmp_test_dir}/rel_only_import"
mkdir -p "${rel_only_indices_dir}"

create_cross_module_relationship_relationship_only_scip_json > "${rel_only_indices_dir}/rel_only.scip.json"

run_script_with_env "${rel_only_indices_dir}" "${rel_only_import_dir}"
assert_exit_code "exits 0 for relationship-only target fixture (admin)" "0" "${exit_code}"

rel_only_nodes=$(cat "${rel_only_import_dir}/scip_type_nodes_admin.csv")
assert_contains "external node created for relationship-only JDK target (admin)" \
    "jdk 21 java/io/Serializable#" "${rel_only_nodes}"

rel_only_edges=$(cat "${rel_only_import_dir}/scip_type_edges_admin.csv")
assert_contains "DEPENDS_ON edge from MyImpl to relationship-only JDK type (admin)" \
    "maven/com.example/module-b 2.0 com/example/impl/MyImpl#" "${rel_only_edges}"
assert_contains "Serializable is the target of relationship-only edge (admin)" \
    "jdk 21 java/io/Serializable#" "${rel_only_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: internal type referencing an external type whose symbol has pkg_id "."
# (no groupId/version set). Package must be derived from the descriptor path.
# Models the real-world pattern seen in aggregated SCIP indices.
# ---------------------------------------------------------------------------

function create_external_pkg_dot_scip_json() {
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
          "symbol": "semanticdb maven . . org/slf4j/Logger#",
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
# Test: external type with pkg_id "." creates a node and an edge (admin)
# Regression test: edges to these types were dropped by the "ref_pkg_id != ." filter
# ---------------------------------------------------------------------------

echo "Test: external type with pkg_id '.' creates node and edge (admin)"
ext_dot_indices_dir="${tmp_test_dir}/ext_dot_indices"
ext_dot_import_dir="${tmp_test_dir}/ext_dot_import"
mkdir -p "${ext_dot_indices_dir}"

create_external_pkg_dot_scip_json > "${ext_dot_indices_dir}/ext_dot.scip.json"

run_script_with_env "${ext_dot_indices_dir}" "${ext_dot_import_dir}"
assert_exit_code "exits 0 for pkg_id '.' fixture (admin)" "0" "${exit_code}"

ext_dot_nodes=$(cat "${ext_dot_import_dir}/scip_type_nodes_admin.csv")
assert_contains "external Logger node created despite pkg_id '.'" \
    "org/slf4j/Logger#" "${ext_dot_nodes}"
logger_row=$(echo "${ext_dot_nodes}" | grep "org/slf4j/Logger#" | head -1)
assert_contains "Logger packageId derived from descriptor, not '.'" \
    '"org/slf4j"' "${logger_row}"

ext_dot_edges=$(cat "${ext_dot_import_dir}/scip_type_edges_admin.csv")
assert_contains "edge from Service to Logger exists" \
    "com/example/Service#" "${ext_dot_edges}"
assert_contains "Logger is target of edge despite pkg_id '.'" \
    "org/slf4j/Logger#" "${ext_dot_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: file with only external type references in a directory that also
# contains a file with internal definitions. Models package-info.java files
# annotated with external annotations (e.g. @NullMarked) that reference no
# internal types. The sibling file provides directory-level package metadata.
# ---------------------------------------------------------------------------

function create_external_only_refs_with_sibling_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/package-info.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven com.external/lib 2.0 com/external/NullMarked#",
          "symbol_roles": 0
        }
      ]
    },
    {
      "relative_path": "src/main/java/com/example/MyClass.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyClass#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/MyClass#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Fixture: file with only external type references isolated in its own directory
# (no sibling file with internal definitions). No __file__ node or edge should
# be created because directory-level package metadata is unavailable.
# ---------------------------------------------------------------------------

function create_external_only_refs_isolated_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/isolated/annotations-only.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven com.external/lib 2.0 com/external/NullMarked#",
          "symbol_roles": 0
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: file with only external refs + sibling creates __file__ node and edge (admin)
# Covers files like package-info.java that have no internal type definitions.
# ---------------------------------------------------------------------------

echo "Test: file with only external refs + sibling creates __file__ node and edge (admin)"
ext_sibling_indices_dir="${tmp_test_dir}/ext_sibling_indices"
ext_sibling_import_dir="${tmp_test_dir}/ext_sibling_import"
mkdir -p "${ext_sibling_indices_dir}"

create_external_only_refs_with_sibling_scip_json > "${ext_sibling_indices_dir}/ext_sibling.scip.json"

run_script_with_env "${ext_sibling_indices_dir}" "${ext_sibling_import_dir}"
assert_exit_code "exits 0 for external-only-refs-with-sibling fixture (admin)" "0" "${exit_code}"

ext_sibling_nodes=$(cat "${ext_sibling_import_dir}/scip_type_nodes_admin.csv")
assert_contains "__file__ node created for file with only external refs (admin)" \
    "__file__ src/main/java/com/example/package-info.java" "${ext_sibling_nodes}"

file_node_row=$(echo "${ext_sibling_nodes}" | grep "__file__ src/main/java/com/example/package-info.java" | head -1)
assert_contains "__file__ node typeName is File (admin)" '"File"' "${file_node_row}"
assert_contains "__file__ node packageId from sibling (admin)" '"maven/com.example/app"' "${file_node_row}"
assert_contains "__file__ node scheme from sibling (admin)" '"semanticdb"' "${file_node_row}"

ext_sibling_edges=$(cat "${ext_sibling_import_dir}/scip_type_edges_admin.csv")
assert_contains "DEPENDS_ON edge from __file__ package-info to external type (admin)" \
    "__file__ src/main/java/com/example/package-info.java" "${ext_sibling_edges}"
assert_contains "NullMarked is the target of the edge (admin)" \
    "com/external/NullMarked#" "${ext_sibling_edges}"
assert_contains "edge has DEPENDS_ON type (admin)" "DEPENDS_ON" "${ext_sibling_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: file with only external refs isolated (no sibling) creates no node or
# edge (admin) — no directory-level package metadata available.
# ---------------------------------------------------------------------------

echo "Test: file with only external refs isolated (no sibling) creates no node or edge (admin)"
ext_isolated_indices_dir="${tmp_test_dir}/ext_isolated_indices"
ext_isolated_import_dir="${tmp_test_dir}/ext_isolated_import"
mkdir -p "${ext_isolated_indices_dir}"

create_external_only_refs_isolated_scip_json > "${ext_isolated_indices_dir}/ext_isolated.scip.json"

run_script_with_env "${ext_isolated_indices_dir}" "${ext_isolated_import_dir}"
assert_exit_code "exits 0 for external-only-refs-isolated fixture (admin)" "0" "${exit_code}"

ext_isolated_nodes=$(cat "${ext_isolated_import_dir}/scip_type_nodes_admin.csv")
assert_not_contains "no __file__ node for isolated external-only file (admin)" \
    "annotations-only.java" "${ext_isolated_nodes}"

ext_isolated_edges=$(cat "${ext_isolated_import_dir}/scip_type_edges_admin.csv")
assert_not_contains "no edge from isolated external-only file (admin)" \
    "annotations-only.java" "${ext_isolated_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: file with only internal type references, with sibling providing package info
# (e.g., package-info.java referencing @Deprecated or other internal annotations)
# Should create __file__ node using coordinates from the internal type reference itself
# ---------------------------------------------------------------------------

function create_internal_only_refs_with_sibling_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/org/axonframework/common/package-info.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "symbol_roles": 0
        },
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/AxonException#",
          "symbol_roles": 0
        }
      ]
    },
    {
      "relative_path": "src/main/java/org/axonframework/common/DescribableComponent.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "kind": 7
        }
      ]
    },
    {
      "relative_path": "src/main/java/org/axonframework/common/AxonException.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/AxonException#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/AxonException#",
          "kind": 7
        }
      ]
    },
    {
      "relative_path": "src/main/java/org/axonframework/common/SomeClass.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/SomeClass#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/SomeClass#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Fixture: file with only internal type references, isolated (no sibling)
# Even though it has internal refs, without another source of package info,
# we can extract from the internal type reference itself
# ---------------------------------------------------------------------------

function create_internal_only_refs_isolated_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/isolated/AnnotationOnly.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "symbol_roles": 0
        }
      ]
    },
    {
      "relative_path": "src/isolated/DescribableComponent.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: file with only internal refs + sibling creates __file__ node and edge (admin)
# Internal references have full module coordinates, so __file__ can be created
# ---------------------------------------------------------------------------

echo "Test: file with only internal refs + sibling creates __file__ node and edge (admin)"
int_sibling_indices_dir="${tmp_test_dir}/int_sibling_indices"
int_sibling_import_dir="${tmp_test_dir}/int_sibling_import"
mkdir -p "${int_sibling_indices_dir}"

create_internal_only_refs_with_sibling_scip_json > "${int_sibling_indices_dir}/int_sibling.scip.json"

run_script_with_env "${int_sibling_indices_dir}" "${int_sibling_import_dir}"
assert_exit_code "exits 0 for internal-only-refs-with-sibling fixture (admin)" "0" "${exit_code}"

int_sibling_nodes=$(cat "${int_sibling_import_dir}/scip_type_nodes_admin.csv")
assert_contains "__file__ node created for file with only internal refs (admin)" \
    "__file__ src/main/java/org/axonframework/common/package-info.java" "${int_sibling_nodes}"

int_file_node_row=$(echo "${int_sibling_nodes}" | grep "__file__ src/main/java/org/axonframework/common/package-info.java" | head -1)
assert_contains "__file__ node typeName is File for internal refs (admin)" '"File"' "${int_file_node_row}"
assert_contains "__file__ node packageId from internal ref (admin)" '"maven/org.axonframework/axon-common"' "${int_file_node_row}"

int_sibling_edges=$(cat "${int_sibling_import_dir}/scip_type_edges_admin.csv")
assert_contains "DEPENDS_ON edge from __file__ package-info to internal type (admin)" \
    "__file__ src/main/java/org/axonframework/common/package-info.java" "${int_sibling_edges}"
assert_contains "DescribableComponent is the target (admin)" \
    "maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#" "${int_sibling_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: file with only internal refs isolated creates __file__ node and edge (admin)
# Should extract full coordinates from the internal type reference itself
# ---------------------------------------------------------------------------

echo "Test: file with only internal refs isolated creates __file__ node and edge (admin)"
int_isolated_indices_dir="${tmp_test_dir}/int_isolated_indices"
int_isolated_import_dir="${tmp_test_dir}/int_isolated_import"
mkdir -p "${int_isolated_indices_dir}"

create_internal_only_refs_isolated_scip_json > "${int_isolated_indices_dir}/int_isolated.scip.json"

run_script_with_env "${int_isolated_indices_dir}" "${int_isolated_import_dir}"
assert_exit_code "exits 0 for internal-only-refs-isolated fixture (admin)" "0" "${exit_code}"

int_isolated_nodes=$(cat "${int_isolated_import_dir}/scip_type_nodes_admin.csv")
assert_contains "__file__ node created for isolated internal refs (admin)" \
    "__file__ src/isolated/AnnotationOnly.java" "${int_isolated_nodes}"

int_isolated_file_node_row=$(echo "${int_isolated_nodes}" | grep "__file__ src/isolated/AnnotationOnly.java" | head -1)
assert_contains "__file__ node packageId from isolated internal ref (admin)" '"maven/org.axonframework/axon-common"' "${int_isolated_file_node_row}"

int_isolated_edges=$(cat "${int_isolated_import_dir}/scip_type_edges_admin.csv")
assert_contains "DEPENDS_ON edge from isolated __file__ to internal type (admin)" \
    "__file__ src/isolated/AnnotationOnly.java" "${int_isolated_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: type defined only in the symbols section (truncated occurrence)
# Models the real-world case where a SCIP indexer emits a truncated occurrence
# format (no symbol_roles, pkg_id = ".") for a type it defines, but the type's
# full symbol appears correctly in the document's symbols section. The type must
# still be extracted as InternalType using the symbols-section path.
# ---------------------------------------------------------------------------

function create_symbols_section_only_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Handler.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Handler#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Handler#",
          "kind": 7
        }
      ]
    },
    {
      "relative_path": "src/main/java/com/example/core/CoreService.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven . . com/example/core/CoreService#"
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/core/CoreService#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: type with symbols-section-only definition is extracted as InternalType (admin)
# The occurrence for CoreService uses the truncated ". ." format with no symbol_roles,
# so occurrence-based extraction misses it. Fix 1 (symbols section extraction) must
# produce an InternalType node with the correct file path.
# ---------------------------------------------------------------------------

echo "Test: symbols-section-only type is extracted as InternalType (admin)"
sym_section_indices_dir="${tmp_test_dir}/sym_section_indices"
sym_section_import_dir="${tmp_test_dir}/sym_section_import"
mkdir -p "${sym_section_indices_dir}"

create_symbols_section_only_scip_json > "${sym_section_indices_dir}/sym_section.scip.json"

run_script_with_env "${sym_section_indices_dir}" "${sym_section_import_dir}"
assert_exit_code "exits 0 for symbols-section-only fixture (admin)" "0" "${exit_code}"

sym_section_nodes=$(cat "${sym_section_import_dir}/scip_type_nodes_admin.csv")
assert_contains "CoreService node extracted from symbols section (admin)" \
    "com/example/core/CoreService#" "${sym_section_nodes}"

core_service_row=$(echo "${sym_section_nodes}" | grep "com/example/core/CoreService#" | grep -v "__file__" | head -1)
assert_contains "CoreService has InternalType label (admin)" \
    "SemanticCodeIndexInternalType" "${core_service_row}"
assert_contains "CoreService has correct file path (admin)" \
    "src/main/java/com/example/core/CoreService.java" "${core_service_row}"
echo ""

# ---------------------------------------------------------------------------
# Fixtures: multi-index merge where ExternalType from early-sorted index
# should be overridden by InternalType from late-sorted index.
# The consumer module (aaa_) sorts before the service module (bbb_), so without
# Fix 2 the ExternalType from aaa_ wins and Service gets an empty file path.
# ---------------------------------------------------------------------------

function create_multi_index_consumer_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/consumer/Consumer.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/consumer 1.0 com/example/consumer/Consumer#",
          "symbol_roles": 1
        },
        {
          "symbol": "semanticdb maven maven/com.example/service 1.0 com/example/service/Service#",
          "symbol_roles": 0
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/consumer 1.0 com/example/consumer/Consumer#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

function create_multi_index_service_scip_json() {
    cat << 'EOF'
{
  "documents": [
    {
      "relative_path": "src/main/java/com/example/service/Service.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/service 1.0 com/example/service/Service#",
          "symbol_roles": 1
        }
      ],
      "symbols": [
        {
          "symbol": "semanticdb maven maven/com.example/service 1.0 com/example/service/Service#",
          "kind": 7
        }
      ]
    }
  ]
}
EOF
}

# ---------------------------------------------------------------------------
# Test: InternalType from late-sorted index wins over ExternalType from
# early-sorted index for same symbol (admin)
# ---------------------------------------------------------------------------

echo "Test: InternalType wins over ExternalType in multi-index merge (admin)"
multi_idx_indices_dir="${tmp_test_dir}/multi_idx_indices"
multi_idx_import_dir="${tmp_test_dir}/multi_idx_import"
mkdir -p "${multi_idx_indices_dir}"

create_multi_index_consumer_scip_json > "${multi_idx_indices_dir}/aaa_consumer.scip.json"
create_multi_index_service_scip_json  > "${multi_idx_indices_dir}/bbb_service.scip.json"

run_script_with_env "${multi_idx_indices_dir}" "${multi_idx_import_dir}"
assert_exit_code "exits 0 for multi-index merge fixture (admin)" "0" "${exit_code}"

multi_idx_nodes=$(cat "${multi_idx_import_dir}/scip_type_nodes_admin.csv")
service_row=$(echo "${multi_idx_nodes}" | grep "com/example/service/Service#" | head -1)
assert_contains "Service has InternalType label after merge (admin)" \
    "SemanticCodeIndexInternalType" "${service_row}"
assert_not_contains "Service does not have ExternalType label after merge (admin)" \
    "SemanticCodeIndexExternalType" "${service_row}"
assert_contains "Service has correct file path after merge (admin)" \
    "src/main/java/com/example/service/Service.java" "${service_row}"
assert_no_duplicate_nodes "no duplicate nodes after multi-index merge (admin)" \
    "${multi_idx_import_dir}/scip_type_nodes_admin.csv"
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
