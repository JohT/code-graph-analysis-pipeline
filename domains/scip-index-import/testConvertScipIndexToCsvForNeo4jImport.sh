#!/usr/bin/env bash

# Tests convertScipIndexToCsvForNeo4jImport.sh: validation, CSV columns, multi-file merge, anonymous inner classes.
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
# Test: method-suffixed references (var-inferred dependencies)
# ---------------------------------------------------------------------------

echo "Test: method-suffixed type references"
method_ref_indices_dir="${tmp_test_dir}/method_ref_indices"
method_ref_import_dir="${tmp_test_dir}/method_ref_import"
mkdir -p "${method_ref_indices_dir}"

create_method_reference_scip_json > "${method_ref_indices_dir}/method_refs.scip.json"

run_script_with_env "${method_ref_indices_dir}" "${method_ref_import_dir}"
assert_exit_code "exits 0 for method-suffixed references" "0" "${exit_code}"

method_ref_edges_csv="${method_ref_import_dir}/scip_type_edges.csv"
assert_file_exists "creates edge CSV with method references" "${method_ref_edges_csv}"

method_ref_edges=$(cat "${method_ref_edges_csv}")
# Handler references Interceptor methods (handle(), process()) and type
# All three should normalize to base type Interceptor# and create edges
assert_contains "edge from Handler to Interceptor (from method ref #handle())" "com/example/Handler#" "${method_ref_edges}"
assert_contains "target is Interceptor base type" "com/example/Interceptor#" "${method_ref_edges}"

# Count edges from Handler to Interceptor: should include edges from method references
handler_to_interceptor=$(echo "${method_ref_edges}" | grep "com/example/Handler#" | grep "com/example/Interceptor#" || true)
if [[ -n "${handler_to_interceptor}" ]]; then
    echo "  PASS: method-suffixed references create edges to base type"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "  FAIL: method-suffixed references should create edges to base type"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Test: field-suffixed references (var-inferred field dependencies)
# ---------------------------------------------------------------------------

echo "Test: field-suffixed type references"
field_ref_indices_dir="${tmp_test_dir}/field_ref_indices"
field_ref_import_dir="${tmp_test_dir}/field_ref_import"
mkdir -p "${field_ref_indices_dir}"

create_field_reference_scip_json > "${field_ref_indices_dir}/field_refs.scip.json"

run_script_with_env "${field_ref_indices_dir}" "${field_ref_import_dir}"
assert_exit_code "exits 0 for field-suffixed references" "0" "${exit_code}"

field_ref_edges_csv="${field_ref_import_dir}/scip_type_edges.csv"
assert_file_exists "creates edge CSV with field references" "${field_ref_edges_csv}"

field_ref_edges=$(cat "${field_ref_edges_csv}")
# Config references Factory fields (provider., cache.) and type
# All should normalize to base type Factory# and create edges
assert_contains "edge from Config to Factory (from field ref .provider)" "com/example/Config#" "${field_ref_edges}"
assert_contains "target is Factory base type" "com/example/Factory#" "${field_ref_edges}"

# Field references should create edges to base type
config_to_factory=$(echo "${field_ref_edges}" | grep "com/example/Config#" | grep "com/example/Factory#" || true)
if [[ -n "${config_to_factory}" ]]; then
    echo "  PASS: field-suffixed references create edges to base type"
    PASS_COUNT=$((PASS_COUNT + 1))
else
    echo "  FAIL: field-suffixed references should create edges to base type"
    FAIL_COUNT=$((FAIL_COUNT + 1))
fi
echo ""

# ---------------------------------------------------------------------------
# Test: self-loop filtering (method refs within same type should not create edges)
# ---------------------------------------------------------------------------

echo "Test: self-loop filtering for same-type method references"
self_loop_indices_dir="${tmp_test_dir}/self_loop_indices"
self_loop_import_dir="${tmp_test_dir}/self_loop_import"
mkdir -p "${self_loop_indices_dir}"

create_self_loop_scip_json > "${self_loop_indices_dir}/self_loop.scip.json"

run_script_with_env "${self_loop_indices_dir}" "${self_loop_import_dir}"
assert_exit_code "exits 0 for self-loop test" "0" "${exit_code}"

