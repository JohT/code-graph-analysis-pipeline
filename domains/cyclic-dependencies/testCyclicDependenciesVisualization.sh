#!/usr/bin/env bash

# Tests cyclicDependenciesVisualization.sh generate_dot_body function:
# backward edge placement, node clustering, and forward edge direction.
# Verifies that backward edges (dashed lines) always cross cluster boundaries.
# Does not require Neo4j or external dependencies.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/cyclic-dependencies" directory if not already set
CYCLIC_DEPENDENCIES_TEST_DIR=${CYCLIC_DEPENDENCIES_TEST_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null && pwd -P )}

PASS_COUNT=0
FAIL_COUNT=0
TEMP_TEST_DIR=""

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
        echo "        Haystack: ${haystack:0:100}..."
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

# ---------------------------------------------------------------------------
# Test: Backward edges must cross cluster boundaries
# ---------------------------------------------------------------------------

function test_backward_edges_cross_clusters() {
    echo "Test: Backward edges cross cluster boundaries"
    
    # Create a CSV matching the real format: packageName in $4, dependentPackageName in $8, dependency in $10
    local test_csv="${TEMP_TEST_DIR}/test_cycle_breakdown.csv"
    
    cat > "${test_csv}" << 'EOF'
"artifactName","packageName","dependentArtifactName","dependentPackageName","dependency","forwardToBackwardBalance","numberForward","numberBackward","Source Cypher File"
"artifact1","com.example.pkg1","artifact2","com.example.pkg2","TypeA->TypeB",0,1,1,""
"artifact1","com.example.pkg1","artifact2","com.example.pkg2","TypeC<-TypeD",0,1,1,""
EOF

    local output
    output=$(awk -F '"' -v pkg="com.example.pkg1" -v dep_pkg="com.example.pkg2" '
        NR > 1 && $4 == pkg && $8 == dep_pkg {
            dep = $10
            gsub(/\r/, "", dep)
            if (index(dep, "->") > 0) {
                split(dep, parts, "->")
                pkg_nodes[parts[1]] = 1
                dep_nodes[parts[2]] = 1
                forward_edges[parts[1], parts[2]] = 1
            } else if (index(dep, "<-") > 0) {
                split(dep, parts, "<-")
                backward_tgt = parts[1]
                backward_src = parts[2]
                pkg_nodes[backward_tgt] = 1
                dep_nodes[backward_src] = 1
                backward_edges[backward_src, backward_tgt] = 1
            }
        }
        END {
            pkg_count = 0
            for (n in pkg_nodes) pkg_count++
            dep_count = 0
            for (n in dep_nodes) dep_count++
            if (pkg_count + dep_count == 0) exit 0
            
            for (n in pkg_nodes) if (n in dep_nodes) ambiguous[n] = 1
            
            print "===PKG_NODES==="
            for (n in pkg_nodes) {
                node_name = (n in ambiguous) ? n "_pkg" : n
                print "\"" node_name "\" [label=\"" n "\"; fillcolor=\"#B3E5FC\"; color=\"#0277BD\"; penwidth=\"1.5\"];"
            }
            print "===DEP_NODES==="
            for (n in dep_nodes) {
                node_name = (n in ambiguous) ? n "_dep" : n
                print "\"" node_name "\" [label=\"" n "\"; fillcolor=\"#F3E5F5\"; color=\"#8E24AA\"; penwidth=\"1.5\"];"
            }
            print "===EDGES==="
            for (edge in forward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_pkg" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_dep" : parts[2]
                print "\"" src "\" -> \"" tgt "\" [color=\"#90CAF9\"; penwidth=\"0.7\"];"
            }
            for (edge in backward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_dep" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_pkg" : parts[2]
                print "\"" src "\" -> \"" tgt "\" [color=\"#E91E63\"; penwidth=\"2.5\"; style=\"dashed\";];"
            }
        }
    ' "${test_csv}")

    # Extract package nodes (left cluster)
    local pkg_nodes
    pkg_nodes=$(echo "${output}" | sed -n '/^===PKG_NODES===/,/^===/{ /^===/!p; }')
    
    # Extract dependent nodes (right cluster)
    local dep_nodes
    dep_nodes=$(echo "${output}" | sed -n '/^===DEP_NODES===/,/^===/{ /^===/!p; }')
    
    # Extract edges
    local edges
    edges=$(echo "${output}" | sed -n '/^===EDGES===/,$ { /^===EDGES===/!p; }')
    
    echo "  PKG_NODES:"
    echo "${pkg_nodes}" | sed 's/^/    /'
    echo "  DEP_NODES:"
    echo "${dep_nodes}" | sed 's/^/    /'
    echo "  EDGES:"
    echo "${edges}" | sed 's/^/    /'
    
    # Verify forward edge: TypeA (pkg) -> TypeB (dep)
    assert_contains "Forward edge source in PKG_NODES" 'TypeA' "${pkg_nodes}"
    assert_contains "Forward edge target in DEP_NODES" 'TypeB' "${dep_nodes}"
    assert_contains "Forward edge defined correctly" '"TypeA" -> "TypeB"' "${edges}"
    
    # Verify backward edge: TypeD (dep) -> TypeC (pkg)
    # The critical bug was: backward edge had BOTH endpoints in wrong clusters
    # Correct behavior: TypeC must be in PKG_NODES, TypeD must be in DEP_NODES
    assert_contains "Backward edge target in PKG_NODES" 'TypeC' "${pkg_nodes}"
    assert_contains "Backward edge source in DEP_NODES" 'TypeD' "${dep_nodes}"
    assert_contains "Backward edge defined with correct order" '"TypeD" -> "TypeC"' "${edges}"
    assert_contains "Backward edge has dashed style" 'style="dashed"' "${edges}"
    
    # Key verification: TypeC and TypeD must NOT be in the same cluster
    local typec_in_pkg
    typec_in_pkg=$(echo "${pkg_nodes}" | grep -c 'TypeC' || true)
    local typed_in_dep
    typed_in_dep=$(echo "${dep_nodes}" | grep -c 'TypeD' || true)
    
    if [[ ${typec_in_pkg} -eq 1 && ${typed_in_dep} -eq 1 ]]; then
        echo "  PASS: Backward edge correctly crosses cluster boundary"
        PASS_COUNT=$((PASS_COUNT + 1))
    else
        echo "  FAIL: Backward edge does not cross cluster boundary"
        echo "        TypeC in PKG_NODES: ${typec_in_pkg}, TypeD in DEP_NODES: ${typed_in_dep}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
}

# ---------------------------------------------------------------------------
# Test: Ambiguous node names (same simple name in both clusters)
# ---------------------------------------------------------------------------

function test_ambiguous_node_names() {
    echo "Test: Ambiguous node names get suffixes to avoid cluster conflicts"
    
    local test_csv="${TEMP_TEST_DIR}/test_ambiguous.csv"
    
    # Shared appears in both forward (->Other) and backward (<-Shared)
    # This means it belongs in pkg_nodes (left of ->) AND dep_nodes (right of <-)
    # So it should get disambiguated as "Shared_pkg" and "Shared_dep"
    cat > "${test_csv}" << 'EOF'
"artifactName","packageName","dependentArtifactName","dependentPackageName","dependency","forwardToBackwardBalance","numberForward","numberBackward","Source Cypher File"
"artifact1","pkg1","artifact2","pkg2","Shared->Other",0,1,1,""
"artifact1","pkg1","artifact2","pkg2","Another<-Shared",0,1,1,""
EOF

    local output
    output=$(awk -F '"' -v pkg="pkg1" -v dep_pkg="pkg2" '
        NR > 1 && $4 == pkg && $8 == dep_pkg {
            dep = $10
            gsub(/\r/, "", dep)
            if (index(dep, "->") > 0) {
                split(dep, parts, "->")
                pkg_nodes[parts[1]] = 1
                dep_nodes[parts[2]] = 1
                forward_edges[parts[1], parts[2]] = 1
            } else if (index(dep, "<-") > 0) {
                split(dep, parts, "<-")
                backward_tgt = parts[1]
                backward_src = parts[2]
                pkg_nodes[backward_tgt] = 1
                dep_nodes[backward_src] = 1
                backward_edges[backward_src, backward_tgt] = 1
            }
        }
        END {
            pkg_count = 0
            for (n in pkg_nodes) pkg_count++
            dep_count = 0
            for (n in dep_nodes) dep_count++
            if (pkg_count + dep_count == 0) exit 0
            
            for (n in pkg_nodes) if (n in dep_nodes) ambiguous[n] = 1
            
            print "===PKG_NODES==="
            for (n in pkg_nodes) {
                node_name = (n in ambiguous) ? n "_pkg" : n
                print "\"" node_name "\" [label=\"" n "\"];"
            }
            print "===DEP_NODES==="
            for (n in dep_nodes) {
                node_name = (n in ambiguous) ? n "_dep" : n
                print "\"" node_name "\" [label=\"" n "\"];"
            }
            print "===EDGES==="
            for (edge in forward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_pkg" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_dep" : parts[2]
                print "\"" src "\" -> \"" tgt "\";"
            }
            for (edge in backward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_dep" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_pkg" : parts[2]
                print "\"" src "\" -> \"" tgt "\";"
            }
        }
    ' "${test_csv}")

    local pkg_nodes
    pkg_nodes=$(echo "${output}" | sed -n '/^===PKG_NODES===/,/^===/{ /^===/!p; }')
    
    local dep_nodes
    dep_nodes=$(echo "${output}" | sed -n '/^===DEP_NODES===/,/^===/{ /^===/!p; }')
    
    # Check for suffixed ambiguous nodes
    assert_contains "Ambiguous node in pkg cluster gets _pkg suffix" '"Shared_pkg"' "${pkg_nodes}"
    assert_contains "Ambiguous node in dep cluster gets _dep suffix" '"Shared_dep"' "${dep_nodes}"
    assert_contains "Ambiguous node keeps original label" 'label="Shared"' "${pkg_nodes}"
    assert_contains "Ambiguous node keeps original label (dep)" 'label="Shared"' "${dep_nodes}"
}

# ---------------------------------------------------------------------------
# Setup and Main
# ---------------------------------------------------------------------------

function setup() {
    TEMP_TEST_DIR=$(mktemp -d)
    echo "Using test directory: ${TEMP_TEST_DIR}"
}

function cleanup() {
    if [[ -n "${TEMP_TEST_DIR}" ]] && [[ -d "${TEMP_TEST_DIR}" ]]; then
        rm -rf "${TEMP_TEST_DIR}"
    fi
}

function run_all_tests() {
    setup
    trap cleanup EXIT
    
    test_backward_edges_cross_clusters
    echo ""
    test_ambiguous_node_names
}

function summary() {
    echo ""
    echo "================================"
    echo "Test Results"
    echo "  Passed: ${PASS_COUNT}"
    echo "  Failed: ${FAIL_COUNT}"
    echo "================================"
    
    if [[ ${FAIL_COUNT} -gt 0 ]]; then
        return 1
    fi
}

# Run all tests if not sourced
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
    summary
fi
