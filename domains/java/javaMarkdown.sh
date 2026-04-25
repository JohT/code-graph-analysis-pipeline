#!/usr/bin/env bash

# This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
# It is designed as an entry point and delegates the execution to the dedicated "javaSummary.sh" script that does the "heavy lifting".

# Note that "scripts/prepareAnalysis.sh" is required to run prior to this script.

# Requires javaSummary.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exit on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
REPORTS_DIRECTORY=${REPORTS_DIRECTORY:-"reports"}

## Get this "domains/java" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution.
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR:-$(CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
# echo "javaMarkdown: JAVA_SCRIPT_DIR=${JAVA_SCRIPT_DIR}"

# Get the "summary" directory by taking the path of this script and selecting "summary".
JAVA_SUMMARY_DIR=${JAVA_SUMMARY_DIR:-"${JAVA_SCRIPT_DIR}/summary"} # Contains everything (scripts, templates) to create the Markdown summary report

# Delegate the execution to the responsible script.
# SC1091: sourced file is a co-located domain script resolved at runtime via a variable path
# shellcheck disable=SC1091
source "${JAVA_SUMMARY_DIR}/javaSummary.sh"
