#!/usr/bin/env bash

# Applies node similarity (Jaccard) using the Neo4j Graph Data Science Library and writes CSV reports.
# Results are written to reports/similarity-csv/.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "cypher/Dependency_Enrichment/" must have set weight properties on nodes/relationships.
# If no dependency data is present, all queries return empty results and
# cleanupAfterReportGeneration.sh will remove the empty CSV files — no report directory is created.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/graph-algorithms" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "similarityCsv: GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GRAPH_ALGORITHMS_SCRIPT_DIR}/../../scripts"}

# Get the central "cypher" directory — still needed for Dependencies_Projection utilities.
CYPHER_DIR=${CYPHER_DIR:-"${GRAPH_ALGORITHMS_SCRIPT_DIR}/../../cypher"}

# Domain-local query directories within this domain
GRAPH_ALGORITHMS_QUERIES_DIR="${GRAPH_ALGORITHMS_SCRIPT_DIR}/queries"

# Function to display script usage
usage() {
    echo "Usage: $0 [--help]" >&2
    echo "" >&2
    echo "Applies node similarity (Jaccard) via Neo4j GDS and writes SIMILAR relationship" >&2
    echo "and similarity score CSV files." >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REPORTS_DIRECTORY  Output directory (default: reports)" >&2
    echo "  NEO4J_INITIAL_PASSWORD  Neo4j password (required by executeQueryFunctions.sh)" >&2
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help)
            usage
            ;;
        *)
            echo "similarityCsv: Error: Unknown option: $1" >&2
            usage
            ;;
    esac
    shift
done

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create main report directory
REPORT_NAME="similarity-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "similarityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing node similarity (Jaccard)..."

# Apply the node similarity algorithm (Jaccard).
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package-similarity"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight25PercentInterfaces"
similarity() {
    local SIMILARITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/similarity"

    # Statistics
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1a_Estimate.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1b_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1c_Mutate.cypher" "${@}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1d_Stream_Mutated.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Similarity.csv"

    # Update Graph (write SIMILAR relationship and similarity score into the main graph)
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1f_Delete_Relationships.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1g_Write_Mutated.cypher" "${@}"
    execute_cypher "${SIMILARITY_CYPHER_DIR}/Similarity_1i_Write_Node_Properties.cypher" "${@}"
}


# ── Java Artifact Similarity ──────────────────────────────────────────────────

ARTIFACT_PROJECTION="dependencies_projection=artifact-similarity"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    time similarity "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi

# ── Java Package Similarity ───────────────────────────────────────────────────

PACKAGE_PROJECTION="dependencies_projection=package-similarity"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    time similarity "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
fi

# ── Java Type Similarity ──────────────────────────────────────────────────────

TYPE_PROJECTION="dependencies_projection=type-similarity"
TYPE_NODE="dependencies_projection_node=Type"
TYPE_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    time similarity "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
fi

# ── TypeScript Module Similarity ──────────────────────────────────────────────

MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-similarity"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    time similarity "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
fi

# ─────────────────────────────────────────────────────────────────────────────

# Clean up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "similarityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
