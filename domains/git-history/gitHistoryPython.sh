#!/usr/bin/env bash

# Generates git history charts as SVG files using Python.
# If the required CSV data files are not yet present, it automatically runs "gitHistoryCsv.sh" first.
# The results will be written into the sub directory reports/git-history.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "gitHistoryCsv.sh" is called automatically if the CSV files are not yet present
# (e.g. when running '--report Python' standalone). When running '--report All', the CSV step
# has already run via CsvReports.sh, so no duplicate work is done.
# If no git history data is present (report directory missing), this script exits cleanly.

# Requires gitHistoryCharts.py

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/git-history" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GIT_HISTORY_SCRIPT_DIR=${GIT_HISTORY_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "gitHistoryPython: GIT_HISTORY_SCRIPT_DIR=${GIT_HISTORY_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${GIT_HISTORY_SCRIPT_DIR}/../../scripts"}

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
      echo -e "${COLOR_ERROR}gitHistoryPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Report directory
REPORT_NAME="git-history"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "gitHistoryPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting git history chart generation..."

# If the primary CSV is missing, generate CSVs now so this report type is self-contained.
# When running '--report All', CsvReports.sh already ran, so this is a no-op in that case.
PRIMARY_CSV="${FULL_REPORT_DIRECTORY}/List_git_files_with_commit_statistics_by_author.csv"
if [ ! -f "${PRIMARY_CSV}" ]; then
    echo "gitHistoryPython: Primary CSV not found — running gitHistoryCsv.sh first to generate CSV data."
    source "${GIT_HISTORY_SCRIPT_DIR}/gitHistoryCsv.sh"
fi

time python "${GIT_HISTORY_SCRIPT_DIR}/gitHistoryCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "gitHistoryPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
