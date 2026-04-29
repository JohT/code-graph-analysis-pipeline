#!/usr/bin/env bash

# This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
# It is designed as an entry point and delegates the execution to the dedicated "graphAlgorithmsSummary.sh" script.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "centralityCsv.sh" and "communityCsv.sh" must have run at least once before this script
# to ensure the centralityPageRank, centralityBetweenness, and communityLeidenId properties are written.

# Requires graphAlgorithmsSummary.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/graph-algorithms" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "graphAlgorithmsMarkdown: GRAPH_ALGORITHMS_SCRIPT_DIR=${GRAPH_ALGORITHMS_SCRIPT_DIR}"

# Get the "summary" directory by taking the path of this script and selecting "summary".
GRAPH_ALGORITHMS_SUMMARY_DIR=${GRAPH_ALGORITHMS_SUMMARY_DIR:-"${GRAPH_ALGORITHMS_SCRIPT_DIR}/summary"}

# Delegate the execution to the responsible script.
# SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${GRAPH_ALGORITHMS_SUMMARY_DIR}/graphAlgorithmsSummary.sh"
