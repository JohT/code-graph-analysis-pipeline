#!/usr/bin/env bash

# Creates a Markdown report summarising overview metrics: node label and relationship type
# distributions, general graph density, Java artifact type composition and package counts,
# and TypeScript module element composition.
# It requires an already running Neo4j graph database with scanned code data.
# The results will be written into the sub directory reports/overview.
# Dynamically triggered by "MarkdownReports.sh" via "overviewMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "overviewCsv.sh" must have run at least once to generate the CSV data files.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory for Markdown includes embedded by the report template.

## Get this "domains/overview/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
OVERVIEW_SUMMARY_DIR=${OVERVIEW_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "overviewSummary: OVERVIEW_SUMMARY_DIR=${OVERVIEW_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${OVERVIEW_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Query directory within this domain
OVERVIEW_QUERIES_DIR="${OVERVIEW_SUMMARY_DIR}/../queries/overview"

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

overview_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Overview Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# ── SVG chart reference helpers ───────────────────────────────────────────────

# Emits Markdown image references for every SVG matching the given glob pattern, sorted.
include_svgs_matching() {
    local base_dir="${1}"
    local pattern="${2}"
    [ -d "${base_dir}" ] || return 0
    find "${base_dir}" -maxdepth 1 -type f -name "${pattern}" | sort | while read -r svg_file; do
        local chart_filename
        chart_filename=$(basename -- "${svg_file}")
        local chart_label="${chart_filename%.*}"
        echo ""
        echo "![${chart_label}](./${chart_filename})"
    done
}

# ── Report assembly helpers ───────────────────────────────────────────────────

# Limits a piped Markdown table to at most 10 data rows (header + separator kept in full).
limit_markdown_table() {
    awk '/^\|[| :-]*-[| :-]*\|/ { sep=1; print; next } !sep { print } sep && ++rows <= 10 { print }'
}

# Runs a Cypher query and outputs a limited Markdown table to stdout.
# Arguments: <cypher_file> [cypher_params...]
cypher_table() {
    execute_cypher "$@" --output-markdown-table | limit_markdown_table
}

# Appends a CSV download link to stdout if the CSV file exists.
# Arguments: <csv_relative_path>
csv_link() {
    local full_csv="${FULL_REPORT_DIRECTORY}/${1}"
    if [ -f "${full_csv}" ]; then
        echo ""
        echo "[Full data](./${1})"
    fi
}

# ── Report assembly ───────────────────────────────────────────────────────────

assemble_overview_report() {
    echo "overviewSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    overview_front_matter > "${report_include_directory}/OverviewReportFrontMatter.md"

    # ── General: node label combinations ──────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Node_label_combination_count.cypher"
        csv_link "Node_label_combination_count.csv"
    } > "${report_include_directory}/NodeLabelCombinationCount.md"

    # ── General: individual node labels ───────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Node_label_count.cypher"
        csv_link "Node_label_count.csv"
    } > "${report_include_directory}/NodeLabelCount.md"

    # ── General: relationship types ────────────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Relationship_type_count.cypher"
        csv_link "Relationship_type_count.csv"
    } > "${report_include_directory}/RelationshipTypeCount.md"

    # ── General: node labels with relationships ───────────────────────────────────

    {
       cypher_table "${OVERVIEW_QUERIES_DIR}/Node_labels_and_their_relationships.cypher"
       csv_link "Node_labels_and_their_relationships.csv"
    } > "${report_include_directory}/NodeLabelsAndTheirRelationships.md"

    # ── General: dependency node labels ───────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Dependency_node_labels.cypher"
        csv_link "Dependency_node_labels.csv"
    } > "${report_include_directory}/DependencyNodeLabels.md"

    # ── General: graph density CSV link ───────────────────────────────────

    {
        csv_link "Overview_General_Graph_Density.csv"
    } > "${report_include_directory}/GeneralGraphDensity.md"

    # ── General: node label combination charts ─────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Overview_General_Node_Label_Combination_Count_*.svg"
    } > "${report_include_directory}/NodeLabelCombinationCharts.md"

    # ── General: node label count charts ───────────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Overview_General_Node_Label_Count.svg"
    } > "${report_include_directory}/NodeLabelCharts.md"

    # ── General: relationship type charts ──────────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Overview_General_Relationship_Type_Count_*.svg"
    } > "${report_include_directory}/RelationshipTypeCharts.md"

    # ── Java: size overview ────────────────────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Overview_size.cypher"
        csv_link "Overview_size.csv"
    } > "${report_include_directory}/JavaOverviewSize.md"

    # ── Java: SVG charts ───────────────────────────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Overview_Java_*.svg"
    } > "${report_include_directory}/OverviewJavaCharts.md"

    # ── TypeScript: size overview ──────────────────────────────────────────

    {
        cypher_table "${OVERVIEW_QUERIES_DIR}/Overview_size_for_Typescript.cypher"
        csv_link "Overview_size_for_Typescript.csv"
    } > "${report_include_directory}/TypescriptOverviewSize.md"

    # ── TypeScript: SVG charts ─────────────────────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Overview_Typescript_*.svg"
    } > "${report_include_directory}/OverviewTypescriptCharts.md"

    # -- Remove empty Markdown includes ------------------------------------
    # SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-data fallback template ------------------------------------
    cp -f "${OVERVIEW_SUMMARY_DIR}/report_no_data.template.md" \
        "${report_include_directory}/report_no_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${OVERVIEW_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/overview_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "overviewSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="overview"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_overview_report
