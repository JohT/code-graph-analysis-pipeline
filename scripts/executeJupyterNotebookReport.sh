#!/usr/bin/env bash

# Executes the given Jupyter Notebook and puts all resulting files (ipynb, md, pdf) into an accordingly named directory within the "results" directory.
#
# Command line options:
# --jupyterNotebook: Name of the Jupyter Notebook file including its file extension relative to the "jupyter" directory (required)
# --reportName: nameOfTheReportsDirectory (optional, default = kebab cased name of the Jupyter Notebook file)

# Requires executeQueryFunctions.sh, executeJupyterNotebook.sh, cleanupAfterReportGeneration.sh

# Override-able constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Function to display script usage
usage() {
  echo "Usage:   $0 --jupyterNotebook nameOfTheJupyterNotebook [--reportName nameOfTheReportsDirectory]"
  echo "Example: $0 --jupyterNotebook ArtifactDependencies.ipynb"
  exit 1
}

# Converts the given camel case file name (basename) to kebab case (with dashed in between)
# Parameters:
#  - File name in camel case
camel_to_kebab_case_file_name() {
    basename "${1%.*}" | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]'
}

# Returns the value of the Jupyter Notebook custom metadata property "code_graph_analysis_pipeline_data_validation"
# or an empty string if it doesn't exist.
# Parameters
#  - Jupyter Notebook file name, e.g. ${JUPYTER_NOTEBOOK_DIRECTORY}/${jupyterNotebook}
get_data_validation_from_jupyter_metadata() {
    grep -m1 -o '"code_graph_analysis_pipeline_data_validation":\s*"[^"]*"' "${1}" | cut -d '"' -f 4 || true
}

# Uses "get_data_validation_from_jupyter_metadata" to extract the name of the 
# data validation Cypher query out of the Jupyter Notebook file given as first parameter.
# The equally named Cypher query file is then loaded from the Cypher directory given as second parameter
# and the "Validation" directory in it.
# This Cypher query is then executed. If there is at least one result, then the validation is considered successful.
# 
# Parameters
#  - Jupyter Notebook file name, e.g. ${JUPYTER_NOTEBOOK_DIRECTORY}/${jupyterNotebook}
#  - Cypher query directory, e.g. ${CYPHER_DIR}
validate_data_available() {
  local jupyterNotebookFile="${1}"
  local cypherDirectory="${2}"

  dataValidation=$(get_data_validation_from_jupyter_metadata "${jupyterNotebookFile}")
  if [ -z "${dataValidation}" ] ; then
      echo "executeJupyterNotebookReport: Skipping data validation. Jupyter Notebook ${jupyterNotebookFile} has no 'code_graph_analysis_pipeline_data_validation' metadata property."
      return 0
  fi
  echo "executeJupyterNotebookReport: dataValidation=${dataValidation}"

  local dataValidationCypherQuery="${cypherDirectory}/Validation/${dataValidation}.cypher"
  if [ ! -f "${dataValidationCypherQuery}" ] ; then
    echo "executeJupyterNotebookReport: Error: Validation Cypher Query file ${dataValidationCypherQuery} doesn't exist."
    exit 1
  fi

  echo "executeJupyterNotebookReport: Validating data using Cypher query ${dataValidationCypherQuery} ..."
  local dataValidationResult
  dataValidationResult=$( execute_cypher_http_number_of_lines_in_result "${dataValidationCypherQuery}" )
  if [[ "${dataValidationResult}" -ge 1 ]]; then
    echo "executeJupyterNotebookReport: Validation succeeded."
    true;
  else
    echo "executeJupyterNotebookReport: Validation failed. No data from query ${dataValidationCypherQuery}."
    false;
  fi
}

# Default values
reportName=""
jupyterNotebook=""

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  commandLineOption="${1}"
  case ${commandLineOption} in
    --jupyterNotebook)
      jupyterNotebook="${2}"
      shift
      ;;
    --reportName)
      reportName="${2}"
      shift
      ;;

    *)
      echo "executeJupyterNotebookReport: Error: Unknown option: ${commandLineOption}"
      usage
      ;;
  esac
  shift
done

if [[ -z ${jupyterNotebook} ]]; then
  echo "${USAGE}"
  exit 1
fi

if [[ -z ${reportName} ]]; then
  reportName=$(camel_to_kebab_case_file_name "${jupyterNotebook}")
  echo "executeJupyterNotebookReport: reportName defaults to ${reportName}"
fi

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "executeJupyterNotebookReport: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-"${SCRIPTS_DIR}/reports"} # Repository directory containing the report scripts
echo "executeJupyterNotebookReport: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "executeJupyterNotebookReport: JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${SCRIPTS_DIR}/../cypher"}
echo "executeJupyterNotebookReport CYPHER_DIR=${CYPHER_DIR}"

# Define functions to execute cypher queries from within a given file, like e.g. "get_data_validation_from_jupyter_metadata"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${reportName}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

if validate_data_available "${JUPYTER_NOTEBOOK_DIRECTORY}/${jupyterNotebook}" "${CYPHER_DIR}"; then
  # Execute and convert the given Jupyter Notebook within the given reports directory
  (cd "${FULL_REPORT_DIRECTORY}" && exec "${SCRIPTS_DIR}/executeJupyterNotebook.sh" "${JUPYTER_NOTEBOOK_DIRECTORY}/${jupyterNotebook}")
else
  echo "executeJupyterNotebookReport: Skipping Jupyter Notebook ${jupyterNotebook} because of missing data."
fi


# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"