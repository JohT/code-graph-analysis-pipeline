#!/usr/bin/env bash

# Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/community-csv.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "communityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "communityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "communityCsv: CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="community-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Community Detection using the Louvain Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithLouvain() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
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

    # Stream to CSV 
    # Reads the mutated intermediate community ids for hierarchical algorighms in general
    # and provides the first, the final and all intermediate community ids.
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1d_Stream_Intermediate_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Louvain.csv"
    #execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1d_Louvain_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Louvain.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Leiden Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithLeiden() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
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

    # Stream to CSV
    # Reads the mutated intermediate community ids for hierarchical algorighms in general
    # and provides the first, the final and all intermediate community ids.
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_1d_Stream_Intermediate_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Louvain.csv"
    #execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_2d_Leiden_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Leiden.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyNameIntermediate}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Weakly Connected Components Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithWeaklyConnectedComponents() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
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
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Weakly_Connected_Components.csv"
    #execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_3d_WeaklyConnectedComponents_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Weakly_Connected_Components.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Label Propagation Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithLabelPropagation() {
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"

    local writePropertyName="dependencies_projection_write_property=communityLabelPropagationId" 
    local writeLabelName="dependencies_projection_write_label=LabelPropagation" 

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4a_Label_Propagation_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4b_Label_Propagation_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4c_Label_Propagation_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}"  "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Label_Propagation.csv"
    #execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_4d_Label_Propagation_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Label_Propagation.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the K-Core Decomposition Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithKCoreDecomposition() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
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
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_K_Core_Decomposition.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Community Detection using the Approximate Maximum k-cut Algorithm
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
detectCommunitiesWithApproximateMaximumKCut() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    local writePropertyName="dependencies_projection_write_property=communityMaximumKCutId" 
    local writeLabelName="dependencies_projection_write_label=MaximumKCut" 

    # Statistics
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_6a_Approximate_Maximum_k_cut_Estimate.cypher" "${@}" "${writePropertyName}"
    # Note: There is no statistics function yet in gds version 2.5.0-preview3
    #execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_5b_K_Core_Decomposition_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_6c_Approximate_Maximum_k_cut_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Grouped.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Approximate_Maximum_K_Cut.csv"
    #execute_cypher "${PROJECTION_CYPHER_DIR}/Community_Detection_6d_Approximate_Maximum_k_cut_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Communities_Approximate_Maximum_K_Cut.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_10_Delete_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_11_Add_Label.cypher" "${@}" "${writePropertyName}" "${writeLabelName}"

    calculateCommunityMetrics "${@}" "${writePropertyName}"
}

# Calculates community metrics including "Modularity" and "Conductance".
# 
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - writePropertyName=...
#   Name of the property that contains the communitiy id
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
calculateCommunityMetrics() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
    
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")

    local propertyName
    propertyName=$( extractQueryParameter "dependencies_projection_write_property" "${@}")

    local fileNamePrefix
    fileNamePrefix="${FULL_REPORT_DIRECTORY}/${nodeLabel}_${propertyName}_Community_"

    # Print results to CSV
    local combinedMetrics
    if combinedMetrics=$( execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_9_Community_Metrics.cypher" "${@}" ); then
        echo "${combinedMetrics}" > "${fileNamePrefix}_Metrics.csv"
    else
        # Combined metrics failed. Trying one by one at least get those that doesn't fail.
        local modularity
        if modularity=$( execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_7d_Modularity_Members.cypher" "${@}" ); then
            echo "${modularity}" > "${fileNamePrefix}_Modularity.csv"
        fi
        local conductance
        if conductance=$( execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_8d_Conductance_Members.cypher" "${@}" ); then
            echo "${conductance}" > "${fileNamePrefix}_Conductance.csv"
        fi
    fi
    # Continue even if there were metrics that failed since they aren't essential
    # and there seem to be open issues like: 
    # gds.modularity.stream ArrayIndexOutOfBoundsException: Index -1 out of bounds for length 100
}

# Write modularity for Leiden communities
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
writeLeidenModularity() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
    local writePropertyName="dependencies_projection_write_property=communityLeidenId" 
    local writtenModularity
    if writtenModularity=$( execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_7e_Write_Modularity.cypher" "${@}" "${writePropertyName}" ); then
        echo "${writtenModularity}"
        echo "communityCsv: Successfully written Leiden Modularity per node with parameters ${*}"
    else
        echo "communityCsv: Error: Failed to write Leiden Modularity per node with parameters ${*}"
    fi
}

# Compare the results of different community detection algorighms
# 
# Required Parameters:
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
compareCommunityDetectionResults() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}")
    execute_cypher "${CYPHER_DIR}/Community_Detection/Compare_Louvain_vs_Leiden_Results.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Compare_Louvain_with_Leiden.csv"
}

