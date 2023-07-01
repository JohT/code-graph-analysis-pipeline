#!/usr/bin/env bash

# Executes "resetAndScan.sh" only if "detectChangedArtifacts.sh" returns detected changes.

# Note: "resetAndScan" expects jQAssistant to be installed in the "tools" directory.

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "resetAndScanChanged SCRIPTS_DIR=$SCRIPTS_DIR"

# Scan and analyze Artifacts when they were changed
changeDetectionReturnCode=$( source "$SCRIPTS_DIR/detectChangedArtifacts.sh" )
if [[ "${changeDetectionReturnCode}" == "0" ]] ; then
    echo "resetAndScanChanged: Artifacts unchanged. Scan skipped."
else
    echo "resetAndScanChanged: Detected change (${changeDetectionReturnCode}). Resetting database and scanning artifacts."
    source "${SCRIPTS_DIR}/resetAndScan.sh"
fi