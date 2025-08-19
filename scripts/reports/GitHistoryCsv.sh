#!/usr/bin/env bash

# Executes "GitLog" Cypher queries to get the "git-history-csv" CSV reports.
# It contains lists of files with only one author, last changed or created files, pairwise changed files,...

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "GitHistoryCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "GitHistoryCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "GitHistoryCsv: CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="git-history-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
GIT_LOG_CYPHER_DIR="${CYPHER_DIR}/GitLog"

echo "GitHistoryCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing git history..."

# Detailed git file statistics
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_git_files_with_commit_statistics_by_author.cypher" > "${FULL_REPORT_DIRECTORY}/List_git_files_with_commit_statistics_by_author.csv"
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_git_files_that_were_changed_together_with_another_file.cypher" > "${FULL_REPORT_DIRECTORY}/List_git_files_that_were_changed_together_with_another_file.csv"
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_git_file_directories_with_commit_statistics.cypher" > "${FULL_REPORT_DIRECTORY}/List_git_file_directories_with_commit_statistics.csv"

# Overall distribution of how many files were changed with one git commit, how many were changed with two, etc. 
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_git_files_per_commit_distribution.cypher" > "${FULL_REPORT_DIRECTORY}/List_git_files_per_commit_distribution.csv"

# Find pairwise changed files that depend on each other
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_pairwise_changed_files_with_dependencies.cypher" > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files_with_dependencies.csv"

# List pairwise changed files with various metrics
execute_cypher "${GIT_LOG_CYPHER_DIR}/List_pairwise_changed_files.cypher" > "${FULL_REPORT_DIRECTORY}/List_pairwise_changed_files.csv"

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "GitHistoryCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."