listAllResults() {
    local COMMUNITY_DETECTION_CYPHER_DIR="${CYPHER_DIR}/Community_Detection"
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${COMMUNITY_DETECTION_CYPHER_DIR}/Community_Detection_Summary.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_All_Communities.csv"
}

detectCommunities() {
    time detectCommunitiesWithWeaklyConnectedComponents "${@}"
    time detectCommunitiesWithLabelPropagation "${@}"
    time detectCommunitiesWithLouvain "${@}"
    time detectCommunitiesWithLeiden "${@}"
    time detectCommunitiesWithKCoreDecomposition "${@}"
    time detectCommunitiesWithApproximateMaximumKCut "${@}"
    compareCommunityDetectionResults "${@}"
    listAllResults "${@}"
}

# -- Java Artifact Community Detection ---------------------------

ARTIFACT_PROJECTION="dependencies_projection=artifact-community" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 
ARTIFACT_GAMMA="dependencies_leiden_gamma=1.11" # default = 1.00
ARTIFACT_KCUT="dependencies_maxkcut=5" # default = 2

if createUndirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    detectCommunities "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_GAMMA}" "${ARTIFACT_KCUT}"
    writeLeidenModularity "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
fi

# -- Java Package Community Detection -------------------------------

PACKAGE_PROJECTION="dependencies_projection=package-community" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 
PACKAGE_GAMMA="dependencies_leiden_gamma=1.14" # default = 1.00
PACKAGE_KCUT="dependencies_maxkcut=20" # default = 2

if createUndirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    detectCommunities "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_GAMMA}" "${PACKAGE_KCUT}"
    writeLeidenModularity "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
    
    # Package Community Detection - Special CSV Queries after update
    execute_cypher "${CYPHER_DIR}/Community_Detection/Which_package_community_spans_several_artifacts_and_how_are_the_packages_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Package_Communities_Leiden_That_Span_Multiple_Artifacts.csv"
fi

# -- Java Type Community Detection -------------------------------

TYPE_PROJECTION="dependencies_projection=type-community" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 
TYPE_GAMMA="dependencies_leiden_gamma=5.00" # default = 1.00
TYPE_KCUT="dependencies_maxkcut=100" # default = 2

if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}"; then
    detectCommunities "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_GAMMA}" "${TYPE_KCUT}"

    # Type Community Detection - Special CSV Queries after update
    execute_cypher "${CYPHER_DIR}/Community_Detection/Which_type_community_spans_several_artifacts_and_how_are_the_types_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Type_Communities_Leiden_That_Span_Multiple_Artifacts.csv"
    execute_cypher "${CYPHER_DIR}/Community_Detection/Type_communities_with_few_members_in_foreign_packages.cypher" > "${FULL_REPORT_DIRECTORY}/Type_communities_with_few_members_in_foreign_packages.csv"
    execute_cypher "${CYPHER_DIR}/Community_Detection/Type_communities_that_span_the_most_packages_with_type_statistics.cypher" > "${FULL_REPORT_DIRECTORY}/Type_communities_that_span_the_most_packages_with_type_statistics.csv"
fi
# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."