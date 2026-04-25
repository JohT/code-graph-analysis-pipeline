#!/usr/bin/env bash

# Executes artifact dependency Cypher queries to produce CSV reports for Java artifact analysis.
# It covers incoming and outgoing artifact dependencies, most used internal dependencies,
# dependency spread, and duplicate package detection across artifacts.
# The results will be written into the sub directory reports/java.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "cypher/General_Enrichment/Add_file_name and_extension.cypher" must have run
# before this script to ensure the name and extension properties are set on File nodes.
# If no Java artifacts are present, all queries return empty results and
# cleanupAfterReportGeneration.sh will remove the empty CSV files — no report directory is created.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail

# Overrideable constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/java" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "artifactDependenciesCsv: JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${JAVA_SCRIPT_DIR}/../../scripts"}

# Cypher query directories within this domain
ENRICHMENT_CYPHER_DIR="${JAVA_SCRIPT_DIR}/queries/enrichment"
ARTIFACT_DEPENDENCIES_CYPHER_DIR="${JAVA_SCRIPT_DIR}/queries/artifact-dependencies"

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create main report directory
REPORT_NAME="java"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "artifactDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing Java artifact dependencies..."

# ── Enrichment ────────────────────────────────────────────────────────────────

# Set numberOfPackages and numberOfTypes counts on each Java artifact.
# These properties are used as context in the artifact dependency analysis.
execute_cypher "${ENRICHMENT_CYPHER_DIR}/Set_number_of_Java_packages_and_types_on_artifacts.cypher"

# Set the parsed Maven version string on each Java artifact where possible.
execute_cypher "${ENRICHMENT_CYPHER_DIR}/Set_maven_artifact_version.cypher"

# ── Incoming and outgoing artifact dependencies ───────────────────────────────

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Incoming_Java_Artifact_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/IncomingDependencies.csv"

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Outgoing_Java_Artifact_Dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/OutgoingDependencies.csv"

# ── Most used internal dependencies ──────────────────────────────────────────

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Most_used_internal_dependencies_across_artifacts.cypher" \
    > "${FULL_REPORT_DIRECTORY}/MostUsedDependenciesAcrossArtifacts.csv"

# ── Dependency relationships ──────────────────────────────────────────────────

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_dependencies_to_other_artifacts.cypher" \
    > "${FULL_REPORT_DIRECTORY}/DependenciesAcrossArtifacts.csv"

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_duplicate_packages.cypher" \
    > "${FULL_REPORT_DIRECTORY}/DuplicatePackageNamesAcrossArtifacts.csv"

# ── Dependency usage spread ───────────────────────────────────────────────────

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependencies.cypher" \
    > "${FULL_REPORT_DIRECTORY}/InternalArtifactUsageSpreadPerDependency.csv"

execute_cypher "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependents.cypher" \
    > "${FULL_REPORT_DIRECTORY}/InternalArtifactUsageSpreadPerDependent.csv"

# ── Cleanup ───────────────────────────────────────────────────────────────────

# Clean-up after report generation. Empty reports will be deleted.
# If all queries returned empty results (no Java artifacts), the report directory will be removed entirely.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "artifactDependenciesCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
