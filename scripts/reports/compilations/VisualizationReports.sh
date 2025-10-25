#!/usr/bin/env bash

# Runs all Visualization reports.
# It only consideres scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.
# These require node.js.
# Therefore these reports will take longer and require more resources than just plain database queries/procedures.

# Requires reports/*.sh
# Needs to run after reports/TopologySortCsv.sh that provides the property "topologicalSortIndex" to be queried.

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
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY:-"${REPORTS_SCRIPT_DIR}/../../domains"}

# For detailed debug output uncomment the following lines:
#echo "${LOG_GROUP_START}Initialize Visualization Reports";
#echo "VisualizationReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"
#echo "VisualizationReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"
#echo "VisualizationReports: DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY}"
#echo "${LOG_GROUP_END}";

# Run all visualization scripts (filename ending with Visualization.sh) in the REPORTS_SCRIPT_DIR and DOMAINS_DIRECTORY directories.
for directory in "${REPORTS_SCRIPT_DIR}" "${DOMAINS_DIRECTORY}"; do
    if [ ! -d "${directory}" ]; then
        echo "PythonReports: Error: Directory ${directory} does not exist. Please check your REPORTS_SCRIPT_DIR and DOMAIN_DIRECTORY settings."
        exit 1
    fi

    # Run all visualization scripts in the selected directory.
    find "${directory}" -type f -name "*Visualization.sh" | sort | while read -r visualization_script_file; do
        visualization_script_filename=$(basename -- "${visualization_script_file}")
        visualization_script_filename="${visualization_script_filename%.*}" # Remove file extension

        echo "${LOG_GROUP_START}Create Visualization Report ${visualization_script_filename}";
        echo "VisualizationReports: $(date +'%Y-%m-%dT%H:%M:%S%z') Starting ${visualization_script_filename}...";

        source "${visualization_script_file}"

        echo "VisualizationReports: $(date +'%Y-%m-%dT%H:%M:%S%z') Finished ${visualization_script_filename}";
        echo "${LOG_GROUP_END}";
    done
done
