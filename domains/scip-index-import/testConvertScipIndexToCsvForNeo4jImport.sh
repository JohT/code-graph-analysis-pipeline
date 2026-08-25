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
# Summary
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
