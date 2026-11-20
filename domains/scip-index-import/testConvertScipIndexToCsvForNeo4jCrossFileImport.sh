#!/usr/bin/env bash

# Tests convertScipIndexToCsvForNeo4jCrossFileImport.sh: validation, CSV columns,
# cross-file filtering, symbol type correctness, and multi-file merge.
# Follows testConvertScipIndexToCsvForNeo4jAdminImport.sh structure and assertion helpers.
# Requires jq to be installed for the core test cases.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/scip-index-import" directory if not already set
SCIP_CROSS_FILE_TEST_SCRIPT_DIR=${SCIP_CROSS_FILE_TEST_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

SCRIPT="${SCIP_CROSS_FILE_TEST_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jCrossFileImport.sh"
ADMIN_SCRIPT="${SCIP_CROSS_FILE_TEST_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jAdminCrossFileImport.sh"

PASS_COUNT=0
FAIL_COUNT=0

# ---------------------------------------------------------------------------
# Assertion helpers
# ---------------------------------------------------------------------------

function test_failed() {
    FAIL_COUNT=$((FAIL_COUNT + 1))
}

function assert_exit_code() {
    local description="${1}"
    local expected_exit="${2}"
    local actual_exit="${3}"
    if [ "${expected_exit}" = "${actual_exit}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}" >&2
        echo "        Expected exit code: ${expected_exit}, got: ${actual_exit}" >&2
        echo "        Script output (first 50 lines):" >&2
        echo "${output:-<empty>}" | head -50 | sed 's/^/        /' >&2
        test_failed
    fi
}

function assert_file_exists() {
    local description="${1}"
    local file="${2}"
    if [ -f "${file}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}" >&2
        echo "        File not found: ${file}" >&2
        test_failed
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
        echo "  FAIL: ${description}" >&2
        echo "        Expected to find: ${needle}" >&2
        test_failed
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
        echo "  FAIL: ${description}" >&2
        echo "        Expected NOT to find: ${needle}" >&2
        test_failed
    fi
}

function assert_equals() {
    local description="${1}"
    local expected="${2}"
    local actual="${3}"
    if [ "${expected}" = "${actual}" ]; then
        echo "  PASS: ${description}"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: ${description}" >&2
        echo "        Expected: ${expected}, got: ${actual}" >&2
        test_failed
    fi
}

# ---------------------------------------------------------------------------
# Fixtures — minimal SCIP JSON documents
# ---------------------------------------------------------------------------

# Two-document index: Foo defined in Foo.java, referenced from Bar.java.
# Foo is cross-file (referenced from Bar). Bar is also cross-file (referenced from Foo... wait,
# actually Bar is defined in Bar.java and Foo references it via implements).
# Local symbol in Foo.java must not appear in output.
function create_cross_file_java_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///home/user/my-project"
  },
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Foo.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 1,
          "range": [0, 0, 0, 10]
        },
        {
          "symbol": "local abcd1234",
          "symbol_roles": 1,
          "range": [5, 0, 5, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Bar#",
          "symbol_roles": 0,
          "range": [10, 0, 10, 10]
        }
      ],
      "symbols": [
        { "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#", "kind": 7 }
      ]
    },
    {
      "relative_path": "src/main/java/com/example/Bar.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Bar#",
          "symbol_roles": 1,
          "range": [0, 0, 0, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0,
          "range": [5, 0, 5, 10]
        }
      ],
      "symbols": [
        { "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Bar#", "kind": 7 }
      ]
    }
  ]
}
EOF
}

# Single-document index: Baz defined and only used within the same file.
# Baz is NOT cross-file (no reference from another file). Should produce no symbol nodes.
function create_single_file_java_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///home/user/my-project"
  },
  "documents": [
    {
      "relative_path": "src/main/java/com/example/Baz.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Baz#",
          "symbol_roles": 1,
          "range": [0, 0, 0, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Baz#",
          "symbol_roles": 0,
          "range": [5, 0, 5, 10]
        }
      ],
      "symbols": [
        { "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Baz#", "kind": 7 }
      ]
    }
  ]
}
EOF
}

