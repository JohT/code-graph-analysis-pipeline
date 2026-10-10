#!/usr/bin/env bash

# Uses git log to create two CSV files for multi-pass import:
# 1. gitLogCommits.csv — schema: hash,parent,author,email,timestamp_unix,message (one row per unique commit with file changes)
# 2. gitLog.csv        — schema: hash,filename,change_type,old_filename (one row per file change)
# change_type values: A (added), M (modified), D (deleted), R (renamed), C (copied)
# For renames: filename = new path, old_filename = old path. For all other types: old_filename is empty.
# Merge commits are included. Bot-author filtering is handled in Cypher after import.

# Note: This script must be executed (via source) within a git repository directory.
# Note: Requires two positional parameters: path to gitLog.csv output, path to gitLogCommits.csv output.
# Note: Requires git to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

CSV_OUTPUT_FILE_PATH=${1:-}
CSV_COMMITS_OUTPUT_FILE_PATH=${2:-}

if [ ! -d "./.git" ]; then
  echo "createGitLogData: The current directory ${PWD} is not a git repository."
  return 0
fi

if [ -z "${CSV_OUTPUT_FILE_PATH}" ]; then
  echo "createGitLogData: Missing gitLog.csv output file path parameter."
  return 0
fi

if [ -z "${CSV_COMMITS_OUTPUT_FILE_PATH}" ]; then
  echo "createGitLogData: Missing gitLogCommits.csv output file path parameter."
  return 0
fi

echo "createGitLogData: Creating ${CSV_COMMITS_OUTPUT_FILE_PATH} and ${CSV_OUTPUT_FILE_PATH} from git log..."

echo "hash,parent,author,email,timestamp_unix,message" > "${CSV_COMMITS_OUTPUT_FILE_PATH}"
echo "hash,filename,change_type,old_filename" > "${CSV_OUTPUT_FILE_PATH}"

# Skip git log if the repository has no commits yet (git log would exit with code 128)
if ! git rev-parse --verify HEAD > /dev/null 2>&1; then
  echo "createGitLogData: Repository ${PWD} has no commits. CSVs contain only headers."
  return 0
fi

# git log format for gitLogCommits.csv:
# - Lines starting with a space are commit metadata, delimited by ,,, to avoid conflicts with field content.
# - %H: commit hash, %P: parent hash(es) space-separated, %an: author name, %ae: author email,
#   %aI: ISO 8601 date (kept for field count), %ct: Unix timestamp, %s: commit subject.
# - awk: on the first file status line per commit, print one commit row (skipping commits with no file changes).
#   has_files flag prevents duplicate rows for commits touching multiple files.
git log --pretty=format:' %H,,,%P,,,%an,,,%ae,,,%aI,,,%ct,,,%s' --name-status | \
awk 'BEGIN { FS="\t"; COMMA=","; QUOTE="\"" }
/^ / {
    split($0, a, ",,,")
    gsub(/^ /, "", a[1])
    gsub(/"/, "\"\"", a[3])
    gsub(/"/, "\"\"", a[4])
    gsub(/"/, "\"\"", a[7])
    gsub(/\\/, " ", a[7])
    commit = a[1] COMMA a[2] COMMA QUOTE a[3] QUOTE COMMA QUOTE a[4] QUOTE COMMA a[6] COMMA QUOTE a[7] QUOTE
    has_files = 0
}
NF && !/^ / {
    if (!has_files) { print commit; has_files = 1 }
}' >> "${CSV_COMMITS_OUTPUT_FILE_PATH}"

# git log format for gitLog.csv:
# - Lines starting with a space are commit lines: only the hash is extracted (no other metadata needed).
# - Non-empty, non-commit lines are tab-delimited file status lines.
#   change_type = first character of $1 (R100 -> R, A -> A, etc.)
#   For R-type: filename = $3 (new path), old_filename = $2 (old path)
#   For C-type (copy): filename = $3 (new path), old_filename = empty
#   For all other types: filename = $2, old_filename = empty
git log --pretty=format:' %H' --name-status | \
awk 'BEGIN { FS="\t"; COMMA=","; QUOTE="\"" }
/^ / {
    current_hash = substr($0, 2)
}
NF && !/^ / {
    change_type = substr($1, 1, 1)
    if (change_type == "R") {
        print current_hash COMMA QUOTE $3 QUOTE COMMA QUOTE "R" QUOTE COMMA QUOTE $2 QUOTE
    } else if (change_type == "C") {
        print current_hash COMMA QUOTE $3 QUOTE COMMA QUOTE "C" QUOTE COMMA QUOTE QUOTE
    } else {
        print current_hash COMMA QUOTE $2 QUOTE COMMA QUOTE change_type QUOTE COMMA QUOTE QUOTE
    }
}' | sort -u >> "${CSV_OUTPUT_FILE_PATH}"

commits_size=$(wc -c "${CSV_COMMITS_OUTPUT_FILE_PATH}" | awk '{print $1}')
commits_lines=$(wc -l "${CSV_COMMITS_OUTPUT_FILE_PATH}" | awk '{print $1}')
echo "createGitLogData: File ${CSV_COMMITS_OUTPUT_FILE_PATH} with ${commits_size} bytes and ${commits_lines} lines created."

files_size=$(wc -c "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
files_lines=$(wc -l "${CSV_OUTPUT_FILE_PATH}" | awk '{print $1}')
echo "createGitLogData: File ${CSV_OUTPUT_FILE_PATH} with ${files_size} bytes and ${files_lines} lines created."
