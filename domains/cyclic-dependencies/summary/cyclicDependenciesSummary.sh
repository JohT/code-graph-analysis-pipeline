#!/usr/bin/env bash

# Creates a Markdown report summarising all cyclic dependency analysis results for Java packages, Java artifacts, and TypeScript modules.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/cyclic-dependencies.
# Dynamically triggered by "MarkdownReports.sh" via "cyclicDependenciesMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "cyclicDependenciesCsv.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/cyclic-dependencies/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SUMMARY_DIR=${CYCLIC_DEPENDENCIES_SUMMARY_DIR:-$( (unset CDPATH; cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P) )}
#echo "cyclicDependenciesSummary: CYCLIC_DEPENDENCIES_SUMMARY_DIR=${CYCLIC_DEPENDENCIES_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Cypher query directory within this domain (flat — the domain IS cyclic-dependencies)
CYCLIC_DEPS_QUERY_CYPHER_DIR="${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/../queries"

# Define functions to execute a cypher query from within a given file like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

cyclic_dependencies_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Cyclic Dependencies Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# ── Report assembly helpers ───────────────────────────────────────────────────

# Limits a piped Markdown table to at most 10 data rows (header + separator kept in full).
limit_markdown_table() {
    awk '/^\|[| :-]*-[| :-]*\|/ { sep=1; print; next } !sep { print } sep && ++rows <= 10 { print }'
}

# Runs a Cypher query as a Markdown table (top 10 rows) and appends a CSV download link if the CSV exists.
# Arguments: <cypher_file> <csv_relative_path> <output_file>
execute_limited_table() {
    local cypher_file="${1}"
    local csv_path="${2}"
    local output_file="${3}"
    {
        execute_cypher "${cypher_file}" --output-markdown-table | limit_markdown_table
        local full_csv="${FULL_REPORT_DIRECTORY}/${csv_path}"
        if [ -f "${full_csv}" ]; then
            echo ""
            echo "[Full data](./${csv_path})"
        fi
    } > "${output_file}"
}

# ── Report assembly ───────────────────────────────────────────────────────────

assemble_cyclic_dependencies_report() {
    echo "cyclicDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    cyclic_dependencies_front_matter > "${report_include_directory}/CyclicDependenciesReportFrontMatter.md"

    # ── Java cyclic dependencies ───────────────────────────────────────────

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies.cypher" \
        "Java_Package/Cyclic_Dependencies.csv" \
        "${report_include_directory}/Cyclic_Dependencies.md"

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_Breakdown.cypher" \
        "Java_Package/Cyclic_Dependencies_Breakdown.csv" \
        "${report_include_directory}/Cyclic_Dependencies_Breakdown.md"

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only.cypher" \
        "Java_Package/Cyclic_Dependencies_Breakdown_Backward_Only.csv" \
        "${report_include_directory}/Cyclic_Dependencies_Breakdown_Backward_Only.md"

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher" \
        "Java_Artifact/CyclicArtifactDependenciesUnwinded.csv" \
        "${report_include_directory}/Cyclic_Dependencies_between_Artifacts.md"

    # ── TypeScript cyclic dependencies ────────────────────────────────────

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_for_Typescript.cypher" \
        "Typescript_Module/Cyclic_Dependencies_for_Typescript.csv" \
        "${report_include_directory}/Cyclic_Dependencies_for_Typescript.md"

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_for_Typescript.cypher" \
        "Typescript_Module/Cyclic_Dependencies_Breakdown_for_Typescript.csv" \
        "${report_include_directory}/Cyclic_Dependencies_Breakdown_for_Typescript.md"

    execute_limited_table \
        "${CYCLIC_DEPS_QUERY_CYPHER_DIR}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher" \
        "Typescript_Module/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv" \
        "${report_include_directory}/Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.md"

    # -- Remove empty Markdown includes ------------------------------------
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-cycles fallback template ----------------------------------
    cp -f "${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/report_no_cycles_data.template.md" \
        "${report_include_directory}/report_no_cycles_data.template.md"

    # -- Copy no-TypeScript-data fallback template --------------------------
    cp -f "${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/report_no_typescript_data.template.md" \
        "${report_include_directory}/report_no_typescript_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/cyclic_dependencies_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "cyclicDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="cyclic-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_cyclic_dependencies_report