# TypeScript index: a function (kind 17) cross-file referenced.
# Tests that symbol_type=Function is emitted.
function create_cross_file_typescript_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///home/user/ts-project"
  },
  "documents": [
    {
      "relative_path": "src/utils.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/utils.ts/helper().",
          "symbol_roles": 1,
          "range": [0, 0, 0, 20]
        }
      ],
      "symbols": [
        { "symbol": "scip-typescript npm my-pkg 1.0.0 src/utils.ts/helper().", "kind": 17 }
      ]
    },
    {
      "relative_path": "src/app.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/utils.ts/helper().",
          "symbol_roles": 0,
          "range": [3, 0, 3, 10]
        }
      ],
      "symbols": []
    }
  ]
}
EOF
}

# Outbound-caller index: internalCallerFunction is NEVER referenced from another file
# but DOES call helperExport (defined in a different file).
# isolatedFunction is defined and only referenced within its own file.
# Expected:
#   internalCallerFunction: included (makes cross-file call)
#   helperExport:           included (referenced cross-file by internalCallerFunction)
#   isolatedFunction:       excluded (single-file only)
#   Edge internalCallerFunction -> helperExport: present
function create_outbound_caller_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///home/user/ts-project"
  },
  "documents": [
    {
      "relative_path": "src/caller.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/caller.ts/internalCallerFunction().",
          "symbol_roles": 1,
          "range": [0, 0, 0, 30]
        },
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/helper.ts/helperExport().",
          "symbol_roles": 0,
          "range": [5, 0, 5, 20]
        }
      ],
      "symbols": [
        { "symbol": "scip-typescript npm my-pkg 1.0.0 src/caller.ts/internalCallerFunction().", "kind": 17 }
      ]
    },
    {
      "relative_path": "src/helper.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/helper.ts/helperExport().",
          "symbol_roles": 1,
          "range": [0, 0, 0, 25]
        }
      ],
      "symbols": [
        { "symbol": "scip-typescript npm my-pkg 1.0.0 src/helper.ts/helperExport().", "kind": 17 }
      ]
    },
    {
      "relative_path": "src/isolated.ts",
      "occurrences": [
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/isolated.ts/isolatedFunction().",
          "symbol_roles": 1,
          "range": [0, 0, 0, 25]
        },
        {
          "symbol": "scip-typescript npm my-pkg 1.0.0 src/isolated.ts/isolatedFunction().",
          "symbol_roles": 0,
          "range": [5, 0, 5, 25]
        }
      ],
      "symbols": [
        { "symbol": "scip-typescript npm my-pkg 1.0.0 src/isolated.ts/isolatedFunction().", "kind": 17 }
      ]
    }
  ]
}
EOF
}

