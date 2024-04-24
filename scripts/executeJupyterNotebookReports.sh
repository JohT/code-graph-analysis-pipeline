#!/usr/bin/env bash

# Executes the Jupyter Notebook given with the command line option --jupyterNotebook and creates a report directory for the results (ipynb, md, pdf)..

# Requires executeJupyterNotebook.sh, cleanupAfterReportGeneration.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Function to display script usage
usage() {
  echo "Usage:   $0 --jupyterNotebook nameOfTheJupyterNotebook [--reportName nameOfTheReportsDirectory]"
  echo "Example: $0 --jupyterNotebook ArtifactDependencies.ipynb"
  exit 1
}

camel_to_kebab_case_file_name() {
    basename "${1%.*}" | sed -r 's/([a-z0-9])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]'
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
      echo "executeJupyterNotebookReports: Error: Unknown option: ${commandLineOption}"
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
  echo "executeJupyterNotebookReports: reportName defaults to ${reportName}"
fi

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "executeJupyterNotebookReports: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-"${SCRIPTS_DIR}/reports"} # Repository directory containing the report scripts
echo "executeJupyterNotebookReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "executeJupyterNotebookReports: JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY}"

# Create report directory
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${reportName}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Execute and convert the given Jupyter Notebook within the given reports directory
(cd "${FULL_REPORT_DIRECTORY}" && exec "${SCRIPTS_DIR}/executeJupyterNotebook.sh" "${JUPYTER_NOTEBOOK_DIRECTORY}/${jupyterNotebook}")

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"