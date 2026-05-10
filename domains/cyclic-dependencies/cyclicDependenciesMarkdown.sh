#!/usr/bin/env bash

# This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
# It is designed as an entry point and delegates the execution to the dedicated "cyclicDependenciesSummary.sh" script that does the "heavy lifting".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires cyclicDependenciesSummary.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/cyclic-dependencies" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "cyclicDependenciesMarkdown: CYCLIC_DEPENDENCIES_SCRIPT_DIR=${CYCLIC_DEPENDENCIES_SCRIPT_DIR}"

# Get the "summary" directory by taking the path of this script and selecting "summary".
CYCLIC_DEPENDENCIES_SUMMARY_DIR=${CYCLIC_DEPENDENCIES_SUMMARY_DIR:-"${CYCLIC_DEPENDENCIES_SCRIPT_DIR}/summary"} # Contains everything (scripts, queries, templates) to create the Markdown summary report for cyclic dependencies

# Delegate the execution to the responsible script.
source "${CYCLIC_DEPENDENCIES_SUMMARY_DIR}/cyclicDependenciesSummary.sh"
