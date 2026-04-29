#!/usr/bin/env bash

# Generates 2D UMAP scatter plots of node embeddings stored in Neo4j as SVG files.
# Reads embedding vectors directly from Neo4j — no CSV files required.
# If the required embedding properties are not yet written to the graph, it automatically
# runs "nodeEmbeddingsCsv.sh" first to generate them.
# The results will be written into the sub directory reports/node-embeddings/.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "nodeEmbeddingsCsv.sh" is called automatically if no embedding property CSV files
# are present (e.g. when running '--report Python' standalone). When running '--report All',
# the CSV step has already run via CsvReports.sh, so no duplicate work is done.
# If no embedding data is present in Neo4j, this script exits cleanly without generating charts.

# Requires nodeEmbeddingsCharts.py

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/node-embeddings" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
NODE_EMBEDDINGS_SCRIPT_DIR=${NODE_EMBEDDINGS_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "nodeEmbeddingsPython: NODE_EMBEDDINGS_SCRIPT_DIR=${NODE_EMBEDDINGS_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${NODE_EMBEDDINGS_SCRIPT_DIR}/../../scripts"}

# Function to display script usage
usage() {
    echo "Usage: $0 [--verbose] [--help]" >&2
    echo "" >&2
    echo "Generates 2D UMAP scatter plots of node embeddings stored in Neo4j." >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REPORTS_DIRECTORY       Output directory (default: reports)" >&2
    echo "  NEO4J_INITIAL_PASSWORD  Neo4j password (required by nodeEmbeddingsCharts.py)" >&2
    exit 1
}

# Default values
verboseMode="" # either "" or "--verbose"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --verbose)
            verboseMode="--verbose"
            ;;
        --help)
            usage
            ;;
        *)
            echo "nodeEmbeddingsPython: Error: Unknown option: $1" >&2
            usage
            ;;
    esac
    shift
done

# Report directory
REPORT_NAME="node-embeddings"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "nodeEmbeddingsPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting node-embeddings chart generation..."

# If the primary CSV file is missing, run nodeEmbeddingsCsv.sh first so this report type is self-contained.
# When running '--report All', CsvReports.sh already ran, so this is a no-op in that case.
# nodeEmbeddingsCharts.py reads directly from Neo4j, but the CSV presence indicates the GDS step ran.
csvFileCount=$(find "${FULL_REPORT_DIRECTORY}" -maxdepth 1 -name "*.csv" | wc -l)
if [ "${csvFileCount}" -eq 0 ]; then
    echo "nodeEmbeddingsPython: Primary CSV not found — running nodeEmbeddingsCsv.sh first to write embedding properties."
    # SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${NODE_EMBEDDINGS_SCRIPT_DIR}/nodeEmbeddingsCsv.sh"
fi

# Recreate report directory to ensure a clean state for the generated charts.
# If there is no data, the clean-up step at the end will remove the empty directory.
mkdir -p "${FULL_REPORT_DIRECTORY}"

time python "${NODE_EMBEDDINGS_SCRIPT_DIR}/nodeEmbeddingsCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verboseMode}

# Clean-up after report generation. Empty reports will be deleted.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "nodeEmbeddingsPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
