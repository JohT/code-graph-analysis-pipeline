#!/usr/bin/env bash

# Uses git log to create a comma separated values (CSV) file containing aggregated changes, their author name and email address, year and month for all the files that were changed. The CSV is then imported into Neo4j.

# Note: This script needs the path to a git repository directory. It defaults to SOURCE_DIRECTORY ("source"). 
# Note: Import will be skipped without an error if the directory is not a git repository.
# Note: This script needs git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.16.0"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"} # Get the source repository directory (defaults to "source")

# Default and initial values for command line options
repository="${SOURCE_DIRECTORY}"

# Read  command line options
USAGE="importAggregatedGitLog: Usage: $0 [--repository <git repository directory>(default=source)]"
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --repository)
      repository="$2"
      # Check if the explicitly given repository is a valid directory
      if [ ! -d "${repository}" ] ; then
        echo "importAggregatedGitLog: Error: The given repository <${repository}> is not a directory" >&2
        echo "${USAGE}" >&2
        exit 1
      fi
      shift
      ;;
    *)
      echo "importAggregatedGitLog: Error: Unknown option: ${key}"
      echo "${USAGE}" >&2
      exit 1
  esac
  shift
done

# Check if the repository is actually a git repository
if ! (cd "${repository}" || exit; git rev-parse --git-dir 2> /dev/null || exit); then
  echo "importAggregatedGitLog: Import skipped. ${repository} is not a git repository."
  exit 0
fi

echo "importAggregatedGitLog: repository=${repository}"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "importAggregatedGitLog: SCRIPTS_DIR=$SCRIPTS_DIR"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}
echo "importAggregatedGitLog: CYPHER_DIR=${CYPHER_DIR}"

# Define functions (like execute_cypher and execute_cypher_summarized) to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Internal constants
IMPORTS_CYPHER_DIR="${CYPHER_DIR}/Imports"
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"
NEO4J_FULL_IMPORT_DIRECTORY=$(cd "${NEO4J_INSTALLATION_DIRECTORY}/import"; pwd)
OUTPUT_CSV_FILENAME="${NEO4J_FULL_IMPORT_DIRECTORY}/aggregatedGitLog.csv"

# ----- Create a CSV file with git log data containing all commits and their changed files
echo "importAggregatedGitLog: Creating ${OUTPUT_CSV_FILENAME} from git log..."

(
  # Git log needs to be executed in the directory of the repository.
  # This is done in a sub shell to automatically return to the previous directory. 
  cd "${repository}" || exit

  # Prints the header line of the CSV file with the names of the columns.
  echo "filename,year,month,author,email,commits" > "${OUTPUT_CSV_FILENAME}"
  
  # Prints the aggregated git log in CSV format starting with the changed file, year-month, author, author email and number of commits.
  # Includes quoted strings, double quote escaping and supports commas in strings.
  git log --no-merges --pretty=format:' %ad,,,%an,,,%ae' --date=format:'%Y,%m' --name-only | \
  awk 'BEGIN { COMMA=",";QUOTE="\"" } /^ / { split($0, a, ",,,"); gsub(/^ /, "", a[1]); gsub(/"/, "\"\"", a[2]); gsub(/"/, "\"\"", a[3]); commit=a[1] COMMA QUOTE a[2] QUOTE COMMA QUOTE a[3] QUOTE } NF && !/^\ / { print "\""$0"\"," commit }' |
  grep -v -F '[bot]' | \
  sort | uniq -c | \
  sed -E 's/^ *([0-9]+) (.+)/\2,\1/g' \
      >> "${OUTPUT_CSV_FILENAME}"
  # Explanation:
  #
  # - --no-merges: Excludes merge commits from the log.
  # - %ad: Author date (formatted as specified later)
  # - %an: Author name
  # - %ae: Author email
  # - %ct: Commit date, Unix timestamp
  # - %s: Subject of the commit
  # - --date=format:'%Y,%m': Takes the year and the month of the date separated by a comma for example 2024,06
  # - --name-only: Lists the files affected by each commit.
  # - --pretty=format starts with a space that is needed to detect the start of a line.
  # - The chosen delimiters ,,, are used to separate these fields to make parsing easier.
  #   It is very unlikely that they appear in the contents and will be used as an intermediate step before escaping.
  #
  # - BEGIN { COMMA=","; QUOTE="\"" }: Initializes the variables COMMA and QUOTE to hold a comma and a double-quote character respectively.
  # - /^ / { ... }: Processes lines that start with a space (indicating a file name in git log --name-only output).
  # - gsub(/^ /, "", a[1]): Removes leading spaces from the first field (commit hash) that was used to indicate a new commit.
  # - gsub(/"/, "\"\"", a[2]) escapes double quotes with two double quotes (CSV standard).
  #   a[2] is the commit author. Double quote escaping is done for every string column
  # - commit=...: Constructs the commit information in CSV format, including the year-month of the change, quoted author name, and email.
  # - NF && !/^\ / { print "\""$0"\"," commit }: For non-empty lines that do not start with a space (indicating commit information), 
  #   it prints the commit information followed by the file name(s), enclosed in quotes.
  #
  # - grep -v -F '[bot]': Filters out commits where the commit message includes [bot]
  #   Used to identify commits made by automated systems or bots.
  #
  # - sort | uniq -c: Sorts the lines by their content (order of columns essential for that), removes duplicate lines and adds the number of duplicates at the beginning of each line
  #-   sed -E 's/^ *([0-9]+) (.+)/\2,\1/g': Reformats each line so that the commits count are the last column delimited by a comma.
)

csv_file_size=$(wc -c "${OUTPUT_CSV_FILENAME}" | awk '{print $1}')
csv_lines=$(wc -l "${OUTPUT_CSV_FILENAME}" | awk '{print $1}')
echo "importAggregatedGitLog: File ${OUTPUT_CSV_FILENAME} with ${csv_file_size} bytes and ${csv_lines} lines created."
# ---------

# ----- Import aggregate git log data csv
GIT_LOG_CYPHER_DIR="${CYPHER_DIR}/GitLog"

echo "importAggregatedGitLog: Prepare import by creating indexes..."
execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_author_name.cypher"
execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_change_span_year.cypher"
execute_cypher "${GIT_LOG_CYPHER_DIR}/Index_file_name.cypher"

echo "importAggregatedGitLog: Deleting all existing git data in the Graph..."
execute_cypher "${GIT_LOG_CYPHER_DIR}/Delete_git_log_data.cypher"

echo "importAggregatedGitLog: Importing aggregated git log data into the Graph..."
time execute_cypher "${GIT_LOG_CYPHER_DIR}/Import_aggregated_git_log_csv_data.cypher"

echo "importAggregatedGitLog: Creating connections to nodes with matching file names..."
execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher"
execute_cypher "${GIT_LOG_CYPHER_DIR}/Add_RESOLVES_TO_relationships_to_git_files_for_Typescript.cypher"
execute_cypher "${GIT_LOG_CYPHER_DIR}/Set_number_of_aggregated_git_commits.cypher"
# ---------