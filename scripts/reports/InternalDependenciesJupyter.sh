#!/usr/bin/env bash

# Creates the "internal-dependencies" report (ipynb, md, pdf) based on the Jupyter Notebook "InternalDependencies.ipynb".
# It contains lists of e.g. cyclic dependencies, dependencies that are only used by a few packages,
# classes that are used by many different packages and some more.

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "InternalDependenciesJupyter: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."}
echo "InternalDependenciesJupyter: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"}
echo "InternalDependenciesJupyter: JUPYTER_NOTEBOOK_DIRECTORY=$JUPYTER_NOTEBOOK_DIRECTORY"

# Create report directory
REPORT_NAME="internal-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Execute and convert the Jupyter Notebook "InternalDependencies.ipynb" within the given reports directory
(cd "${FULL_REPORT_DIRECTORY}" && exec ${SCRIPTS_DIR}/executeJupyterNotebook.sh ${JUPYTER_NOTEBOOK_DIRECTORY}/InternalDependencies.ipynb) || exit 1