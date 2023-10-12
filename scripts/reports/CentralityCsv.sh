#!/usr/bin/env bash

# Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/centrality-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "centralityCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "centralityCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "centralityCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="centrality-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Centrality Preparation
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
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_1_Delete_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_2_Delete_Subgraph.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_3_Create_Projection.cypher" "${@}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_5_Create_Subgraph.cypher" "${@}"
}

# Apply the centrality algorithm "Page Rank".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithPageRank() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityPageRank" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2a_Page_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2b_Page_Rank_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3c_Page_Rank_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Page_Rank.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3d_Page_Rank_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Article Rank".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithArticleRank() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    
    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityArticleRank" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4a_Article_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4b_Article_Rank_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4c_Article_Rank_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Article_Rank.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4d_Article_Rank_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Betweenness".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithBetweenness() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    
    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityBetweenness" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5a_Betweeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5b_Betweeness_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5c_Betweeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Betweeness.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5d_Betweeness_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Cost Effective Lazy Forward (CELF)".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithCostEffectiveLazyForwardCELF() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityCostEffectiveLazyForward" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6a_Cost_effective_Lazy_Forward_CELF_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6b_Cost_effective_Lazy_Forward_CELF_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6c_Cost_effective_Lazy_Forward_CELF_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Cost_effective_Lazy_Forward_CELF.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6d_Cost_effective_Lazy_Forward_CELF_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Harmonic" (variant of "Closeness)").
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithHarmonic() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityHarmonic" 

    # Statistics
    # Note: Estimate procedure doesn't seem to exist for now (gds version 2.5.0-preview3)
    # execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7a_Harmonic_Closeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7b_Harmonic_Closeness_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7c_Harmonic_Closeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Harmonic.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7d_Harmonic_Closeness_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Closeness".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithCloseness() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityCloseness" 

    # Statistics
    # Note: Estimate procedure doesn't seem to exist for now (gds version 2.5.0-preview3)
    # execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8a_Closeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8b_Closeness_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8c_Closeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Closeness.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8d_Closeness_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Hyperlink-Induced Topic Search (HITS)".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "centralityPageRank"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithHyperlinkInducedTopicSearchHITS() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityHyperlinkInducedTopicSearchAuthority" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9a_Hyperlink_Induced_Topic_Search_HITS_Estimate.cypher" "${@}" "${writePropertyName}"
    # Note: There is an issue in gds version 2.5.0-preview3: https://github.com/neo4j/graph-data-science/issues/285
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9b_Hyperlink_Induced_Topic_Search_HITS_Statistics.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9c_Hyperlink_Induced_Topic_Search_HITS_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Hyperlink_Induced_Topic_Search_HITS.csv"
    
    # Update Graph (node properties and labels)
    # Note: There is an issue in gds version 2.5.0-preview3: https://github.com/neo4j/graph-data-science/issues/285
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9d_Hyperlink_Induced_Topic_Search_HITS_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# ---------------------------------------------------------------

# Artifact Query Parameters
ARTIFACT_PROJECTION="dependencies_projection=artifact-centrality" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 

# Artifact Centrality
echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing artifact dependencies..."
createProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithPageRank "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithArticleRank "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithBetweenness "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithCostEffectiveLazyForwardCELF "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithHarmonic "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithCloseness "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
time centralityWithHyperlinkInducedTopicSearchHITS "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"

# ---------------------------------------------------------------

# Package Query Parameters
PACKAGE_PROJECTION="dependencies_projection=package-centrality" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 

# Package Centrality
echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing package dependencies..."
createProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithPageRank "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithArticleRank "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithBetweenness "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithCostEffectiveLazyForwardCELF "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithHarmonic "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithCloseness "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
time centralityWithHyperlinkInducedTopicSearchHITS "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"

# ---------------------------------------------------------------

# Type Query Parameters
TYPE_PROJECTION="dependencies_projection=type-centrality" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 

# Type Centrality
echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing type dependencies..."
createProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithPageRank "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithArticleRank "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithBetweenness "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithCostEffectiveLazyForwardCELF "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithHarmonic "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithCloseness "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
time centralityWithHyperlinkInducedTopicSearchHITS "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"

echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished"