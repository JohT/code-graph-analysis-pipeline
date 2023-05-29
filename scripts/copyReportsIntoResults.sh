#!/usr/bin/env bash

# Copies the results from the temp directory to the results directory grouped by the analysis name.
# Takes the "results" directories within the "temp" directory (e.g. "temp/Analysis1/reports", "temp/Analysis2/reports")
# and copies them into the "results" directory preserving their surrounding directory (e.g. "results/Analysis1", "results/Analysis2").

# Notice that this scripts needs to be executed within the "temp" directory.

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "copyReportsIntoResults: SCRIPTS_DIR=$SCRIPTS_DIR"

RESULTS_DIRECTORY=${RESULTS_DIRECTORY:-"results"}
echo "copyReportsIntoResults: RESULTS_DIRECTORY=${RESULTS_DIRECTORY}"

# Create the results directory if it is missing
mkdir -p "./../${RESULTS_DIRECTORY}"

# Move all reports directories to the results directory preserving their surrounding directory
for report_source_folder in **/reports; do 
    reportTargetDirectory="./../${RESULTS_DIRECTORY}/$(dirname -- "${report_source_folder}")"
    cp -RpPf "${report_source_folder}" "${reportTargetDirectory}"
done

# Generate REPORTS.md containing a reference to all Markdown Reports in the "results" directory and its subdirectories.
(cd "./../${RESULTS_DIRECTORY}" && exec "${SCRIPTS_DIR}/generateMarkdownReference.sh")