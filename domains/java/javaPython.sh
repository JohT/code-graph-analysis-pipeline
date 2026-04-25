#!/usr/bin/env bash

# Generates Java analysis charts as SVG files using Python.
# If the required CSV data files are not yet present, it automatically runs "javaCsv.sh"
# and "artifactDependenciesCsv.sh" first.
# The results will be written into the sub directory reports/java.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "javaCsv.sh" and "artifactDependenciesCsv.sh" are called automatically if the CSV files
# are not yet present (e.g. when running '--report Python' standalone). When running '--report All',
# the CSV step has already run via CsvReports.sh, so no duplicate work is done.
# If no Java data is present (report directory missing), this script exits cleanly.

# Requires javaCharts.py

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/java" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "javaPython: JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${JAVA_SCRIPT_DIR}/../../scripts"}

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
      echo -e "${COLOR_ERROR}javaPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Report directory
REPORT_NAME="java"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "javaPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting Java chart generation..."

# If the primary CSV is missing, generate CSVs now so this report type is self-contained.
# When running '--report All', CsvReports.sh already ran, so this is a no-op in that case.
PRIMARY_CSV="${FULL_REPORT_DIRECTORY}/AnnotatedCodeElements.csv"
if [ ! -f "${PRIMARY_CSV}" ]; then
    echo "javaPython: Primary CSV not found — running javaCsv.sh first to generate CSV data."
    # SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${JAVA_SCRIPT_DIR}/javaCsv.sh"
fi

# Run artifact dependencies CSV if not yet present.
ARTIFACT_PRIMARY_CSV="${FULL_REPORT_DIRECTORY}/MostUsedDependenciesAcrossArtifacts.csv"
if [ ! -f "${ARTIFACT_PRIMARY_CSV}" ]; then
    echo "javaPython: Artifact dependencies CSV not found — running artifactDependenciesCsv.sh first."
    # SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${JAVA_SCRIPT_DIR}/artifactDependenciesCsv.sh"
fi

# Recreate report directory to ensure a clean state for the generated charts.
# If there is no data, the clean-up step at the end will remove the empty directory, so this is not a problem.
mkdir -p "${FULL_REPORT_DIRECTORY}"

time python "${JAVA_SCRIPT_DIR}/javaCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# Clean-up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "javaPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
