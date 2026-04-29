#!/usr/bin/env bash

# Detects communities using the Neo4j Graph Data Science Library and writes CSV reports.
# Covers Louvain, Leiden, Strongly/Weakly Connected Components, Label Propagation, K-Core Decomposition,
# Approximate Maximum k-cut, Local Clustering Coefficient, and HDBSCAN.
# Results are written to reports/graph-algorithms/<NodeType>/communities/ (e.g., Java_Package/communities/).
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
echo "communityCsv: GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GRAPH_ALGORITHMS_SCRIPT_DIR}/../../scripts"}

# Get the central "cypher" directory — still needed for Dependencies_Projection utilities
# and for the Node_Embeddings queries used as preprocessing in HDBSCAN community detection.
CYPHER_DIR=${CYPHER_DIR:-"${GRAPH_ALGORITHMS_SCRIPT_DIR}/../../cypher"}

# Domain-local query directories within this domain
GRAPH_ALGORITHMS_QUERIES_DIR="${GRAPH_ALGORITHMS_SCRIPT_DIR}/queries"

# Function to display script usage
usage() {
    echo "Usage: $0 [--help]" >&2
    echo "" >&2
    echo "Detects communities (Louvain, Leiden, Strongly Connected Components, Weakly Connected Components," >&2
    echo "Label Propagation, K-Core, Approximate Maximum k-cut, Local Clustering Coefficient, HDBSCAN)" >&2
    echo "via Neo4j GDS and writes results to CSV files." >&2
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
            echo "communityCsv: Error: Unknown option: $1" >&2
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

# Report parent directory (will be set per node type)
REPORT_PARENT="graph-algorithms"

echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing community detection algorithms..."

# Community Detection using the Louvain Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithLouvain() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityLouvainId"
    local writePropertyNameIntermediate="dependencies_projection_write_property=communityLouvainIntermediateIds"

    local excludeIntermediateCommunities="dependencies_include_intermediate_communities=false"
    local includeIntermediateCommunities="dependencies_include_intermediate_communities=true"

    local writeLabelName="dependencies_projection_write_label=LouvainCommunity"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1a_Louvain_Estimate.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1b_Louvain_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1c_Louvain_Mutate.cypher" "${@}" "${writePropertyName}" "${excludeIntermediateCommunities}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1c_Louvain_Mutate.cypher" "${@}" "${writePropertyNameIntermediate}" "${includeIntermediateCommunities}"

    # Stream to CSV — reads the mutated intermediate community ids and provides first, final, and all intermediate ids
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1d_Stream_Intermediate_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Louvain.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Leiden Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithLeiden() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityLeidenId"
    local writePropertyNameIntermediate="dependencies_projection_write_property=communityLeidenIntermediateIds"

    local excludeIntermediateCommunities="dependencies_include_intermediate_communities=false"
    local includeIntermediateCommunities="dependencies_include_intermediate_communities=true"

    local writeLabelName="dependencies_projection_write_label=LeidenCommunity"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_2a_Leiden_Estimate.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_2b_Leiden_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_2c_Leiden_Mutate.cypher" "${@}" "${writePropertyName}" "${excludeIntermediateCommunities}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_2c_Leiden_Mutate.cypher" "${@}" "${writePropertyNameIntermediate}" "${includeIntermediateCommunities}"

    # Stream to CSV — reads the mutated intermediate community ids
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1d_Stream_Intermediate_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Leiden.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Strongly Connected Components Algorithm.
# Requires a directed graph projection.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
detectCommunitiesWithStronglyConnectedComponents() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityStronglyConnectedComponentId"
    local writeLabelName="dependencies_projection_write_label=StronglyConnectedComponent"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3a_StronglyConnectedComponents_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3b_StronglyConnectedComponents_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3c_StronglyConnectedComponents_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Strongly_Connected_Components.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Weakly Connected Components Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
detectCommunitiesWithWeaklyConnectedComponents() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityWeaklyConnectedComponentId"
    local writeLabelName="dependencies_projection_write_label=WeaklyConnectedComponent"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3a_WeaklyConnectedComponents_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3b_WeaklyConnectedComponents_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3c_WeaklyConnectedComponents_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Weakly_Connected_Components.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Label Propagation Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithLabelPropagation() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityLabelPropagationId"
    local writeLabelName="dependencies_projection_write_label=LabelPropagation"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4a_Label_Propagation_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4b_Label_Propagation_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4c_Label_Propagation_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Label_Propagation.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the K-Core Decomposition Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithKCoreDecomposition() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityKCoreDecompositionValue"
    local writeLabelName="dependencies_projection_write_label=KCoreDecomposition"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_5a_K_Core_Decomposition_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_5b_K_Core_Decomposition_Statistics.cypher" "${@}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_5c_K_Core_Decomposition_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_K_Core_Decomposition.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Generates a 2-dimensional FastRP node embedding used as input for HDBSCAN clustering.
# The embedding property is written into the in-memory projection only (mutate).
# Node_Embeddings queries are sourced from the central cypher/ directory because the
# graph-algorithms domain uses them purely as preprocessing — they are not its primary output.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
# - dependencies_projection_node_embeddings_property=...
nodeEmbeddingsWithFastRandomProjectionForHDBSCAN() {
    local embeddingProperty
    embeddingProperty=$(extractQueryParameter "dependencies_projection_node_embeddings_property" "${@}")

    # Node_Embeddings queries stay central — used only as HDBSCAN preprocessing input here
    local NODE_EMBEDDINGS_CYPHER_DIR="${CYPHER_DIR}/Node_Embeddings"
    local mutatePropertyName="dependencies_projection_write_property=${embeddingProperty}"
    local embeddingsDimension="dependencies_projection_embedding_dimension=2"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${NODE_EMBEDDINGS_CYPHER_DIR}/Node_Embeddings_1c_Fast_Random_Projection_Mutate.cypher" "${@}" "${mutatePropertyName}" ${embeddingsDimension}
}

# Community Detection using Hierarchical Density-Based Spatial Clustering (HDBSCAN).
# Requires a node property with an array of floats (produced here via FastRP).
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithHDBSCAN() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityFastRpHdbscanLabel"
    local writeLabelName="dependencies_projection_write_label=HDBSCAN"
    local embeddingProperty="dependencies_projection_node_embeddings_property=embeddingsFastRandomProjection2dHDBSCAN"

    nodeEmbeddingsWithFastRandomProjectionForHDBSCAN "${@}" ${embeddingProperty}

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_11a_HDBSCAN_Estimate.cypher" "${@}" ${embeddingProperty} "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_11b_HDBSCAN_Statistics.cypher" "${@}" ${embeddingProperty}

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_11c_HDBSCAN_Mutate.cypher" "${@}" ${embeddingProperty} "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_HDBSCAN.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Approximate Maximum k-cut Algorithm.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
detectCommunitiesWithApproximateMaximumKCut() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityMaximumKCutId"
    local writeLabelName="dependencies_projection_write_label=MaximumKCut"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_6a_Approximate_Maximum_k_cut_Estimate.cypher" "${@}" "${writePropertyName}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_6c_Approximate_Maximum_k_cut_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Approximate_Maximum_K_Cut.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Calculates community metrics including Modularity and Conductance.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - writePropertyName=... (the property name that holds the community id)
# - dependencies_projection_weight_property=...
calculateCommunityMetrics() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"

    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")

    local propertyName
    propertyName=$(extractQueryParameter "dependencies_projection_write_property" "${@}")

    local fileNamePrefix="${FULL_REPORT_DIRECTORY}/${nodeLabel}_${propertyName}_Community_"

    # Try combined metrics first; fall back to individual metrics on failure
    local combinedMetrics
    if combinedMetrics=$(execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_9_Community_Metrics.cypher" "${@}"); then
        echo "${combinedMetrics}" > "${fileNamePrefix}_Metrics.csv"
    else
        # Combined metrics failed — attempt each metric individually to recover partial results
        local modularity
        if modularity=$(execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_7d_Modularity_Members.cypher" "${@}"); then
            echo "${modularity}" > "${fileNamePrefix}_Modularity.csv"
        fi
        local conductance
        if conductance=$(execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_8d_Conductance_Members.cypher" "${@}"); then
            echo "${conductance}" > "${fileNamePrefix}_Conductance.csv"
        fi
    fi
    # Continue even on metric failures — open issues like gds.modularity.stream ArrayIndexOutOfBoundsException
}

# Calculates the Local Clustering Coefficient for each node in the projected graph.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_node=...
# - dependencies_projection_weight_property=...
calculateLocalClusteringCoefficient() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityLocalClusteringCoefficient"
    local writeLabelName="dependencies_projection_write_label=LocalClusteringCoefficient"

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_10a_LocalClusteringCoefficient_Estimate.cypher" "${@}" "${writePropertyName}"

    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_10c_LocalClusteringCoefficient_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream aggregated results to CSV
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_10d_LocalClusteringCoefficient_Stream_Aggregated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Local_Clustering_Coefficient_Aggregated.csv"

    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
}

# Write modularity scores for Leiden communities back into the graph.
#
# Required Parameters:
# - dependencies_projection=...
# - dependencies_projection_weight_property=...
writeLeidenModularity() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local writePropertyName="dependencies_projection_write_property=communityLeidenId"
    local writtenModularity
    if writtenModularity=$(execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_7e_Write_Modularity.cypher" "${@}" "${writePropertyName}"); then
        echo "${writtenModularity}"
        echo "communityCsv: Successfully written Leiden Modularity per node with parameters ${*}"
    else
        echo "communityCsv: Error: Failed to write Leiden Modularity per node with parameters ${*}"
    fi
}

# Compare the results of Louvain vs. Leiden community detection.
#
# Required Parameters:
# - dependencies_projection_node=...
compareCommunityDetectionResults() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Compare_Louvain_vs_Leiden_Results.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Compare_Louvain_with_Leiden.csv"
}

listCommunityDetectionResults() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection"
    local nodeLabel
    nodeLabel=$(extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_Summary.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_All_Communities.csv"
}

detectCommunities() {
    time detectCommunitiesWithWeaklyConnectedComponents "${@}"
    time detectCommunitiesWithLabelPropagation "${@}"
    time detectCommunitiesWithLouvain "${@}"
    time detectCommunitiesWithLeiden "${@}"
    time detectCommunitiesWithKCoreDecomposition "${@}"
    time detectCommunitiesWithApproximateMaximumKCut "${@}"
    time calculateLocalClusteringCoefficient "${@}"

    compareCommunityDetectionResults "${@}"
}

detectDirectedCommunities() {
    time detectCommunitiesWithStronglyConnectedComponents "${@}"
}


# ── Java Artifact Community Detection ────────────────────────────────────────
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Artifact/communities"
mkdir -p "${FULL_REPORT_DIRECTORY}"
ARTIFACT_PROJECTION="dependencies_projection=artifact-community"
ARTIFACT_NODE="dependencies_projection_node=Artifact"
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight"
ARTIFACT_GAMMA="dependencies_leiden_gamma=1.11"
ARTIFACT_KCUT="dependencies_maxkcut=5"

if createUndirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    detectCommunities "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_GAMMA}" "${ARTIFACT_KCUT}"
    writeLeidenModularity "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"

    if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
        detectDirectedCommunities "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
    fi

    listCommunityDetectionResults "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_GAMMA}" "${ARTIFACT_KCUT}"
fi

# ── Java Package Community Detection ─────────────────────────────────────────
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Package/communities"
mkdir -p "${FULL_REPORT_DIRECTORY}"
PACKAGE_PROJECTION="dependencies_projection=package-community"
PACKAGE_NODE="dependencies_projection_node=Package"
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"
PACKAGE_GAMMA="dependencies_leiden_gamma=1.14"
PACKAGE_KCUT="dependencies_maxkcut=20"

if createUndirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    detectCommunities "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_GAMMA}" "${PACKAGE_KCUT}"
    writeLeidenModularity "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"

    detectCommunitiesWithHDBSCAN "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"

    if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
        detectDirectedCommunities "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
    fi
    listCommunityDetectionResults "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_GAMMA}" "${PACKAGE_KCUT}"

    # Package Community Detection — special CSV queries using written node properties
    execute_cypher "${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection/Which_package_community_spans_several_artifacts_and_how_are_the_packages_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Package_Communities_Leiden_That_Span_Multiple_Artifacts.csv"
fi

# ── Java Type Community Detection ────────────────────────────────────────────
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Java_Type/communities"
mkdir -p "${FULL_REPORT_DIRECTORY}"
TYPE_PROJECTION="dependencies_projection=type-community"
TYPE_NODE="dependencies_projection_node=Type"
TYPE_WEIGHT="dependencies_projection_weight_property=weight"
TYPE_GAMMA="dependencies_leiden_gamma=5.00"
TYPE_KCUT="dependencies_maxkcut=100"

if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    detectCommunities "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_GAMMA}" "${TYPE_KCUT}"
    detectCommunitiesWithHDBSCAN "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"

    # Type Community Detection — special CSV queries using written node properties
    execute_cypher "${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection/Which_type_community_spans_several_artifacts_and_how_are_the_types_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Type_Communities_Leiden_That_Span_Multiple_Artifacts.csv"
    execute_cypher "${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection/Type_communities_with_few_members_in_foreign_packages.cypher" > "${FULL_REPORT_DIRECTORY}/Type_communities_with_few_members_in_foreign_packages.csv"
    execute_cypher "${GRAPH_ALGORITHMS_QUERIES_DIR}/community-detection/Type_communities_that_span_the_most_packages_with_type_statistics.cypher" > "${FULL_REPORT_DIRECTORY}/Type_communities_that_span_the_most_packages_with_type_statistics.csv"

    if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
        detectDirectedCommunities "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
    fi
    listCommunityDetectionResults "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_GAMMA}" "${TYPE_KCUT}"
fi

# ── TypeScript Module Community Detection ────────────────────────────────────
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_PARENT}/Typescript_Module/communities"
mkdir -p "${FULL_REPORT_DIRECTORY}"
MODULE_LANGUAGE="dependencies_projection_language=Typescript"
MODULE_PROJECTION="dependencies_projection=typescript-module-community"
MODULE_NODE="dependencies_projection_node=Module"
MODULE_WEIGHT="dependencies_projection_weight_property=lowCouplingElement25PercentWeight"
MODULE_GAMMA="dependencies_leiden_gamma=1.14"
MODULE_KCUT="dependencies_maxkcut=20"

if createUndirectedDependencyProjection "${MODULE_LANGUAGE}" "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
    detectCommunities "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_GAMMA}" "${MODULE_KCUT}"
    if createDirectedDependencyProjection "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"; then
        detectDirectedCommunities "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}"
    fi
    listCommunityDetectionResults "${MODULE_PROJECTION}" "${MODULE_NODE}" "${MODULE_WEIGHT}" "${MODULE_GAMMA}" "${MODULE_KCUT}"
fi

# ─────────────────────────────────────────────────────────────────────────────

# Clean up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${REPORTS_DIRECTORY}/${REPORT_PARENT}"

echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
