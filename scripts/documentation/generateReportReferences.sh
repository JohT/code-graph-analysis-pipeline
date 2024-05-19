#!/usr/bin/env bash

# Triggers the regeneration of all reference documentations for the reports inside the "results" directory.
# The generation to the reference documentations is delegated to the dedicated scripts.

# Notice that this scripts needs to be executed within the "results" directory.

# Requires generateJupyterReportReference.sh, generateCsvReportReference.sh, generateImageReference.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
DOCUMENTATION_SCRIPT_DIR=${DOCUMENTATION_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "generateReportReferences: SCRIPTS_DIR=${DOCUMENTATION_SCRIPT_DIR}"

# Generate JUPYTER_REPORTS.md containing a reference to all Jupyter Notebook Markdown reports in the "results" directory and its subdirectories.
source "${DOCUMENTATION_SCRIPT_DIR}/generateJupyterReportReference.sh"

# Generate CSV_REPORTS.md containing a reference to all CSV cypher query reports in the "results" directory and its subdirectories.
source "${DOCUMENTATION_SCRIPT_DIR}/generateCsvReportReference.sh"

# Generate IMAGES.md containing a reference to all PNG images in the "results" directory and its subdirectories.
source "${DOCUMENTATION_SCRIPT_DIR}/generateImageReference.sh"