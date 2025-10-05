#!/usr/bin/env bash

# Runs all Markdown report scripts (no Chromium required, no Python required).
# It only considers scripts in the "reports" and "domains" directories and their sub directories (overridable with REPORTS_SCRIPT_DIR and DOMAINS_DIRECTORY).

# Requires reports/*.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"} # Prefix to start a log group. Defaults to GitHub Actions log group start command.
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"} # Prefix to end a log group. Defaults to GitHub Actions log group end command.

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "MarkdownReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
echo "MarkdownReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${REPORTS_SCRIPT_DIR}")}
echo "MarkdownReports: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "domains" directory that contains analysis and report scripts by functionality.
DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY:-"${REPORTS_SCRIPT_DIR}/../../domains"}
echo "MarkdownReports: DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY}"

# Run all Markdown report scripts (filename ending with Markdown.sh or Summary.sh) in the REPORTS_SCRIPT_DIR and DOMAINS_DIRECTORY directories.
for directory in "${REPORTS_SCRIPT_DIR}" "${DOMAINS_DIRECTORY}"; do
    if [ ! -d "${directory}" ]; then
        echo "MarkdownReports: Error: Directory ${directory} does not exist. Please check your REPORTS_SCRIPT_DIR and DOMAIN_DIRECTORY settings."
        exit 1
    fi

    # Run all Python report scripts for the selected directory.
    find "${directory}" -type f -name "*Markdown.sh" | sort | while read -r report_script_file; do
        report_script_filename=$(basename -- "${report_script_file}");
        report_script_filename="${report_script_filename%.*}" # Remove file extension

        echo "${LOG_GROUP_START}Create Markdown Report ${report_script_filename}";
        echo "MarkdownReports: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting ${report_script_filename}...";

        source "${report_script_file}"

        echo "MarkdownReports: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished ${report_script_filename}";
        echo "${LOG_GROUP_END}";
    done
done
