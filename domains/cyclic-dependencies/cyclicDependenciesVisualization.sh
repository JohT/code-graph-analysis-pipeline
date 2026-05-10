#!/usr/bin/env bash

# Generates GraphViz SVG graph visualizations for the top cyclic dependency cycle groups.
# Reads from already-generated CSV reports produced by "cyclicDependenciesCsv.sh".
# Produces one SVG per top cycle pair for Java packages and TypeScript modules.
# The SVG files will be written into reports/cyclic-dependencies/{Java_Package,Typescript_Module}/Graph_Visualizations/.
# Dynamically triggered by "VisualizationReports.sh".

# Requires renderGraphVizSVG.sh
# Requires cyclicDependenciesCsv.sh to have run first (provides the breakdown CSV input)

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

usage() {
    echo "Usage: source ${BASH_SOURCE[0]}"
    echo ""
    echo "Environment variables:"
    echo "  CYCLIC_DEPENDENCIES_TOP_N_GRAPHS  Number of top cycle pairs to visualize per language (default: 5)"
    echo "  REPORTS_DIRECTORY                 Report output base directory (default: reports)"
    echo "  MARKDOWN_INCLUDES_DIRECTORY       Markdown includes subdirectory name (default: includes)"
    echo ""
    echo "Example:"
    echo "  CYCLIC_DEPENDENCIES_TOP_N_GRAPHS=3 source cyclicDependenciesVisualization.sh"
}

if [ "${1:-}" = "--help" ]; then
    usage
    exit 0
fi

# Overrideable constants
CYCLIC_DEPENDENCIES_TOP_N_GRAPHS=${CYCLIC_DEPENDENCIES_TOP_N_GRAPHS:-5}
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}
MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"}

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
# Unset CDPATH to prevent cd from printing the directory to stdout when capturing the result.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$( (unset CDPATH; cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P) )}
echo "cyclicDependenciesVisualization: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Directory containing the GraphViz template file
CYCLIC_DEPENDENCIES_GRAPHS_DIR="${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/graphs"

