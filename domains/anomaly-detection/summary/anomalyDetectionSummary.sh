#!/usr/bin/env bash

# Creates a Markdown report that contains all results of all the anomaly detection methods.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/anomaly-detection.
# Dynamically triggered by "MarkdownReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that either "anomalyDetectionCsv.sh" or "anomalyDetectionPython.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"}

## Get this "domains/anomaly-detection/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANOMALY_DETECTION_SUMMARY_DIR=${ANOMALY_DETECTION_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
#echo "anomalyDetectionSummary: ANOMALY_DETECTION_SUMMARY_DIR=${ANOMALY_DETECTION_SUMMARY_DIR}"
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_SUMMARY_DIR}/../../../scripts"} # Repository directory containing the shell scripts

MARKDOWN_INCLUDES_DIRECTORY="includes"
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}
#echo "anomalyDetectionSummary: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher" and "execute_cypher_summarized"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Aggregates all results in a Markdown report.
#
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_deep_dive_report() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${language} ${nodeLabel} anomaly summary Markdown report..."
    
    local detail_report_directory_name="${language}_${nodeLabel}"
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${detail_report_directory_name}"
    
    # Skip the deep dive report part if there is no data available
    if ! find "${detail_report_directory}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
        echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Skipping ${language} ${nodeLabel} report..." >&2
        return 0
    fi    
    
    report_number=$((report_number+1))

    # Create the directory that contains the Markdown includes
    local detail_report_include_directory="${detail_report_directory}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${detail_report_include_directory}"

    # Collect dynamic Markdown includes
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesDeepDiveOverview.cypher" "${@}" --output-markdown-table > "${detail_report_include_directory}/DeepDiveOverview.md"
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesDeepDiveArchetypes.cypher" "${@}" --output-markdown-table > "${detail_report_include_directory}/DeepDiveArchetypes.md"
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomalyDeepDiveTopAnomalies.cypher" "${@}" --output-markdown-table > "${detail_report_include_directory}/DeepDiveTopAnomalies.md"

    # Remove empty Markdown includes
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_include_directory}"

    # Collect static Markdown includes (after cleanup to not remove one-liner)
    echo "### 2.${report_number} ${language} ${nodeLabel}" > "${detail_report_include_directory}/DeepDiveSectionTitle.md"
    echo "" > "${detail_report_include_directory}/empty.md"
    cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_no_anomaly_detection_data.template.md" "${detail_report_include_directory}/report_no_anomaly_detection_data.template.md"
    cp -f "${detail_report_directory}/Top_anomaly_features.md" "${detail_report_include_directory}" || true

    # Assemble Markdown-Includes containing plots depending on their availability (fallback empty.md)
    if [ -f "${detail_report_directory}/Anomaly_feature_importance_explained.svg" ] ; then
        cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive_anomaly_plots.template.md" "${detail_report_include_directory}/report_deep_dive_anomaly_plots.md"
    fi

    if [ -f "${detail_report_directory}/Clusters_Overall.svg" ] ; then
        cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive_cluster_overall_plot.template.md" "${detail_report_include_directory}/report_deep_dive_cluster_overall_plot.md"
    fi

    if [ -f "${detail_report_directory}/Clusters_largest_average_radius.svg" ] ; then
        cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive_cluster_focus_plots.template.md" "${detail_report_include_directory}/report_deep_dive_cluster_focus_plots.md"
    fi

    if [ -f "${detail_report_directory}/Cluster_probabilities.svg" ] ; then
        cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive_cluster_noise_plots.template.md" "${detail_report_include_directory}/report_deep_dive_cluster_noise_plots.md"
    fi

    if [ -f "${detail_report_directory}/ClusteringCoefficient_distribution.svg" ] ; then
        cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive_feature_plots.template.md" "${detail_report_include_directory}/report_deep_dive_feature_plots.md"
    fi

    # Use Markdown template to assemble the final deep dive section of the Markdown report and replace variables
    cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report_deep_dive.template.md" "${detail_report_directory}/report_deep_dive.template.md"
    cat "${detail_report_directory}/report_deep_dive.template.md" | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${detail_report_include_directory}" > "${detail_report_directory}/report_deep_dive_with_vars.md"
    sed "s/{{deep_dive_directory}}/${detail_report_directory_name}/g" "${detail_report_directory}/report_deep_dive_with_vars.md" > "${detail_report_directory}/report_deep_dive_${report_number}.md" 

    rm -rf "${detail_report_directory}/report_deep_dive_with_vars.md"
    rm -rf "${detail_report_directory}/report_deep_dive.template.md"
    rm -rf "${detail_report_include_directory}"

    # Clean-up after report generation. Empty reports will be deleted.
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_directory}"
}

# Run the anomaly detection report generation.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_report() {
    time anomaly_detection_deep_dive_report "${@}"
}

anomaly_detection_front_matter_metadata_head() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git ls-remote --tags origin | grep -v '\^{}' | tail -n1 | awk '{print $2}' | sed 's|refs/tags/||')"
    
    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Anomaly Detection Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# Finalize the anomaly detection report by taking the main template, applying includes and appending all deep dive reports
anomaly_detection_finalize_report() {
    echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling main anomaly detection Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesPerAbstractionLayer.cypher" --output-markdown-table > "${report_include_directory}/AnomaliesPerAbstractionLayer.md"
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesInTotal.cypher" --output-markdown-table > "${report_include_directory}/AnomaliesInTotal.md"

    # Write "front matter" metadata section
    anomaly_detection_front_matter_metadata_head > "${report_include_directory}/AnomalyDetectionReportFrontMatter.md"

    # Concatenate all deep dive reports as Markdown include
    rm -rf "${report_include_directory}/AnomalyDetectionDeepDive.md"
    for markdown_file in $(find . -type f -name 'report_deep_dive_*.md' | sort); do
        cat "${markdown_file}" >> "${report_include_directory}/AnomalyDetectionDeepDive.md"
        echo "" >> "${report_include_directory}/AnomalyDetectionDeepDive.md"
        rm -rf "${markdown_file}"
    done

    # Remove empty Markdown includes
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" > "${FULL_REPORT_DIRECTORY}/anomaly_detection_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"
}

# Create report directory
REPORT_NAME="anomaly-detection"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
ALGORITHM_NODE="projection_node_label"
ALGORITHM_LANGUAGE="projection_language"

# -- Detail Reports for each code type -------------------------------
report_number=0

anomaly_detection_report "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${ALGORITHM_NODE}=Package" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${ALGORITHM_NODE}=Type" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${ALGORITHM_NODE}=Module" "${ALGORITHM_LANGUAGE}=Typescript"

# ---------------------------------------------------------------

anomaly_detection_finalize_report

echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."