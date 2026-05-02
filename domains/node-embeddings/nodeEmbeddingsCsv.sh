#!/usr/bin/env bash

# Generates node embeddings using the Neo4j Graph Data Science Library and writes CSV reports.
# Covers FastRP (Fast Random Projection), HashGNN, Node2Vec, and GraphSAGE embedding algorithms.
# GraphSAGE is run for Artifact and Package node labels only (computationally expensive — skipped for Type/Module).
# Results are written to reports/node-embeddings/.
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

## Get this "domains/node-embeddings" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
NODE_EMBEDDINGS_SCRIPT_DIR=${NODE_EMBEDDINGS_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "nodeEmbeddingsCsv: NODE_EMBEDDINGS_SCRIPT_DIR=${NODE_EMBEDDINGS_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${NODE_EMBEDDINGS_SCRIPT_DIR}/../../scripts"}

# Get the central "cypher" directory — still needed for Dependencies_Projection utilities.
CYPHER_DIR=${CYPHER_DIR:-"${NODE_EMBEDDINGS_SCRIPT_DIR}/../../cypher"}

# Domain-local query directories within this domain
NODE_EMBEDDINGS_QUERIES_DIR="${NODE_EMBEDDINGS_SCRIPT_DIR}/queries"

# Function to display script usage
usage() {
    echo "Usage: $0 [--help]" >&2
    echo "" >&2
    echo "Generates node embeddings (FastRP, HashGNN, Node2Vec, GraphSAGE) via Neo4j GDS and writes" >&2
    echo "embedding vectors to CSV files for downstream UMAP visualisation." >&2
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
            echo "nodeEmbeddingsCsv: Error: Unknown option: $1" >&2
            usage
            ;;
    esac
    shift
done

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create main report directory
REPORT_NAME="node-embeddings"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "nodeEmbeddingsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing node embeddings..."

# Node embeddings using Fast Random Projection (FastRP).
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package-embeddings"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - dependencies_projection_embedding_dimension=...
#   Number of dimensions in the resulting embedding vector. Example: "32"
nodeEmbeddingsWithFastRandomProjection() {
    local NODE_EMBEDDINGS_CYPHER_DIR="${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local writePropertyName="dependencies_projection_write_property=embeddingsFastRandomProjection"

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1a_Fast_Random_Projection_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1b_Fast_Random_Projection_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1c_Fast_Random_Projection_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_Label_Random_Projection.csv"

    # Update Graph (node properties) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# Node embeddings using HashGNN (Hash Graph Neural Networks).
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
# - dependencies_projection_embedding_dimension=...
nodeEmbeddingsWithHashGNN() {
    local NODE_EMBEDDINGS_CYPHER_DIR="${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local writePropertyName="dependencies_projection_write_property=embeddingsHashGNN"

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_2a_Hash_GNN_Estimate.cypher" "${@}" "${writePropertyName}"
    # Note: There is no statistics function for HashGNN yet (graph-data-science plugin version 2.5.0-preview3)

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_2c_Hash_GNN_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_HashGNN.csv"

    # Update Graph (node properties) — mutate + write is used because HashGNN has no direct write mode
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# Node embeddings using Node2Vec.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
# - dependencies_projection_embedding_dimension=...
nodeEmbeddingsWithNode2Vec() {
    local NODE_EMBEDDINGS_CYPHER_DIR="${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local writePropertyName="dependencies_projection_write_property=embeddingsNode2Vec"

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_3a_Node2Vec_Estimate.cypher" "${@}" "${writePropertyName}"
    # Note: There is no statistics function for Node2Vec yet (graph-data-science plugin version 2.5.0-preview3)

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_3c_Node2Vec_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_Node2Vec.csv"

    # Update Graph (node properties) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# Node embeddings using GraphSAGE (Graph Neural Networks).
# GraphSAGE requires a training step and uses degree as a node feature.
# It is limited to Artifact and Package projections — skipped for larger node sets (Type, Module).
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
# - dependencies_projection_embedding_dimension=...
nodeEmbeddingsWithGraphSAGE() {
    local NODE_EMBEDDINGS_CYPHER_DIR="${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local writePropertyName="dependencies_projection_write_property=embeddingsGraphSAGE"

    # Prepare: mutate degree property into the projection as a node feature for training
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_0b_Prepare_Degree.cypher" "${@}" "${writePropertyName}"

    # Drop any previously trained model to avoid name conflicts
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_0c_Drop_Model.cypher" "${@}" "${writePropertyName}"

    # Train the GraphSAGE model
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_4b_GraphSAGE_Train.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_4d_GraphSAGE_Stream.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_GraphSAGE.csv"

    # Write embeddings back to graph nodes so nodeEmbeddingsCharts.py can read them
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_4e_GraphSAGE_Write.cypher" "${@}" "${writePropertyName}"
}


# Checks whether a given node property has been written on nodes with the given label.
# Returns true (=0) if at least one node has the property set, false (=1) otherwise.
#
# Required Parameters:
# - dependencies_projection_node=...
#   Label of the nodes to check. Example: "Package"
# - dependencies_projection_write_property=...
#   Name of the property to check. Example: "centralityPageRank"
isNodePropertyCalculated() {
    local checkResult
    checkResult=$(execute_cypher "${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings/Node_Embeddings_0d_Check_Node_Property.cypher" "${@}")
    if is_result_and_csv_column_greater_zero "${checkResult}" "nodeCount"; then
        true
    else
        false
    fi
}

# Writes PageRank centrality scores to nodes as 'centralityPageRank' if not already present.
# Runs on the already-created in-memory projection for the given node layer.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
ensureCentralityPageRankWritten() {
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    local checkProperty="dependencies_projection_write_property=centralityPageRank"

    if isNodePropertyCalculated "${@}" "${checkProperty}"; then
        echo "nodeEmbeddingsCsv: centralityPageRank already exists for ${nodeLabel} nodes — skipping."
        return
    fi
    echo "nodeEmbeddingsCsv: centralityPageRank not found for ${nodeLabel} nodes — computing now."
    execute_cypher "${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings/Node_Embeddings_0e_Write_Centrality_Page_Rank.cypher" "${@}"
}

# Writes Leiden community IDs to nodes as 'communityLeidenId' if not already present.
# Runs on the already-created in-memory projection for the given node layer.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
ensureCommunityLeidenIdWritten() {
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    local checkProperty="dependencies_projection_write_property=communityLeidenId"

    if isNodePropertyCalculated "${@}" "${checkProperty}"; then
        echo "nodeEmbeddingsCsv: communityLeidenId already exists for ${nodeLabel} nodes — skipping."
        return
    fi
    echo "nodeEmbeddingsCsv: communityLeidenId not found for ${nodeLabel} nodes — computing now."
    execute_cypher "${NODE_EMBEDDINGS_QUERIES_DIR}/node-embeddings/Node_Embeddings_0f_Write_Community_Leiden_Id.cypher" "${@}"
}

# Runs all node embedding algorithms for a given architectural layer.
# Ensures centrality and community properties exist first, then computes embeddings.
#
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "artifact-embeddings"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Artifact"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - dependencies_projection_embedding_dimension=...
#   Number of dimensions for FastRP and Node2Vec. Example: "16"
# - dependencies_projection_embedding_dimension_hashgnn=...
#   Number of dimensions for HashGNN (typically larger). Example: "32"
runNodeEmbeddingsForLayer() {
    local projection="$1"
    local node="$2"
    local weight="$3"
    local dimensions="$4"
    local dimensions_hashgnn="$5"

    ensureCentralityPageRankWritten "${projection}" "${node}" "${weight}"
    ensureCommunityLeidenIdWritten "${projection}" "${node}" "${weight}"
    time nodeEmbeddingsWithFastRandomProjection "${projection}" "${node}" "${weight}" "${dimensions}"
    time nodeEmbeddingsWithHashGNN "${projection}" "${node}" "${weight}" "${dimensions_hashgnn}"
    time nodeEmbeddingsWithNode2Vec "${projection}" "${node}" "${weight}" "${dimensions}"
    # GraphSAGE is very computationally expensive so it is currently optional and can be enabled if desired.
    # time nodeEmbeddingsWithGraphSAGE "${projection}" "${node}" "${weight}" "${dimensions}"
}


# ── Java Artifact Node Embeddings ─────────────────────────────────────────────

ARTIFACT_PROJECTION="dependencies_projection=artifact-embeddings"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"
ARTIFACT_DIMENSIONS="dependencies_projection_embedding_dimension=16"
ARTIFACT_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=32"

if createUndirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    runNodeEmbeddingsForLayer "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_DIMENSIONS}" "${ARTIFACT_DIMENSIONS_HASHGNN}"
fi

# ── Java Package Node Embeddings ──────────────────────────────────────────────

PACKAGE_PROJECTION="dependencies_projection=package-embeddings"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"
PACKAGE_DIMENSIONS="dependencies_projection_embedding_dimension=32"
PACKAGE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=64"

if createUndirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    runNodeEmbeddingsForLayer "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_DIMENSIONS}" "${PACKAGE_DIMENSIONS_HASHGNN}"
fi

# ── Java Type Node Embeddings ─────────────────────────────────────────────────

TYPE_PROJECTION="dependencies_projection=type-embeddings"
TYPE_NODE="dependencies_projection_node=Type"
TYPE_WEIGHT="dependencies_projection_weight_property=weight"
TYPE_DIMENSIONS="dependencies_projection_embedding_dimension=64"
TYPE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=128"

if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    runNodeEmbeddingsForLayer "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_DIMENSIONS}" "${TYPE_DIMENSIONS_HASHGNN}"
fi

# ── TypeScript Module Node Embeddings ─────────────────────────────────────────

MODULE_PROJECTION="dependencies_projection=typescript-module-embeddings"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"
MODULE_DIMENSIONS="dependencies_projection_embedding_dimension=32"
MODULE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=32"

if createUndirectedDependencyProjection "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    runNodeEmbeddingsForLayer "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_DIMENSIONS}" "${MODULE_DIMENSIONS_HASHGNN}"
fi

# ─────────────────────────────────────────────────────────────────────────────

# Clean up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "nodeEmbeddingsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
