#!/usr/bin/env bash

# Runs all Jupyter Notebook report scripts.
# It only consideres scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.
# These require phython, conda (e.g. miniconda) as well as several packages.
# For PDF generation chromium is required additionally.
# Therefore these reports will take longer and require more ressources than just plain database queries/procedures.

## Get this "reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
# The following solution should work in most shells but returns the (wrong) path of the caller when using "source" to call.
#REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "$0")" && pwd -P)}
echo "JupyterReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
echo "JupyterReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Run all report scripts
for report_script_file in "${REPORTS_SCRIPT_DIR}"/*Jupyter.sh; do 
    echo "JupyterReports: Starting ${report_script_file}..."; 
    source "${report_script_file}" || exit 1
done
