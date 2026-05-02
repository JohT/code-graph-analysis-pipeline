#!/usr/bin/env bash

# Applies centrality algorithms using the Neo4j Graph Data Science Library and writes CSV reports.
# Covers PageRank, ArticleRank, Betweenness, Cost-Effective Lazy Forward (CELF), Harmonic, Closeness, HITS, and Bridges.
# Results are written to reports/graph-algorithms/<NodeType>/centrality/ (e.g., Java_Package/centrality/).
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
echo "centralityCsv: GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR}"

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
    echo "Applies centrality algorithms (PageRank, ArticleRank, Betweenness, CELF, Harmonic," >&2
    echo "Closeness, HITS, Bridges) via Neo4j GDS and writes results to CSV files." >&2
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
            echo "centralityCsv: Error: Unknown option: $1" >&2
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

# Report parent directory (will be set per node type)
REPORT_PARENT="graph-algorithms"

echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing centrality algorithms..."

# Apply the centrality algorithm "Page Rank".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithPageRank() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centrality nodes.
    local writePropertyName="dependencies_projection_write_property=centralityPageRank"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2a_Page_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2b_Page_Rank_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3c_Page_Rank_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Page_Rank.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Article Rank".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithArticleRank() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityArticleRank"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4a_Article_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4b_Article_Rank_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4c_Article_Rank_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Article_Rank.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Betweenness".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithBetweenness() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityBetweenness"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5a_Betweeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5b_Betweeness_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5c_Betweeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Betweeness.csv"

    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Cost Effective Lazy Forward (CELF)".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithCostEffectiveLazyForwardCELF() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityCostEffectiveLazyForward"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6a_Cost_effective_Lazy_Forward_CELF_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6b_Cost_effective_Lazy_Forward_CELF_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6c_Cost_effective_Lazy_Forward_CELF_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Cost_Effective_Lazy_Forward_CELF.csv"

    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Harmonic" (variant of "Closeness").
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithHarmonic() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityHarmonic"

    # Note: Estimate procedure does not exist for Harmonic (gds version 2.5.0-preview3)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7b_Harmonic_Closeness_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7c_Harmonic_Closeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Harmonic_Closeness.csv"

    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Closeness".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithCloseness() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityCloseness"

    # Note: Estimate procedure does not exist for Closeness (gds version 2.5.0-preview3)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8b_Closeness_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8c_Closeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Closeness.csv"

    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Hyperlink-Induced Topic Search (HITS)".
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithHyperlinkInducedTopicSearchHITS() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=centralityHyperlinkInducedTopicSearch"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9a_Hyperlink_Induced_Topic_Search_HITS_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9b_Hyperlink_Induced_Topic_Search_HITS_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9c_Hyperlink_Induced_Topic_Search_HITS_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV — HITS produces two scores (authority + hub), use the dedicated stream query
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9d_Hyperlink_Induced_Topic_Search_HITS_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Hyperlink_Induced_Topic_Search_HITS.csv"

    # Update Graph (node properties and labels) — write both authority and hub scores
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}Hub"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}Hub"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}Hub"
}

# Apply the centrality algorithm "Bridges".
# Requires an undirected graph projection and ignores weights.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package-centrality-undirected"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
centralityWithBridges() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10a_Bridges_Estimate.cypher" "${@}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10d_Bridges_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Bridges.csv"

    # Set "isBridge=true" on all relationships identified as Bridge
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10e_Bridges_Write.cypher" "${@}"
}

listCentralityResults() {
    local CENTRALITY_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/centrality"

    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_90_Summary.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_All.csv"
}

# Run all centrality algorithms that require a directed graph projection.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
runCentralityAlgorithms() {
    time centralityWithPageRank "${@}"
    time centralityWithArticleRank "${@}"
    time centralityWithBetweenness "${@}"
    time centralityWithCostEffectiveLazyForwardCELF "${@}"
    time centralityWithHarmonic "${@}"
    time centralityWithCloseness "${@}"
    time centralityWithHyperlinkInducedTopicSearchHITS "${@}"
    listCentralityResults "${@}"
}

# Run all centrality algorithms that require an undirected graph projection.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
runUndirectedCentralityAlgorithms() {
    time centralityWithBridges "${@}"
}


