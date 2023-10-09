#!/usr/bin/env bash

# Creates the "overview" report (ipynb, md, pdf) based on the Jupyter Notebook "Overview.ipynb".
# It contains a basic overview on how many Classes, Interfaces, Enums and Annotations earch artifact contains,
# how they relate to each other, distribution of Methods and their effective lines of code
# and how the cyclomatic complexity is distributed across all Methods per artifact.

# Requires executeJupyterNotebook.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "OverviewJupyter: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "OverviewJupyter: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "OverviewJupyter: JUPYTER_NOTEBOOK_DIRECTORY=$JUPYTER_NOTEBOOK_DIRECTORY"

# Create report directory
REPORT_NAME="external-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Execute and convert the following Jupyter Notebook within the given reports directory
(cd "${FULL_REPORT_DIRECTORY}" && exec ${SCRIPTS_DIR}/executeJupyterNotebook.sh ${JUPYTER_NOTEBOOK_DIRECTORY}/ExternalDependencies.ipynb)