self_loop_edges_csv="${self_loop_import_dir}/scip_type_edges.csv"
assert_file_exists "creates edge CSV" "${self_loop_edges_csv}"

self_loop_edges=$(cat "${self_loop_edges_csv}")
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
echo "Test: node deduplication (no duplicate base types)"
node_dedup_indices_dir="${tmp_test_dir}/node_dedup_indices"
node_dedup_import_dir="${tmp_test_dir}/node_dedup_import"
mkdir -p "${node_dedup_indices_dir}"

# Use method_reference fixture which has potential for duplicate nodes if filtering is wrong
create_method_reference_scip_json > "${node_dedup_indices_dir}/method_ref.scip.json"

run_script_with_env "${node_dedup_indices_dir}" "${node_dedup_import_dir}"
assert_exit_code "exits 0 for node dedup test" "0" "${exit_code}"

node_dedup_nodes_csv="${node_dedup_import_dir}/scip_type_nodes.csv"
assert_file_exists "creates node CSV" "${node_dedup_nodes_csv}"
assert_no_duplicate_nodes "no duplicate nodes (base types only)" "${node_dedup_nodes_csv}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: Java class with one anonymous inner class implementing Callback.
# local 3 has enclosing_symbol + relationships.is_implementation to verify
# anonymous class node creation and DEPENDS_ON edge generation.
# ---------------------------------------------------------------------------