# ── Java Artifact Centrality ──────────────────────────────────────────────────

FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Artifact/centrality"
mkdir -p "${FULL_REPORT_DIRECTORY}"

ARTIFACT_PROJECTION="dependencies_projection=artifact-centrality"
ARTIFACT_PROJECTION_UNDIRECTED="dependencies_projection=artifact-centrality-undirected"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    runCentralityAlgorithms "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi
if createUndirectedDependencyProjection "${ARTIFACT_PROJECTION_UNDIRECTED}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    runUndirectedCentralityAlgorithms "${ARTIFACT_PROJECTION_UNDIRECTED}" "${ARTIFACT_NODE}"
fi

# ── Java Package Centrality ───────────────────────────────────────────────────

FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Package/centrality"
mkdir -p "${FULL_REPORT_DIRECTORY}"

PACKAGE_PROJECTION="dependencies_projection=package-centrality"
PACKAGE_PROJECTION_UNDIRECTED="dependencies_projection=package-centrality-undirected"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runCentralityAlgorithms "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
fi
if createUndirectedDependencyProjection "${PACKAGE_PROJECTION_UNDIRECTED}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runUndirectedCentralityAlgorithms "${PACKAGE_PROJECTION_UNDIRECTED}" "${PACKAGE_NODE}"
fi

# ── Java Type Centrality ──────────────────────────────────────────────────────

FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Type/centrality"
mkdir -p "${FULL_REPORT_DIRECTORY}"

TYPE_PROJECTION="dependencies_projection=type-centrality"
TYPE_PROJECTION_UNDIRECTED="dependencies_projection=type-centrality-undirected"
TYPE_NODE="dependencies_projection_node=Type"
TYPE_WEIGHT="dependencies_projection_weight_property=weight"

if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    runCentralityAlgorithms "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
fi
if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION_UNDIRECTED}"; then
    runUndirectedCentralityAlgorithms "${TYPE_PROJECTION_UNDIRECTED}" "${TYPE_NODE}"
fi

# ── Java Method Centrality ────────────────────────────────────────────────────

FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Method/centrality"
mkdir -p "${FULL_REPORT_DIRECTORY}"

METHOD_PROJECTION="dependencies_projection=method-centrality"
METHOD_NODE="dependencies_projection_node=Method"
METHOD_WEIGHT="dependencies_projection_weight_property="

if createDirectedJavaMethodDependencyProjection "${METHOD_PROJECTION}"; then
    runCentralityAlgorithms "${METHOD_PROJECTION}" "${METHOD_NODE}" "${METHOD_WEIGHT}"
fi

# ── TypeScript Module Centrality ──────────────────────────────────────────────

FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Typescript_Module/centrality"
mkdir -p "${FULL_REPORT_DIRECTORY}"

MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-centrality"
MODULE_PROJECTION_UNDIRECTED="dependencies_projection=typescript-module-centrality-undirected"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"

if createDirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    runCentralityAlgorithms "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
fi
if createUndirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION_UNDIRECTED}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    runUndirectedCentralityAlgorithms "${MODULE_PROJECTION_UNDIRECTED}" "${MODULE_NODE}"
fi

# ── Non-Dev NPM Package Centrality ────────────────────────────────────────────

NPM_LANGUAGE="dependencies_projection_language=NPM"
NPM_PROJECTION="dependencies_projection=npm-non-dev-package-centrality"
NPM_PROJECTION_UNDIRECTED="dependencies_projection=npm-non-dev-package-centrality-undirected"
NPM_NODE="dependencies_projection_node=NpmNonDevPackage"
NPM_WEIGHT="dependencies_projection_weight_property=weightByDependencyType"

if createDirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    runCentralityAlgorithms "${NPM_PROJECTION}" "${NPM_NODE}" "${NPM_WEIGHT}"
fi
if createUndirectedDependencyProjection "${NPM_LANGUAGE}" "${NPM_PROJECTION_UNDIRECTED}" "${NPM_NODE}" "${NPM_WEIGHT}"; then
    runUndirectedCentralityAlgorithms "${NPM_PROJECTION_UNDIRECTED}" "${NPM_NODE}"
fi

# ─────────────────────────────────────────────────────────────────────────────

# Clean up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${REPORTS_DIRECTORY}/${REPORT_PARENT}"

echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
