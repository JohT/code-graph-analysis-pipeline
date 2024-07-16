#!/usr/bin/env bash

# Coordinates the import of git data from the given --source directory where one ore more git repositories are located and the value of the environment variable IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT.

# Requires executeQueryFunctions.sh, createGitLogCsv.sh, createAggregatedGitLogCsv

# Note: This script needs the path to source directory that contains one or more git repositories. It defaults to SOURCE_DIRECTORY ("source"). 
# Note: Import will be skipped without an error if the source directory doesn't any git repositories.
# Note: This script needs git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.20.0"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT=${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT:-"full"} # Select how to import git log data. Options: "none", "aggregated", "full". Default="full".

# Default and initial values for command line options
source="${SOURCE_DIRECTORY}"

# Read  command line options
USAGE="importGit: Usage: $0 [--source <directory containing git repositories>(default=source)]"
while [[ $# -gt 0 ]]; do
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

importGitLog() {
  echo "importGit: Preparing import by creating indexes for the full git log..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_author_name.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_commit_hash.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_commit_parent.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"
  
  echo "importGit: Importing full git log data into the Graph..."
  time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_git_log_csv_data.cypher"
  
  echo "importGit: Creating relationships for parent commits..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_HAS_PARENT_relationships_to_commits.cypher"
}

importAggregatedGitLog() {
  echo "importGit: Preparing import by creating indexes for the aggregated git log..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_author_name.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_change_span_year.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"

  echo "importGit: Importing aggregated git log data into the Graph..."
  time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"
}

commonPostGitLogImport() {
  echo "importGit: Creating relationships to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher"
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Typescript.cypher"
}

postGitLogImport() {
  commonPostGitLogImport

  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_git_commits.cypher"
}

postAggregatedGitLogImport() {
  commonPostGitLogImport

  echo "importGit: Add numberOfGitCommits property to nodes with matching file names..."
  execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_aggregated_git_commits.cypher"
}

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"
NEO4J_FULL_IMPORT_DIRECTORY=$(cd "${NEO4J_INSTALLATION_DIRECTORY}/import"; pwd)

# Skip import when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "none"
if [[ ! ${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT} == "none" ]]; then

  existing_data_has_been_deleted=false

  for repository in $(find "${source}" -type d -name ".git" -print0 | xargs -0 -r -I {} dirname {}); do
    # Prepare import by cleaning existing data first
    if [ "${existing_data_has_been_deleted}" = false ] ; then
      deleteExistingGitData
      existing_data_has_been_deleted=true
    fi
    
    echo "importGit: Importing git repository ${repository}"
    if [[ ${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT} == "aggregated" ]]; then
    # Import pre-aggregated git log data (no single commits) when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "aggregated"
        (cd "${repository}" && source "${SCRIPTS_DIR}/createAggregatedGitLogCsv.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/aggregatedGitLog.csv")
        importAggregatedGitLog
        postAggregatedGitLogImport
    else
    # Import git log data with every commit when IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT = "full" (default)
        (cd "${repository}" && source "${SCRIPTS_DIR}/createGitLogCsv.sh" "${NEO4J_FULL_IMPORT_DIRECTORY}/gitLog.csv")
        importGitLog
        postGitLogImport
    fi
  done
fi
