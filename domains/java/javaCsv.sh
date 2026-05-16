#!/usr/bin/env bash

# Executes Java code quality and method metrics Cypher queries to produce CSV reports.
# It covers reflection usage, deprecated element usage, annotated code elements,
# web framework annotations (Spring, Jakarta EE REST), and method line count metrics.
# The results will be written into the sub directory reports/java.
# Dynamically triggered by "CsvReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "cypher/General_Enrichment/Add_file_name_and_extension.cypher" must have run
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
echo "javaCsv: JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR}"

# Get the "scripts" directory by navigating two levels up from this domain directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${JAVA_SCRIPT_DIR}/../../scripts"}

# Cypher query directories within this domain
JAVA_CODE_QUALITY_CYPHER_DIR="${JAVA_SCRIPT_DIR}/queries/java-code-quality"
METHOD_METRICS_CYPHER_DIR="${JAVA_SCRIPT_DIR}/queries/method-metrics"

# Define functions to execute a Cypher query from within a given file like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Create main report directory
REPORT_NAME="java"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

echo "javaCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing Java code quality and method metrics..."

# ── Reflection usage ──────────────────────────────────────────────────────────

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_Reflection_usage.cypher" \
    > "${FULL_REPORT_DIRECTORY}/ReflectionUsage.csv"

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_Reflection_usage_detailed.cypher" \
    > "${FULL_REPORT_DIRECTORY}/ReflectionUsageDetailed.csv"

# ── Deprecated element usage ──────────────────────────────────────────────────

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_deprecated_element_usage.cypher" \
    > "${FULL_REPORT_DIRECTORY}/DeprecatedElementUsage.csv"

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_deprecated_element_usage_detailed.cypher" \
    > "${FULL_REPORT_DIRECTORY}/DeprecatedElementUsageDetailed.csv"

# ── Annotated code elements ───────────────────────────────────────────────────

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Annotated_code_elements.cypher" \
    > "${FULL_REPORT_DIRECTORY}/AnnotatedCodeElements.csv"

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Annotated_code_elements_per_artifact.cypher" \
    > "${FULL_REPORT_DIRECTORY}/AnnotatedCodeElementsPerArtifact.csv"

# ── Web framework annotations ─────────────────────────────────────────────────

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/Spring_Web_Request_Annotations.cypher" \
    > "${FULL_REPORT_DIRECTORY}/SpringWebRequestAnnotations.csv"

execute_cypher "${JAVA_CODE_QUALITY_CYPHER_DIR}/JakartaEE_REST_Annotations.cypher" \
    > "${FULL_REPORT_DIRECTORY}/JakartaEE_REST_Annotations.csv"

# ── Method metrics ────────────────────────────────────────────────────────────

execute_cypher "${METHOD_METRICS_CYPHER_DIR}/Effective_Method_Line_Count_Distribution.cypher" \
    > "${FULL_REPORT_DIRECTORY}/EffectiveMethodLineCountDistribution.csv"

execute_cypher "${METHOD_METRICS_CYPHER_DIR}/Cyclomatic_Method_Complexity_Distribution.cypher" \
    > "${FULL_REPORT_DIRECTORY}/CyclomaticMethodComplexityDistribution.csv"

execute_cypher "${METHOD_METRICS_CYPHER_DIR}/Effective_lines_of_method_code_per_type.cypher" \
    > "${FULL_REPORT_DIRECTORY}/EffectiveLinesOfMethodCodePerType.csv"

execute_cypher "${METHOD_METRICS_CYPHER_DIR}/Effective_lines_of_method_code_per_package.cypher" \
    > "${FULL_REPORT_DIRECTORY}/EffectiveLinesOfMethodCodePerPackage.csv"

# ── Cleanup ───────────────────────────────────────────────────────────────────

# Clean-up after report generation. Empty reports will be deleted.
# If all queries returned empty results (no Java artifacts), the report directory will be removed entirely.
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "javaCsv: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
