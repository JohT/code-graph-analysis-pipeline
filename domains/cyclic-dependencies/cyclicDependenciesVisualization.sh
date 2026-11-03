#!/usr/bin/env bash

# Generates GraphViz SVG graph visualizations for the top cyclic dependency cycle groups.
# Reads from already-generated CSV reports produced by "cyclicDependenciesCsv.sh".
# Produces one SVG per top cycle pair for Java packages, TypeScript modules, and SCIP Semantic Index modules.
# The SVG files will be written into reports/cyclic-dependencies/{Java_Package,Typescript_Module,SCIP_Semantic_Index_Module}/Graph_Visualizations/.
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

# Extracts nodes and edges from the cycle breakdown CSV.
# Outputs node definitions with full styling (one per line).
# Edge definitions appear at the end (one per line).
# Does NOT output cluster structure (that's in the template).
#
# Parameters:
#   $1  package_name
#   $2  dependent_package_name
#   $3  breakdown_csv
# Output: Three sections marked with special lines:
#   ===PKG_NODES===
#   "node_name" [attributes];
#   ===DEP_NODES===
#   "node_name" [attributes];
#   ===EDGES===
#   "src" -> "tgt" [attributes];
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
                pkg_nodes[parts[1]] = 1
                dep_nodes[parts[2]] = 1
                forward_edges[parts[1], parts[2]] = 1
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
            pkg_count = 0
            for (n in pkg_nodes) pkg_count++
            dep_count = 0
            for (n in dep_nodes) dep_count++
            if (pkg_count + dep_count == 0) exit 0
            
            for (n in pkg_nodes) if (n in dep_nodes) ambiguous[n] = 1
            
            print "===PKG_NODES==="
            for (n in pkg_nodes) {
                node_name = (n in ambiguous) ? n "_pkg" : n
                print "\"" node_name "\" [label=\"" n "\"; fillcolor=\"#B3E5FC\"; color=\"#0277BD\"; penwidth=\"1.5\"];"
            }
            print "===DEP_NODES==="
            for (n in dep_nodes) {
                node_name = (n in ambiguous) ? n "_dep" : n
                print "\"" node_name "\" [label=\"" n "\"; fillcolor=\"#F3E5F5\"; color=\"#8E24AA\"; penwidth=\"1.5\"];"
            }
            print "===EDGES==="
            for (edge in forward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_pkg" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_dep" : parts[2]
                print "\"" src "\" -> \"" tgt "\" [color=\"#90CAF9\"; penwidth=\"0.7\"];"
            }
            for (edge in backward_edges) {
                split(edge, parts, SUBSEP)
                src = (parts[1] in ambiguous) ? parts[1] "_dep" : parts[1]
                tgt = (parts[2] in ambiguous) ? parts[2] "_pkg" : parts[2]
                print "\"" src "\" -> \"" tgt "\" [color=\"#E91E63\"; penwidth=\"2.5\"; style=\"dashed\";];"
            }
        }
    ' "${breakdown_csv}"
}

# Generates a complete .gv file by combining template with extracted cycle data.
#
# Parameters:
#   $1  package_name
#   $2  dependent_package_name
#   $3  breakdown_csv
#   $4  output_gv
generate_cycle_graph() {
    local package_name="${1}"
    local dependent_package_name="${2}"
    local breakdown_csv="${3}"
    local output_gv="${4}"

    echo "cyclicDependenciesVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Generating graph for ${package_name} <-> ${dependent_package_name}..."

    # Extract nodes and edges from CSV
    local data
    data=$(generate_dot_body "${package_name}" "${dependent_package_name}" "${breakdown_csv}")

    if [[ -z "${data}" ]]; then
        echo "cyclicDependenciesVisualization: No dependency data found for ${package_name} <-> ${dependent_package_name}. Skipping."
        return 0
    fi

    # Create temp files for sections
    local pkg_nodes_file dep_nodes_file edges_file
    pkg_nodes_file=$(mktemp)
    dep_nodes_file=$(mktemp)
    edges_file=$(mktemp)
    trap "rm -f '$pkg_nodes_file' '$dep_nodes_file' '$edges_file'" RETURN

    # Extract and save sections
    sed -n '/^===PKG_NODES===/,/^===/{ /^===/!p; }' <<< "$data" > "$pkg_nodes_file"
    sed -n '/^===DEP_NODES===/,/^===/{ /^===/!p; }' <<< "$data" > "$dep_nodes_file"
    sed -n '/^===EDGES===/,$ { /^===EDGES===/!p; }' <<< "$data" > "$edges_file"

    # Build output file using template + sections
    {
        # Read template and substitute labels
        sed "s|{{PACKAGE_LABEL}}|$package_name|g; s|{{DEPENDENT_LABEL}}|$dependent_package_name|g" \
            "${CYCLE_TEMPLATE_FILE}" | \
        while IFS= read -r line; do
            # Trim leading/trailing whitespace for pattern matching
            trimmed="${line#"${line%%[! ]*}"}"
            trimmed="${trimmed%"${trimmed##*[! ]}"}"
            
            case "$trimmed" in
                "{{PACKAGE_NODES}}")
                    cat "$pkg_nodes_file"
                    ;;
                "{{DEPENDENT_NODES}}")
                    cat "$dep_nodes_file"
                    ;;
                "{{EDGES}}")
                    cat "$edges_file"
                    ;;
                *)
                    echo "$line"
                    ;;
            esac
        done
    } > "$output_gv"
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

# ── SCIP Semantic Index Module Cyclic Dependencies ────────────────────────────

process_language_cycle_graphs \
    "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_for_SCIP_Module.csv" \
    "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/Cyclic_Dependencies_Breakdown_for_SCIP_Module.csv" \
    "${FULL_REPORT_DIRECTORY}/SCIP_Semantic_Index_Module/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "ScipModuleCyclicDependencies" \
    "SCIP_Semantic_Index_Module/${GRAPH_VISUALIZATIONS_DIRECTORY_NAME}" \
    "SCIP Semantic Index Module"

echo "cyclicDependenciesVisualization: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
