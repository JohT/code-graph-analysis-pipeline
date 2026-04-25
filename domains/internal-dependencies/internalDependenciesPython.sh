#!/usr/bin/env bash

# Generates path finding charts as SVG files using Python.
# It requires that "internalDependenciesCsv.sh" has already run to produce the CSV data files.
# The results will be written into the sub directory reports/internal-dependencies.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "internalDependenciesCsv.sh" is required to run prior to this script
# so that path finding CSV files exist in the report directory.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/internal-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
INTERNAL_DEPENDENCIES_SCRIPT_DIR=${INTERNAL_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "internalDependenciesPython: INTERNAL_DEPENDENCIES_SCRIPT_DIR=${INTERNAL_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

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
      echo -e "${COLOR_ERROR}internalDependenciesPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Create report directory
REPORT_NAME="internal-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "internalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting path finding chart generation..."

time python "${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/pathFindingCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

echo "internalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting object-oriented design metrics chart generation..."

time python "${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/objectOrientedDesignMetricsCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

echo "internalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting visibility metrics chart generation..."

time python "${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/visibilityMetricsCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

echo "internalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting code names wordcloud generation..."

time python "${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/wordcloudChart.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "internalDependenciesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