# Get the "scripts" directory by navigating two levels up from this domain directory
SCRIPTS_DIR=${SCRIPTS_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/../../scripts"}

# Get the "scripts/visualization" directory
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"}

# Report output paths
REPORT_NAME="cyclic-dependencies"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
GRAPH_VISUALIZATIONS_DIRECTORY_NAME="Graph_Visualizations"
GRAPHVIZ_SUBDIRECTORY_NAME="graphviz"
MARKDOWN_REFERENCE_FILE_NAME="GraphVisualizationsReferenceForSummary.md"
CYCLE_TEMPLATE_FILE="${CYCLIC_DEPENDENCIES_GRAPHS_DIR}/cycle.template.gv"

# ── Graph generation functions ────────────────────────────────────────────────

# Reads the cycle breakdown CSV, filters by the given package/module pair,
# and writes the inner DOT body (two clusters and all forward/backward edges) to stdout.
#
# CSV columns when using awk -F '"' (double-quote as field separator, produced by jq @csv):
#   $4  = packageName / moduleName
#   $8  = dependentPackageName / dependentModulePathName
#   $10 = dependency ("TypeA->TypeB" for forward, "TypeC<-TypeD" for backward)
# Numeric columns (forwardToBackwardBalance, numberForward, numberBackward) are unquoted in @csv
# and appear inside $9/$11 between the quoted string fields.
# Column positions are derived from the RETURN clause order in the Cypher breakdown queries.
#
# Parameters:
#   $1  package_name           — left-side code unit to filter by
#   $2  dependent_package_name — right-side code unit to filter by
#   $3  breakdown_csv          — path to the breakdown CSV file
generate_dot_body() {
    local package_name="${1}"
    local dependent_package_name="${2}"
    local breakdown_csv="${3}"

    awk -F '"' -v pkg="${package_name}" -v dep_pkg="${dependent_package_name}" '
        NR > 1 && $4 == pkg && $8 == dep_pkg {
            dep = $10
            gsub(/\r/, "", dep)
            if (index(dep, "->") > 0) {
                split(dep, parts, "->")
                src = parts[1]
                tgt = parts[2]
                pkg_nodes[src] = 1
                dep_nodes[tgt] = 1
                forward_edges[src, tgt] = 1
            } else if (index(dep, "<-") > 0) {
                split(dep, parts, "<-")
                backward_tgt = parts[1]
                backward_src = parts[2]
                pkg_nodes[backward_tgt] = 1
                dep_nodes[backward_src] = 1
                backward_edges[backward_src, backward_tgt] = 1
            }
        }
        END {
            # Count array elements (POSIX awk compatible; length(array) is not POSIX)
            pkg_count = 0
            for (n in pkg_nodes) pkg_count++
            dep_count = 0
            for (n in dep_nodes) dep_count++
            if (pkg_count + dep_count == 0) exit 0
            # Detect nodes whose simple name exists in both clusters.
            # GraphViz (fdp) cannot place a single node in two clusters simultaneously,
            # so these are disambiguated with a "_pkg" / "_dep" suffix while keeping
            # the original name as the visible label.
            # This typically happens when two packages each contain a type with the
            # same simple name and one depends on the other.
            for (n in pkg_nodes) if (n in dep_nodes) ambiguous[n] = 1
            print "    subgraph cluster_package {"
            print "        label=\"" pkg "\";"
            print "        style=\"filled\";"
            print "        fillcolor=\"lightblue\";"
            for (n in pkg_nodes) {
                if (n in ambiguous) print "        \"" n "_pkg\" [label=\"" n "\"];"
                else print "        \"" n "\";"
            }
            print "    }"
            print ""
            print "    subgraph cluster_dependent {"
            print "        label=\"" dep_pkg "\";"
            print "        style=\"filled\";"
            print "        fillcolor=\"peachpuff\";"
            for (n in dep_nodes) {
                if (n in ambiguous) print "        \"" n "_dep\" [label=\"" n "\"];"
                else print "        \"" n "\";"
            }
            print "    }"
            print ""
            for (edge in forward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_pkg" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_dep" : parts[2]
                print "    \"" src "\" -> \"" tgt "\" [color=\"#6699CC\"; penwidth=\"0.5\"];"
            }
            for (edge in backward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_dep" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_pkg" : parts[2]
                print "    \"" src "\" -> \"" tgt "\" [color=\"red\"; penwidth=\"2.5\"; style=\"dashed\";];"
            }
        }
    ' "${breakdown_csv}"
}

# Generates a DOT file for a single cycle pair by combining the template settings
# with the cluster and edge content from the breakdown CSV.
# Writes nothing and returns 0 (no error) if no matching data is found in the CSV.
#
# Parameters:
#   $1  package_name           — left-side code unit (packageName / moduleName)
#   $2  dependent_package_name — right-side code unit (dependentPackageName / dependentModulePathName)
#   $3  breakdown_csv          — path to the breakdown CSV file
#   $4  output_gv              — path for the output .gv file to create
generate_cycle_graph() {
    local package_name="${1}"
    local dependent_package_name="${2}"
    local breakdown_csv="${3}"
    local output_gv="${4}"

    echo "cyclicDependenciesVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Generating graph for ${package_name} <-> ${dependent_package_name}..."

    local template_content
    template_content=$(sed -n '/\/\/Begin-Template/,/\/\/End-Template/{//!p;}' "${CYCLE_TEMPLATE_FILE}")

    local graph_body
    graph_body=$(generate_dot_body "${package_name}" "${dependent_package_name}" "${breakdown_csv}")

    if [[ -z "${graph_body}" ]]; then
        echo "cyclicDependenciesVisualization: No dependency data found for ${package_name} <-> ${dependent_package_name}. Skipping."
        return 0
    fi

    {
        echo "strict digraph cycle {"
        echo "${template_content}"
        echo ""
        echo "${graph_body}"
        echo "}"
    } > "${output_gv}"
}

# Appends an SVG image reference to the markdown reference file in the given output directory.
# Creates the file with a section header when called for index 1.
# The image path is relative to the assembled report location (reports/cyclic-dependencies/).
#
# Parameters:
#   $1  svg_prefix              — SVG filename prefix (e.g. "JavaPackageCyclicDependencies")
#   $2  index                   — 1-based index of this visualization
#   $3  output_dir              — directory where the reference file is written
#   $4  package_name            — left-side code unit label for the section heading
#   $5  dependent_package_name  — right-side code unit label for the section heading
#   $6  relative_dir            — path from reports/cyclic-dependencies/ to output_dir
update_markdown_references() {
    local svg_prefix="${1}"
    local index="${2}"
    local output_dir="${3}"
    local package_name="${4}"
    local dependent_package_name="${5}"
    local relative_dir="${6}"

    local markdown_reference_file="${output_dir}/${MARKDOWN_REFERENCE_FILE_NAME}"

    if [[ "${index}" -eq 1 ]]; then
        {
            echo "#### Graph Visualizations"
            echo ""
        } > "${markdown_reference_file}"
    fi

    {
        echo "##### Cycle ${index}: \`${package_name}\` ↔ \`${dependent_package_name}\`"
        echo ""
        echo "![Cycle ${index}](./${relative_dir}/${svg_prefix}${index}.svg)"
        echo ""
    } >> "${markdown_reference_file}"
}

# ── Core processing function ──────────────────────────────────────────────────

# Generates cycle graph SVGs for the top N cycle pairs from the given CSV files.
# Extracts the top N pairs (sorted by forwardToBackwardBalance DESC, as per the Cypher query)
# from the source CSV, then renders a graph for each pair using the breakdown CSV.
#
# Parameters:
#   $1  source_csv              — path to the overview CSV (Cyclic_Dependencies*.csv)
#   $2  breakdown_csv           — path to the breakdown CSV (Cyclic_Dependencies_Breakdown*.csv)
#   $3  output_dir              — directory for SVGs and the markdown reference file
#   $4  svg_prefix              — prefix for output filenames (e.g. "JavaPackageCyclicDependencies")
#   $5  relative_dir            — path from reports/cyclic-dependencies/ to output_dir
#   $6  language_label          — human-readable label for log messages (e.g. "Java Package")
process_language_cycle_graphs() {
    local source_csv="${1}"
    local breakdown_csv="${2}"
    local output_dir="${3}"
    local svg_prefix="${4}"
    local relative_dir="${5}"
    local language_label="${6}"

    if [[ ! -f "${source_csv}" ]] || [[ "$(wc -l < "${source_csv}")" -le 1 ]]; then
        echo "cyclicDependenciesVisualization: No ${language_label} cyclic dependency data found in ${source_csv}. Skipping."
        return 0
    fi

    if [[ ! -f "${breakdown_csv}" ]] || [[ "$(wc -l < "${breakdown_csv}")" -le 1 ]]; then
        echo "cyclicDependenciesVisualization: No ${language_label} breakdown data found in ${breakdown_csv}. Skipping."
        return 0
    fi

    mkdir -p "${output_dir}"

    echo "cyclicDependenciesVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Processing top ${CYCLIC_DEPENDENCIES_TOP_N_GRAPHS} ${language_label} cycle pairs..."

    local pair_index=0
    while IFS=$'\t' read -r package_name dependent_package_name; do
        pair_index=$((pair_index + 1))
        local output_gv="${output_dir}/${svg_prefix}${pair_index}.gv"

        generate_cycle_graph "${package_name}" "${dependent_package_name}" "${breakdown_csv}" "${output_gv}"

        if [[ ! -f "${output_gv}" ]]; then
            continue
        fi

        source "${VISUALIZATION_SCRIPTS_DIR}/renderGraphVizSVG.sh" "${output_gv}"

        mkdir -p "${output_dir}/${GRAPHVIZ_SUBDIRECTORY_NAME}"
        mv -f "${output_gv}" "${output_dir}/${GRAPHVIZ_SUBDIRECTORY_NAME}/"

        update_markdown_references "${svg_prefix}" "${pair_index}" "${output_dir}" "${package_name}" "${dependent_package_name}" "${relative_dir}"

    done < <(awk -F '"' 'NR > 1 && NF >= 8 { print $4 "\t" $8 }' "${source_csv}" | head -n "${CYCLIC_DEPENDENCIES_TOP_N_GRAPHS}")
}

# ── Java Package Cyclic Dependencies ─────────────────────────────────────────

process_language_cycle_graphs \
    "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies.csv" \
    "${FULL_REPORT_DIRECTORY}/Java_Package/Cyclic_Dependencies_Breakdown.csv" \
    "${FULL_REPORT_DIRECTORY}/Java_Package/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "JavaPackageCyclicDependencies" \
    "Java_Package/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "Java Package"

# ── TypeScript Module Cyclic Dependencies ─────────────────────────────────────

process_language_cycle_graphs \
    "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_for_Typescript.csv" \
    "${FULL_REPORT_DIRECTORY}/Typescript_Module/Cyclic_Dependencies_Breakdown_for_Typescript.csv" \
    "${FULL_REPORT_DIRECTORY}/Typescript_Module/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "TypescriptModuleCyclicDependencies" \
    "Typescript_Module/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "TypeScript Module"

echo "cyclicDependenciesVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
