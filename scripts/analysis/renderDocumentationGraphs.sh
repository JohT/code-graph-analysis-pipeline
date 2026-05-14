#!/usr/bin/env bash

# Renders all documentation graphs (.gv files) as SVG images.
#
# Renders:
# - analysis_process_graph.gv
# - getting_started_flow.gv
#
# Requires renderGraphVizSVG.sh
#
# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

## Get this "scripts/analysis" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANALYSIS_DIR=${ANALYSIS_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)} # Directory containing analysis scripts
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANALYSIS_DIR}/.."} # Repository directory containing the shell scripts
# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization

# Render analysis process graph
echo "Rendering analysis process graph..."
source "${VISUALIZATION_SCRIPTS_DIR}/renderGraphVizSVG.sh" "${ANALYSIS_DIR}/analysis_process_graph.gv"

# Render getting started flow diagram
echo "Rendering getting started flow diagram..."
source "${VISUALIZATION_SCRIPTS_DIR}/renderGraphVizSVG.sh" "${ANALYSIS_DIR}/getting_started_flow.gv"

echo "Done! All documentation graphs have been rendered."
