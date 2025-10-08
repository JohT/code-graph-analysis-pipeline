#!/usr/bin/env bash

# Executes selected anomaly detection Cypher queries for GraphViz visualization.
# Visualizes top ranked anomaly archetypes.
# Requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv, dot and svg files) will be written into the sub directory reports/anomaly-detection/{language}_{codeUnit}.

# Requires executeQueryFunctions.sh, visualizeQueryResults.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANOMALY_DETECTION_GRAPHS_DIR=${ANOMALY_DETECTION_GRAPHS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
#echo "anomalyDetectionGraphVisualization: ANOMALY_DETECTION_GRAPHS_DIR=${ANOMALY_DETECTION_GRAPHS_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_GRAPHS_DIR}/../../../scripts"} # Repository directory containing the shell scripts

# echo "anomalyDetectionGraphVisualization: SCRIPTS_DIR=${SCRIPTS_DIR}"
# Get the "cypher" query directory for gathering features.
ANOMALY_DETECTION_FEATURE_CYPHER_DIR=${ANOMALY_DETECTION_FEATURE_CYPHER_DIR:-"${ANOMALY_DETECTION_GRAPHS_DIR}/../features"}

# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization
# echo "anomalyDetectionGraphVisualization: VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR}"

MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"}
ANOMALY_DETECTION_TOP_N_GRAPHS=${ANOMALY_DETECTION_TOP_N_GRAPHS:-5} # Number of top ranked graphs to visualize per query for anomaly detection.

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Query or recalculate features.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
set_required_features() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )

    echo "anomalyDetectionGraphVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Collecting features for ${nodeLabel} nodes..."

    # TODO Create missing projection (with all that comes with it) for the sake of self containment or assume Page/Article Rank?
    # Determine the page rank if not already done
    #execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Exists.cypher" \
    #                                     "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Write.cypher" "${@}"
    # Determine the article rank if not already done
    #execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Exists.cypher" \
    #                                     "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Write.cypher" "${@}"
    # Determine the normalized difference between Page Rank and Article Rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Write.cypher" "${@}"
}

# Creates or updates the markdown file (include for main summary) that contains the references to all graph visualizations.
# 
# Required Parameters:
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - report_name=...
#   Name of the query and then also the resulting visualization file.
# - index=...
#   Index of visualization plot.
update_markdown_references() {
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local report_name
    report_name=$( extractQueryParameter "report_name" "${@}" )

    local index
    index=$( extractQueryParameter "index" "${@}" )

    local detail_report_directory_name="${language}_${nodeLabel}"
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${detail_report_directory_name}/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}"
    local markdown_graph_visualizations_reference_file="${detail_report_directory}/${MARKDOWN_REFERENCE_FILE_NAME}"

    if [ ! -f "${markdown_graph_visualizations_reference_file}" ]; then
        echo "anomalyDetectionGraphVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${markdown_graph_visualizations_reference_file}..."
        {
            echo "#### Graph Visualizations"
            echo ""
        } >> "${markdown_graph_visualizations_reference_file}"
    else 
        {
            echo "---"
            echo ""
        } >> "${markdown_graph_visualizations_reference_file}"
    fi

    if [ "${index}" == "1" ]; then
        {
            echo "##### ${report_name} Graph Visualizations"
            echo ""
        } >> "${markdown_graph_visualizations_reference_file}"
    fi

    {
        echo "![${report_name} ${index}](./${detail_report_directory_name}/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}/${report_name}${index}.svg)"
        echo ""
    } >> "${markdown_graph_visualizations_reference_file}"
}

# Runs a parametrized query, converts their results in GraphViz format and creates a Graph visualization.
# Outputs (at most) 10 indexed files (for report_name="TopHub" then TopHub1, TopHub2,...) with a focused visualization of one selected node and its surroundings.
# 
# Required Parameters:
# - report_name=...
#   Name of the query and then also the resulting visualization file.
# - template_name=...
#   Name of the GraphViz template gv file.
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
create_graph_visualization() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    local report_name
    report_name=$( extractQueryParameter "report_name" "${@}" )
    
    local template_name
    template_name=$( extractQueryParameter "template_name" "${@}" )
    
    echo "anomalyDetectionGraphVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${language} ${nodeLabel} ${report_name} visualizations with template ${template_name}..."
    
    local detail_report_directory_name="${language}_${nodeLabel}"
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${detail_report_directory_name}/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}"
    mkdir -p "${detail_report_directory}"
    rm -rf "${detail_report_directory}/${report_name}.*"

    for ((index=1; index<=ANOMALY_DETECTION_TOP_N_GRAPHS; index++)); do
        # Query Graph data
        local resultFileName="${detail_report_directory}/${report_name}${index}"
        local queryResultFile="${resultFileName}.csv"
        execute_cypher "${ANOMALY_DETECTION_GRAPHS_DIR}/${report_name}.cypher" "${@}" "projection_node_rank=${index}" > "${queryResultFile}" || true
        
        # Remove empty files
        # Note: Afterwards, detail_report_directory might be deleted as well. 
        #       In that case the image generation is finished and the loop needs to be terminated.
        source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_directory}" 
        # Stop generation as soon as the first query result is empty or the directory is deleted.
        if [ ! -f "${queryResultFile}" ] ; then
            break; 
        fi

        # Generate svg image using GraphViz
        source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${queryResultFile}" --template "${ANOMALY_DETECTION_GRAPHS_DIR}/${template_name}.template.gv"
        
        # Clean up after graph visualization image generation: 
        rm -rf "${queryResultFile}" # Remove query result
        # Collect graphviz files in a "graphviz" sub directory
        mkdir -p "${detail_report_directory}/graphviz"
        mv -f "${resultFileName}.gv" "${detail_report_directory}/graphviz"

        update_markdown_references "${@}" "index=${index}"
    done
}

# Run queries, outputs their results in GraphViz format and create Graph visualizations.
#
# Required Parameters:
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
anomaly_detection_graph_visualization() {
    set_required_features "${@}"
    
    create_graph_visualization "report_name=TopHub" "template_name=TopCentral" "${@}"
    create_graph_visualization "report_name=TopBottleneck" "template_name=TopCentral" "${@}"
    create_graph_visualization "report_name=TopAuthority" "template_name=TopCentral" "${@}"
    create_graph_visualization "report_name=TopBridge" "template_name=TopCentral" "${@}"
    create_graph_visualization "report_name=TopOutlier" "template_name=TopCentral" "${@}"
}


# Create report directory
REPORT_NAME="anomaly-detection"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

GRAPH_VISUALIZATIONS_DIRECTORY_NAME="GraphVisualizations"

MARKDOWN_REFERENCE_FILE_NAME="GraphVisualizationsReferenceForSummary.md"
# Delete all markdown reference files so that they can be written by appending lines. 
# Wildcards/Globs need to be outside of double quotes.
rm -rfv "${FULL_REPORT_DIRECTORY}"/*_*/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}/${MARKDOWN_REFERENCE_FILE_NAME}

# Query Parameter key pairs for projection and algorithm side
QUERY_NODE="projection_node_label"
QUERY_LANGUAGE="projection_language"

# -- Detail Reports for each code type -------------------------------

anomaly_detection_graph_visualization "${QUERY_NODE}=Artifact" "${QUERY_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${QUERY_NODE}=Package" "${QUERY_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${QUERY_NODE}=Type" "${QUERY_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${QUERY_NODE}=Module" "${QUERY_LANGUAGE}=Typescript"

# ---------------------------------------------------------------

echo "anomalyDetectionGraphVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."