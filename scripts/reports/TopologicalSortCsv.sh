#!/usr/bin/env bash

# Applies the Topological Sorting algorithm for directed acyclic graphs (DAG) to order code units by their dependencies
# using Graph Data Science Library of Neo4j and creates CSV reports.
# This is useful to get the build order and build levels for modules that depend on each other.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The reports (csv files) will be written into the sub directory reports/topology-csv.
# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "topologicalSortCsv: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "topologicalSortCsv: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "cypher" directory by taking the path of this script and going two directory up and then to "cypher".
CYPHER_DIR=${CYPHER_DIR:-"${REPORTS_SCRIPT_DIR}/../../cypher"}
echo "topologicalSortCsv: CYPHER_DIR=$CYPHER_DIR"

# Define functions to execute a cypher query from within the given file (first and only argument)
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Create report directory
REPORT_NAME="topology-csv"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Apply the algorithm "Topological Sort".
# 
# Required Parameters:
# - dependencies_projection=...
#   Name prefix for the in-memory projection name for dependencies. Example: "package"
# - dependencies_projection_node=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - dependencies_projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
topologicalSort() {
    local TOPOLOGICAL_SORT_DIR="$CYPHER_DIR/Topological_Sort"

    # Update Graph (node properties)
    execute_cypher "${TOPOLOGICAL_SORT_DIR}/Topological_Sort_Write.cypher" "${@}"
    
    # Stream to CSV
    local nodeLabel
    nodeLabel=$( extractQueryParameter "dependencies_projection_node" "${@}" )
    execute_cypher "${TOPOLOGICAL_SORT_DIR}/Topological_Sort_Query.cypher" "${@}" > "${FULL_REPORT_DIRECTORY}/${nodeLabel}_Topological_Sort.csv"
}

# ---------------------------------------------------------------

# Artifact Query Parameters
ARTIFACT_PROJECTION="dependencies_projection=artifact-topology" 
ARTIFACT_NODE="dependencies_projection_node=Artifact" 
ARTIFACT_WEIGHT="dependencies_projection_weight_property=weight" 

# Artifact Topology
echo "topologicalSortCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing artifact dependencies..."
if createDirectedDependencyProjection "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"; then
    time topologicalSort "${ARTIFACT_PROJECTION}" "${ARTIFACT_NODE}" "${ARTIFACT_WEIGHT}"
else
    echo "topologicalSortCsv: No data. Artifact analysis skipped."
fi
# ---------------------------------------------------------------

# Package Query Parameters
PACKAGE_PROJECTION="dependencies_projection=package-topology" 
PACKAGE_NODE="dependencies_projection_node=Package" 
PACKAGE_WEIGHT="dependencies_projection_weight_property=weight25PercentInterfaces" 

# Package Topology
echo "topologicalSortCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing package dependencies..."
if createDirectedDependencyProjection "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"; then
    time topologicalSort "${PACKAGE_PROJECTION}" "${PACKAGE_NODE}" "${PACKAGE_WEIGHT}"
else
    echo "topologicalSortCsv: No data. Package analysis skipped."
fi
# ---------------------------------------------------------------

# Type Query Parameters
TYPE_PROJECTION="dependencies_projection=type-topology" 
TYPE_NODE="dependencies_projection_node=Type" 
TYPE_WEIGHT="dependencies_projection_weight_property=weight" 

# Type Topology
echo "topologicalSortCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing type dependencies..."
if createDirectedJavaTypeDependencyProjection "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"; then
    time topologicalSort "${TYPE_PROJECTION}" "${TYPE_NODE}" "${TYPE_WEIGHT}"
else
    echo "topologicalSortCsv: No data. Type analysis skipped."
fi
# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "topologicalSortCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."