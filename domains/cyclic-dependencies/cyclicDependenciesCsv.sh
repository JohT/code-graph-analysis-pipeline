#!/usr/bin/env bash

# Executes all Cypher queries for cyclic dependency analysis across Java packages, Java artifacts, TypeScript modules, and SCIP Semantic Index modules and artifacts.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/cyclic-dependencies.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "cyclicDependenciesCsv: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Cypher query directory within this domain (flat — the domain IS cyclic-dependencies)
CYCLIC_DEPENDENCIES_CYPHER_DIR="${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/queries"

# Centralized Connected Components (Strongly Connected and Weakly Connected) Cypher queries
CONNECTED_COMPONENTS_CYPHER_DIR="${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../cypher/Connected_Components"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create main report directory and abstraction-level subdirectories
REPORT_NAME="cyclic-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Artifact"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Package"
mkdir -p "${FULL_REPORT_DIRECTORY}/Typescript_Module"
mkdir -p "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"
mkdir -p "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Directory"
mkdir -p "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Artifact"

# Detect and write Strongly Connected Components to the graph database.
# Idempotent: skips detection if communityStronglyConnectedComponentId is already written.
# StronglyConnectedComponent nodes and inter-component edges use MERGE, so they are always safe to call.
# Skips if GDS SCC function is not available; logs warning and continues.
# SCC CSV results are written to the same folder as cyclic dependency results (passed as parameter).
#
# Required Parameters:
# - dependencies_projection=...            Name of the in-memory graph projection for GDS
# - dependencies_projection_node=...       Node label to analyze (e.g., "Package", "Module")
# - dependencies_projection_weight_property=... Weight property name
# - scc_report_directory=...               Report directory (folder) for CSV output
runStronglyConnectedComponents() {
    local scc_report_directory; scc_report_directory=$( extractQueryParameter "scc_report_directory" "${@}" )

    # Check if gds.scc.write function is available
    local scc_available; scc_available=$(
        execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CheckAvailable.cypher" 2>/dev/null | grep -c "gds.scc.write" || true
    )
    
    if [ "${scc_available}" -ne "1" ]; then
        echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') WARNING: GDS SCC function not available. Skipping strongly connected component analysis."
        return 0
    fi

    echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Running SCC analysis..."

    # Write SCC properties to nodes using the projection created by createDirectedDependencyProjection
    execute_cypher_queries_until_results \
        "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_Exists.cypher" \
        "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_Write.cypher" \
        "${@}"
    execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CreateNode.cypher" "${@}"
    execute_cypher "${CONNECTED_COMPONENTS_CYPHER_DIR}/StronglyConnectedComponent_CreateDependency.cypher" "${@}"

    # Extract CSV reports to the same directory as cyclic dependency results
    execute_cypher \
        "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_SCC_Overview.cypher" \
        "${@}" \
        > "${scc_report_directory}/Cyclic_Dependencies_SCC_Overview.csv"

    execute_cypher \
        "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_SCC_Members.cypher" \
        "${@}" \
        > "${scc_report_directory}/Cyclic_Dependencies_SCC_Members.csv"

    echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') SCC analysis completed."
}

# ── Java Cyclic Dependencies ──────────────────────────────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic dependencies for Java..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown_Backward_Only.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/CyclicArtifactDependenciesUnwinded.csv"

# Java Package Strongly Connected Components (SCC) Analysis
PACKAGE_PROJECTION="dependencies_projection=java-package-cycles"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runStronglyConnectedComponents "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "scc_report_directory=${FULL_REPORT_DIRECTORY}/Java_Package"
fi

# Clean up empty CSV files (when no data exists for an abstraction level)
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Artifact"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Package"

# ── TypeScript Cyclic Dependencies ────────────────────────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic dependencies for TypeScript..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv"

# Clean up empty CSV files (when no data exists for an abstraction level)
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Typescript_Module"

# ── SCIP Semantic Index Cyclic Module Dependencies ─────────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic module dependencies for SCIP Semantic Index..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_for_SCIP_Module.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_for_SCIP_Module.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_SCIP_Module.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_Breakdown_for_SCIP_Module.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.csv"

# SCIP Module Strongly Connected Components (SCC) Analysis
SCIP_MODULE_PROJECTION="dependencies_projection=scip-module-cycles"
SCIP_MODULE_NODE="dependencies_projection_node=SemanticCodeIndexModule"
SCIP_MODULE_WEIGHT="dependencies_projection_weight_property=referenceCount"

if createDirectedDependencyProjection "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}"; then
    runStronglyConnectedComponents "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}" "scc_report_directory=${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"
fi

# Clean up empty CSV files (when no SCIP data exists)
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"

# ── SCIP Semantic Index Cyclic Directory Dependencies ─────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic directory dependencies for SCIP Semantic Index..."

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_for_SCIP_Directory.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Directory/Cyclic_Dependencies_for_SCIP_Directory.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_SCIP_Directory.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Directory/Cyclic_Dependencies_Breakdown_for_SCIP_Directory.csv"
execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Directory.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Directory/Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Directory.csv"

execute_cypher "${CYCLIC_DEPENDENCIES_CYPHER_DIR}/Cyclic_Dependencies_between_SCIP_Artifacts_as_unwinded_List.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Artifact/Cyclic_Dependencies_between_SCIP_Artifacts_as_unwinded_List.csv"

# Clean up empty CSV files (when no SCIP data exists)
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Directory"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Artifact"

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
