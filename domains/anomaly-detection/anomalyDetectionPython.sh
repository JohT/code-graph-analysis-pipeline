#!/usr/bin/env bash

# Pipeline that coordinates anomaly detection using the Graph Data Science Library of Neo4j.
# It requires an already running Neo4j graph database with already scanned and analyzed artifacts.
# The results will be written into the sub directory reports/anomaly-detection.
# Dynamically triggered by "PythonReports.sh".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires executeQueryFunctions.sh, projectionFunctions.sh, cleanupAfterReportGeneration.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

MARKDOWN_INCLUDES_DIRECTORY=${MARKDOWN_INCLUDES_DIRECTORY:-"includes"} # Subdirectory that contains Markdown files to be included by the Markdown template for the report.

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANOMALY_DETECTION_SCRIPT_DIR=${ANOMALY_DETECTION_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
echo "anomalyDetectionPython: ANOMALY_DETECTION_SCRIPT_DIR=${ANOMALY_DETECTION_SCRIPT_DIR}"
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/../../scripts"} # Repository directory containing the shell scripts
# Get the "cypher" query directory for gathering features.
ANOMALY_DETECTION_FEATURE_CYPHER_DIR=${ANOMALY_DETECTION_FEATURE_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/features"}
ANOMALY_DETECTION_QUERY_CYPHER_DIR=${ANOMALY_DETECTION_QUERY_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/queries"}
ANOMALY_DETECTION_LABEL_CYPHER_DIR=${ANOMALY_DETECTION_LABEL_CYPHER_DIR:-"${ANOMALY_DETECTION_SCRIPT_DIR}/labels"}

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
  value="${2}"

  case ${key} in
    --verbose)
      verboseMode="--verbose"
      ;;
    *)
      echo -e "${COLOR_ERROR}anomalyDetectionPython: Error: Unknown option: ${key}${COLOR_DEFAULT}" >&2
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Define functions to execute a cypher query from within a given file (first and only argument) like "execute_cypher"
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"

# Define functions to create and delete Graph Projections like "createUndirectedDependencyProjection"
source "${SCRIPTS_DIR}/projectionFunctions.sh"

# Define functions (like is_csv_column_greater_zero) to parse CSV format strings from Cypher query results.
source "${SCRIPTS_DIR}/parseCsvFunctions.sh"

is_sufficient_data_available() {
    language=$( extractQueryParameter "projection_language" "${@}" )
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    query_result=$( execute_cypher "${ANOMALY_DETECTION_QUERY_CYPHER_DIR}/AnomalyDetectionNodeCount.cypher" "${@}" )
    node_count=$(get_csv_column_value "${query_result}" "node_count")
    if [ "${node_count}" -lt 15 ]; then
        echo "anomalyDetectionPython: Warning: Skipping anomaly detection. Only ${node_count} ${language} ${nodeLabel} nodes. At least 15 required."
        false
    else
        echo "anomalyDetectionPython: Info: Running anomaly detection with ${node_count} ${language} ${nodeLabel} nodes."
        true
    fi
}

# Query or recalculate features.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
anomaly_detection_features() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Collecting features for ${nodeLabel} nodes..."

    # Determine the Betweenness centrality (with the directed graph projection) if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Betweenness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Betweenness-Write.cypher" "${@}"
    # Determine the local clustering coefficient if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-LocalClusteringCoefficient-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-LocalClusteringCoefficient-Write.cypher" "${@}"
    # Determine the page rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageRank-Write.cypher" "${@}"
    # Determine the article rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-ArticleRank-Write.cypher" "${@}"
    # Determine the normalized difference between Page Rank and Article Rank if not already done
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-PageToArticleRank-Write.cypher" "${@}"
    # Determine the "abstractness" (interfaces = 100%, abstract classes = 70%, classes & functions = 0%)
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_Java.cypher" "${@}"
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_JavaType.cypher" "${@}"
    execute_cypher_queries_until_results "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature-Abstractness-Exists.cypher" \
                                         "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeature_Abstractness_TypeScriptModules.cypher" "${@}"
}

