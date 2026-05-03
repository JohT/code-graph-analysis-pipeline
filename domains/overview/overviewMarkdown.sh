#!/usr/bin/env bash

# This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
# It is designed as an entry point and delegates the execution to the dedicated "overviewSummary.sh" script.

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.
# Note that "overviewCsv.sh" must have run at least once before this script
# to ensure CSV data files are present.

# Requires overviewSummary.sh

# Fail on any error and treat unset variables as errors
set -euo pipefail
IFS=$'\n\t'

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/overview" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "overviewMarkdown: OVERVIEW_SCRIPT_DIR=${OVERVIEW_SCRIPT_DIR}"

# Get the "summary" directory by taking the path of this script and selecting "summary".
OVERVIEW_SUMMARY_DIR=${OVERVIEW_SUMMARY_DIR:-"${OVERVIEW_SCRIPT_DIR}/summary"}

# Delegate the execution to the responsible script.
# SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${OVERVIEW_SUMMARY_DIR}/overviewSummary.sh"
