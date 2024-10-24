#!/usr/bin/env bash

# Generates node embeddings using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/node-embeddings-csv.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "nodeEmbeddingsCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "nodeEmbeddingsCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "nodeEmbeddingsCsv: CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="node-embeddings-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Node Embeddings using Fast Random Projection
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - dependencies_projection_embedding_dimension=...
#   Number of the dimensions and therefore size of the resulting array of floating point numbers
nodeEmbeddingsWithFastRandomProjection() {
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local NODE_EMBEDDINGS_CYPHER_DIR="${CYPHER_DIR}/Node_Embeddings"
    local writePropertyName="dependencies_projection_write_property=embeddingsFastRandomProjection" 

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1a_Fast_Random_Projection_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1b_Fast_Random_Projection_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1c_Fast_Random_Projection_Mutate.cypher" "${@}" "${writePropertyName}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_Label_Random_Projection.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# Node Embeddings using Hash GNN (Graph Neural Networks)
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - dependencies_projection_embedding_dimension=...
#   Number of the dimensions and therefore size of the resulting array of floating point numbers
nodeEmbeddingsWithHashGNN() {
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local NODE_EMBEDDINGS_CYPHER_DIR="${CYPHER_DIR}/Node_Embeddings"
    local writePropertyName="dependencies_projection_write_property=embeddingsHashGNN"

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_2a_Hash_GNN_Estimate.cypher" "${@}" "${writePropertyName}"
    #Note: There is no statistics function yet (graph-data-science plugin version 2.5.0-preview3)
    #execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_2b_Hash_GNN_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_2c_Hash_GNN_Mutate.cypher" "${@}" "${writePropertyName}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_HashGNN.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    # Note: There is no write function yet (graph-data-science plugin version 2.5.0-preview3)
    #       Therefore, "..mutate" and "gds.graph.nodeProperties.write" are used.
    #       This turned out to be very efficient because the mutated results can be used instead of "stream" as well.
    #       Therefore, the algorithm needs only to be execute once.
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# Node Embeddings using Node2Vec
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - dependencies_projection_embedding_dimension=...
#   Number of the dimensions and therefore size of the resulting array of floating point numbers
nodeEmbeddingsWithNode2Vec() {
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local NODE_EMBEDDINGS_CYPHER_DIR="${CYPHER_DIR}/Node_Embeddings"
    local writePropertyName="dependencies_projection_write_property=embeddingsNode2Vec" 

    # Statistics
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_3a_Node2Vec_Estimate.cypher" "${@}" "${writePropertyName}"
    #Note: There is no statistics function yet (graph-data-science plugin version 2.5.0-preview3)
    #execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_3c_Node2Vec_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_3c_Node2Vec_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Embeddings_Node2Vec.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
}

# -- Java Artifact Node Embeddings -------------------------------

ARTIFACT_PROJECTION="dependencies_projection=artifact-embeddings" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 
ARTIFACT_DIMENSIONS="dependencies_projection_embedding_dimension=16"
ARTIFACT_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=32"

if createUndirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    time nodeEmbeddingsWithFastRandomProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_DIMENSIONS}"
    time nodeEmbeddingsWithHashGNN "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_DIMENSIONS_HASHGNN}"
    time nodeEmbeddingsWithNode2Vec "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_DIMENSIONS}"
fi

# -- Java Package Node Embeddings --------------------------------

PACKAGE_PROJECTION="dependencies_projection=package-embeddings" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 
PACKAGE_DIMENSIONS="dependencies_projection_embedding_dimension=32" 
PACKAGE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=64"

if createUndirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    time nodeEmbeddingsWithFastRandomProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_DIMENSIONS}"
    time nodeEmbeddingsWithHashGNN "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_DIMENSIONS_HASHGNN}"
    time nodeEmbeddingsWithNode2Vec "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_DIMENSIONS}"
fi

# -- Java Type Node Embeddings -----------------------------------

TYPE_PROJECTION="dependencies_projection=type-embeddings" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 
TYPE_DIMENSIONS="dependencies_projection_embedding_dimension=64" 
TYPE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=128"

if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    time nodeEmbeddingsWithFastRandomProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_DIMENSIONS}"
    time nodeEmbeddingsWithHashGNN "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_DIMENSIONS_HASHGNN}"
    time nodeEmbeddingsWithNode2Vec "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_DIMENSIONS}"
fi

# -- Typescript Module Node Embeddings ---------------------------

MODULE_PROJECTION="dependencies_projection=typescript-module-embeddings" 
MODULE_NODE="dependencies_projection_node=Module" 
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight" 
MODULE_DIMENSIONS="dependencies_projection_embedding_dimension=32" 
MODULE_DIMENSIONS_HASHGNN="dependencies_projection_embedding_dimension=32"

if createUndirectedDependencyProjection "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    time nodeEmbeddingsWithFastRandomProjection "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_DIMENSIONS}"
    time nodeEmbeddingsWithHashGNN "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_DIMENSIONS_HASHGNN}"
    time nodeEmbeddingsWithNode2Vec "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_DIMENSIONS}"
fi

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "nodeEmbeddingsCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."