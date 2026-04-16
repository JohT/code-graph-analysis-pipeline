#!/usr/bin/env bash

# Creates a Markdown report summarising all git history analysis results.
# It requires an already running Neo4j graph database with already imported git log data.
# The results will be written into the sub directory reports/git-history.
# Dynamically triggered by "MarkdownReports.sh" via "gitHistoryMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "gitHistoryCsv.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/git-history/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GIT_HISTORY_SUMMARY_DIR=${GIT_HISTORY_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "gitHistorySummary: GIT_HISTORY_SUMMARY_DIR=${GIT_HISTORY_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GIT_HISTORY_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Cypher query directory for git history statistics queries within this domain
GIT_HISTORY_STATISTICS_CYPHER_DIR="${GIT_HISTORY_SUMMARY_DIR}/../queries/statistics"

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

git_history_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Git History Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# ── SVG chart reference helpers ───────────────────────────────────────────────

# Emits a Markdown image reference for a chart SVG if the file exists, otherwise nothing.
include_svg_if_exists() {
    local svg_file="${FULL_REPORT_DIRECTORY}/${1}"
    local alt_text="${2}"
    if [ -f "${svg_file}" ]; then
        echo ""
        echo "![${alt_text}](./${1})"
        echo ""
    fi
}

# Emits Markdown image references for every SVG matching the given glob pattern, sorted.
include_svgs_matching() {
    local base_dir="${1}"
    local pattern="${2}"
    [ -d "${base_dir}" ] || return 0 # if the base directory doesn't exist, just return without emitting anything
    find "${base_dir}" -maxdepth 1 -type f -name "${pattern}" | sort | while read -r svg_file; do
        local chart_filename
        chart_filename=$(basename -- "${svg_file}")
        local rel_path="${base_dir#"${FULL_REPORT_DIRECTORY}/"}/${chart_filename}"
        local chart_label="${chart_filename%.*}"
        echo ""
        echo "![${chart_label}](./${rel_path})"
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

assemble_git_history_report() {
    echo "gitHistorySummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    git_history_front_matter > "${report_include_directory}/GitHistoryReportFrontMatter.md"

    # ── Overview ──────────────────────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_by_resolved_label_and_extension.cypher"
        csv_link "List_git_files_by_resolved_label_and_extension.csv"
    } > "${report_include_directory}/List_git_files_by_resolved_label_and_extension.md"

    # ── Directory commit statistics ────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_file_directories_with_commit_statistics.cypher"
        csv_link "List_git_file_directories_with_commit_statistics.csv"
    } > "${report_include_directory}/List_git_file_directories_with_commit_statistics.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "DirectoryCommitStatistics_*.svg"
    } > "${report_include_directory}/DirectoryCommitStatisticsCharts.md"

    # ── Co-changed files ──────────────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_that_were_changed_together.cypher"
        csv_link "List_git_files_that_were_changed_together.csv"
    } > "${report_include_directory}/List_git_files_that_were_changed_together.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_that_were_changed_together_all_in_one.cypher"
        csv_link "List_git_files_that_were_changed_together_all_in_one.csv"
    } > "${report_include_directory}/List_git_files_that_were_changed_together_all_in_one.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_that_were_changed_together_with_another_file.cypher"
        csv_link "List_git_files_that_were_changed_together_with_another_file.csv"
    } > "${report_include_directory}/List_git_files_that_were_changed_together_with_another_file.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_that_were_changed_together_with_another_file_all_in_one.cypher"
        csv_link "List_git_files_that_were_changed_together_with_another_file_all_in_one.csv"
    } > "${report_include_directory}/List_git_files_that_were_changed_together_with_another_file_all_in_one.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "CoChangedFiles_*.svg"
    } > "${report_include_directory}/CoChangedFilesCharts.md"

    # ── File change distribution ───────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_per_commit_distribution.cypher"
        csv_link "List_git_files_per_commit_distribution.csv"
    } > "${report_include_directory}/List_git_files_per_commit_distribution.md"

    {
        include_svg_if_exists "FilesPerCommit_Bar.svg" "Files per Commit Distribution"
    } > "${report_include_directory}/FilesPerCommitChart.md"

    # ── Pairwise changed files ─────────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_pairwise_changed_files.cypher"
        csv_link "List_pairwise_changed_files.csv"
    } > "${report_include_directory}/List_pairwise_changed_files.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_top_selected_metric.cypher" \
            "selected_pair_metric=updateCommitLift"
        csv_link "List_pairwise_changed_files_top_lift.csv"
    } > "${report_include_directory}/List_pairwise_changed_files_top_selected_metric.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_with_dependencies.cypher"
        csv_link "List_pairwise_changed_files_with_dependencies.csv"
    } > "${report_include_directory}/List_pairwise_changed_files_with_dependencies.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "PairwiseChangedFiles_*.svg"
    } > "${report_include_directory}/PairwiseChangedFilesCharts.md"

    # ── Files by author ────────────────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_git_files_with_commit_statistics_by_author.cypher"
        csv_link "List_git_files_with_commit_statistics_by_author.csv"
    } > "${report_include_directory}/List_git_files_with_commit_statistics_by_author.md"

    # ── Data quality ──────────────────────────────────────────────────────

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_ambiguous_git_files.cypher"
        csv_link "List_ambiguous_git_files.csv"
    } > "${report_include_directory}/List_ambiguous_git_files.md"

    {
        cypher_table "${GIT_HISTORY_STATISTICS_CYPHER_DIR}/List_unresolved_git_files.cypher"
        csv_link "List_unresolved_git_files.csv"
    } > "${report_include_directory}/List_unresolved_git_files.md"

    # ── Git author wordcloud ───────────────────────────────────────────────

    {
        include_svg_if_exists "GitAuthorWordcloud.svg" "Git Author Wordcloud"
    } > "${report_include_directory}/GitAuthorWordcloudChart.md"

    # -- Remove empty Markdown includes ------------------------------------
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-git-data fallback template --------------------------------
    cp -f "${GIT_HISTORY_SUMMARY_DIR}/report_no_git_data.template.md" \
        "${report_include_directory}/report_no_git_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${GIT_HISTORY_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/git_history_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "gitHistorySummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="git-history"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_git_history_report
