#!/usr/bin/env bash

# Executes selected "Artifact_Dependencies" Cypher queries for GraphViz visualization.
# It contains lists of dependencies across artifacts and their build levels (topologically sorted).
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv, dot and svg files) will be written into the sub directory reports/artifact-dependencies-visualization.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "ArtifactDependenciesVisualization: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "ArtifactDependenciesVisualization SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization
echo "ArtifactDependenciesVisualization VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "ArtifactDependenciesVisualization CYPHER_DIR=${CYPHER_DIR}"

if ! command -v "npx" &> /dev/null ; then
    echo "ArtifactDependenciesVisualization: Error: Command npx (run npm locally) not found. It's needed for Graph visualization with GraphViz." >&2
    exit 1
fi

# Define functions to execute cypher queries from within a given file
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create report directory
REPORT_NAME="artifact-dependencies-visualization"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Local Constants
ARTIFACT_DEPENDENCIES_CYPHER_DIR="${CYPHER_DIR}/Artifact_Dependencies"

# Preparation: Set number of packages and types per artifact
reportName="${FULL_REPORT_DIRECTORY}/ArtifactBuildLevels"
echo "ArtifactDependenciesVisualization reportName=${reportName}"
execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifact_build_levels_for_graphviz.cypher" > "${reportName}.csv"
source "${VISUALIZATION_SCRIPTS_DIR}/convertQueryResultCsvToGraphVizDotFile.sh" --filename "${reportName}.csv"

# Run GraphViz command line interface (CLI) wrapped utilizing WASM (WebAssembly) 
# to convert the DOT file to SVG operating system independently.
npx --yes @hpcc-js/wasm-graphviz-cli@1.2.6 -T svg "${reportName}.gv" > "${reportName}.svg"

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"