# Execute the Python scripts for anomaly detection.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
anomaly_detection_using_python() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Executing Python scripts for ${language} ${nodeLabel} nodes..."

    # Within the absolute (full) report directory for anomaly detection, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    # Get tuned Leiden communities as a reference to tune clustering
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/tunedLeidenCommunityDetection.py" "${@}" ${verboseMode}
    # Tuned Fast Random Projection and tuned HDBSCAN clustering 
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/tunedNodeEmbeddingClustering.py" "${@}" ${verboseMode}
    # Reduce the dimensionality of the node embeddings down to 2D for visualization using UMAP
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/umap2dNodeEmbeddings.py" "${@}" ${verboseMode}
    # Plot the results with clustering and UMAP embeddings to reveal anomalies in rare feature combinations
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/anomalyDetectionFeaturePlots.py" "${@}" "--report_directory" "${detail_report_directory}" ${verboseMode}
    # Run an unsupervised anomaly detection algorithm including tuning and explainability
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/tunedAnomalyDetectionExplained.py" "${@}" "--report_directory" "${detail_report_directory}" ${verboseMode}
    # Query Results: Output all collected features into a CSV file.
    execute_cypher "${ANOMALY_DETECTION_FEATURE_CYPHER_DIR}/AnomalyDetectionFeatures.cypher" "${@}" > "${detail_report_directory}/Anomaly_Features.csv"
}

# Label code units with top anomalies by archetype.
# 
# Required Parameters:
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_labels() {
    local nodeLabel
    nodeLabel=$( extractQueryParameter "projection_node_label" "${@}" )
    
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )

    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Labelling ${language} ${nodeLabel} anomalies..."
    
    # Within the absolute (full) report directory for anomaly detection, create a sub directory for every detailed type (Java_Package, Java_Type,...)
    local detail_report_directory="${FULL_REPORT_DIRECTORY}/${language}_${nodeLabel}"
    mkdir -p "${detail_report_directory}"

    execute_cypher_summarized "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeRemoveLabels.cypher" "${@}"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeAuthority.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopAuthority.csv"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeBottleneck.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopBottleneck.csv"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeHub.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopHub.csv"
    # The following two label types require Python scripts to run first.
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeBridge.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopBridge.csv"
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionArchetypeOutlier.cypher" "${@}" > "${detail_report_directory}/AnomalyArchetypeTopOutlier.csv"
    # Output the top anomalies and their archetype + rank
    execute_cypher "${ANOMALY_DETECTION_LABEL_CYPHER_DIR}/AnomalyDetectionTopAnomalies.cypher" "${@}" > "${detail_report_directory}/TopAnomalies.csv"

}

# Run the anomaly detection pipeline.
# 
# Required Parameters:
# - projection_name=...
#   Name prefix for the in-memory projection name. Example: "package-anomaly-detection"
# - projection_node_label=...
#   Label of the nodes that will be used for the projection. Example: "Package"
# - projection_weight_property=...
#   Name of the node property that contains the dependency weight. Example: "weight"
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_python_reports() {
    time anomaly_detection_features "${@}"
    anomaly_detection_using_python "${@}"
    time anomaly_detection_labels "${@}"
}

# Creates the markdown file (to be included in the main summary) 
# that contains the references to all treemap charts.
anomaly_detection_treemap_charts_markdown_reference() {

    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting treemap charts markdown reference generation..."

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

    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished treemap charts markdown reference generation..."
}

# Visualize results with treemap charts.
# 
# Required Parameters:
# - projection_language=...
#   Name of the associated programming language. Examples: "Java", "Typescript"
anomaly_detection_treemap_charts() {
    local language
    language=$( extractQueryParameter "projection_language" "${@}" )
    
    echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Visualizing ${language} results..."
    time "${ANOMALY_DETECTION_SCRIPT_DIR}/treemapVisualizations.py" "${@}" "--report_directory" "${FULL_REPORT_DIRECTORY}" ${verboseMode}
}

