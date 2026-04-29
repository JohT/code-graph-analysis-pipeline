#!/usr/bin/env bash

# Creates a Markdown report summarising centrality, community detection, and similarity results.
# It requires an already running Neo4j graph database with already imported code and
# centralityCsv.sh and communityCsv.sh run at least once to have written node properties.
# The results will be written into the sub directory reports/graph-algorithms.
# Dynamically triggered by "MarkdownReports.sh" via "graphAlgorithmsMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "centralityCsv.sh", "communityCsv.sh", and "similarityCsv.sh" must have run first.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory for Markdown includes embedded by the report template.

## Get this "domains/graph-algorithms/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GRAPH_ALGORITHMS_SUMMARY_DIR=${GRAPH_ALGORITHMS_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "graphAlgorithmsSummary: GRAPH_ALGORITHMS_SUMMARY_DIR=${GRAPH_ALGORITHMS_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GRAPH_ALGORITHMS_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Statistics query directory within this domain
STATISTICS_CYPHER_DIR="${GRAPH_ALGORITHMS_SUMMARY_DIR}/../queries/statistics"

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

graph_algorithms_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Graph Algorithms Report\""
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

assemble_graph_algorithms_report() {
    echo "graphAlgorithmsSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    graph_algorithms_front_matter > "${report_include_directory}/GraphAlgorithmsReportFrontMatter.md"

    # ── Centrality ─────────────────────────────────────────────────────────

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Top_nodes_by_PageRank.cypher"
        csv_link "Package_Centrality_Page_Rank.csv"
    } > "${report_include_directory}/TopNodesByPageRank.md"

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Top_nodes_by_ArticleRank.cypher"
        csv_link "Package_Centrality_Article_Rank.csv"
    } > "${report_include_directory}/TopNodesByArticleRank.md"

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Top_nodes_by_Betweenness.cypher"
        csv_link "Package_Centrality_Betweenness.csv"
    } > "${report_include_directory}/TopNodesByBetweenness.md"

    # ── Community Detection ────────────────────────────────────────────────

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Leiden_community_overview.cypher"
        csv_link "Package_Communities_Leiden.csv"
    } > "${report_include_directory}/LeidenCommunityOverview.md"

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/SCC_overview.cypher"
        csv_link "Package_Communities_Strongly_Connected_Components.csv"
    } > "${report_include_directory}/SCCOverview.md"

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/WCC_overview.cypher"
        csv_link "Package_Communities_Weakly_Connected_Components.csv"
    } > "${report_include_directory}/WCCOverview.md"

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/LCC_nodes_by_coefficient.cypher"
        csv_link "Package_communityLocalClusteringCoefficient_Community__Metrics.csv"
    } > "${report_include_directory}/LCCNodesByCoefficient.md"

    # ── Similarity ─────────────────────────────────────────────────────────

    {
        cypher_table "${STATISTICS_CYPHER_DIR}/Jaccard_similarity_top_pairs.cypher"
        csv_link "Package_Similarity.csv"
    } > "${report_include_directory}/JaccardSimilarityTopPairs.md"

    # -- Remove empty Markdown includes ------------------------------------
    # SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-data fallback template ------------------------------------
    cp -f "${GRAPH_ALGORITHMS_SUMMARY_DIR}/report_no_graph_data.template.md" \
        "${report_include_directory}/report_no_graph_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${GRAPH_ALGORITHMS_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/graph_algorithms_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "graphAlgorithmsSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="graph-algorithms"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_graph_algorithms_report
