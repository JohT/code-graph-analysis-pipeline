#!/usr/bin/env bash

# Uses git log to create a comma separated values (CSV) file containing all commits, their author, email address, date and all the file names that were changed with it.

# Note: This script needs to be executed within a git repository.
# Note: This script has one unnamed parameter that contains the fully qualified path to the neo4j import directory.
# Note: This script needs git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

CSV_OUTPUT_FILE_PATH=${1}

# Check if the current directory is a git repository
if [ ! -d "./.git" ]; then
  echo "createGitLogCsv: The current directory ${PWD} is not a git repository."
  return 0
fi

# Check if the repository is actually a git repository
if [ -z "${CSV_OUTPUT_FILE_PATH}" ]; then
  echo "createGitLogCsv: Missing CSV output file path parameter."
  return 0
fi

# ----- Create a CSV file with git log data containing all commits and their changed files
echo "createGitLogCsv: Creating ${CSV_OUTPUT_FILE_PATH} from git log..."

# Prints the header line of the CSV file with the names of the columns.
echo "hash,parent,author,email,timestamp,timestamp_unix,message,filename" > "${CSV_OUTPUT_FILE_PATH}"

# Prints the git log in CSV format including the changed files.
# Includes quoted strings, double quote escaping and supports commas in strings.
git log --no-merges --pretty=format:' %H,,,%P,,,%an,,,%ae,,,%aI,,,%ct,,,%s' --name-only | \
awk 'BEGIN { COMMA=",";QUOTE="\"" } /^ / { split($0, a, ",,,"); gsub(/^ /, "", a[1]); gsub(/"/, "\"\"", a[3]); gsub(/"/, "\"\"", a[4]); gsub(/"/, "\"\"", a[7]); gsub(/\\/, " ", a[7]); commit=a[1] COMMA a[2] COMMA QUOTE a[3] QUOTE COMMA QUOTE a[4] QUOTE COMMA a[5] COMMA a[6] COMMA QUOTE a[7] QUOTE } NF && !/^\ / { print commit ",\""$0"\"" }' | \
grep -v -F '[bot]' >> "${CSV_OUTPUT_FILE_PATH}"
# Explanation:
#
# - --no-merges: Excludes merge commits from the log.
# - %H: Commit hash
# - %P: Commit hash parent(s)
# - %an: Author name
# - %ae: Author email
# - %aI: Author date, ISO 8601 format
# - %ct: Commit date, Unix timestamp
# - %s: Subject of the commit
# - --name-only: Lists the files affected by each commit.
# - --pretty=format starts with a space that is needed to detect the start of a line.
# - The chosen delimiters ,,, are used to separate these fields to make parsing easier.
#   It is very unlikely that they appear in the contents and will be used as an intermediate step before escaping.
#
# - BEGIN { COMMA=","; QUOTE="\"" }: Initializes the variables COMMA and QUOTE to hold a comma and a double-quote character respectively.
# - /^ / { ... }: Processes lines that start with a space (indicating a file name in git log --name-only output).
# - gsub(/^ /, "", a[1]): Removes leading spaces from the first field (commit hash) that was used to indicate a new commit.
# - gsub(/"/, "\"\"", a[6]) escapes double quotes with two double quotes (CSV standard).
#   a[6] is the commit message column. Double quote escaping is done for every string column
# - gsub(/\\/, " ", a[6]): Replaces backslashes in the commit message with spaces.
#   Otherwise, \" would lead to an error since it would be seen as an non escaped double quote.
# - commit=...: Constructs the commit information in CSV format, including the quoted author name, author email, and commit message except for the file name.
# - NF && !/^\ / { print commit ",\""$0"\"" }: For non-empty lines that do not start with a space (indicating commit information), 
#   it prints the commit information followed by the file name(s), enclosed in quotes.
#
# - grep -v -F '[bot]': Filters out commits where the commit message includes [bot]
#   Used to identify commits made by automated systems or bots.

csv_file_size=$(wc -c "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
csv_lines=$(wc -l "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
echo "createGitLogCsv: File ${CSV_OUTPUT_FILE_PATH} with ${csv_file_size} bytes and ${csv_lines} lines created."
