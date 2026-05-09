#!/usr/bin/env bash

# Executes all Cypher queries for cyclic dependency analysis across Java packages, Java artifacts, and TypeScript modules.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/cyclic-dependencies.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "cyclicDependenciesCsv: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Cypher query directory within this domain (flat — the domain IS cyclic-dependencies)
CYCLIC_DEPS_CYPHER_DIR="${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/queries"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create main report directory and abstraction-level subdirectories
REPORT_NAME="cyclic-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Artifact"
mkdir -p "${FULL_REPORT_DIRECTORY}/Java_Package"
mkdir -p "${FULL_REPORT_DIRECTORY}/Typescript_Module"

# ── Java Cyclic Dependencies ──────────────────────────────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic dependencies for Java..."

execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown_Backward_Only.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Java_Artifact/CyclicArtifactDependenciesUnwinded.csv"

# ── TypeScript Cyclic Dependencies ────────────────────────────────────────────

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing cyclic dependencies for TypeScript..."

execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_for_Typescript.csv"
execute_cypher "${CYCLIC_DEPS_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher" \
    > "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv"

# Clean up empty CSV files (when no data exists for an abstraction level)
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Artifact"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Java_Package"
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}/Typescript_Module"

echo "cyclicDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
