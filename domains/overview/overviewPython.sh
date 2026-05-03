#!/usr/bin/env bash

# Generates overview charts as SVG files by executing overviewCharts.py.
# Reads data directly from Neo4j. If no CSV files are present yet, it automatically
# runs overviewCsv.sh first to ensure the data was queried and empty files cleaned up.
# The results will be written into the sub directory reports/overview/.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "overviewCsv.sh" is called automatically if no CSV files are present
# (e.g. when running '--report Python' standalone). When running '--report All',
# the CSV step has already run via CsvReports.sh, so no duplicate work is done.
# If no data is present in Neo4j, this script exits cleanly without generating charts.

# Requires overviewCharts.py

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/overview" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "overviewPython: OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${OVERVIEW_SCRIPT_DIR}/../../scripts"}

# Function to display script usage
usage() {
    echo "Usage: $0 [--verbose] [--help]" >&2
    echo "" >&2
    echo "Generates overview charts as SVG files from Neo4j data." >&2
    echo "" >&2
    echo "Flags:" >&2
    echo "  --verbose  Enable detailed logging" >&2
    echo "  --help     Print this usage message and exit" >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REPORTS_DIRECTORY       Output directory (default: reports)" >&2
    echo "  NEO4J_INITIAL_PASSWORD  Neo4j password (required by overviewCharts.py)" >&2
}

# Default values
verbose_mode="" # either "" or "--verbose"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --verbose)
            verbose_mode="--verbose"
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "overviewPython: Error: Unknown option: $1" >&2
            usage
            exit 1
            ;;
    esac
    shift
done

# Report directory
REPORT_NAME="overview"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "overviewPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting overview chart generation..."

# If no CSV files are present, run overviewCsv.sh first so this report type is self-contained.
# When running '--report All', CsvReports.sh already ran, so this becomes a no-op.
csv_file_count=$(find "${FULL_REPORT_DIRECTORY}" -maxdepth 1 -name "*.csv" | wc -l)
if [[ "${csv_file_count}" -eq 0 ]]; then
    echo "overviewPython: No CSV files found — running overviewCsv.sh first."
    # SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${OVERVIEW_SCRIPT_DIR}/overviewCsv.sh"
fi

# Run the Python chart generator
python "${OVERVIEW_SCRIPT_DIR}/overviewCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verbose_mode}

# Clean-up empty report files
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "overviewPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
