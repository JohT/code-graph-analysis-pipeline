#!/usr/bin/env bash

# Provides the runStronglyConnectedComponents function for cyclic dependency analysis.
# Extracted for reuse by cyclicDependenciesCsv.sh and Python report entry points.
# Sources executeQueryFunctions.sh and projectionFunctions.sh when not already loaded.
# Requires CYCLIC_DEPENDENCIES_SCRIPT_DIR, SCRIPTS_DIR, CONNECTED_COMPONENTS_CYPHER_DIR,
# CYCLIC_DEPENDENCIES_CYPHER_DIR to be set before sourcing. Derives defaults from BASH_SOURCE[0].

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "cyclicDependenciesStronglyConnectedComponents: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Cypher query directory within this domain
CYCLIC_DEPENDENCIES_CYPHER_DIR=${CYCLIC_DEPENDENCIES_CYPHER_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/queries"}

# Centralized Connected Components (Strongly Connected and Weakly Connected) Cypher queries
CONNECTED_COMPONENTS_CYPHER_DIR=${CONNECTED_COMPONENTS_CYPHER_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../cypher/Connected_Components"}

# Source execute_cypher and related query functions only when not already defined (safe to double-source)
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
if ! declare -f execute_cypher > /dev/null 2>&1; then
    source "${SCRIPTS_DIR}/executeQueryFunctions.sh"
fi

# Source projection functions only when createDirectedDependencyProjection is not already defined
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
if ! declare -f createDirectedDependencyProjection > /dev/null 2>&1; then
    source "${SCRIPTS_DIR}/projectionFunctions.sh"
fi

# Detect and write Strongly Connected Components to the graph database.
# Idempotent: skips detection if communityStronglyConnectedComponentId is already written.
# StronglyConnectedComponent nodes and inter-component edges use MERGE, so they are always safe to call.
# Skips if GDS SCC function is not available; logs warning and continues.
# Strongly Connected Component CSV results are written to the same folder as cyclic dependency results (passed as parameter).
#
# Required Parameters:
# - dependencies_projection=...            Name of the in-memory graph projection for GDS
# - dependencies_projection_node=...       Node label to analyze (e.g., "Package", "SemanticCodeIndexModule")
# - dependencies_projection_weight_property=... Weight property name
# - scc_report_directory=...               Report directory (folder) for CSV output
runStronglyConnectedComponents() {
    local scc_report_directory; scc_report_directory=$( extractQueryParameter "scc_report_directory" "${@}" )

    # Check if gds.scc.write function is available
    local scc_available; scc_available=$(
        execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CheckAvailable.cypher" 2>/dev/null | grep -c "gds.scc.write" || true
    )

    if [ "${scc_available}" -ne "1" ]; then
        echo "cyclicDependenciesStronglyConnectedComponents: $(date +'%Y-%m-%dT%H:%M:%S%z') WARNING: GDS Strongly Connected Component function not available. Skipping analysis."
        return 0
    fi

    echo "cyclicDependenciesStronglyConnectedComponents: $(date +'%Y-%m-%dT%H:%M:%S%z') Running Strongly Connected Component analysis..."

    # Write Strongly Connected Component properties to nodes using the directed dependency projection
    execute_cypher_queries_until_results \
        "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_Exists.cypher" \
        "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_Write.cypher" \
        "${@}"
    execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CreateNode.cypher" "${@}"
    execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CreateDependency.cypher" "${@}"

    # Extract CSV reports to the report directory
    execute_cypher \
        "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_SCC_Overview.cypher" \
        "${@}" \
        > "${scc_report_directory}/Cyclic_Dependencies_SCC_Overview.csv"

    execute_cypher \
        "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_SCC_Members.cypher" \
        "${@}" \
        > "${scc_report_directory}/Cyclic_Dependencies_SCC_Members.csv"

    echo "cyclicDependenciesStronglyConnectedComponents: $(date +'%Y-%m-%dT%H:%M:%S%z') Strongly Connected Component analysis completed."
}
