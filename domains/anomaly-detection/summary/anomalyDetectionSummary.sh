#!/usr/bin/env bash

# Creates a Markdown report that contains all results of all the anomaly detection methods.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/anomaly-detection.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that either "anomalyDetectionCsv.sh" or "anomalyDetectionPython.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

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

# Appends a Markdown table to an existing file and
# removes redundant header + separator rows.
#
# Usage:
#   cat newTable.md | append_table myMarkdownFile.md
#
#   append_table myMarkdownFile.md <<'EOF'
#   | Name | Score | Archetype |
#   | ---  | ---   | ---       |
#   | Bar  | 0.9   | Something |
#   EOF
#
# Behavior:
#   - Keeps the first header row and its following separator row.
#   - Removes all subsequent duplicate header + separator pairs.
#   - Leaves all data rows untouched.
append_to_markdown_table() {
  local file="$1"

  # Append stdin to the target file
  cat >> "${file}"
  
  # Clean up duplicate headers (header row + --- row)
  awk '!seen[$0]++ || NR <= 2' "${file}" > "${file}.tmp" && mv "${file}.tmp" "${file}"
}

# Run the anomaly detection main report generation.
anomaly_detection_report_first_section() {
    local report_markdown_includes_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_markdown_includes_directory}"
    
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesPerAbstractionLayer.cypher" --output-markdown-table > "${report_markdown_includes_directory}/AnomaliesPerAbstractionLayer.md"
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesInTotal.cypher" --output-markdown-table > "${report_markdown_includes_directory}/AnomaliesInTotal.md"
}

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
    
    local report_number
    report_number=$( extractQueryParameter "report_number" "${@}" )
    
    echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${language} ${nodeLabel} anomaly summary Markdown report..."
    
    anomaly_summary_directory="${FULL_REPORT_DIRECTORY}/anomaly_summary_${language}_${nodeLabel}"
    mkdir -p "${anomaly_summary_directory}/${MARKDOWN_INCLUDES_DIRECTORY}"
    
    # TODO 2.{number of report}
    echo "### 2.${report_number} ${language} ${nodeLabel}" > "${anomaly_summary_directory}/${MARKDOWN_INCLUDES_DIRECTORY}/DeepDiveSectionTitle.md"

    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomaliesDeepDiveOverview.cypher" "${@}" --output-markdown-table > "${anomaly_summary_directory}/${MARKDOWN_INCLUDES_DIRECTORY}/DeepDiveOverview.md"
    execute_cypher "${ANOMALY_DETECTION_SUMMARY_DIR}/AnomalyDetectionReportTopArchetypes.cypher" "${@}" --output-markdown-table > "${anomaly_summary_directory}/${MARKDOWN_INCLUDES_DIRECTORY}/TopAnomaliesByArchetype.md"
    
    # Use Markdown template to assemble the final deep dive section of the Markdown report
    cp -f "${ANOMALY_DETECTION_SUMMARY_DIR}/report-deep-dive-template.md" "${anomaly_summary_directory}"
    cat "${anomaly_summary_directory}/report-deep-dive-template.md" | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${anomaly_summary_directory}/${MARKDOWN_INCLUDES_DIRECTORY}" > "${anomaly_summary_directory}/report-deep-dive.md"
    rm -rf "${anomaly_summary_directory}/report-deep-dive-template.md"

    # Clean-up after report generation. Empty reports will be deleted.
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${anomaly_summary_directory}"
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

# Create report directory
REPORT_NAME="anomaly-detection"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
ALGORITHM_NODE="projection_node_label"
ALGORITHM_LANGUAGE="projection_language"
REPORT_NUMBER="report_number"

# -- Overview Report for all code type -------------------------------

anomaly_detection_report_first_section

# -- Detail Reports for each code type -------------------------------

anomaly_detection_report "${REPORT_NUMBER}=1" "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${REPORT_NUMBER}=2" "${ALGORITHM_NODE}=Package" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${REPORT_NUMBER}=3" "${ALGORITHM_NODE}=Type" "${ALGORITHM_LANGUAGE}=Java"
anomaly_detection_report "${REPORT_NUMBER}=4" "${ALGORITHM_NODE}=Module" "${ALGORITHM_LANGUAGE}=Typescript"

# ---------------------------------------------------------------

echo "anomalyDetectionSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."