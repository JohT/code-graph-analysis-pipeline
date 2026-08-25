#!/usr/bin/env bash

# Test SCIP index node deduplication for anonymous classes with method-suffixed symbol references.

set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Get this "domains/scip-index-import" directory
SCIP_TEST_SCRIPT_DIR=${SCIP_TEST_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}
SCIP_CONVERSION_SCRIPT="${SCIP_TEST_SCRIPT_DIR}/convertScipIndexToCsvForNeo4jImport.sh"

# Create a test SCIP index with method-suffixed references to check node deduplication
TEST_DIR=$(mktemp -d)
trap "rm -rf $TEST_DIR" EXIT

cat > "$TEST_DIR/test.scip.json" << 'SCIP'
{
  "documents": [
    {
      "relative_path": "ExampleClass.java",
      "occurrences": [
        {"symbol": "semanticdb maven . . org/example/ExampleClass#", "symbol_roles": 1, "range": [0, 0, 0, 10]},
        {"symbol": "semanticdb maven . . org/example/TargetClass#doSomething().", "symbol_roles": 0, "range": [1, 0, 1, 10]}
      ]
    }
  ],
  "external_symbols": [
    {"symbol": "semanticdb maven . . org/example/TargetClass#", "kind": "Class", "documentation": "Target class"}
  ]
}
SCIP

# Convert using main script
INDICES_DIRECTORY="$TEST_DIR" IMPORT_DIRECTORY="$TEST_DIR/neo4j-import" bash "$SCIP_CONVERSION_SCRIPT" > /dev/null 2>&1

# Check node CSV for duplicates
NODE_CSV="$TEST_DIR/neo4j-import/scip_type_nodes.csv"
if [ -f "$NODE_CSV" ]; then
  UNIQUE_NODES=$(tail -n +2 "$NODE_CSV" | cut -d',' -f1 | sort -u | wc -l)
  TOTAL_NODES=$(tail -n +2 "$NODE_CSV" | wc -l)
  echo ""
  echo "Node deduplication check:"
  echo "  Total node entries: $TOTAL_NODES"
  echo "  Unique node entries: $UNIQUE_NODES"
  if [ "$UNIQUE_NODES" -eq "$TOTAL_NODES" ]; then
    echo "  Result: ✓ No duplicate nodes"
  else
    echo "  Result: ✗ Found duplicate nodes"
  fi
fi