# Create report directory
REPORT_NAME="anomaly-detection"
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

# Code independent algorithm parameters
COMMUNITY_PROPERTY="community_property=communityLeidenIdTuned"
EMBEDDING_PROPERTY="embedding_property=embeddingsFastRandomProjectionTunedForClustering"

# -- Java Artifact Node Embeddings -------------------------------

if is_sufficient_data_available "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_WEIGHT}=weight"; then
  if createUndirectedDependencyProjection "${PROJECTION_NAME}=artifact-anomaly-detection" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"; then
      createDirectedDependencyProjection "${PROJECTION_NAME}=artifact-anomaly-detection-directed" "${PROJECTION_NODE}=Artifact" "${PROJECTION_WEIGHT}=weight" "${PROJECTION_LANGUAGE}=Java"
      anomaly_detection_python_reports "${ALGORITHM_PROJECTION}=artifact-anomaly-detection" "${ALGORITHM_NODE}=Artifact" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
  fi
fi

# -- Java Package Node Embeddings --------------------------------

if is_sufficient_data_available "${ALGORITHM_NODE}=Package" "${ALGORITHM_WEIGHT}=weight25PercentInterfaces"; then
  if createUndirectedDependencyProjection "${PROJECTION_NAME}=package-anomaly-detection" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"; then
      createDirectedDependencyProjection "${PROJECTION_NAME}=package-anomaly-detection-directed" "${PROJECTION_NODE}=Package" "${PROJECTION_WEIGHT}=weight25PercentInterfaces" "${PROJECTION_LANGUAGE}=Java"
      anomaly_detection_python_reports "${ALGORITHM_PROJECTION}=package-anomaly-detection" "${ALGORITHM_NODE}=Package" "${ALGORITHM_WEIGHT}=weight25PercentInterfaces" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
  fi
fi

# -- Java Type Node Embeddings -----------------------------------

if is_sufficient_data_available "${ALGORITHM_NODE}=Type" "${ALGORITHM_WEIGHT}=weight"; then
  if createUndirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-anomaly-detection"; then
      createDirectedJavaTypeDependencyProjection "${PROJECTION_NAME}=type-anomaly-detection-directed"
      anomaly_detection_python_reports "${ALGORITHM_PROJECTION}=type-anomaly-detection" "${ALGORITHM_NODE}=Type" "${ALGORITHM_WEIGHT}=weight" "${ALGORITHM_LANGUAGE}=Java" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
      anomaly_detection_treemap_charts "${ALGORITHM_LANGUAGE}=Java"
  fi
fi

# -- Typescript Module Node Embeddings ---------------------------

if is_sufficient_data_available "${ALGORITHM_NODE}=Module" "${ALGORITHM_WEIGHT}=lowCouplingElement25PercentWeight"; then
  if createUndirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-embedding" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"; then
      createDirectedDependencyProjection "${PROJECTION_NAME}=typescript-module-embedding-directed" "${PROJECTION_NODE}=Module" "${PROJECTION_WEIGHT}=lowCouplingElement25PercentWeight" "${PROJECTION_LANGUAGE}=Typescript"
      anomaly_detection_python_reports "${ALGORITHM_PROJECTION}=typescript-module-embedding" "${ALGORITHM_NODE}=Module" "${ALGORITHM_WEIGHT}=lowCouplingElement25PercentWeight" "${ALGORITHM_LANGUAGE}=Typescript" "${COMMUNITY_PROPERTY}" "${EMBEDDING_PROPERTY}"
      anomaly_detection_treemap_charts "${ALGORITHM_LANGUAGE}=Module"
  fi
fi

# -- Markdown summary  ---------------------------

anomaly_detection_treemap_charts_markdown_reference

# ---------------------------------------------------------------

# Clean-up after report generation. Empty reports will be deleted.
source "${SCRIPTS_DIR}/cleanupAfterReportGeneration.sh" "${FULL_REPORT_DIRECTORY}"

echo "anomalyDetectionPython: $(date +'%Y-%m-%dT%H:%M:%S%z') Successfully finished."