#!/usr/bin/env bash

# Pipeline that creates treemap visualizations for structural archetype classification results.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/archetypes.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "domains/archetypes" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ARCHETYPES_SCRIPT_DIR=${ARCHETYPES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "archetypesPython: ARCHETYPES_SCRIPT_DIR=${ARCHETYPES_SCRIPT_DIR}"
# Get the "scripts" directory by taking the path of this script and going two directories up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ARCHETYPES_SCRIPT_DIR}/../../scripts"} # Repository directory containing the shell scripts
# Get the "cypher" query directories for gathering features and writing labels.
ARCHETYPES_FEATURE_CYPHER_DIR=${ARCHETYPES_FEATURE_CYPHER_DIR:-"${ARCHETYPES_SCRIPT_DIR}/features"}
ARCHETYPES_LABEL_CYPHER_DIR=${ARCHETYPES_LABEL_CYPHER_DIR:-"${ARCHETYPES_SCRIPT_DIR}/labels"}

# Function to display script usage
usage() {
  echo -e "${COLOR_ERROR}" >&2
  echo "Usage: $0 [--verbose]" >&2
  echo -e "${COLOR_DEFAULT}" >&2
  exit 1
}

# Default values
verboseMode="" # either "" or "--verbose"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"

  case ${key} in
    --verbose)
      verboseMode="--verbose"
      ;;
    *)
      echo -e "${COLOR_ERROR}archetypesPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Query or recalculate features (skip if already computed via Exists checks).
#
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-archetypes"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
archetype_features() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Collecting features for ${nodeLabel} nodes..."

    # Determine the Betweenness centrality (with the directed graph projection) if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Betweenness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Betweenness-Write.cypher" "${@}"
    # Determine the local clustering coefficient if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-LocalClusteringCoefficient-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-LocalClusteringCoefficient-Write.cypher" "${@}"
    # Determine the page rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageRank-Write.cypher" "${@}"
    # Determine the article rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-ArticleRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-ArticleRank-Write.cypher" "${@}"
    # Determine the normalized difference between Page Rank and Article Rank if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageToArticleRank-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-PageToArticleRank-Write.cypher" "${@}"
    # Determine the "abstractness" (interfaces = 100%, abstract classes = 70%, classes & functions = 0%)
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_Java.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_JavaType.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-Abstractness-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature_Abstractness_TypeScriptModule.cypher" "${@}"
    # Determines strongly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-CreateNode.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-StronglyConnectedComponents-CreateDependency.cypher" "${@}"
    # Determines weakly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-Write.cypher" "${@}"
    execute_cypher "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-WeaklyConnectedComponents-CreateNode.cypher" "${@}"
    # Determines topological sort max distance from source for strongly connected components if not already done
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Delete-Projection.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Projection.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Exists.cypher" \
                                         "${ARCHETYPES_FEATURE_CYPHER_DIR}/ArchetypeFeature-TopologicalSortComponents-Write.cypher" "${@}"
}

# Label code units with top archetypes (skip if already labeled via Exists checks).
#
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetype_labels() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )

    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Labelling ${language} ${nodeLabel} archetypes..."
    execute_cypher "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeRemoveLabels.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeAuthority-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeAuthority.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeBottleneck-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeBottleneck.cypher" "${@}"
    execute_cypher_queries_until_results "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeHub-Exists.cypher" \
                                         "${ARCHETYPES_LABEL_CYPHER_DIR}/ArchetypeHub.cypher" "${@}"
}

# Run the archetype feature computation and labeling pipeline.
#
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-archetypes"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetype_python_reports() {
    time archetype_features "${@}"
    time archetype_labels "${@}"
}

# Creates the markdown file (to be included in the main summary)
# that contains the references to all treemap charts.
archetypes_treemap_charts_markdown_reference() {

    echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting treemap charts markdown reference generation..."

    local detail_report_include_directory="${FULL_REPORT_DIRECTORY}/${MARKDOWN_INCLUDES_DIRECTORY}"
    mkdir -p "${detail_report_include_directory}"

    local markdown_reference_file_name="TreemapChartsReference.md"
    local markdown_reference_file="${detail_report_include_directory}/${markdown_reference_file_name}"

    # Write markdown references section title
    {
      echo "#### Treemap Charts"
    } > "${markdown_reference_file}"

    # Find all treemap chart SVG files and add them to the markdown reference file
    find "${FULL_REPORT_DIRECTORY}" -type f -name "*Treemap*.svg" | sort | while read -r chart_file; do
      chart_filename=$(basename -- "${chart_file}")
      chart_filename_without_extension="${chart_filename%.*}" # Remove file extension
      {
        echo ""
        echo "![${chart_filename_without_extension}](./${chart_filename})"
      } >> "${markdown_reference_file}"
    done

    # Add a horizontal rule at the end
    {
      echo ""
      echo "---"
    } >> "${markdown_reference_file}"

    echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished treemap charts markdown reference generation..."
}

# Visualize archetype results with treemap charts.
#
# Required Parameters:
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
archetypes_treemap_charts() {
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Visualizing ${language} archetypes as treemaps..."
    time "${ARCHETYPES_SCRIPT_DIR}/treemapVisualizations.py" "${@}" "--report_directory" "${FULL_REPORT_DIRECTORY}" ${verboseMode}
}

# Create report directory
REPORT_NAME="archetypes"
FULL_REPORT_DIRECTORY="${REPORTS_DIRECTORY}/${REPORT_NAME}"
mkdir -p "${FULL_REPORT_DIRECTORY}"

# Query Parameter key pairs for projection and algorithm side
PROJECTION_NAME="dependencies_projection"
ALGORITHM_PROJECTION="projection_name"

PROJECTION_NODE="dependencies_projection_node"
ALGORITHM_NODE="projection_node_label"

PROJECTION_WEIGHT="dependencies_projection_weight_property"
ALGORITHM_WEIGHT="projection_weight_property"

PROJECTION_LANGUAGE="dependencies_projection_language"
ALGORITHM_LANGUAGE="projection_language"

# -- Java Artifact Archetypes -------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=artifact-archetypes" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=artifact-archetypes-directed" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"
    archetype_python_reports "${ALGORITHM_PROJECTION}=artifact-archetypes" "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Java Package Archetypes --------------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=package-archetypes" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=package-archetypes-directed" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"
    archetype_python_reports "${ALGORITHM_PROJECTION}=package-archetypes" "${ALGORITHM_NODE}=Package" "${ALGORITHM_WEIGHT}=weight25PercentInterfaces" "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Java Type Archetypes -----------------------------------

if createUndirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-archetypes"; then
    createDirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-archetypes-directed"
    archetype_python_reports "${ALGORITHM_PROJECTION}=type-archetypes" "${ALGORITHM_NODE}=Type" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java"
    archetypes_treemap_charts "${ALGORITHM_LANGUAGE}=Java"
fi

# -- Typescript Module Archetypes ---------------------------

if createUndirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-archetypes" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"; then
    createDirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-archetypes-directed" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"
    archetype_python_reports "${ALGORITHM_PROJECTION}=typescript-module-archetypes" "${ALGORITHM_NODE}=Module" "${ALGORITHM_WEIGHT}=lowCouplingElement25PercentWeight" "${ALGORITHM_LANGUAGE}=Typescript"
    archetypes_treemap_charts "${ALGORITHM_LANGUAGE}=Typescript"
fi

# -- Markdown summary  ---------------------------

archetypes_treemap_charts_markdown_reference

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "archetypesPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."
