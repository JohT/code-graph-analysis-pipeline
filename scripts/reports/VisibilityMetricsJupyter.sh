#!/usr/bin/env bash

# Creates the "visibility-metrics" report (ipynb, md, pdf) based on the Jupyter Notebook "VisibilityMetrics.ipynb".
# It contains lists of how many components are visible everywhere in comparison to all (including internal) components.

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "VisibilityMetricsJupyter: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "VisibilityMetricsJupyter: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"}
echo "VisibilityMetricsJupyter: JUPYTER_NOTEBOOK_DIRECTORY=$JUPYTER_NOTEBOOK_DIRECTORY"

# Create report directory
REPORT_NAME="visibility-metrics"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Execute and convert the Jupyter Notebook "VisibilityMetrics.ipynb" within the given reports directory
(cd "${FULL_REPORT_DIRECTORY}" && exec ${SCRIPTS_DIR}/executeJupyterNotebook.sh ${JUPYTER_NOTEBOOK_DIRECTORY}/VisibilityMetrics.ipynb) || exit 1