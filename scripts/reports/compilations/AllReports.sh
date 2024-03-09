#!/usr/bin/env bash

# Runs all report scripts.
# It only consideres scripts in the "reports" directory (overridable with REPORTS_SCRIPT_DIR) one directory above this one.

# Requires reports/*.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "AllReports: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"

# The reports will not be generically searched as files anymore.
# Instead, they will be processed in order. Especially the visualization
# needs to be done as a last step to be able to use properties
# and data written to the Graph in the CsvReports.
# Additionally, Jupyter notebooks can then use precalculated properties from
# the CSV reports. The drawback of this approach is that the introduced
# dependencies take away the self-containment of those reports and make it
# then hard to parallelize them. So if coupling can be prevented, it still should.
source "${REPORT_COMPILATIONS_SCRIPT_DIR}/CsvReports.sh"
source "${REPORT_COMPILATIONS_SCRIPT_DIR}/JupyterReports.sh"
source "${REPORT_COMPILATIONS_SCRIPT_DIR}/VisualizationReports.sh"