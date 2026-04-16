#!/usr/bin/env bash

# Uses git log to create a comma separated values (CSV) file containing aggregated changes, their author name and email address, year and month for all the files that were changed.

# Note: This script needs to be executed within a git repository.
# Note: This script has one unnamed parameter that contains the fully qualified path to the neo4j import directory.
# Note: This script needs git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

CSV_OUTPUT_FILE_PATH=${1}

# Check if the current directory is a git repository
if [ ! -d "./.git" ]; then
  echo "createAggregatedGitLogCsv: The current directory ${PWD} is not a git repository."
  return 0
fi

# Check if the repository is actually a git repository
if [ -z "${CSV_OUTPUT_FILE_PATH}" ]; then
  echo "createAggregatedGitLogCsv: Missing CSV output file path parameter."
  return 0
fi

# ----- Create a CSV file with git log data containing all commits and their changed files
echo "createAggregatedGitLogCsv: Creating ${CSV_OUTPUT_FILE_PATH} from git log..."

# Prints the header line of the CSV file with the names of the columns.
echo "filename,year,month,author,email,commits" > "${CSV_OUTPUT_FILE_PATH}"

# Prints the aggregated git log in CSV format starting with the changed file, year-month, author, author email and number of commits.
# Includes quoted strings, double quote escaping and supports commas in strings.
git log --no-merges --pretty=format:' %ad,,,%an,,,%ae' --date=format:'%Y,%m' --name-only | \
awk 'BEGIN { COMMA=",";QUOTE="\"" } /^ / { split($0, a, ",,,"); gsub(/^ /, "", a[1]); gsub(/"/, "\"\"", a[2]); gsub(/"/, "\"\"", a[3]); commit=a[1] COMMA QUOTE a[2] QUOTE COMMA QUOTE a[3] QUOTE } NF && !/^\ / { print "\""$0"\"," commit }' |
grep -v -F '[bot]' | \
sort | uniq -c | \
sed -E 's/^ *([0-9]+) (.+)/\2,\1/g' \
    >> "${CSV_OUTPUT_FILE_PATH}"
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

csv_file_size=$(wc -c "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
csv_lines=$(wc -l "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
echo "createAggregatedGitLogCsv: File ${CSV_OUTPUT_FILE_PATH} with ${csv_file_size} bytes and ${csv_lines} lines created."