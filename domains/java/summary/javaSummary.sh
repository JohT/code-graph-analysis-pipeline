#!/usr/bin/env bash

# Creates a Markdown report summarising all Java code quality, method metrics, and artifact dependency analysis results.
# It requires an already running Neo4j graph database with already imported Java code.
# The results will be written into the sub directory reports/java.
# Dynamically triggered by "MarkdownReports.sh" via "javaMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "javaCsv.sh" and "artifactDependenciesCsv.sh" are required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/java/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
JAVA_SUMMARY_DIR=${JAVA_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "javaSummary: JAVA_SUMMARY_DIR=${JAVA_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${JAVA_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Cypher query directories for Java queries within this domain
JAVA_CODE_QUALITY_CYPHER_DIR="${JAVA_SUMMARY_DIR}/../queries/java-code-quality"
METHOD_METRICS_CYPHER_DIR="${JAVA_SUMMARY_DIR}/../queries/method-metrics"
ARTIFACT_DEPENDENCIES_CYPHER_DIR="${JAVA_SUMMARY_DIR}/../queries/artifact-dependencies"

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
# SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

java_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Java Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# ── SVG chart reference helpers ───────────────────────────────────────────────

# Emits a Markdown image reference for a chart SVG if the file exists, otherwise nothing.
include_svg_if_exists() {
    local svg_file="${FULL_REPORT_DIRECTORY}/${1}"
    local alt_text="${2}"
    if [ -f "${svg_file}" ]; then
        echo ""
        echo "![${alt_text}](./${1})"
        echo ""
    fi
}

# Emits Markdown image references for every SVG matching the given glob pattern, sorted.
include_svgs_matching() {
    local base_dir="${1}"
    local pattern="${2}"
    [ -d "${base_dir}" ] || return 0 # if the base directory doesn't exist, just return without emitting anything
    find "${base_dir}" -maxdepth 1 -type f -name "${pattern}" | sort | while read -r svg_file; do
        local chart_filename
        chart_filename=$(basename -- "${svg_file}")
        local chart_label="${chart_filename%.*}"
        echo ""
        echo "![${chart_label}](./${chart_filename})"
    done
}

# ── Report assembly helpers ───────────────────────────────────────────────────

# Limits a piped Markdown table to at most 10 data rows (header + separator kept in full).
limit_markdown_table() {
    awk '/^\|[| :-]*-[| :-]*\|/ { sep=1; print; next } !sep { print } sep && ++rows <= 10 { print }'
}

# Runs a Cypher query and outputs a limited Markdown table to stdout.
# Arguments: <cypher_file> [cypher_params...]
cypher_table() {
    execute_cypher "$@" --output-markdown-table | limit_markdown_table
}

# Appends a CSV download link to stdout if the CSV file exists.
# Arguments: <csv_relative_path>
csv_link() {
    local full_csv="${FULL_REPORT_DIRECTORY}/${1}"
    if [ -f "${full_csv}" ]; then
        echo ""
        echo "[Full data](./${1})"
    fi
}

# ── Report assembly ───────────────────────────────────────────────────────────

assemble_java_report() {
    echo "javaSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    java_front_matter > "${report_include_directory}/JavaReportFrontMatter.md"

    # ── Artifact dependencies ──────────────────────────────────────────────

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Incoming_Java_Artifact_Dependencies.cypher"
        csv_link "IncomingDependencies.csv"
    } > "${report_include_directory}/IncomingDependencies.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Outgoing_Java_Artifact_Dependencies.cypher"
        csv_link "OutgoingDependencies.csv"
    } > "${report_include_directory}/OutgoingDependencies.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Most_used_internal_dependencies_across_artifacts.cypher"
        csv_link "MostUsedDependenciesAcrossArtifacts.csv"
    } > "${report_include_directory}/MostUsedDependenciesAcrossArtifacts.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_dependencies_to_other_artifacts.cypher"
        csv_link "DependenciesAcrossArtifacts.csv"
    } > "${report_include_directory}/DependenciesAcrossArtifacts.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Artifacts_with_duplicate_packages.cypher"
        csv_link "DuplicatePackageNamesAcrossArtifacts.csv"
    } > "${report_include_directory}/DuplicatePackageNamesAcrossArtifacts.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependencies.cypher"
        csv_link "InternalArtifactUsageSpreadPerDependency.csv"
    } > "${report_include_directory}/InternalArtifactUsageSpreadPerDependency.md"

    {
        cypher_table "${ARTIFACT_DEPENDENCIES_CYPHER_DIR}/Usage_and_spread_of_internal_artifact_dependents.cypher"
        csv_link "InternalArtifactUsageSpreadPerDependent.csv"
    } > "${report_include_directory}/InternalArtifactUsageSpreadPerDependent.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "ArtifactDependencies_*.svg"
    } > "${report_include_directory}/ArtifactDependenciesCharts.md"

    # ── Method metrics ─────────────────────────────────────────────────────

    {
        cypher_table "${METHOD_METRICS_CYPHER_DIR}/Effective_Method_Line_Count_Distribution.cypher"
        csv_link "EffectiveMethodLineCountDistribution.csv"
    } > "${report_include_directory}/EffectiveMethodLineCountDistribution.md"

    {
        cypher_table "${METHOD_METRICS_CYPHER_DIR}/Effective_lines_of_method_code_per_type.cypher"
        csv_link "EffectiveLinesOfMethodCodePerType.csv"
    } > "${report_include_directory}/EffectiveLinesOfMethodCodePerType.md"

    {
        cypher_table "${METHOD_METRICS_CYPHER_DIR}/Effective_lines_of_method_code_per_package.cypher"
        csv_link "EffectiveLinesOfMethodCodePerPackage.csv"
    } > "${report_include_directory}/EffectiveLinesOfMethodCodePerPackage.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "MethodMetrics_*.svg"
    } > "${report_include_directory}/MethodMetricsCharts.md"

    # ── Java code quality ──────────────────────────────────────────────────

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_Reflection_usage.cypher"
        csv_link "ReflectionUsage.csv"
    } > "${report_include_directory}/ReflectionUsage.md"

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/Java_deprecated_element_usage.cypher"
        csv_link "DeprecatedElementUsage.csv"
    } > "${report_include_directory}/DeprecatedElementUsage.md"

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/Annotated_code_elements.cypher"
        csv_link "AnnotatedCodeElements.csv"
    } > "${report_include_directory}/AnnotatedCodeElements.md"

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/Annotated_code_elements_per_artifact.cypher"
        csv_link "AnnotatedCodeElementsPerArtifact.csv"
    } > "${report_include_directory}/AnnotatedCodeElementsPerArtifact.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "JavaCodeQuality_*.svg"
    } > "${report_include_directory}/JavaCodeQualityCharts.md"

    # ── Web framework annotations ──────────────────────────────────────────

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/Spring_Web_Request_Annotations.cypher"
        csv_link "SpringWebRequestAnnotations.csv"
    } > "${report_include_directory}/SpringWebRequestAnnotations.md"

    {
        cypher_table "${JAVA_CODE_QUALITY_CYPHER_DIR}/JakartaEE_REST_Annotations.cypher"
        csv_link "JakartaEE_REST_Annotations.csv"
    } > "${report_include_directory}/JakartaEE_REST_Annotations.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}" "WebFrameworks_*.svg"
    } > "${report_include_directory}/WebFrameworksCharts.md"

    # -- Remove empty Markdown includes ------------------------------------
    # SC1091: sourced file is a pipeline-provided utility resolved at runtime via a variable path
    # shellcheck disable=SC1091
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-java-data fallback template --------------------------------
    cp -f "${JAVA_SUMMARY_DIR}/report_no_java_data.template.md" \
        "${report_include_directory}/report_no_java_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${JAVA_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/java_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "javaSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="java"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_java_report
