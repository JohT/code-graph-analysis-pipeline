#!/usr/bin/env bash

# Runs all Jupyter Notebook report scripts.
# It only considers scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.
# These require Python, Conda (e.g. Miniconda) as well as several packages.
# For PDF generation chromium is required additionally.
# Therefore these reports will take longer and require more resources than just plain database queries/procedures.

# Requires executeJupyterNotebookReports.sh, jupyter/*.ipynb

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "JupyterReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
echo "JupyterReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the scripts report path and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${REPORTS_SCRIPT_DIR}")}
echo "JupyterReports: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of the scripts directory, going up one directory and change then into "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "JupyterReports: JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY}"

# Run all report scripts
for jupyter_notebook_file in "${JUPYTER_NOTEBOOK_DIRECTORY}"/*.ipynb; do 
    jupyter_notebook_file=$( basename "${jupyter_notebook_file}")
    echo "JupyterReports: Executing ${jupyter_notebook_file}..."; 
    source "${SCRIPTS_DIR}/executeJupyterNotebookReports.sh" --jupyterNotebook "${jupyter_notebook_file}"
done
