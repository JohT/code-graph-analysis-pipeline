#!/usr/bin/env bash

# Creates the "artifact-dependencies" report (ipynb, md, pdf) based on the Jupyter Notebook "ArtifactDependencies.ipynb".
# It contains the hierarchical artifact dependencies graph

# Requires executeJupyterNotebook.sh, AritfactCommunityCsv.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "ArtifactDependenciesJupyter: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "ArtifactDependenciesJupyter: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "ArtifactDependenciesJupyter: JUPYTER_NOTEBOOK_DIRECTORY=$JUPYTER_NOTEBOOK_DIRECTORY"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "ArtifactDependenciesJupyter CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Local Constants
LEIDEN_CYPHER_DIR="$CYPHER_DIR/Community_Detection_Leiden_for_Artifacts"

# Create report directory
REPORT_NAME="artifact-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Dependency: Assure that artifacts have a Leiden Community Id (written by "AritfactCommunityCsv.sh")
execute_cypher_expect_results "${LEIDEN_CYPHER_DIR}/Community_Detection_8_Check_Leiden_Community_Id.cypher"

# Execute and convert the Jupyter Notebook "ArtifactDependencies.ipynb" within the given reports directory
(cd "${FULL_REPORT_DIRECTORY}" && exec ${SCRIPTS_DIR}/executeJupyterNotebook.sh ${JUPYTER_NOTEBOOK_DIRECTORY}/ArtifactDependencies.ipynb) || exit 1