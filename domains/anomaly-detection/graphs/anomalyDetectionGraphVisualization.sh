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
ANOMALY_DETECTION_GRAPHS_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
#echo "anomalyDetectionGraphVisualization: ANOMALY_DETECTION_GRAPHS_DIR=${ANOMALY_DETECTION_GRAPHS_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_GRAPHS_DIR}/../../../scripts"} # Repository directory containing the shell scripts
# echo "anomalyDetectionGraphVisualization: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization
# echo "anomalyDetectionGraphVisualization: VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Run queries, outputs their results in GraphViz format and create Graph visualizations.
#
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_graph_visualization() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${language} ${nodeLabel} anomaly summary Markdown report..."
    
    local detail_report_directory_name="${language}_${nodeLabel}"
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${detail_report_directory_name}"
    mkdir -p "${detail_report_directory}"

    local queryResultFile="${detail_report_directory}/TopHubsGraphVisualization.csv"
    execute_cypher "${ANOMALY_DETECTION_GRAPHS_DIR}/AnomalyDetectionTopHubsGraph.cypher" "${@}" > "${queryResultFile}"
   
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_directory}" # Remove empty files

    if [ -f "${queryResultFile}" ] ; then
        source "${VISUALIZATION_SCRIPTS_DIR}/visualizeQueryResults.sh" "${queryResultFile}" --template "${ANOMALY_DETECTION_GRAPHS_DIR}/anomaly-archetype-hub.template.gv"
    fi
}


# Create report directory
REPORT_NAME="anomaly-detection"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
ALGORITHM_NODE="projection_node_label"
ALGORITHM_LANGUAGE="projection_language"

# -- Detail Reports for each code type -------------------------------

anomaly_detection_graph_visualization "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${ALGORITHM_NODE}=Package" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${ALGORITHM_NODE}=Type" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_graph_visualization "${ALGORITHM_NODE}=Module" "${ALGORITHM_LANGUAGE}=Typescript"

# ---------------------------------------------------------------

echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."