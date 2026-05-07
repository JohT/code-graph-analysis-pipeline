#!/usr/bin/env bash

# Creates a Markdown report that contains all results of archetype classification.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/archetypes.
# Dynamically triggered by "MarkdownReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "archetypesCsv.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/archetypes/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ARCHETYPES_SUMMARY_DIR=${ARCHETYPES_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
#echo "archetypesSummary: ARCHETYPES_SUMMARY_DIR=${ARCHETYPES_SUMMARY_DIR}"
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ARCHETYPES_SUMMARY_DIR}/../../../scripts"} # Repository directory containing the shell scripts

MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}
#echo "archetypesSummary: MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR}" >&2

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher" and "execute_cypher_summarized"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Aggregates deep dive results in a Markdown report section for a single abstraction level.
#
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetypes_deep_dive_report() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    echo "archetypesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Creating ${language} ${nodeLabel} archetypes summary Markdown report..."
    
    local detail_report_directory_name="${language}_${nodeLabel}"
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${detail_report_directory_name}"
    
    # Skip the deep dive report part if there is no data available
    if ! find "${detail_report_directory}" -mindepth 1 -print -quit 2>/dev/null | grep -q .; then
        echo "archetypesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Skipping ${language} ${nodeLabel} report..." >&2
        return 0
    fi    
    
    report_number=$((report_number+1))

    # Create the directory that contains the Markdown includes
    local detail_report_include_directory="${detail_report_directory}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${detail_report_include_directory}"

    # Collect dynamic Markdown includes
    execute_cypher "${ARCHETYPES_SUMMARY_DIR}/ArchetypeDeepDiveArchetypes.cypher" "${@}" --output-markdown-table > "${detail_report_include_directory}/DeepDiveArchetypes.md"

    # Remove empty Markdown includes
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_include_directory}"

    # Collect static Markdown includes (after cleanup to not remove one-liner)
    echo "### 2.${report_number} ${language} ${nodeLabel}" > "${detail_report_include_directory}/DeepDiveSectionTitle.md"
    echo "" > "${detail_report_include_directory}/empty.md"
    cp -f "${ARCHETYPES_SUMMARY_DIR}/report_no_archetype_data.template.md" "${detail_report_include_directory}/report_no_archetype_data.template.md"

    # Copy graph visualization references if available
    cp -f "${detail_report_directory}/GraphVisualizations/GraphVisualizationsReferenceForSummary.md" "${detail_report_include_directory}/GraphVisualizationsReference.md" || true

    # Use Markdown template to assemble the final deep dive section of the Markdown report and replace variables
    cp -f "${ARCHETYPES_SUMMARY_DIR}/report_deep_dive.template.md" "${detail_report_directory}/report_deep_dive.template.md"
    cat "${detail_report_directory}/report_deep_dive.template.md" | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${detail_report_include_directory}" > "${detail_report_directory}/report_deep_dive_with_vars.md"
    sed "s/{{deep_dive_directory}}/${detail_report_directory_name}/g" "${detail_report_directory}/report_deep_dive_with_vars.md" > "${detail_report_directory}/report_deep_dive_${report_number}.md" 

    # Add a page break at the end of a deep dive section
    {
        echo "--"
    } >> "${detail_report_directory}/report_deep_dive_${report_number}.md" 

    rm -rf "${detail_report_directory}/report_deep_dive_with_vars.md"
    rm -rf "${detail_report_directory}/report_deep_dive.template.md"
    rm -rf "${detail_report_include_directory}"

    # Clean-up after report generation. Empty reports will be deleted.
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${detail_report_directory}"
}

# Run the archetypes report generation for a single abstraction level.
#
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetypes_report() {
    time archetypes_deep_dive_report "${@}"
}

archetypes_front_matter_metadata_head() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Archetypes Report\""
    echo "generated: \"${current_date}\""
    echo "model_version: \"${latest_tag}\""
    echo "dataset: \"${analysis_directory}\""
    echo "authors: [\"JohT/code-graph-analysis-pipeline\"]"
    echo "---"
}

# Finalize the archetypes report by taking the main template, applying includes and appending all deep dive reports
archetypes_finalize_report() {
    echo "archetypesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling main archetypes Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    execute_cypher "${ARCHETYPES_SUMMARY_DIR}/ArchetypesPerAbstractionLayer.cypher" --output-markdown-table > "${report_include_directory}/ArchetypesPerAbstractionLayer.md"
    execute_cypher "${ARCHETYPES_SUMMARY_DIR}/ArchetypesInTotal.cypher" --output-markdown-table > "${report_include_directory}/ArchetypesInTotal.md"

    # Write "front matter" metadata section
    archetypes_front_matter_metadata_head > "${report_include_directory}/ArchetypesReportFrontMatter.md"

    # Concatenate all deep dive reports as Markdown include
    rm -rf "${report_include_directory}/ArchetypesDeepDive.md"
    for markdown_file in $(find . -type f -name 'report_deep_dive_*.md' | sort); do
        cat "${markdown_file}" >> "${report_include_directory}/ArchetypesDeepDive.md"
        echo "" >> "${report_include_directory}/ArchetypesDeepDive.md"
        rm -rf "${markdown_file}"
    done

    # Remove empty Markdown includes
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # Collect static Markdown includes (after cleanup to not remove one-liner)
    cp -f "${ARCHETYPES_SUMMARY_DIR}/report_no_dependency_data.template.md" "${report_include_directory}/report_no_dependency_data.md"
    cp -f "${ARCHETYPES_SUMMARY_DIR}/report_no_archetypes_treemaps.template.md" "${report_include_directory}/report_no_archetypes_treemaps.md"

    # Assemble final report by applying includes to the main template
    cp -f "${ARCHETYPES_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" > "${FULL_REPORT_DIRECTORY}/archetypes_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"
}

# Create report directory
REPORT_NAME="archetypes"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
ALGORITHM_NODE="projection_node_label"
ALGORITHM_LANGUAGE="projection_language"

# -- Detail Reports for each code type -------------------------------
report_number=0

archetypes_report "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_LANGUAGE}=Java"
archetypes_report "${ALGORITHM_NODE}=Package" "${ALGORITHM_LANGUAGE}=Java"
archetypes_report "${ALGORITHM_NODE}=Type" "${ALGORITHM_LANGUAGE}=Java"
archetypes_report "${ALGORITHM_NODE}=Module" "${ALGORITHM_LANGUAGE}=Typescript"

# ---------------------------------------------------------------

archetypes_finalize_report

echo "archetypesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
