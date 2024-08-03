#!/usr/bin/env bash

# Executes "resetAndScan.sh" only if "detectChangedArtifacts.sh" returns detected changes.

# Note: "resetAndScan" expects jQAssistant to be installed in the "tools" directory.

# Requires resetAndScan.sh, copyPackageJsonFiles.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "resetAndScanChanged SCRIPTS_DIR=${SCRIPTS_DIR}"

# Prepare scan
source "${SCRIPTS_DIR}/copyPackageJsonFiles.sh"

# Scan and analyze Artifacts when they were changed
changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedArtifacts.sh" --readonly)
if [[ "${changeDetectionReturnCode}" == "0" ]] ; then
    echo "resetAndScanChanged: Artifacts unchanged. Scan skipped."
else
    echo "resetAndScanChanged: Detected change (${changeDetectionReturnCode}). Resetting database and scanning artifacts."
    source "${SCRIPTS_DIR}/resetAndScan.sh"
    changeDetectionReturnCode=$( source "${SCRIPTS_DIR}/detectChangedArtifacts.sh")
fi