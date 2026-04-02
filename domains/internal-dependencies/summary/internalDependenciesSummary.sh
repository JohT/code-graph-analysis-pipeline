#!/usr/bin/env bash

# Creates a Markdown report summarising all internal dependency analysis results.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/internal-dependencies.
# Dynamically triggered by "MarkdownReports.sh" via "internalDependenciesMarkdown.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that either "internalDependenciesCsv.sh" or "internalDependenciesVisualization.sh"
# is required to run prior to this script.

# Requires executeQueryFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/internal-dependencies/summary" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
INTERNAL_DEPENDENCIES_SUMMARY_DIR=${INTERNAL_DEPENDENCIES_SUMMARY_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
#echo "internalDependenciesSummary: INTERNAL_DEPENDENCIES_SUMMARY_DIR=${INTERNAL_DEPENDENCIES_SUMMARY_DIR}"

# Get the "scripts" directory by navigating three levels up from this summary directory.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/../../../scripts"}
MARKDOWN_SCRIPTS_DIR=${MARKDOWN_SCRIPTS_DIR:-"${SCRIPTS_DIR}/markdown"}

# Cypher query directories within this domain
INTERNAL_DEPS_QUERY_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/../queries/internal-dependencies"
CYCLIC_DEPS_QUERY_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/../queries/cyclic-dependencies"
TOPOLOGICAL_SORT_SUMMARY_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/../queries/topological-sort"
PATH_FINDING_CYPHER_DIR="${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/../queries/path-finding"

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createDirectedDependencyProjection" or "projectionExists"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# ── Front matter ──────────────────────────────────────────────────────────────

internal_dependencies_front_matter() {
    local current_date
    current_date="$(date +'%Y-%m-%d')"

    local latest_tag
    latest_tag="$(git for-each-ref --sort=-creatordate --count=1 --format '%(refname:short)' refs/tags)"

    local analysis_directory
    analysis_directory="${PWD##*/}"

    echo "---"
    echo "title: \"Internal Dependencies Report\""
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
        local rel_path="${base_dir#"${FULL_REPORT_DIRECTORY}/"}/${chart_filename}"
        local chart_label="${chart_filename%.*}"
        echo ""
        echo "![${chart_label}](./${rel_path})"
    done
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

assemble_internal_dependencies_report() {
    echo "internalDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Assembling Markdown report..."

    local report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${report_include_directory}"

    # -- Write front matter ------------------------------------------------
    internal_dependencies_front_matter > "${report_include_directory}/InternalDependenciesReportFrontMatter.md"

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

    # ── Java internal structure ────────────────────────────────────────────

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/List_all_Java_artifacts.cypher" \
        "Java_Artifact/List_all_Java_artifacts.csv" \
        "${report_include_directory}/List_all_Java_artifacts.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/Candidates_for_Interface_Segregation.cypher" \
        "Java_Package/InterfaceSegregationCandidates.csv" \
        "${report_include_directory}/Candidates_for_Interface_Segregation.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/List_types_that_are_used_by_many_different_packages.cypher" \
        "Java_Package/WidelyUsedTypes.csv" \
        "${report_include_directory}/List_types_that_are_used_by_many_different_packages.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher" \
        "Java_Artifact/ArtifactPackageUsage.csv" \
        "${report_include_directory}/How_many_packages_used_by_dependent_artifacts.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher" \
        "Java_Artifact/ClassesPerPackageUsageAcrossArtifacts.csv" \
        "${report_include_directory}/How_many_classes_used_by_dependent_packages.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/Get_file_distance_as_shortest_contains_path_for_dependencies.cypher" \
        "Distance_distribution_between_dependent_files.csv" \
        "${report_include_directory}/File_distance_distribution.md"

    # ── TypeScript internal structure ──────────────────────────────────────

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/List_all_Typescript_modules.cypher" \
        "Typescript_Module/List_all_Typescript_modules.csv" \
        "${report_include_directory}/List_all_Typescript_modules.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher" \
        "Typescript_Module/WidelyUsedTypescriptElements.csv" \
        "${report_include_directory}/List_elements_used_by_many_modules.md"

    execute_limited_table \
        "${INTERNAL_DEPS_QUERY_CYPHER_DIR}/How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher" \
        "Typescript_Module/ModuleElementsUsageTypescript.csv" \
        "${report_include_directory}/How_many_elements_used_by_dependent_modules.md"

    # ── Path finding tables (Java Artifact) ──────────────────────────────────
    # Guard: only run if Java Artifact path finding projection exists.
    ARTIFACT_PROJECTION="dependencies_projection=artifact-path-finding"
    if projectionExists "${ARTIFACT_PROJECTION}"; then
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher" \
                "${ARTIFACT_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Java_Artifact/Artifact_all_pairs_shortest_paths_distribution_per_project.csv" ]; then
                echo ""
                echo "[Full data per project](./Java_Artifact/Artifact_all_pairs_shortest_paths_distribution_per_project.csv)"
            fi
        } > "${report_include_directory}/JavaArtifactAllPairsShortestPathDistribution.md"
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_distribution_overall.cypher" \
                "${ARTIFACT_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Java_Artifact/Artifact_longest_paths_distribution.csv" ]; then
                echo ""
                echo "[Full data per project](./Java_Artifact/Artifact_longest_paths_distribution.csv)"
            fi
        } > "${report_include_directory}/JavaArtifactLongestPathDistribution.md"
    fi
    
    # ── Path finding tables (Java Package) ─────────────────────────────────
    # Guard: only run if Java Package path finding projection exists.
    PACKAGE_PROJECTION="dependencies_projection=package-path-finding"
    if projectionExists "${PACKAGE_PROJECTION}"; then
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher" \
                "${PACKAGE_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Java_Package/Package_all_pairs_shortest_paths_distribution_per_project.csv" ]; then
                echo ""
                echo "[Full data per project](./Java_Package/Package_all_pairs_shortest_paths_distribution_per_project.csv)"
            fi
        } > "${report_include_directory}/JavaPackageAllPairsShortestPathDistribution.md"
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_distribution_overall.cypher" \
                "${PACKAGE_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Java_Package/Package_longest_paths_distribution.csv" ]; then
                echo ""
                echo "[Full data per project](./Java_Package/Package_longest_paths_distribution.csv)"
            fi
        } > "${report_include_directory}/JavaPackageLongestPathDistribution.md"
    fi

    # ── Path finding SVG chart references (Java Package) ──────────────────
    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_AllPairsShortestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_AllPairsShortestPath_Pie.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_AllPairsShortestPath_StackedBar_Log.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_AllPairsShortestPath_StackedBar_Normalised.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_GraphDiameter_per_Project.svg"
    } > "${report_include_directory}/JavaPackageAllPairsShortestPathCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_LongestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_LongestPath_Pie.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_LongestPath_StackedBar_Log.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_LongestPath_StackedBar_Normalised.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Package" "Java_Package_MaxLongestPath_per_Project.svg"
    } > "${report_include_directory}/JavaPackageLongestPathCharts.md"

    # ── Path finding SVG chart references (Java Artifact) ─────────────────
    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Artifact" "Java_Artifact_AllPairsShortestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Artifact" "Java_Artifact_AllPairsShortestPath_Pie.svg"
    } > "${report_include_directory}/JavaArtifactAllPairsShortestPathCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Artifact" "Java_Artifact_LongestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Java_Artifact" "Java_Artifact_LongestPath_Pie.svg"
    } > "${report_include_directory}/JavaArtifactLongestPathCharts.md"

    # ── Path finding tables (TypeScript Module) ───────────────────────────────
    # Guard: only run if TypeScript path finding projection exists.
    MODULE_PROJECTION="dependencies_projection=typescript-module-path-finding"
    if projectionExists "${MODULE_PROJECTION}"; then
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher" \
                "${MODULE_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Typescript_Module/Module_all_pairs_shortest_paths_distribution_per_project.csv" ]; then
                echo ""
                echo "[Full data per project](./Typescript_Module/Module_all_pairs_shortest_paths_distribution_per_project.csv)"
            fi
        } > "${report_include_directory}/TypescriptModuleAllPairsShortestPathDistribution.md"
        {
            execute_cypher "${PATH_FINDING_CYPHER_DIR}/Path_Finding_6_Longest_paths_distribution_overall.cypher" \
                "${MODULE_PROJECTION}" \
                --output-markdown-table | limit_markdown_table
            if [ -f "${FULL_REPORT_DIRECTORY}/Typescript_Module/Module_longest_paths_distribution.csv" ]; then
                echo ""
                echo "[Full data per project](./Typescript_Module/Module_longest_paths_distribution.csv)"
            fi
        } > "${report_include_directory}/TypescriptModuleLongestPathDistribution.md"
    fi

    # ── Path finding SVG chart references (TypeScript Module) ─────────────
    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_AllPairsShortestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_AllPairsShortestPath_Pie.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_AllPairsShortestPath_StackedBar_Log.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_AllPairsShortestPath_StackedBar_Normalised.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_GraphDiameter_per_Project.svg"
    } > "${report_include_directory}/TypescriptModuleAllPairsShortestPathCharts.md"

    {
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_LongestPath_Bar.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_LongestPath_Pie.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_LongestPath_StackedBar_Log.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_LongestPath_StackedBar_Normalised.svg"
        include_svgs_matching "${FULL_REPORT_DIRECTORY}/Typescript_Module" "Typescript_Module_MaxLongestPath_per_Project.svg"
    } > "${report_include_directory}/TypescriptModuleLongestPathCharts.md"

    # ── Graph visualization SVG references (Java Artifact) ────────────────
    {
        include_svg_if_exists "Java_Artifact/Graph_Visualizations/JavaArtifactBuildLevels.svg" \
            "Java Artifact Build Levels"
        include_svg_if_exists "Java_Artifact/Graph_Visualizations/JavaArtifactLongestPathsIsolated.svg" \
            "Java Artifact Longest Paths (Isolated)"
        include_svg_if_exists "Java_Artifact/Graph_Visualizations/JavaArtifactLongestPaths.svg" \
            "Java Artifact Longest Paths (with contributors)"
    } > "${report_include_directory}/JavaArtifactGraphVisualizations.md"

    # ── Graph visualization SVG references (TypeScript Module) ────────────
    {
        include_svg_if_exists "Typescript_Module/Graph_Visualizations/TypeScriptModuleBuildLevels.svg" \
            "TypeScript Module Build Levels"
        include_svg_if_exists "Typescript_Module/Graph_Visualizations/TypeScriptModuleLongestPathsIsolated.svg" \
            "TypeScript Module Longest Paths (Isolated)"
        include_svg_if_exists "Typescript_Module/Graph_Visualizations/TypeScriptModuleLongestPaths.svg" \
            "TypeScript Module Longest Paths (with contributors)"
    } > "${report_include_directory}/TypescriptModuleGraphVisualizations.md"

    # ── Graph visualization SVG references (NPM Packages) ─────────────────
    {
        include_svg_if_exists "NPM_NonDevPackage/Graph_Visualizations/NpmPackageBuildLevels.svg" \
            "NPM Package Build Levels"
        include_svg_if_exists "NPM_NonDevPackage/Graph_Visualizations/NpmNonDevPackageLongestPathsIsolated.svg" \
            "NPM Non-Dev Package Longest Paths (Isolated)"
        include_svg_if_exists "NPM_NonDevPackage/Graph_Visualizations/NpmNonDevPackageLongestPaths.svg" \
            "NPM Non-Dev Package Longest Paths (with contributors)"
        include_svg_if_exists "NPM_DevPackage/Graph_Visualizations/NpmDevPackageLongestPathsIsolated.svg" \
            "NPM Dev Package Longest Paths (Isolated)"
        include_svg_if_exists "NPM_DevPackage/Graph_Visualizations/NpmDevPackageLongestPaths.svg" \
            "NPM Dev Package Longest Paths (with contributors)"
    } > "${report_include_directory}/NpmPackageGraphVisualizations.md"

    # ── Topological sort critical path length KPI ─────────────────────────

    execute_limited_table \
        "${TOPOLOGICAL_SORT_SUMMARY_CYPHER_DIR}/Topological_Sort_Critical_Path_Length.cypher" \
        "" \
        "${report_include_directory}/Topological_Sort_Critical_Path_Length.md"

    # -- Remove empty Markdown includes ------------------------------------
    source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${report_include_directory}"

    # -- Create fallback empty file for optional includes ------------------
    echo "" > "${report_include_directory}/empty.md"

    # -- Copy no-Java-data fallback template --------------------------
    cp -f "${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/report_no_java_data.template.md" \
        "${report_include_directory}/report_no_java_data.template.md"

    # -- Copy no-TypeScript-data fallback template --------------------------
    cp -f "${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/report_no_typescript_data.template.md" \
        "${report_include_directory}/report_no_typescript_data.template.md"

    # -- Copy no-cycles fallback template ----------------------------------
    cp -f "${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/report_no_cycles_data.template.md" \
        "${report_include_directory}/report_no_cycles_data.template.md"

    # -- Assemble final report from template --------------------------------
    cp -f "${INTERNAL_DEPENDENCIES_SUMMARY_DIR}/report.template.md" "${FULL_REPORT_DIRECTORY}/report.template.md"
    cat "${FULL_REPORT_DIRECTORY}/report.template.md" \
        | "${MARKDOWN_SCRIPTS_DIR}/embedMarkdownIncludes.sh" "${report_include_directory}" \
        > "${FULL_REPORT_DIRECTORY}/internal_dependencies_report.md"

    rm -rf "${FULL_REPORT_DIRECTORY}/report.template.md"
    rm -rf "${report_include_directory}"

    echo "internalDependenciesSummary: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Create report directory
REPORT_NAME="internal-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

assemble_internal_dependencies_report
