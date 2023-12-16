#!/usr/bin/env bash

# Runs all Visualization reports.
# It only consideres scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.
# These require node.js.
# Therefore these reports will take longer and require more ressources than just plain database queries/procedures.

# Requires reports/*.sh
# Needs to run after reports/TopologySortCsv.sh that provides the property "topologicalSortIndex" to be queried.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "VisualizationReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
echo "VisualizationReports: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"

# Run all report scripts
for report_script_file in "${REPORTS_SCRIPT_DIR}"/*Visualization.sh; do 
    echo "VisualizationReports: Starting ${report_script_file}..."; 
    source "${report_script_file}"
done
