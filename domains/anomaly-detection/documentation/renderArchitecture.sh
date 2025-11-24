#!/usr/bin/env bash

# Renders the described Graph in Architecture.gv as a SVG image.
#
# Requires renderGraphVizSVG.sh
#
# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANOMALY_DETECTION_DOCS_DIR=${ANOMALY_DETECTION_DOCS_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)} # Directory containing documentation for the anomaly detection
# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-"${ANOMALY_DETECTION_DOCS_DIR}/../../../scripts"} # Repository directory containing the shell scripts
# Get the "scripts/visualization" directory.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-"${SCRIPTS_DIR}/visualization"} # Repository directory containing the shell scripts for visualization

source "${VISUALIZATION_SCRIPTS_DIR}/renderGraphVizSVG.sh" "${ANOMALY_DETECTION_DOCS_DIR}/Architecture.gv"