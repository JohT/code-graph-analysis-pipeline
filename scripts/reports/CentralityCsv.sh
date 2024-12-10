#!/usr/bin/env bash

# Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports.
# It requires an already running Neo4j graph database with already scanned analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/centrality-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

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

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="centrality-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityPageRank" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2a_Page_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_2b_Page_Rank_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3c_Page_Rank_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Page_Rank.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3d_Page_Rank_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Page_Rank.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_3e_Page_Rank_Write.cypher" "${@}" "${writePropertyName}"
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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"
    
    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityArticleRank" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4a_Article_Rank_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4b_Article_Rank_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4c_Article_Rank_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Article_Rank.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4d_Article_Rank_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Article_Rank.csv"
    
    # Update Graph (node properties and labels) using the already mutated property projection
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_4e_Article_Rank_Write.cypher" "${@}" "${writePropertyName}"
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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"
    
    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityBetweenness" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5a_Betweeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5b_Betweeness_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5c_Betweeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Betweeness.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5d_Betweeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Betweeness.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_5e_Betweeness_Write.cypher" "${@}" "${writePropertyName}"
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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityCostEffectiveLazyForward" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6a_Cost_effective_Lazy_Forward_CELF_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6b_Cost_effective_Lazy_Forward_CELF_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6c_Cost_effective_Lazy_Forward_CELF_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Cost_Effective_Lazy_Forward_CELF.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6d_Cost_effective_Lazy_Forward_CELF_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Cost_effective_Lazy_Forward_CELF.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_6e_Cost_effective_Lazy_Forward_CELF_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}"
}

# Apply the centrality algorithm "Harmonic" (variant of "Closeness)").
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
centralityWithHarmonic() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityHarmonic" 

    # Statistics
    # Note: Estimate procedure doesn't seem to exist for now (gds version 2.5.0-preview3)
    # execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7a_Harmonic_Closeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7b_Harmonic_Closeness_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7c_Harmonic_Closeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Harmonic_Closeness.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7d_Harmonic_Closeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Harmonic.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_7e_Harmonic_Closeness_Write.cypher" "${@}" "${writePropertyName}"
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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityCloseness" 

    # Statistics
    # Note: Estimate procedure doesn't seem to exist for now (gds version 2.5.0-preview3)
    # execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8a_Closeness_Estimate.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8b_Closeness_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8c_Closeness_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Betweeness.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8d_Closeness_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Closeness.csv"
    
    # Update Graph (node properties and labels)
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_8e_Closeness_Write.cypher" "${@}" "${writePropertyName}"
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
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"

    # Name of the property that will be written to the nodes containing the centrality score.
    # This is also used as a name with the first letter capitalized as a label for the top centraliy nodes.
    local writePropertyName="dependencies_projection_write_property=centralityHyperlinkInducedTopicSearch" 

    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9a_Hyperlink_Induced_Topic_Search_HITS_Estimate.cypher" "${@}" "${writePropertyName}"
    # Note: There was an issue in gds version 2.5.0-preview3 that is now resolved: https://github.com/neo4j/graph-data-science/issues/285
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9b_Hyperlink_Induced_Topic_Search_HITS_Statistics.cypher" "${@}"
    
    # Run the algorithm and write the result into the in-memory projection ("mutate")
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9c_Hyperlink_Induced_Topic_Search_HITS_Mutate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9d_Hyperlink_Induced_Topic_Search_HITS_Stream_Mutated.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Hyperlink_Induced_Topic_Search_HITS.csv"
    #execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_8_Stream_Mutated_Value_Descending.cypher" "${@}" "${writePropertyName}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Hyperlink_Induced_Topic_Search_HITS.csv"
    #execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9d_Hyperlink_Induced_Topic_Search_HITS_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Hyperlink_Induced_Topic_Search_HITS.csv"
    
    # Update Graph (node properties and labels)
    # Note: There was an issue in gds version 2.5.0-preview3 that is now resolved: https://github.com/neo4j/graph-data-science/issues/285
    # execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_9e_Hyperlink_Induced_Topic_Search_HITS_Write.cypher" "${@}" "${writePropertyName}"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${PROJECTION_CYPHER_DIR}/Dependencies_9_Write_Mutated.cypher" "${@}" "${writePropertyName}Hub"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1c_Label_Delete.cypher" "${@}" "${writePropertyName}Hub"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}Authority"
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_1d_Label_Add.cypher" "${@}" "${writePropertyName}Hub"
}

# Apply the centrality algorithm "Bridges".
# Requires an undirected graph projection and ignores weights. Thus, no weight property is needed.
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "type-centrality"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Type"
centralityWithBridges() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"
    local PROJECTION_CYPHER_DIR="$CYPHER_DIR/Dependencies_Projection"
    
    # Statistics
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10a_Bridges_Estimate.cypher" "${@}" "${writePropertyName}"

    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10d_Bridges_Stream.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_Bridges.csv"
    
    # Set "isBridge=true" on all relationships identified as Bridge
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_10e_Bridges_Write.cypher" "${@}"
}

listAllResults() {
    local CENTRALITY_CYPHER_DIR="$CYPHER_DIR/Centrality"

    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${CENTRALITY_CYPHER_DIR}/Centrality_90_Summary.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Centrality_All.csv"
}

# Run all contained centrality algorithms.
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "centralityPageRank"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
runCentralityAlgorithms() {
    time centralityWithPageRank "${@}"
    time centralityWithArticleRank "${@}"
    time centralityWithBetweenness "${@}"
    time centralityWithCostEffectiveLazyForwardCELF "${@}"
    time centralityWithHarmonic "${@}"
    time centralityWithCloseness "${@}"
    time centralityWithHyperlinkInducedTopicSearchHITS "${@}"
    listAllResults "${@}"
}

# Run all centrality algorithms that require an undirected graph projection.
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "centralityPageRank"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
runUndirectedCentralityAlgorithms() {
    time centralityWithBridges "${@}"
}


# -- Java Artifact Centrality ------------------------------------

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

# -- Java Package Centrality -------------------------------------

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

# -- Java Type Centrality ----------------------------------------

TYPE_PROJECTION="dependencies_projection=type-centrality"
TYPE_PROJECTION_UNDIRECTED="dependencies_projection=type-centrality-undirected" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 

if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"; then
    runCentralityAlgorithms "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
fi
if createUndirectedJavaTypeDependencyProjection "${TYPE_PROJECTION_UNDIRECTED}"; then
    runUndirectedCentralityAlgorithms "${TYPE_PROJECTION_UNDIRECTED}" "${TYPE_NODE}"
fi

# -- Java Method Centrality --------------------------------------

METHOD_PROJECTION="dependencies_projection=method-centrality"
METHOD_NODE="dependencies_projection_node=Method" 
METHOD_WEIGHT="dependencies_projection_weight_property=" 

if createDirectedJavaMethodDependencyProjection "${METHOD_PROJECTION}"; then
    runCentralityAlgorithms "${METHOD_PROJECTION}" "${METHOD_NODE}" "${METHOD_WEIGHT}"
fi

# -- Typescript Modules Centrality -------------------------------

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

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "centralityCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."