function create_anonymous_class_scip_json() {
    cat << 'EOF'
{
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
# Test: anonymous inner class node creation (LOAD CSV)
# ---------------------------------------------------------------------------

echo "Test: anonymous inner class node (LOAD CSV)"
anon_indices_dir="${tmp_test_dir}/anon_indices"
anon_import_dir="${tmp_test_dir}/anon_import"
mkdir -p "${anon_indices_dir}"
create_anonymous_class_scip_json > "${anon_indices_dir}/manager.scip.json"

run_script_with_env "${anon_indices_dir}" "${anon_import_dir}"
assert_exit_code "exits 0 for anonymous class fixture" "0" "${exit_code}"

anon_nodes_csv="${anon_import_dir}/scip_type_nodes.csv"
assert_file_exists "creates node CSV for anonymous class fixture" "${anon_nodes_csv}"

anon_nodes=$(cat "${anon_nodes_csv}")
assert_contains "anonymous class node has \$anonymous in symbol"    '$anonymous'               "${anon_nodes}"
assert_contains "anonymous class node has type_name=AnonymousClass" '"AnonymousClass"'         "${anon_nodes}"
assert_contains "enclosing class Manager also exists as node"       "com/example/Manager#"     "${anon_nodes}"
assert_no_duplicate_nodes "no duplicate nodes with anonymous class" "${anon_nodes_csv}"
echo ""

# ---------------------------------------------------------------------------
# Test: anonymous inner class DEPENDS_ON edge to implemented interface (LOAD CSV)
# ---------------------------------------------------------------------------

echo "Test: anonymous inner class DEPENDS_ON edge (LOAD CSV)"
anon_edges_csv="${anon_import_dir}/scip_type_edges.csv"
assert_file_exists "creates edge CSV for anonymous class fixture" "${anon_edges_csv}"

anon_edges=$(cat "${anon_edges_csv}")
assert_contains "anonymous class depends on Callback interface" '$anonymous'             "${anon_edges}"
assert_contains "anonymous DEPENDS_ON edge targets Callback#"   "com/example/Callback#" "${anon_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: local symbol without methods inside must NOT produce anonymous class node
# Covers the false-positive case: local variables with enclosing_symbol but no
# methods (kind=26/66/67/80) nested inside them. Only true anonymous inner classes
# (with methods inside) should be detected.
# ---------------------------------------------------------------------------

echo "Test: no anonymous class node for local symbol without methods"
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
assert_exit_code "exits 0 for no-methods fixture" "0" "${exit_code}"

no_anon_nodes_csv="${no_anon_import_dir}/scip_type_nodes.csv"
assert_file_exists "creates node CSV" "${no_anon_nodes_csv}"

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
# Before the normalize_symbol fix, both would collapse to Cache# (wrong).
# After the fix, both correctly point to Cache#EntryListener#.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Fixture: two sibling inner types defined in the same file, one referencing the other.
# Models e.g. PessimisticLockFactory$DisposableLock depending on $PubliclyOwnedReentrantLock.
# Both are inner types of the same outer class and live in the same Java source file.
# Before BUG 1 fix: same-file filter dropped this edge.
# After fix: edge is correctly emitted.
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
        {"symbol": "semanticdb maven . . org/example/Outer#InnerB#doSomething().", "symbol_roles": 0}
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

echo "Test: sibling inner types in same file create edges between each other"
sibling_inner_indices_dir="${tmp_test_dir}/sibling_inner_indices"
sibling_inner_import_dir="${tmp_test_dir}/sibling_inner_import"
mkdir -p "${sibling_inner_indices_dir}"

create_sibling_inner_type_scip_json > "${sibling_inner_indices_dir}/sibling_inner.scip.json"
run_script_with_env "${sibling_inner_indices_dir}" "${sibling_inner_import_dir}"
assert_exit_code "exits 0 for sibling inner type fixture" "0" "${exit_code}"

sibling_inner_edges=$(cat "${sibling_inner_import_dir}/scip_type_edges.csv")
# InnerA has a method reference to InnerB (doSomething), so InnerA should depend on InnerB.
assert_contains "InnerA depends on sibling InnerB (same-file edge)" \
    '. . org/example/Outer#InnerA#' "${sibling_inner_edges}"
assert_contains "InnerB is the target of the sibling edge" \
    '. . org/example/Outer#InnerB#' "${sibling_inner_edges}"
# No self-loop: InnerB must not appear as depending on itself
assert_not_contains "no InnerB self-loop" \
    '". . org/example/Outer#InnerB#",". . org/example/Outer#InnerB#"' "${sibling_inner_edges}"
echo ""

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
# ---------------------------------------------------------------------------

echo "Test: inner type reference creates edge to inner type, not outer type"
inner_type_ref_indices_dir="${tmp_test_dir}/inner_type_ref_indices"
inner_type_ref_import_dir="${tmp_test_dir}/inner_type_ref_import"
mkdir -p "${inner_type_ref_indices_dir}"

create_inner_type_reference_scip_json > "${inner_type_ref_indices_dir}/inner_type_ref.scip.json"

run_script_with_env "${inner_type_ref_indices_dir}" "${inner_type_ref_import_dir}"
assert_exit_code "exits 0 for inner type reference fixture" "0" "${exit_code}"

inner_type_nodes_csv="${inner_type_ref_import_dir}/scip_type_nodes.csv"
inner_type_edges_csv="${inner_type_ref_import_dir}/scip_type_edges.csv"
assert_file_exists "creates node CSV for inner type fixture" "${inner_type_nodes_csv}"
assert_file_exists "creates edge CSV for inner type fixture" "${inner_type_edges_csv}"

inner_type_nodes=$(cat "${inner_type_nodes_csv}")
assert_contains "inner interface Cache#EntryListener# is a node" "Cache#EntryListener#" "${inner_type_nodes}"

inner_type_edges=$(cat "${inner_type_edges_csv}")
# WeakReferenceCache references Cache#EntryListener# (null role) and calls a method on it (role 0).
# Both should normalize to Cache#EntryListener# — reference count is 2.
assert_contains "WeakReferenceCache depends on inner type Cache#EntryListener#" "Cache#EntryListener#" "${inner_type_edges}"
# The full target symbol '. . org/example/Cache#' (closed by quote + comma) must not appear:
# 'WeakReferenceCache#"' contains 'Cache#"' as a substring, but not '"Cache#",' (full quoted value).
assert_not_contains "inner type Cache#EntryListener# not collapsed to outer Cache#" '". . org/example/Cache#",' "${inner_type_edges}"

inner_edge=$(echo "${inner_type_edges}" | grep "WeakReferenceCache#" | grep "Cache#EntryListener#" || true)
assert_contains "WeakReferenceCache→Cache#EntryListener# reference count is 2" ",2" "${inner_edge}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: class implementing an interface defined in a different file,
# captured only via symbols[].relationships (is_implementation=true), not occurrences.
# Models e.g. SimpleQueryBus implements QueryHandlerRegistry:
#   - Interface.java defines Interface#
#   - Impl.java defines Impl# with a relationship to Interface# (is_implementation)
#   - Impl.java has no occurrence of Interface# (only via inheritance)
# Before BUG 2 fix: no edge created (relationships not processed).
# After fix: edge Impl# → Interface# is created with count=1.
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

echo "Test: symbols.relationships with is_implementation creates edge to implemented interface"
rel_dep_indices_dir="${tmp_test_dir}/rel_dep_indices"
rel_dep_import_dir="${tmp_test_dir}/rel_dep_import"
mkdir -p "${rel_dep_indices_dir}"

create_relationship_dependency_scip_json > "${rel_dep_indices_dir}/rel_dep.scip.json"
run_script_with_env "${rel_dep_indices_dir}" "${rel_dep_import_dir}"
assert_exit_code "exits 0 for relationship dependency fixture" "0" "${exit_code}"

rel_dep_edges=$(cat "${rel_dep_import_dir}/scip_type_edges.csv")
assert_contains "MyImpl depends on MyInterface via relationship" \
    '. . org/example/MyInterface#' "${rel_dep_edges}"
assert_contains "MyImpl is the source of the relationship edge" \
    '. . org/example/MyImpl#' "${rel_dep_edges}"
rel_dep_edge=$(echo "${rel_dep_edges}" | grep "MyImpl#" | grep "MyInterface#" || true)
assert_contains "relationship edge has count 1" ",1" "${rel_dep_edge}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: cross-module is_implementation relationship (two separate SCIP files)
# Models the real-world case: class in module B implements interface from module A.
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

echo "Test: cross-module is_implementation creates edge to interface in other module"
xmod_rel_indices_dir="${tmp_test_dir}/xmod_rel_indices"
xmod_rel_import_dir="${tmp_test_dir}/xmod_rel_import"
mkdir -p "${xmod_rel_indices_dir}"

create_cross_module_relationship_module_a_scip_json > "${xmod_rel_indices_dir}/module_a.scip.json"
create_cross_module_relationship_module_b_scip_json > "${xmod_rel_indices_dir}/module_b.scip.json"

run_script_with_env "${xmod_rel_indices_dir}" "${xmod_rel_import_dir}"
assert_exit_code "exits 0 for cross-module relationship fixture" "0" "${exit_code}"

xmod_rel_edges=$(cat "${xmod_rel_import_dir}/scip_type_edges.csv")
assert_contains "DEPENDS_ON edge from MyImpl to cross-module MyInterface" \
    "maven/com.example/module-b 2.0 com/example/impl/MyImpl#" "${xmod_rel_edges}"
assert_contains "cross-module MyInterface is the target" \
    "maven/com.example/module-a 1.0 com/example/api/MyInterface#" "${xmod_rel_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: relationship-only target (no occurrence) creates node and edge
# ---------------------------------------------------------------------------

echo "Test: relationship-only cross-module target creates node and edge"
rel_only_indices_dir="${tmp_test_dir}/rel_only_indices"
rel_only_import_dir="${tmp_test_dir}/rel_only_import"
mkdir -p "${rel_only_indices_dir}"

create_cross_module_relationship_relationship_only_scip_json > "${rel_only_indices_dir}/rel_only.scip.json"

run_script_with_env "${rel_only_indices_dir}" "${rel_only_import_dir}"
assert_exit_code "exits 0 for relationship-only target fixture" "0" "${exit_code}"

rel_only_nodes=$(cat "${rel_only_import_dir}/scip_type_nodes.csv")
assert_contains "external node created for relationship-only JDK target" \
    "jdk 21 java/io/Serializable#" "${rel_only_nodes}"

rel_only_edges=$(cat "${rel_only_import_dir}/scip_type_edges.csv")
assert_contains "DEPENDS_ON edge from MyImpl to relationship-only JDK type" \
    "maven/com.example/module-b 2.0 com/example/impl/MyImpl#" "${rel_only_edges}"
assert_contains "Serializable is the target of relationship-only edge" \
    "jdk 21 java/io/Serializable#" "${rel_only_edges}"
echo ""

# ---------------------------------------------------------------------------
# Fixture: internal type referencing an external type whose symbol has pkg_id "."
# (no groupId/version set). Package must be derived from the descriptor path.
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
# Test: external type with pkg_id "." creates a node and an edge
# Regression test: nodes and edges to these types were dropped by the "pkg_id != ." filter
# ---------------------------------------------------------------------------

echo "Test: external type with pkg_id '.' creates node and edge"
ext_dot_indices_dir="${tmp_test_dir}/ext_dot_indices"
ext_dot_import_dir="${tmp_test_dir}/ext_dot_import"
mkdir -p "${ext_dot_indices_dir}"

create_external_pkg_dot_scip_json > "${ext_dot_indices_dir}/ext_dot.scip.json"

run_script_with_env "${ext_dot_indices_dir}" "${ext_dot_import_dir}"
assert_exit_code "exits 0 for pkg_id '.' fixture" "0" "${exit_code}"

ext_dot_nodes=$(cat "${ext_dot_import_dir}/scip_type_nodes.csv")
assert_contains "external Logger node created despite pkg_id '.'" \
    "org/slf4j/Logger#" "${ext_dot_nodes}"
logger_row=$(echo "${ext_dot_nodes}" | grep "org/slf4j/Logger#" | head -1)
assert_contains "Logger package_id derived from descriptor, not '.'" \
    '"org/slf4j"' "${logger_row}"

ext_dot_edges=$(cat "${ext_dot_import_dir}/scip_type_edges.csv")
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
# Test: file with only external refs + sibling creates __file__ node and edge
# Covers files like package-info.java that have no internal type definitions.
# ---------------------------------------------------------------------------

echo "Test: file with only external refs + sibling creates __file__ node and edge"
ext_sibling_indices_dir="${tmp_test_dir}/ext_sibling_indices"
ext_sibling_import_dir="${tmp_test_dir}/ext_sibling_import"
mkdir -p "${ext_sibling_indices_dir}"

create_external_only_refs_with_sibling_scip_json > "${ext_sibling_indices_dir}/ext_sibling.scip.json"

run_script_with_env "${ext_sibling_indices_dir}" "${ext_sibling_import_dir}"
assert_exit_code "exits 0 for external-only-refs-with-sibling fixture" "0" "${exit_code}"

ext_sibling_nodes=$(cat "${ext_sibling_import_dir}/scip_type_nodes.csv")
assert_contains "__file__ node created for file with only external refs" \
    "__file__ src/main/java/com/example/package-info.java" "${ext_sibling_nodes}"

file_node_row=$(echo "${ext_sibling_nodes}" | grep "__file__ src/main/java/com/example/package-info.java" | head -1)
assert_contains "__file__ node type_name is File" '"File"' "${file_node_row}"
assert_contains "__file__ node package_id from sibling" '"maven/com.example/app"' "${file_node_row}"
assert_contains "__file__ node scheme from sibling" '"semanticdb"' "${file_node_row}"

ext_sibling_edges=$(cat "${ext_sibling_import_dir}/scip_type_edges.csv")
assert_contains "DEPENDS_ON edge from __file__ package-info to external type" \
    "__file__ src/main/java/com/example/package-info.java" "${ext_sibling_edges}"
assert_contains "NullMarked is the target of the edge" \
    "com/external/NullMarked#" "${ext_sibling_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: file with only external refs isolated (no sibling) creates no node or
# edge — no directory-level package metadata available.
# ---------------------------------------------------------------------------

echo "Test: file with only external refs isolated (no sibling) creates no node or edge"
ext_isolated_indices_dir="${tmp_test_dir}/ext_isolated_indices"
ext_isolated_import_dir="${tmp_test_dir}/ext_isolated_import"
mkdir -p "${ext_isolated_indices_dir}"

create_external_only_refs_isolated_scip_json > "${ext_isolated_indices_dir}/ext_isolated.scip.json"

run_script_with_env "${ext_isolated_indices_dir}" "${ext_isolated_import_dir}"
assert_exit_code "exits 0 for external-only-refs-isolated fixture" "0" "${exit_code}"

ext_isolated_nodes=$(cat "${ext_isolated_import_dir}/scip_type_nodes.csv")
assert_not_contains "no __file__ node for isolated external-only file" \
    "annotations-only.java" "${ext_isolated_nodes}"

ext_isolated_edges=$(cat "${ext_isolated_import_dir}/scip_type_edges.csv")
assert_not_contains "no edge from isolated external-only file" \
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
# Test: file with only internal refs + sibling creates __file__ node and edge
# Internal references have full module coordinates, so __file__ can be created
# ---------------------------------------------------------------------------

echo "Test: file with only internal refs + sibling creates __file__ node and edge"
int_sibling_indices_dir="${tmp_test_dir}/int_sibling_indices"
int_sibling_import_dir="${tmp_test_dir}/int_sibling_import"
mkdir -p "${int_sibling_indices_dir}"

create_internal_only_refs_with_sibling_scip_json > "${int_sibling_indices_dir}/int_sibling.scip.json"

run_script_with_env "${int_sibling_indices_dir}" "${int_sibling_import_dir}"
assert_exit_code "exits 0 for internal-only-refs-with-sibling fixture" "0" "${exit_code}"

int_sibling_nodes=$(cat "${int_sibling_import_dir}/scip_type_nodes.csv")
assert_contains "__file__ node created for file with only internal refs" \
    "__file__ src/main/java/org/axonframework/common/package-info.java" "${int_sibling_nodes}"

int_file_node_row=$(echo "${int_sibling_nodes}" | grep "__file__ src/main/java/org/axonframework/common/package-info.java" | head -1)
assert_contains "__file__ node type_name is File for internal refs" '"File"' "${int_file_node_row}"
assert_contains "__file__ node package_id from internal ref" '"maven/org.axonframework/axon-common"' "${int_file_node_row}"

int_sibling_edges=$(cat "${int_sibling_import_dir}/scip_type_edges.csv")
assert_contains "DEPENDS_ON edge from __file__ package-info to internal type" \
    "__file__ src/main/java/org/axonframework/common/package-info.java" "${int_sibling_edges}"
assert_contains "DescribableComponent is the target" \
    "maven/org.axonframework/axon-common 5.1.1 org/axonframework/common/DescribableComponent#" "${int_sibling_edges}"
echo ""

# ---------------------------------------------------------------------------
# Test: file with only internal refs isolated creates __file__ node and edge
# Should extract full coordinates from the internal type reference itself
# ---------------------------------------------------------------------------

echo "Test: file with only internal refs isolated creates __file__ node and edge"
int_isolated_indices_dir="${tmp_test_dir}/int_isolated_indices"
int_isolated_import_dir="${tmp_test_dir}/int_isolated_import"
mkdir -p "${int_isolated_indices_dir}"

create_internal_only_refs_isolated_scip_json > "${int_isolated_indices_dir}/int_isolated.scip.json"

run_script_with_env "${int_isolated_indices_dir}" "${int_isolated_import_dir}"
assert_exit_code "exits 0 for internal-only-refs-isolated fixture" "0" "${exit_code}"

int_isolated_nodes=$(cat "${int_isolated_import_dir}/scip_type_nodes.csv")
assert_contains "__file__ node created for isolated internal refs" \
    "__file__ src/isolated/AnnotationOnly.java" "${int_isolated_nodes}"

int_isolated_file_node_row=$(echo "${int_isolated_nodes}" | grep "__file__ src/isolated/AnnotationOnly.java" | head -1)
assert_contains "__file__ node package_id from isolated internal ref" '"maven/org.axonframework/axon-common"' "${int_isolated_file_node_row}"

int_isolated_edges=$(cat "${int_isolated_import_dir}/scip_type_edges.csv")
assert_contains "DEPENDS_ON edge from isolated __file__ to internal type" \
    "__file__ src/isolated/AnnotationOnly.java" "${int_isolated_edges}"
echo ""

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
