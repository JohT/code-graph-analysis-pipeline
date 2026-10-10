#!/usr/bin/env bash

# Coordinates the import of git data from the given --source directory where one ore more git repositories are located and the value of the environment variable IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT.

# Requires executeQueryFunctions.sh, createGitLogData.sh, createAggregatedGitLogData

# Note: This script needs the path to source directory that contains one or more git repositories. It defaults to SOURCE_DIRECTORY ("source"). 
# Note: Import will be skipped without an error if the source directory doesn't any git repositories.
# Note: This script needs git to be installed.
# Note: IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="plugin" is default and recommended (uses jQAssistant git plugin).
# Options "aggregated" and "full" will become important in future for SCIP index-based analysis without jQAssistant.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"import"}
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT:-"plugin"} # Select how to import git log data. Options: "none", "aggregated", "full" and "plugin". Default="plugin".

# Local constants
COLOR_YELLOW='\033[0;33m'
COLOR_DEFAULT='\033[0m'

# Default and initial values for command line options
source="${SOURCE_DIRECTORY}"

# Read  command line options
USAGE="importGit: Usage: $0 [--source <directory containing git repositories>(default=source)]"
while [ "$#" -gt "0" ]; do
  key="$1"
  case $key in
    --source)
      source="$2"
      # Check if the explicitly given source is a valid directory
      if [ ! -d "${source}" ] ; then
        echo "importGit: Error: The given source <${source}> is not a directory" >&2
        echo "${USAGE}" >&2
        exit 1
      fi
      shift
      ;;
    *)
      echo "importGit: Error: Unknown option: ${key}"
      echo "${USAGE}" >&2
      exit 1
  esac
  shift
done

