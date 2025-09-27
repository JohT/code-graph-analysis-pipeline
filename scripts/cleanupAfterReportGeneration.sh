#!/usr/bin/env bash

# Cleans up after report generation. This includes deleting empty files or in case no file is left deleting the report folder.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Read the first input argument containing the name of the cypher file
if [ "$#" -ne 1 ]; then
  echo "cleanupReports: Usage: $0 <report directory>" >&2
fi

# Check the first input argument to be a valid file
if [ ! -d "$1" ] ; then
    echo "cleanupReports: $1 directory not found" >&2
    exit 1
fi

report_directory=$1
echo "cleanupReports: report_directory=${report_directory}"

# Find all comma separated values (CSV) files in the report directory
# and delete the ones that contain only one line (header) or less.
find "${report_directory}" -type f -name "*.csv" | sort | while read -r report_file; do
    number_of_lines=$(wc -l < "${report_file}" | awk '{print $1}')
    if [[ "${number_of_lines}" -le 1 ]]; then
        echo "cleanupReports: deleting empty (${number_of_lines} lines) report file ${report_file}"
        rm -f "${report_file}"
    fi
done

# Find all Markdown (md) files in the report directory
# and delete the ones that contain less than 3 lines.
find "${report_directory}" -type f -name "*.md" | sort | while read -r report_file; do
    number_of_lines=$(wc -l < "${report_file}" | awk '{print $1}')
    if [[ "${number_of_lines}" -le 2 ]]; then
        echo "cleanupReports: deleting empty (${number_of_lines} lines) report file ${report_file}"
        rm -f "${report_file}"
    fi
done

# Delete reports directory if its empty
number_files_in_report_directory=$( find "${report_directory}" -type f | wc -l | awk '{print $1}' )
if [[ "${number_files_in_report_directory}" -lt 1 ]]; then
    echo "cleanupReports: deleting empty (${number_files_in_report_directory} files) directory ${report_directory}"
    rm -rf "${report_directory}"
fi