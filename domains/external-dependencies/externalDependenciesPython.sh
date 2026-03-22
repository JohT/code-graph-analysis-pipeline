#!/usr/bin/env bash

# Generates external dependency charts as SVG files using Python.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/external-dependencies.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "externalDependenciesCsv.sh" is required to run prior to this script
# so that ExternalType and ExternalAnnotation labels exist in the graph.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/external-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
EXTERNAL_DEPENDENCIES_SCRIPT_DIR=${EXTERNAL_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "externalDependenciesPython: EXTERNAL_DEPENDENCIES_SCRIPT_DIR=${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Function to display script usage
usage() {
  echo -e "${COLOR_ERROR}" >&2
  echo "Usage: $0 [--verbose]" >&2
  echo -e "${COLOR_DEFAULT}" >&2
  exit 1
}

# Default values
verboseMode="" # either "" or "--verbose"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case ${key} in
    --verbose)
      verboseMode="--verbose"
      ;;
    *)
      echo -e "${COLOR_ERROR}externalDependenciesPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="external-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "externalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting external dependencies Python chart generation..."

# -- Java Charts -----------------------------------------------------------
echo "externalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Generating Java charts..."
time python "${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/externalDependencyCharts.py" \
    --language Java \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# -- TypeScript Charts -----------------------------------------------------
echo "externalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Generating TypeScript charts..."
time python "${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/externalDependencyCharts.py" \
    --language Typescript \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "externalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
