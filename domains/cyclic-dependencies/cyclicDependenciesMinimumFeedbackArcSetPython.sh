#!/usr/bin/env bash

# Runs Minimum Feedback Arc Set analysis for the top 5 Strongly Connected Components
# of Java Packages and SCIP Semantic Index Modules. Writes CSV reports and
# adjacency matrix heatmap SVG files, and generates GraphViz DOT files.
# Automatically ensures Strongly Connected Component data exists in Neo4j before running.
# The results will be written into reports/cyclic-dependencies/{Java_Package,SCIP_Semantic_Index_Module}/.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "cyclicDependenciesCsv.sh" is called automatically for each node type when
# Strongly Connected Component CSV files are absent. When running '--report All', the CSV
# step has already run, so no duplicate work is done.

# Requires minimumFeedbackArcSetCharts.py, cyclicDependenciesStronglyConnectedComponents.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "cyclicDependenciesMinimumFeedbackArcSetPython: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Source Strongly Connected Component functions (runStronglyConnectedComponents, createDirectedDependencyProjection)
# SC1091: sourced domain-local file resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/cyclicDependenciesStronglyConnectedComponents.sh"

usage() {
    echo "Usage: source ${BASH_SOURCE[0]} [--verbose] [--help]" >&2
    echo "" >&2
    echo "Runs Minimum Feedback Arc Set analysis for top Strongly Connected Components." >&2
    echo "" >&2
    echo "Environment variables:" >&2
    echo "  REPORTS_DIRECTORY       Output directory (default: reports)" >&2
    echo "  NEO4J_INITIAL_PASSWORD  Neo4j password (required by minimumFeedbackArcSetCharts.py)" >&2
    exit 1
}

verbose_flag=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --verbose)
            verbose_flag="--verbose"
            ;;
        --help)
            usage
            ;;
        *)
            echo "cyclicDependenciesMinimumFeedbackArcSetPython: Error: Unknown option: $1" >&2
            usage
            ;;
    esac
    shift
done

REPORT_NAME="cyclic-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Package"
mkdir -p "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"

# Projection parameters for Java Packages
JAVA_PACKAGE_PROJECTION="dependencies_projection=java-package-cycles"
JAVA_PACKAGE_NODE="dependencies_projection_node=Package"
JAVA_PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces"

# Projection parameters for SCIP Semantic Index Modules
SCIP_MODULE_PROJECTION="dependencies_projection=scip-module-cycles"
SCIP_MODULE_NODE="dependencies_projection_node=SemanticCodeIndexModule"
SCIP_MODULE_WEIGHT="dependencies_projection_weight_property=referenceCount"

# Ensure Strongly Connected Component data exists for Java Packages.
# When '--report All' already ran the CSV step, the CSV file is present and this is skipped.
if [ ! -f "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_SCC_Overview.csv" ]; then
    echo "cyclicDependenciesMinimumFeedbackArcSetPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Java Package SCC CSV not found — running Strongly Connected Component analysis..."
    if createDirectedDependencyProjection "${JAVA_PACKAGE_PROJECTION}" "${JAVA_PACKAGE_NODE}" "${JAVA_PACKAGE_WEIGHT}"; then
        runStronglyConnectedComponents \
            "${JAVA_PACKAGE_PROJECTION}" "${JAVA_PACKAGE_NODE}" "${JAVA_PACKAGE_WEIGHT}" \
            "scc_report_directory=${FULL_REPORT_DIRECTORY}/Java_Package"
    fi
fi

# Ensure Strongly Connected Component data exists for SCIP Semantic Index Modules.
if [ ! -f "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_SCC_Overview.csv" ]; then
    echo "cyclicDependenciesMinimumFeedbackArcSetPython: $(date +'%Y-%m-%dT%H:%M:%S%z') SCIP Module SCC CSV not found — running Strongly Connected Component analysis..."
    if createDirectedDependencyProjection "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}"; then
        runStronglyConnectedComponents \
            "${SCIP_MODULE_PROJECTION}" "${SCIP_MODULE_NODE}" "${SCIP_MODULE_WEIGHT}" \
            "scc_report_directory=${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"
    fi
fi

echo "cyclicDependenciesMinimumFeedbackArcSetPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting Minimum Feedback Arc Set chart generation..."

time python "${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/minimumFeedbackArcSetCharts.py" \
    --report_directory "${FULL_REPORT_DIRECTORY}" \
    ${verbose_flag}

# Clean up empty report subdirectories after generation
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Package"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module"

echo "cyclicDependenciesMinimumFeedbackArcSetPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