# Second Java index (different module) that imports Foo from the first index.
# Used for multi-file merge tests.
function create_second_module_java_scip_json() {
    cat << 'EOF'
{
  "metadata": {
    "project_root": "file:///home/user/my-project"
  },
  "documents": [
    {
      "relative_path": "src/main/java/com/other/Client.java",
      "occurrences": [
        {
          "symbol": "semanticdb maven maven/com.other/lib 2.0 com/other/Client#",
          "symbol_roles": 1,
          "range": [0, 0, 0, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0,
          "range": [5, 0, 5, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0,
          "range": [6, 0, 6, 10]
        },
        {
          "symbol": "semanticdb maven maven/com.example/app 1.0 com/example/Foo#",
          "symbol_roles": 0,
          "range": [7, 0, 7, 10]
        }
      ],
      "symbols": [
        { "symbol": "semanticdb maven maven/com.other/lib 2.0 com/other/Client#", "kind": 7 }
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
    set +e
    output=$(INDICES_DIRECTORY="${indices_dir}" IMPORT_DIRECTORY="${import_dir}" bash "${SCRIPT}" 2>&1)
    exit_code=$?
    set -e
}

function run_admin_script_with_env() {
    local indices_dir="${1}"
    local import_dir="${2}"
    set +e
    output=$(INDICES_DIRECTORY="${indices_dir}" IMPORT_DIRECTORY="${import_dir}" bash "${ADMIN_SCRIPT}" 2>&1)
    exit_code=$?
    set -e
}

# ---------------------------------------------------------------------------
# Test group 1: Prerequisites
# ---------------------------------------------------------------------------

echo "Test group 1: Prerequisites"

tmp_test_dir=$(mktemp -d)
# shellcheck disable=SC2064
trap 'rm -rf "${tmp_test_dir}"' EXIT

run_script_with_env "${tmp_test_dir}/nonexistent" "${tmp_test_dir}/import"
assert_exit_code "exits 1 when INDICES_DIRECTORY missing" "1" "${exit_code}"
assert_contains "error mentions missing directory" "does not exist" "${output}"
echo ""

tmp_indices="${tmp_test_dir}/prereq_indices"
mkdir -p "${tmp_indices}"
run_script_with_env "${tmp_indices}" "${tmp_test_dir}/import"
assert_exit_code "exits 1 when no .scip.json files found" "1" "${exit_code}"
assert_contains "error mentions no .scip.json files" ".scip.json" "${output}"
echo ""

touch "${tmp_indices}/binary.scip"
run_script_with_env "${tmp_indices}" "${tmp_test_dir}/import"
assert_exit_code "exits 1 when non-.scip.json file is present" "1" "${exit_code}"
assert_contains "error mentions unsupported file" "unsupported" "${output}"
rm "${tmp_indices}/binary.scip"
echo ""

# ---------------------------------------------------------------------------
# Skip content tests if jq is not installed
# ---------------------------------------------------------------------------

if ! command -v jq >/dev/null 2>&1; then
    echo "SKIP: jq not found — skipping CSV content tests"
    echo ""
    echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed (jq tests skipped)"
    exit $((FAIL_COUNT > 0 ? 1 : 0))
fi

# ---------------------------------------------------------------------------
# Test group 2: Column presence in output CSVs
# ---------------------------------------------------------------------------

echo "Test group 2: Column presence"

cross_file_indices="${tmp_test_dir}/cross_file_indices"
cross_file_import="${tmp_test_dir}/cross_file_import"
mkdir -p "${cross_file_indices}"
create_cross_file_java_scip_json > "${cross_file_indices}/app.scip.json"

run_script_with_env "${cross_file_indices}" "${cross_file_import}"
assert_exit_code "exits 0 for valid cross-file index" "0" "${exit_code}"
assert_file_exists "creates scip_symbol_nodes.csv"          "${cross_file_import}/scip_symbol_nodes.csv"
assert_file_exists "creates scip_external_symbol_nodes.csv" "${cross_file_import}/scip_external_symbol_nodes.csv"
assert_file_exists "creates scip_symbol_edges.csv"          "${cross_file_import}/scip_symbol_edges.csv"
assert_file_exists "creates scip_projects.csv"              "${cross_file_import}/scip_projects.csv"

nodes_header=$(head -1 "${cross_file_import}/scip_symbol_nodes.csv")
assert_contains "symbol_nodes header has symbol"           '"symbol"'           "${nodes_header}"
assert_contains "symbol_nodes header has language"         '"language"'         "${nodes_header}"
assert_contains "symbol_nodes header has kind"             '"kind"'             "${nodes_header}"
assert_contains "symbol_nodes header has symbol_type"      '"symbol_type"'      "${nodes_header}"
assert_contains "symbol_nodes header has file"             '"file"'             "${nodes_header}"
assert_contains "symbol_nodes header has is_abstract"      '"is_abstract"'      "${nodes_header}"
assert_contains "symbol_nodes header has is_test"          '"is_test"'          "${nodes_header}"
assert_contains "symbol_nodes header has project_root"     '"project_root"'     "${nodes_header}"
assert_contains "symbol_nodes header has descriptor"       '"descriptor"'       "${nodes_header}"

ext_header=$(head -1 "${cross_file_import}/scip_external_symbol_nodes.csv")
assert_contains "external_nodes header has symbol"      '"symbol"'      "${ext_header}"
assert_contains "external_nodes header has kind"        '"kind"'        "${ext_header}"
assert_contains "external_nodes header has symbol_type" '"symbol_type"' "${ext_header}"

edges_header=$(head -1 "${cross_file_import}/scip_symbol_edges.csv")
assert_contains "edges header has from"             '"from"'             "${edges_header}"
assert_contains "edges header has to"               '"to"'               "${edges_header}"
assert_contains "edges header has edge_type"        '"edge_type"'        "${edges_header}"
assert_contains "edges header has reference_count"  '"reference_count"'  "${edges_header}"
echo ""

# ---------------------------------------------------------------------------
# Test group 3: Cross-file filtering correctness
# ---------------------------------------------------------------------------

echo "Test group 3: Cross-file filtering"

nodes_content=$(cat "${cross_file_import}/scip_symbol_nodes.csv")

# Foo and Bar are cross-file (each references the other from a different file)
assert_contains "Foo is included as cross-file symbol" "com/example/Foo#" "${nodes_content}"
assert_contains "Bar is included as cross-file symbol" "com/example/Bar#" "${nodes_content}"

# Local symbols must not appear in any output CSV
assert_not_contains "local symbol excluded from symbol_nodes" "local abcd1234" "${nodes_content}"
local_in_edges=$(cat "${cross_file_import}/scip_symbol_edges.csv")
assert_not_contains "local symbol excluded from edges" "local abcd1234" "${local_in_edges}"

echo ""

# Single-file-only index: no cross-file symbols should appear
echo "Test group 3b: Single-file symbol excluded"
single_indices="${tmp_test_dir}/single_indices"
single_import="${tmp_test_dir}/single_import"
mkdir -p "${single_indices}"
create_single_file_java_scip_json > "${single_indices}/single.scip.json"

run_script_with_env "${single_indices}" "${single_import}"
assert_exit_code "exits 0 for single-file index" "0" "${exit_code}"
single_nodes_count=$(( $(wc -l < "${single_import}/scip_symbol_nodes.csv") - 1 ))
assert_equals "no internal symbol nodes for single-file-only index" "0" "${single_nodes_count}"
echo ""

# ---------------------------------------------------------------------------
# Test group 4: Symbol type correctness
# ---------------------------------------------------------------------------

echo "Test group 4: Symbol type correctness"

# From cross_file_import: Foo and Bar have kind 7 (Class)
foo_row=$(grep "com/example/Foo#" "${cross_file_import}/scip_symbol_nodes.csv" | head -1)
assert_contains "Foo symbol_type is Class"  "Class"  "${foo_row}"
assert_contains "Foo language is Java"      "Java"   "${foo_row}"

# TypeScript function test
ts_indices="${tmp_test_dir}/ts_indices"
ts_import="${tmp_test_dir}/ts_import"
mkdir -p "${ts_indices}"
create_cross_file_typescript_scip_json > "${ts_indices}/ts.scip.json"

run_script_with_env "${ts_indices}" "${ts_import}"
assert_exit_code "exits 0 for TypeScript index" "0" "${exit_code}"
ts_nodes=$(cat "${ts_import}/scip_symbol_nodes.csv")
assert_contains "TypeScript function has symbol_type Function" "Function"   "${ts_nodes}"
assert_contains "TypeScript function has language TypeScript"  "TypeScript" "${ts_nodes}"
echo ""

# ---------------------------------------------------------------------------
# Test group 5: Multi-file merge (deduplication and edge count summing)
# ---------------------------------------------------------------------------

echo "Test group 5: Multi-file merge"

multi_indices="${tmp_test_dir}/multi_indices"
multi_import="${tmp_test_dir}/multi_import"
mkdir -p "${multi_indices}"
create_cross_file_java_scip_json > "${multi_indices}/module_a.scip.json"
create_second_module_java_scip_json > "${multi_indices}/module_b.scip.json"

run_script_with_env "${multi_indices}" "${multi_import}"
assert_exit_code "exits 0 for multi-file input" "0" "${exit_code}"

# Foo appears in both indices: should be deduplicated to one node
foo_count=$(grep -c "com/example/Foo#" "${multi_import}/scip_symbol_nodes.csv" || echo 0)
assert_equals "Foo deduplicated to exactly one node" "1" "${foo_count}"

# Client references Foo 3 times from module_b; Foo references Bar once from module_a.
# After merge, edge from Client to Foo should have reference_count >= 3.
edges_content=$(cat "${multi_import}/scip_symbol_edges.csv")
client_to_foo_count=$(echo "${edges_content}" | grep "com/other/Client" | grep "com/example/Foo" | awk -F',' '{gsub(/"/, "", $4); sum += $4} END {print sum+0}')
assert_equals "Client->Foo edge reference_count is 3" "3" "${client_to_foo_count}"
echo ""

# ---------------------------------------------------------------------------
# Test group 6: Admin wrapper output
# ---------------------------------------------------------------------------

echo "Test group 6: Admin wrapper output"

admin_indices="${tmp_test_dir}/admin_indices"
admin_import="${tmp_test_dir}/admin_import"
mkdir -p "${admin_indices}"
create_cross_file_java_scip_json > "${admin_indices}/app.scip.json"

run_admin_script_with_env "${admin_indices}" "${admin_import}"
assert_exit_code "admin wrapper exits 0" "0" "${exit_code}"
assert_file_exists "creates scip_symbol_nodes_admin.csv"          "${admin_import}/scip_symbol_nodes_admin.csv"
assert_file_exists "creates scip_external_symbol_nodes_admin.csv" "${admin_import}/scip_external_symbol_nodes_admin.csv"
assert_file_exists "creates scip_symbol_edges_admin.csv"          "${admin_import}/scip_symbol_edges_admin.csv"
assert_file_exists "creates scip_projects_admin.csv"              "${admin_import}/scip_projects_admin.csv"
assert_file_exists "creates scip_symbol_project_links_admin.csv"  "${admin_import}/scip_symbol_project_links_admin.csv"

admin_nodes_header=$(head -1 "${admin_import}/scip_symbol_nodes_admin.csv")
assert_contains "admin nodes header has symbol:ID(ScipNode)"  "symbol:ID(ScipNode)"  "${admin_nodes_header}"
assert_contains "admin nodes header has :LABEL"               ":LABEL"               "${admin_nodes_header}"
assert_contains "admin nodes header has is_abstract:boolean"  "is_abstract:boolean"  "${admin_nodes_header}"
assert_contains "admin nodes header has is_test:boolean"      "is_test:boolean"       "${admin_nodes_header}"

admin_edges_header=$(head -1 "${admin_import}/scip_symbol_edges_admin.csv")
assert_contains "admin edges header has :START_ID(ScipNode)" ":START_ID(ScipNode)" "${admin_edges_header}"
assert_contains "admin edges header has :END_ID(ScipNode)"   ":END_ID(ScipNode)"   "${admin_edges_header}"
assert_contains "admin edges header has :TYPE"               ":TYPE"               "${admin_edges_header}"
assert_contains "admin edges header has reference_count:int" "reference_count:int" "${admin_edges_header}"

admin_projects_header=$(head -1 "${admin_import}/scip_projects_admin.csv")
assert_contains "admin projects header has fqn:ID(ScipNode)" "fqn:ID(ScipNode)" "${admin_projects_header}"

admin_links_header=$(head -1 "${admin_import}/scip_symbol_project_links_admin.csv")
assert_contains "admin links header has :START_ID(ScipNode)" ":START_ID(ScipNode)" "${admin_links_header}"
assert_contains "admin links header has BELONGS_TO"          "BELONGS_TO"          "$(cat "${admin_import}/scip_symbol_project_links_admin.csv")"

admin_foo_node=$(grep "com/example/Foo#" "${admin_import}/scip_symbol_nodes_admin.csv" | head -1)
assert_contains "admin Foo node has SemanticCodeIndexInternalType label" "SemanticCodeIndexInternalType" "${admin_foo_node}"
echo ""

# ---------------------------------------------------------------------------
# Test group 7: Outbound cross-file caller inclusion
# ---------------------------------------------------------------------------

echo "Test group 7: Outbound cross-file caller inclusion"

outbound_indices="${tmp_test_dir}/outbound_indices"
outbound_import="${tmp_test_dir}/outbound_import"
mkdir -p "${outbound_indices}"
create_outbound_caller_scip_json > "${outbound_indices}/outbound.scip.json"

run_script_with_env "${outbound_indices}" "${outbound_import}"
assert_exit_code "exits 0 for outbound-caller index" "0" "${exit_code}"

outbound_nodes=$(cat "${outbound_import}/scip_symbol_nodes.csv")
outbound_edges=$(cat "${outbound_import}/scip_symbol_edges.csv")

# internalCallerFunction is never referenced from another file but calls helperExport
# cross-file: it must be included because it makes an outbound cross-file call.
assert_contains "internalCallerFunction included as outbound caller" \
    "internalCallerFunction" "${outbound_nodes}"

# helperExport is referenced cross-file (by internalCallerFunction): already covered,
# must still be included.
assert_contains "helperExport included as cross-file referenced symbol" \
    "helperExport" "${outbound_nodes}"

# isolatedFunction has no cross-file interactions: must remain excluded.
assert_not_contains "isolatedFunction excluded (single-file only)" \
    "isolatedFunction" "${outbound_nodes}"

# The edge from internalCallerFunction to helperExport must be present.
assert_contains "edge internalCallerFunction -> helperExport exists" \
    "helperExport" "${outbound_edges}"
assert_contains "edge source is internalCallerFunction" \
    "internalCallerFunction" "${outbound_edges}"

echo ""

# ---------------------------------------------------------------------------
# Test group 8: Verify all three fixes working together
# ---------------------------------------------------------------------------

echo "Test group 8: Verify all three fixes working together"

fix_indices="${tmp_test_dir}/fix_indices"
fix_import="${tmp_test_dir}/fix_import"
mkdir -p "${fix_indices}"

# Create minimal SCIP with:
# - File1: external type Promise# (cross-file)
# - File2: calls Promise#, has single-file localFunc (not cross-file)
cat > "${fix_indices}/index.scip.json" << 'SCIP_JSON'
{
  "metadata": {"version": "0.3.0"},
  "documents": [
    {
      "relative_path": "Promise.ts",
      "language": "TypeScript",
      "occurrences": [
        {
          "range": [0, 0, 0, 1],
          "symbol": "scip-typescript npm typescript 5.6.2 lib/lib.promise.d.ts/",
          "symbol_roles": 1
        },
        {
          "range": [1, 0, 1, 7],
          "symbol": "scip-typescript npm typescript 5.6.2 lib/lib.promise.d.ts/Promise#",
          "symbol_roles": 1,
          "enclosing_range": [1, 0, 2, 0]
        }
      ]
    },
    {
      "relative_path": "test.ts",
      "language": "TypeScript",
      "occurrences": [
        {
          "range": [0, 0, 0, 1],
          "symbol": "scip-typescript npm test 1.0.0 test.ts/",
          "symbol_roles": 1
        },
        {
          "range": [1, 0, 1, 15],
          "symbol": "scip-typescript npm typescript 5.6.2 lib/lib.promise.d.ts/Promise#",
          "symbol_roles": 2,
          "enclosing_range": [1, 0, 3, 0]
        },
        {
          "range": [4, 0, 4, 10],
          "symbol": "scip-typescript npm test 1.0.0 test.ts/localFunc().",
          "symbol_roles": 1,
          "enclosing_range": [4, 0, 6, 0]
        },
        {
          "range": [5, 0, 5, 10],
          "symbol": "scip-typescript npm test 1.0.0 test.ts/localFunc().",
          "symbol_roles": 2,
          "enclosing_range": [5, 0, 7, 0]
        }
      ]
    }
  ],
  "external_symbols": []
}
SCIP_JSON

run_script_with_env "${fix_indices}" "${fix_import}"
assert_exit_code "exits 0 for all-fixes test index" "0" "${exit_code}"

# Fix #1: Single-file localFunc should NOT appear in nodes (no cross-file interactions)
fix_nodes=$(cat "${fix_import}/scip_symbol_nodes.csv")
fix_edges=$(cat "${fix_import}/scip_symbol_edges.csv")
assert_not_contains "Fix #1: localFunc excluded (single-file)" "localFunc" "${fix_nodes}"
assert_not_contains "Fix #1: no edges to localFunc (single-file)" "localFunc" "${fix_edges}"

# Fix #2: Edge to Promise# should exist and target preserved (cross-file external)
assert_contains "Fix #2: Promise# included as cross-file external" "Promise#" "${fix_nodes}"
assert_contains "Fix #2: edge to Promise# with full descriptor" "Promise#" "${fix_edges}"

# Fix #3: Admin CSV headers should include "name"
run_admin_script_with_env "${fix_indices}" "${fix_import}"
assert_exit_code "admin wrapper exits 0" "0" "${exit_code}"
admin_internal_header=$(head -1 "${fix_import}/scip_symbol_nodes_admin.csv")
admin_external_header=$(head -1 "${fix_import}/scip_external_symbol_nodes_admin.csv")
assert_contains 'Fix #3: admin internal header has "name"' '"name"' "${admin_internal_header}"
assert_contains 'Fix #3: admin external header has "name"' '"name"' "${admin_external_header}"

echo ""

# ---------------------------------------------------------------------------
# Test group 9: Internal-external deduplication
# This test ensures that when a symbol is both internal (defined in source)
# and external (referenced externally), it appears only as internal, not as a duplicate.
# ---------------------------------------------------------------------------

echo "Test group 9: Internal-external deduplication"

dedup_indices="${tmp_test_dir}/dedup_indices"
dedup_import="${tmp_test_dir}/dedup_import"
mkdir -p "${dedup_indices}"

# Create SCIP with:
# - Foo class (internal, cross-file definitions and calls from multiple files)
# - Some external references that might create duplicates
cat > "${dedup_indices}/module.scip.json" << 'SCIP_JSON'
{
  "metadata": {"version": "0.3.0"},
  "documents": [
    {
      "relative_path": "src/Foo.java",
      "language": "Java",
      "occurrences": [
        {
          "range": [0, 0, 0, 1],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Foo",
          "symbol_roles": 1
        },
        {
          "range": [1, 0, 1, 7],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Foo#",
          "symbol_roles": 1,
          "enclosing_range": [1, 0, 50, 0]
        },
        {
          "range": [2, 0, 2, 25],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Foo#process().",
          "symbol_roles": 1,
          "enclosing_range": [2, 0, 10, 0]
        }
      ]
    },
    {
      "relative_path": "src/Client.java",
      "language": "Java",
      "occurrences": [
        {
          "range": [0, 0, 0, 1],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Client",
          "symbol_roles": 1
        },
        {
          "range": [1, 0, 1, 7],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Client#",
          "symbol_roles": 1,
          "enclosing_range": [1, 0, 20, 0]
        },
        {
          "range": [2, 0, 2, 25],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Foo#",
          "symbol_roles": 2,
          "enclosing_range": [2, 0, 5, 0]
        },
        {
          "range": [3, 0, 3, 25],
          "symbol": "semanticdb maven org.example/common 1.0 org/example/Foo#process().",
          "symbol_roles": 2,
          "enclosing_range": [3, 0, 6, 0]
        }
      ]
    }
  ],
  "external_symbols": []
}
SCIP_JSON

run_script_with_env "${dedup_indices}" "${dedup_import}"
assert_exit_code "deduplication test exits 0" "0" "${exit_code}"

# Foo# should appear in internal nodes (it's defined and cross-file referenced)
internal_foo_count=$(grep -c "org/example/Foo#\"" "${dedup_import}/scip_symbol_nodes.csv" | head -1 || echo 0)
assert_equals "Foo# appears in internal nodes" "1" "${internal_foo_count}"

# Foo# should NOT appear in external nodes after deduplication
external_foo_class=$(grep "^\"semanticdb maven org.example/common 1.0 org/example/Foo#\"" "${dedup_import}/scip_external_symbol_nodes.csv" || echo "")
assert_equals "Foo# NOT in external nodes (deduped)" "" "${external_foo_class}"

# In admin format, same deduplication should apply
run_admin_script_with_env "${dedup_indices}" "${dedup_import}"
admin_foo_internal=$(grep "org/example/Foo#" "${dedup_import}/scip_symbol_nodes_admin.csv" || echo "")
admin_foo_external=$(grep "^\"semanticdb maven org.example/common 1.0 org/example/Foo#\"" "${dedup_import}/scip_external_symbol_nodes_admin.csv" || echo "")
assert_contains "admin: Foo# in internal nodes" "Foo" "${admin_foo_internal}"
assert_equals "admin: Foo# NOT duplicated in external" "" "${admin_foo_external}"

echo ""

# ---------------------------------------------------------------------------
# Results
# ---------------------------------------------------------------------------

echo "Results: ${PASS_COUNT} passed, ${FAIL_COUNT} failed"
exit $((FAIL_COUNT > 0 ? 1 : 0))
