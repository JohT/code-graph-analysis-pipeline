#!/usr/bin/env bash

# Creates a Markdown report summarising node embedding properties present in the graph.
# It requires an already running Neo4j graph database with embedding properties written by nodeEmbeddingsCsv.sh.
# The results will be written into the sub directory reports/node-embeddings.
# Dynamically triggered by "MarkdownReports.sh" via "nodeEmbeddingsMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "nodeEmbeddingsCsv.sh" must have run at least once to write embedding properties.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory for Markdown includes embedded by the report template.

## Get this "domains/node-embeddings/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
NODE_EMBEDDINGS_SUMMARY_DIR=${NODE_EMBEDDINGS_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "nodeEmbeddingsSummary: NODE_EMBEDDINGS_SUMMARY_DIR=${NODE_EMBEDDINGS_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${NODE_EMBEDDINGS_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Statistics query directory within this domain
STATISTICS_CYPHER_DIR="${NODE_EMBEDDINGS_SUMMARY_DIR}/../queries/statistics"

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

node_embeddings_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Node Embeddings Report\""
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

assemble_node_embeddings_report() {
    echo "nodeEmbeddingsSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    node_embeddings_front_matter > "${report_include_directory}/NodeEmbeddingsReportFrontMatter.md"

    # ── Embedding property overview ────────────────────────────────────────

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Embedding_properties_overview.cypher"
        csv_link "Package_Embeddings_Label_Random_Projection.csv"
    } > "${report_include_directory}/EmbeddingPropertiesOverview.md"

    # ── Combined embeddings + community + centrality ───────────────────────

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Node_embeddings_with_community_and_centrality.cypher"
    } > "${report_include_directory}/NodeEmbeddingsWithCommunityAndCentrality.md"

    # ── UMAP 2D scatter plot charts ────────────────────────────────────────

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Package_Embeddings_*_UMAP2D_Scatter.svg"
    } > "${report_include_directory}/PackageEmbeddingCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Artifact_Embeddings_*_UMAP2D_Scatter.svg"
    } > "${report_include_directory}/ArtifactEmbeddingCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Type_Embeddings_*_UMAP2D_Scatter.svg"
    } > "${report_include_directory}/TypeEmbeddingCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "Module_Embeddings_*_UMAP2D_Scatter.svg"
    } > "${report_include_directory}/ModuleEmbeddingCharts.md"

    # -- Remove empty Markdown includes ------------------------------------
    # SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-data fallback template ------------------------------------
    cp -f "${NODE_EMBEDDINGS_SUMMARY_DIR}/report_no_embedding_data.template.md" \
        "${report_include_directory}/report_no_embedding_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${NODE_EMBEDDINGS_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/node_embeddings_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "nodeEmbeddingsSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="node-embeddings"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_node_embeddings_report
