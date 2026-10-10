#!/usr/bin/env bash

# Uses git log to create a CSV file with commits, authors, timestamps, changed files, change types, and rename tracking.
# Schema: hash,parent,author,email,timestamp,timestamp_unix,message,filename,change_type,old_filename
# change_type values: A (added), M (modified), D (deleted), R (renamed), C (copied)
# For renames: filename = new path, old_filename = old path. For all other types: old_filename is empty.
# Merge commits are included. Bot-author filtering is handled in Cypher after import.

# Note: This script must be executed (via source) within a git repository directory.
# Note: Requires one positional parameter: fully qualified path to the CSV output file.
# Note: Requires git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

CSV_OUTPUT_FILE_PATH=${1:-}

if [ ! -d "./.git" ]; then
  echo "createGitLogData: The current directory ${PWD} is not a git repository."
  return 0
fi

if [ -z "${CSV_OUTPUT_FILE_PATH}" ]; then
  echo "createGitLogData: Missing CSV output file path parameter."
  return 0
fi

echo "createGitLogData: Creating ${CSV_OUTPUT_FILE_PATH} from git log..."

echo "hash,parent,author,email,timestamp,timestamp_unix,message,filename,change_type,old_filename" > "${CSV_OUTPUT_FILE_PATH}"

# Skip git log if the repository has no commits yet (git log would exit with code 128)
if ! git rev-parse --verify HEAD > /dev/null 2>&1; then
  echo "createGitLogData: Repository ${PWD} has no commits. CSV contains only the header."
  return 0
fi

# git log format explanation:
# - Lines starting with a space are commit metadata, delimited by ,,, to avoid conflicts with field content.
# - %H: commit hash, %P: parent hash(es) space-separated (merge commits have multiple),
#   %an: author name, %ae: author email, %aI: ISO 8601 author date, %ct: Unix timestamp, %s: subject.
# - --name-status: produces tab-separated status+filename lines after each commit block.
#   Single-file format: STATUS<TAB>filename (e.g. "A\tsrc/Foo.java")
#   Rename/copy format: RSTATUS<TAB>old<TAB>new (e.g. "R100\told.java\tnew.java")
#
# awk logic:
# - FS="\t" so tab-delimited file status lines parse correctly into $1, $2, $3.
# - Lines starting with a space are commit lines: split on ,,, to extract fields,
#   escape double quotes in string fields (CSV standard), replace backslashes in message.
# - Non-empty, non-commit lines are file status lines:
#   change_type = first character of $1 (R100 -> R, A -> A, etc.)
#   For R-type: filename = $3 (new path), old_filename = $2 (old path)
#   For C-type (copy): filename = $3 (new path), old_filename = empty
#   For all other types: filename = $2, old_filename = empty
git log --pretty=format:' %H,,,%P,,,%an,,,%ae,,,%aI,,,%ct,,,%s' --name-status | \
awk 'BEGIN { FS="\t"; COMMA=","; QUOTE="\"" }
/^ / {
    split($0, a, ",,,")
    gsub(/^ /, "", a[1])
    gsub(/"/, "\"\"", a[3])
    gsub(/"/, "\"\"", a[4])
    gsub(/"/, "\"\"", a[7])
    gsub(/\\/, " ", a[7])
    commit = a[1] COMMA a[2] COMMA QUOTE a[3] QUOTE COMMA QUOTE a[4] QUOTE COMMA a[5] COMMA a[6] COMMA QUOTE a[7] QUOTE
}
NF && !/^ / {
    change_type = substr($1, 1, 1)
    if (change_type == "R") {
        print commit COMMA QUOTE $3 QUOTE COMMA QUOTE "R" QUOTE COMMA QUOTE $2 QUOTE
    } else if (change_type == "C") {
        print commit COMMA QUOTE $3 QUOTE COMMA QUOTE "C" QUOTE COMMA QUOTE QUOTE
    } else {
        print commit COMMA QUOTE $2 QUOTE COMMA QUOTE change_type QUOTE COMMA QUOTE QUOTE
    }
}' >> "${CSV_OUTPUT_FILE_PATH}"

csv_file_size=$(wc -c "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
csv_lines=$(wc -l "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
echo "createGitLogData: File ${CSV_OUTPUT_FILE_PATH} with ${csv_file_size} bytes and ${csv_lines} lines created."
