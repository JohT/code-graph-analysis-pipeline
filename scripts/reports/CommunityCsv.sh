#!/usr/bin/env bash

# Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/community-csv.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

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

# Create report directory
REPORT_NAME="community-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Community Detection Preparation 
# Selects the nodes and relationships for the algorithm and creates an in-memory projection.
# Nodes without incoming and outgoing dependencies will be filtered out with a subgraph.
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
createProjection() {
    local PROJECTION_CYPHER_DIR="${CYPHER_DIR}/Dependencies_Projection"

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_1_Delete_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_4_Create_Undirected_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_5_Create_Subgraph.cypher" "${@}"
}

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

    local writePropertyName="dependencies_projection_write_property=louvainCommunityId" 
    local writePropertyNameIntermediate="dependencies_projection_write_property=intermediateLouvainCommunityIds" 
    
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

    local writePropertyName="dependencies_projection_write_property=leidenCommunityId" 
    local writePropertyNameIntermediate="dependencies_projection_write_property=intermediateleidenCommunityIds" 
    
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

    local writePropertyName="dependencies_projection_write_property=weaklyConnectedComponentId" 
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

    local writePropertyName="dependencies_projection_write_property=labelPropagationCommunityId" 
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
}

detectCommunities() {
    createProjection "${@}"
    time detectCommunitiesWithWeaklyConnectedComponents "${@}"
    time detectCommunitiesWithLabelPropagation "${@}"
    time detectCommunitiesWithLouvain "${@}"
    time detectCommunitiesWithLeiden "${@}"
    time detectCommunitiesWithKCoreDecomposition "${@}"
}
# ---------------------------------------------------------------

# Artifact Query Parameters
ARTIFACT_PROJECTION="dependencies_projection=artifact-community" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 
ARTIFACT_GAMMA="dependencies_leiden_gamma=1.11" # default = 1.00

# Artifact Community Detection
echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing artifact dependencies..."
detectCommunities "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}" "${ARTIFACT_GAMMA}"

# ---------------------------------------------------------------

# Package Query Parameters
PACKAGE_PROJECTION="dependencies_projection=package-community" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 
PACKAGE_GAMMA="dependencies_leiden_gamma=1.14" # default = 1.00

# Package Community Detection
echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') communityCsv: Processing package dependencies..."
detectCommunities "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}" "${PACKAGE_GAMMA}"

# Package Community Detection - Special CSV Queries after update
execute_cypher "${CYPHER_DIR}/Community_Detection/Compare_Community_Detection_Results.cypher" > "${FULL_REPORT_DIRECTORY}/Compare_Community_Detection_Results.csv"
execute_cypher "${CYPHER_DIR}/Community_Detection/Which_package_community_spans_several_artifacts_and_how_are_the_packages_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Package_Communities_Leiden_That_Span_Multiple_Artifacts.csv"

# ---------------------------------------------------------------

# Type Query Parameters
TYPE_PROJECTION="dependencies_projection=type-community" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 
TYPE_GAMMA="dependencies_leiden_gamma=5.00" # default = 1.00

# Type Community Detection
echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing type dependencies..."
detectCommunities "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}" "${TYPE_GAMMA}"

# Type Community Detection - Special CSV Queries after update
execute_cypher "${CYPHER_DIR}/Community_Detection/Which_type_community_spans_several_artifacts_and_how_are_the_types_distributed.cypher" > "${FULL_REPORT_DIRECTORY}/Type_Communities_Leiden_That_Span_Multiple_Artifacts.csv"

echo "communityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished"