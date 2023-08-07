#!/usr/bin/env bash

# Creates the "graph-visualization" report (ipynb, md, pdf) based on the Jupyter Notebook "ArtifactDependencies.ipynb".
# It contains the hierarchical artifact dependencies graph

# Requires executeJupyterNotebook.sh

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "GraphVisualization: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${REPORTS_SCRIPT_DIR}/.."} # Repository directory containing the shell scripts
echo "GraphVisualization: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "graph-visualization" directory by taking the path of this script and going two directory up and then to "visualization".
GRAPH_VISUALIZATION_DIRECTORY=${GRAPH_VISUALIZATION_DIRECTORY:-"${SCRIPTS_DIR}/../graph-visualization"} # Repository directory containing the Jupyter Notebooks
echo "GraphVisualization: GRAPH_VISUALIZATION_DIRECTORY=$GRAPH_VISUALIZATION_DIRECTORY"

# Execute the node.js script to render the graph visualizations as image files
(cd "${REPORTS_DIRECTORY}" && exec node ${GRAPH_VISUALIZATION_DIRECTORY}/renderVisualizations.js) || exit 1