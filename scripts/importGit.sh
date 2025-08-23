#!/usr/bin/env bash

# Coordinates the import of git data from the given --source directory where one ore more git repositories are located and the value of the environment variable IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT.

# Requires executeQueryFunctions.sh, createGitLogCsv.sh, createAggregatedGitLogCsv

# Note: This script needs the path to source directory that contains one or more git repositories. It defaults to SOURCE_DIRECTORY ("source"). 
# Note: Import will be skipped without an error if the source directory doesn't any git repositories.
# Note: This script needs git to be installed.
# Note: IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="plugin" is default and recommended. The other options "aggregated" and "full" are not actively maintained anymore.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"import"}
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT:-"plugin"} # Select how to import git log data. Options: "none", "aggregated", "full" and "plugin". Default="plugin".

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
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "importGit: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}
echo "importGit: CYPHER_DIR=${CYPHER_DIR}"

GIT_LOG_CYPHER_DIR="${CYPHER_DIR}/GitLog"

# Define functions (like execute_cypher and execute_cypher_summarized) to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

deleteExistingGitData() {
  echo "importGit: Deleting already imported git data..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Delete_git_log_data.cypher"
}

# Creates one (Git:Repository) node with information about the repository.  
# The first and only parameter is the absolute/full repository directory path.
create_git_repository_node() {
    local full_local_repository_path=${1}
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
  
  echo "importGit: Importing full git log data into the Graph..."
  time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_git_log_csv_data.cypher" "${@}"
  
  echo "importGit: Creating relationships for parent commits..."
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
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Verify_git_to_code_file_unambiguous.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Verify_code_to_git_file_unambiguous.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Verify_git_missing_CHANGED_TOGETHER_WITH_properties.cypher"
}

postGitLogImport() {
  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_log_commits.cypher"

  commonPostGitImport
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

  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_plugin_commits.cypher"
  echo "importGit: Add updateCommitCount property to file nodes and code nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_plugin_update_commits.cypher"

  commonPostGitImport
}

postAggregatedGitLogImport() {
  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_aggregated_git_commits.cypher"

  commonPostGitImport
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
        (cd "${repository}" && source "${SCRIPTS_DIR}/createAggregatedGitLogCsv.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/aggregatedGitLog.csv")
        importAggregatedGitLog "git_repository_absolute_directory_name=${full_repository_path}"
        postAggregatedGitLogImport 
    else
    # Import git log data with every commit when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "full" (default)
        (cd "${repository}" && source "${SCRIPTS_DIR}/createGitLogCsv.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/gitLog.csv")
        importGitLog "git_repository_absolute_directory_name=${full_repository_path}"
        postGitLogImport 
    fi
  done
else
  echo "importGit: Skipped git import because of IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}"
fi

# Even if the data had already been imported by a plugin, the post data enrichment still needs to be done.
if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "plugin" ]; then
  postGitPluginImport
fi