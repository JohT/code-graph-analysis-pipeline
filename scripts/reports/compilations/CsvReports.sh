#!/usr/bin/env bash

# Runs all CSV report scripts (no Python and Chromium required).
# It only consideres scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.

# Requires reports/*.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "CsvReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
echo "CsvReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Run all report scripts
for report_script_file in "${REPORTS_SCRIPT_DIR}"/*Csv.sh; do 
    echo "CsvReports: Starting ${report_script_file}..."; 
    source "${report_script_file}"
done
