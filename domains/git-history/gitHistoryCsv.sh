#!/usr/bin/env bash

# Executes GitLog Cypher statistics queries to produce git history CSV reports.
# It covers directory commit statistics, co-changed files, pairwise changed file metrics, and data quality.
# It requires an already running Neo4j graph database with already imported git history data.
# The results will be written into the sub directory reports/git-history.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that git history data must be imported before this script runs (see import/importGit.sh or the
# jQAssistant git plugin). If no git history is present, all queries return empty results and
# cleanupAfterReportGeneration.sh will remove the empty CSV files — no report directory is created.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/git-history" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GIT_HISTORY_SCRIPT_DIR=${GIT_HISTORY_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "gitHistoryCsv: GIT_HISTORY_SCRIPT_DIR=${GIT_HISTORY_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GIT_HISTORY_SCRIPT_DIR}/../../scripts"}

# Cypher query directories within this domain
STATISTICS_CYPHER_DIR="${GIT_HISTORY_SCRIPT_DIR}/queries/statistics"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create main report directory
REPORT_NAME="git-history"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "gitHistoryCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing git history..."

# ── Detailed file commit statistics ──────────────────────────────────────────

execute_cypher "${STATISTICS_CYPHER_DIR}/List_git_files_with_commit_statistics_by_author.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_git_files_with_commit_statistics_by_author.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_git_files_that_were_changed_together_with_another_file.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_git_files_that_were_changed_together_with_another_file.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_git_file_directories_with_commit_statistics.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_git_file_directories_with_commit_statistics.csv"

# ── Files per commit distribution ────────────────────────────────────────────

execute_cypher "${STATISTICS_CYPHER_DIR}/List_git_files_per_commit_distribution.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_git_files_per_commit_distribution.csv"

# ── Pairwise changed files ────────────────────────────────────────────────────

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_with_dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_with_dependencies.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_top_selected_metric.cypher" \
    "selected_pair_metric=updateCommitCount" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_top_count.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_top_selected_metric.cypher" \
    "selected_pair_metric=updateCommitMinConfidence" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_top_min_confidence.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_top_selected_metric.cypher" \
    "selected_pair_metric=updateCommitJaccardSimilarity" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_top_jaccard.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_pairwise_changed_files_top_selected_metric.cypher" \
    "selected_pair_metric=updateCommitLift" \
    > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_top_lift.csv"

# ── Data quality ──────────────────────────────────────────────────────────────

execute_cypher "${STATISTICS_CYPHER_DIR}/List_git_files_by_resolved_label_and_extension.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_git_files_by_resolved_label_and_extension.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_ambiguous_git_files.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_ambiguous_git_files.csv"

execute_cypher "${STATISTICS_CYPHER_DIR}/List_unresolved_git_files.cypher" \
    > "${FULL_REPORT_DIRECTORY}/List_unresolved_git_files.csv"

# ── Wordcloud data ────────────────────────────────────────────────────────────

execute_cypher "${STATISTICS_CYPHER_DIR}/Words_for_git_author_Wordcloud_with_frequency.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Words_for_git_author_Wordcloud_with_frequency.csv"

# ── Cleanup ───────────────────────────────────────────────────────────────────

# Clean-up after report generation. Empty reports will be deleted.
# If all queries returned empty results (no git data), the report directory will be removed entirely.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "gitHistoryCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