echo "importGit: source directory to look for git repositories=${source}"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GIT_HISTORY_IMPORT_DIR=${GIT_HISTORY_IMPORT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # This "import" directory
echo "importGit: GIT_HISTORY_IMPORT_DIR=${GIT_HISTORY_IMPORT_DIR}"

# Get the central "scripts" directory by navigating three levels up from this domain's import directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GIT_HISTORY_IMPORT_DIR}/../../../scripts"}
echo "importGit: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Cypher enrichment queries are in this domain's queries/enrichment directory.
GIT_LOG_CYPHER_DIR="${GIT_HISTORY_IMPORT_DIR}/../queries/enrichment"
echo "importGit: GIT_LOG_CYPHER_DIR=${GIT_LOG_CYPHER_DIR}"

# Cypher validation queries are in this domain's queries/validation directory.
GIT_LOG_VALIDATION_CYPHER_DIR="${GIT_HISTORY_IMPORT_DIR}/../queries/validation"
echo "importGit: GIT_LOG_VALIDATION_CYPHER_DIR=${GIT_LOG_VALIDATION_CYPHER_DIR}"

# Define functions (like execute_cypher and execute_cypher_summarized) to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions (like get_csv_column_value and is_csv_column_greater_zero) to parse CSV format strings from Cypher query results.
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

deleteExistingGitData() {
  echo "importGit: Deleting already imported git data..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Delete_git_log_data.cypher"
}

# Verifies that all commits from Pass 1 were successfully imported by comparing expected count vs database count.
# Parameter: expected number of commits from Pass 1 import result
# Exits with error code 1 if counts don't match (fail-fast on partial import)
verify_pass1_commit_count() {
  local expected_commits="${1:-}"
  if [ -z "${expected_commits}" ]; then
    echo "importGit: Error: verify_pass1_commit_count() requires expected commit count argument" >&2
    return 1
  fi

  echo "importGit: Verifying Pass 1 imported ${expected_commits} commits..."

  local actual_result
  actual_result=$(execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Query_count_git_log_commits.cypher")

  local actual_commits
  actual_commits=$(get_csv_column_value "${actual_result}" "commitCount")

  if [ "${actual_commits}" -ne "${expected_commits}" ]; then
    echo "importGit: Error: Pass 1 incomplete. Expected ${expected_commits} commits, found ${actual_commits} in database. Aborting." >&2
    return 1
  fi
}

verify_pass2a_file_count() {
  echo "importGit: Checking that Git:Log:File nodes were created..."

  local actual_result
  actual_result=$(execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Query_count_git_log_files.cypher")

  local actual_files
  actual_files=$(get_csv_column_value "${actual_result}" "fileCount")

  if [ "${actual_files}" -le 0 ]; then
    echo "importGit: Error: Pass 2a failed to create any file nodes. Found ${actual_files} files in database. Aborting." >&2
    return 1
  fi
  
  echo "importGit: Pass 2a verified - ${actual_files} Git:Log:File nodes in database."
}

verify_pass2b_relationships() {
  local expected_relationships="${1:-}"
  if [ -z "${expected_relationships}" ]; then
    echo "importGit: Error: verify_pass2b_relationships() requires expected relationship count argument" >&2
    return 1
  fi

  echo "importGit: Verifying Pass 2b created ${expected_relationships} CONTAINS_CHANGED relationships..."

  local actual_result
  actual_result=$(execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Query_count_git_log_relationships.cypher")

  local actual_relationships
  actual_relationships=$(get_csv_column_value "${actual_result}" "relationshipCount")

  if [ "${actual_relationships}" -ne "${expected_relationships}" ]; then
    echo "importGit: Error: Pass 2b incomplete. Expected ${expected_relationships} relationships, found ${actual_relationships} in database. Aborting." >&2
    return 1
  fi
}

# Verifies that Git:File nodes have createdAtEpoch property set. Logs a non-fatal warning if missing.
# Optional parameter: context message (defaults to generic message)
verify_git_file_creation_dates() {
  local context_message="${1:-}"
  
  echo "importGit: Verifying git file creation dates...${context_message:+ ($context_message)}"
  
  local dataVerificationResult
  dataVerificationResult=$( execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Verify_git_missing_create_date.cypher")
  
  if is_csv_column_greater_zero "${dataVerificationResult}" "numberOfMissingCreateDateEntries"; then
      # Warning: The git file creation date must not be missing. However, this is not important enough to stop the analysis.
      #          Therefore, it will only be a warning and subsequent queries will use a default date in these cases.
      echo -e "${COLOR_YELLOW}importGit: Data verification warning: Git:File nodes with missing createdAtEpoch property detected! Affected number of nodes:${COLOR_DEFAULT}"
      echo -e "${COLOR_YELLOW}${dataVerificationResult}${COLOR_DEFAULT}"
      # Since this is now only a warning, execution will be continued.
  fi
}

# Creates one (Git:Repository) node with information about the repository.  
# The first and only parameter is the absolute/full repository directory path.
create_git_repository_node() {
    local full_local_repository_path="${1:-}"
    if [ -z "${full_local_repository_path}" ]; then
        echo "importGit: Error: create_git_repository_node() requires a repository path argument" >&2
        return 1
    fi
    if [ ! -d "${full_local_repository_path}" ]; then
        echo "importGit: Error: Repository directory does not exist: ${full_local_repository_path}" >&2
        return 1
    fi
    echo "importGit:   - full_local_repository_path=${full_local_repository_path}"

    local_repository=$(basename "${full_local_repository_path}")
    echo "importGit:   - local_repository=    ${local_repository}"

    remote_origin=$(cd "${full_local_repository_path}" ;git config --get remote.origin.url || true)
    remote_origin=$(basename -s .git "${remote_origin}" || true)
    echo "importGit:   - remote_origin=       ${remote_origin}"

    current_tags=$(cd "${full_local_repository_path}" ;git tag --points-at HEAD | paste -sd "," - || true)
    echo "importGit:   - current_tags=        ${current_tags}"
    
    current_branch=$(cd "${full_local_repository_path}" ;git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
    echo "importGit:   - current_branch=      ${current_branch}"

    current_commit=$(cd "${full_local_repository_path}" ;git rev-parse HEAD || true)
    echo "importGit:   - current_commit=      ${current_commit}"

    execute_cypher "${GIT_LOG_CYPHER_DIR}/Create_git_repository_node.cypher" \
      "git_repository_origin=${remote_origin}" \
      "git_repository_current_tags=${current_tags}" \
      "git_repository_current_branch=${current_branch}" \
      "git_repository_current_commit=${current_commit}" \
      "git_repository_directory_name=${local_repository}" \
      "git_repository_absolute_directory_name=${full_local_repository_path}"
}

importGitLog() {
  echo "importGit: Preparing import by creating indexes for the full git log..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_author_name.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_commit_hash.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_commit_parent.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Pass 1: Importing git commit and author nodes from gitLogCommits.csv..."
  local pass1_result
  pass1_result=$(time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_git_log_nodes_csv_data.cypher")

  local expected_commits
  expected_commits=$(get_csv_column_value "${pass1_result}" "numberOfCommits")

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Verifying Pass 1 imported ${expected_commits} commits..."
  if ! verify_pass1_commit_count "${expected_commits}"; then
      exit 1
  fi

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Pass 2a: Creating git file nodes from gitLog.csv..."
  time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_git_log_files_csv_data.cypher" "${@}"

  # Verify Pass 2a by checking database count (simpler than calculating from CSV)
  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Verifying Pass 2a created file nodes..."
  if ! verify_pass2a_file_count; then
      exit 1
  fi

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Pass 2b: Creating commit-file relationships from gitLog.csv..."
  local pass2b_result
  pass2b_result=$(time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_git_log_relationships_csv_data_pass2b.cypher" "${@}")

  local expected_relationships
  expected_relationships=$(get_csv_column_value "${pass2b_result}" "relationshipsCreated")

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Verifying Pass 2b created ${expected_relationships} relationships..."
  if ! verify_pass2b_relationships "${expected_relationships}"; then
      exit 1
  fi

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Pass 3: Creating repository-level relationships..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Create_git_log_repo_commit_relationships.cypher" "${@}"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Create_git_log_repo_author_relationships.cypher" "${@}"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Create_git_log_repo_file_relationships.cypher" "${@}"

  echo "importGit: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating relationships for parent commits..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_HAS_PARENT_relationships_to_commits.cypher"
}

importAggregatedGitLog() {
  echo "importGit: Preparing import by creating indexes for the aggregated git log..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_author_name.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_change_span_year.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"

  echo "importGit: Importing aggregated git log data into the Graph..."
  time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher" "${@}"
}

commonPostGitImport() {
  echo "importGit: Creating relationships to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Typescript.cypher"

  echo "importGit: Creating relationships to file nodes that where changed together..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_CHANGED_TOGETHER_WITH_relationships_to_git_files.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_CHANGED_TOGETHER_WITH_relationships_to_code_files.cypher"

  # Since it's currently not possible to rule out ambiguity in git<->code file matching,
  # the following verifications are only an additional info in the log rather than an error.
  echo "importGit: Running verification queries for troubleshooting (non failing)..."
  execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Verify_git_to_code_file_unambiguous.cypher"
  execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Verify_code_to_git_file_unambiguous.cypher"
  execute_cypher "${GIT_LOG_VALIDATION_CYPHER_DIR}/Verify_git_missing_CHANGED_TOGETHER_WITH_properties.cypher"
}

postGitLogImport() {
  # Classify commits first: isManualCommit must be set before commonPostGitImport runs CHANGED_TOGETHER_WITH.
  echo "importGit: Classify git commits (e.g. isMergeCommit, isAutomatedCommit)..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_commit_classification_properties.cypher"

  # RESOLVES_TO relationships must be created before the number-of-commits and update-count queries.
  commonPostGitImport
  
  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_log_commits.cypher"

  echo "importGit: Add updateCommitCount property to file nodes and code nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_log_file_update_commits.cypher"

  echo "importGit: Setting file creation and last modification dates for CSV log files..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_git_log_file_dates.cypher"

  echo "importGit: Creating relationships to file nodes that were changed together (CSV log schema)..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_CHANGED_TOGETHER_WITH_relationships_to_git_log_files.cypher"

  # Verify file creation dates are now set (runs after date enrichment query)
  verify_git_file_creation_dates "after date enrichment"
}

postGitPluginImport() {
  echo "importGit: Creating indexes for plugin-provided git data..."

  # TODO: The deletion of all plain files in the "/.git" directory is needed
  #       until there is a way to exclude all files inside a directory
  #       while still being able to get them analyzed by the git plugin.
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Delete_plain_git_directory_file_nodes.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_commit_sha.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_relative_path.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_absolute_file_name.cypher"

  # Classify commits first: isManualCommit must be set before commonPostGitImport runs CHANGED_TOGETHER_WITH.
  echo "importGit: Classify git commits (e.g. isMergeCommit, isAutomatedCommit)..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_commit_classification_properties.cypher"

  # Set updateCommitCount on git files before CHANGED_TOGETHER_WITH computation needs it
  echo "importGit: Add updateCommitCount property to git file nodes..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_plugin_update_commits.cypher"

  # RESOLVES_TO relationships must be created before the number-of-commits and update-count queries.
  commonPostGitImport

  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_plugin_commits.cypher"
  # Runs a second time: first run (before commonPostGitImport) set updateCommitCount on Git:File nodes so
  # CHANGED_TOGETHER_WITH could read it. This run propagates updateCommitCount to code files via RESOLVES_TO.
  echo "importGit: Propagate updateCommitCount to code file nodes via RESOLVES_TO..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_plugin_update_commits.cypher"

  # Verify file creation dates after all plugin-provided data and enrichment
  verify_git_file_creation_dates "plugin import"
}

postAggregatedGitLogImport() {
  # RESOLVES_TO relationships must be created first, as they are needed by subsequent queries
  commonPostGitImport
  
  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_aggregated_git_commits.cypher"

  # Verify file creation dates after all aggregated data and enrichment
  verify_git_file_creation_dates "aggregated import"
}

# Create import directory in case it doesn't exist.
mkdir -p "${IMPORT_DIRECTORY}"

# Internal constants
NEO4J_FULL_IMPORT_DIRECTORY=$(cd "${IMPORT_DIRECTORY}"; pwd)

# Skip import if it is switched off ("none") or if it already taken care of by a plugin ("plugin"), which is the default.
if [ ! "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "none" ] && [ ! "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "plugin" ]; then

  existing_data_has_been_deleted=false

  for repository in $(find -L "${source}" -type d -name ".git" -print0 | xargs -0 -r -I {} dirname {}); do
    # Prepare import by cleaning existing data first
    if [ "${existing_data_has_been_deleted}" = false ] ; then
      deleteExistingGitData
      existing_data_has_been_deleted=true
    fi
    
    echo "importGit: Importing git repository ${repository}"
    full_repository_path=$(cd "${repository}"; pwd)
    
    create_git_repository_node "${full_repository_path}"

    if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "aggregated" ]; then
    # Import pre-aggregated git log data (no single commits) when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "aggregated"
        (cd "${repository}" && source "${GIT_HISTORY_IMPORT_DIR}/createAggregatedGitLogData.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/aggregatedGitLog.csv")
        importAggregatedGitLog "git_repository_absolute_directory_name=${full_repository_path}"
    else
    # Import git log data with every commit when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "full"
        (cd "${repository}" && source "${GIT_HISTORY_IMPORT_DIR}/createGitLogData.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/gitLog.csv" "${NEO4J_FULL_IMPORT_DIRECTORY}/gitLogCommits.csv")
        importGitLog "git_repository_absolute_directory_name=${full_repository_path}"
    fi
  done
  # Post-import enrichment runs once after all repositories are imported.
  # Running per-repository would create cross-repository co-change artifacts and would be O(n*N) instead of O(N).
  if [ "${existing_data_has_been_deleted}" = true ]; then
    if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "aggregated" ]; then
      postAggregatedGitLogImport
    else
      postGitLogImport
    fi
  fi
else
  echo "importGit: Skipped git import because of IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}"
fi

# Even if the data had already been imported by a plugin, the post data enrichment still needs to be done.
if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "plugin" ]; then
  postGitPluginImport
fi