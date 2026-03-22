#!/usr/bin/env bash

# Creates a Markdown report summarising all external dependency analysis results.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/external-dependencies.
# Dynamically triggered by "MarkdownReports.sh" via "externalDependenciesMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that either "externalDependenciesCsv.sh" or "externalDependenciesPython.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/external-dependencies/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
EXTERNAL_DEPENDENCIES_SUMMARY_DIR=${EXTERNAL_DEPENDENCIES_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
#echo "externalDependenciesSummary: EXTERNAL_DEPENDENCIES_SUMMARY_DIR=${EXTERNAL_DEPENDENCIES_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${EXTERNAL_DEPENDENCIES_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Cypher query directory within this domain
EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR=${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR:-"${EXTERNAL_DEPENDENCIES_SUMMARY_DIR}/../queries"}

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

external_dependencies_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"External Dependencies Report\""
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

# Emits a Markdown image reference for every SVG matching the given glob pattern, sorted.
include_svgs_matching() {
    local pattern="${1}"
    find "${FULL_REPORT_DIRECTORY}" -maxdepth 1 -type f -name "${pattern}" | sort | while read -r svg_file; do
        local chart_filename
        chart_filename=$(basename -- "${svg_file}")
        local chart_label="${chart_filename%.*}"
        echo ""
        echo "![${chart_label}](./${chart_filename})"
    done
}

# ── Report assembly ───────────────────────────────────────────────────────────

assemble_external_dependencies_report() {
    echo "externalDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    external_dependencies_front_matter > "${report_include_directory}/ExternalDependenciesReportFrontMatter.md"

    # -- Java: top external packages by caller types -----------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_overall.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_package_usage_overall.md"

    # -- Java: second-level package grouping (top 20) ---------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_second_level_package_usage_overall.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_second_level_package_usage_overall.md"

    # -- Java: most spread external packages ------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_spread.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_package_usage_spread.md"

    # -- Java: external package usage per artifact (sorted) ---------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_sorted_top.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_package_usage_per_artifact_sorted_top.md"

    # -- Java: aggregated external package usage per artifact -------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_package_usage_per_artifact_package_aggregated.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_package_usage_per_artifact_package_aggregated.md"

    # -- TypeScript: top external modules ---------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_overall_for_Typescript.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_module_usage_overall_for_Typescript.md"

    # -- TypeScript: top external namespaces ------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_namespace_usage_overall_for_Typescript.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_namespace_usage_overall_for_Typescript.md"

    # -- TypeScript: module spread ----------------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_spread_for_Typescript.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_module_usage_spread_for_Typescript.md"

    # -- TypeScript: external module usage per internal module (sorted) ---
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/External_module_usage_per_internal_module_sorted_for_Typescript.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/External_module_usage_per_internal_module_sorted_for_Typescript.md"

    # -- Maven POM declared dependencies -----------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Maven_POMs_and_their_declared_dependencies.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/Maven_POM_dependencies.md"

    # -- Package.json dependency occurrence --------------------------------
    execute_cypher "${EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR}/Package_json_dependencies_occurrence.cypher" \
        --output-markdown-table \
        > "${report_include_directory}/Package_json_dependencies_occurrence.md"

    # -- Inline SVG chart references (Java) --------------------------------
    {
        include_svgs_matching "Java_Top_external_packages_by_types_above_threshold.svg"
        include_svgs_matching "Java_Top_external_packages_by_types_others_drilldown.svg"
        include_svgs_matching "Java_Top_external_packages_by_packages_above_threshold.svg"
        include_svgs_matching "Java_Top_external_packages_by_packages_others_drilldown.svg"
        include_svgs_matching "Java_Top_second_level_packages_by_types_above_threshold.svg"
        include_svgs_matching "Java_Top_second_level_packages_by_packages_above_threshold.svg"
        include_svgs_matching "Java_Most_spread_packages_by_types_above_threshold.svg"
        include_svgs_matching "Java_Most_spread_packages_by_packages_above_threshold.svg"
        include_svgs_matching "Java_Most_spread_second_level_packages_by_types_above_threshold.svg"
        include_svgs_matching "Java_Most_spread_second_level_packages_by_packages_above_threshold.svg"
        include_svgs_matching "Java_External_package_usage_per_artifact_stacked.svg"
        include_svgs_matching "Java_External_second_level_package_usage_per_artifact_stacked.svg"
        include_svgs_matching "Java_External_package_usage_max_internal_packages_percent.svg"
        include_svgs_matching "Java_External_package_usage_median_internal_packages_percent.svg"
    } > "${report_include_directory}/JavaExternalDependencyCharts.md"

    # -- Inline SVG chart references (TypeScript) ---------------------------
    {
        include_svgs_matching "Typescript_Top_external_modules_by_elements_above_threshold.svg"
        include_svgs_matching "Typescript_Top_external_modules_by_elements_others_drilldown.svg"
        include_svgs_matching "Typescript_Top_external_modules_by_modules_above_threshold.svg"
        include_svgs_matching "Typescript_Top_external_namespaces_by_elements_above_threshold.svg"
        include_svgs_matching "Typescript_Top_external_namespaces_by_modules_above_threshold.svg"
        include_svgs_matching "Typescript_Most_spread_modules_by_declarations_above_threshold.svg"
        include_svgs_matching "Typescript_Most_spread_modules_by_modules_above_threshold.svg"
        include_svgs_matching "Typescript_Most_spread_namespaces_by_declarations_above_threshold.svg"
        include_svgs_matching "Typescript_Most_spread_namespaces_by_modules_above_threshold.svg"
    } > "${report_include_directory}/TypescriptExternalDependencyCharts.md"

    # -- Remove empty Markdown includes ------------------------------------
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes --------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${EXTERNAL_DEPENDENCIES_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/external_dependencies_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "externalDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="external-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_external_dependencies_report
