#!/usr/bin/env bash

# Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation.
# - Download and setup Neo4j and JQAssistant
# - Trigger artifacts download
# - Scan and analyze the artifacts to create the graph 
# - Trigger all requested reports

# Note: Everything is done in the current directory. 
#       It is recommended to create an empty directory (preferrable "temp") 
#       and change into it prior to starting this script.

# Note: The argument "--name" is requried. It is used to create the working directory 
#       as well as to find the script "scripts/artifacts/download<name>.sh" to download the artifacts.

# Note: The argument "--version" is also required. 
#       It is appended to the working directory to further distinguish the results.
#       The version is passed to the artifacts download script as an argument.

# Note: The argument "--report" is optional. The default value is "All". 
#       It selects the report compilation, a named group of reports. Besides the default "All" there are e.g. "Csv" and "Jupyter".
#       This makes it possible to run only a subset of the reports. For example "Csv" won't need python to be set up and runs therefore much faster.
#       Implemented is this as a script in "scripts/reports/compilations" that starts with the report compilation name followed by "Reports.sh".

# Note: The argument "--profile" is optional. The default value is "Default". 
#       It selects a settings profile that sets all suitable variables for the analysis.
#       This makes it possible to run an analysis with e.g. Neo4j v4 instead of v5. Further profiles might come in future.
#       Implemented is this as a script in "scripts/profiles" that starts with the settings profile name followed by ".sh".

# Note: The script and its sub scripts are designed to be as efficient as possible 
#       when it comes to subsequent executions.
#       Existing downloads, installations, artifacts, scans and processes will be detected.

# Overrideable variables with directory names
ARTIFACT_SCRIPTS_DIRECTORY=${ARTIFACT_SCRIPTS_DIRECTORY:-"artifacts"}
REPORTS_SCRIPTS_DIRECTORY=${REPORTS_SCRIPTS_DIRECTORY:-"reports"}
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY=${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY:-"compilations"}
SETTINGS_PROFILE_SCRIPTS_DIRECTORY=${SETTINGS_PROFILE_SCRIPTS_DIRECTORY:-"profiles"}

# Function to display script usage
usage() {
  echo "Usage: $0 --name <name> --version <version> [--report <All (default), Csv, Jupyter,...>] [--profile <default, neo4jv5, neo4jv4,...>]"
  exit 1
}

# Default values
analysisReportCompilation="All"
settingsProfile="default"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --name)
      analysisName="${2}"
      shift
      ;;
    --version)
      analysisVersion="$2"
      shift
      ;;
    --report)
      analysisReportCompilation="$2"
      shift
      ;;
    --profile)
      settingsProfile="$2"
      shift
      ;;
    *)
      echo "analyze: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift
done

# Check if the name is provided
if [[ -z ${analysisName} ]]; then
  echo "analyze ${analysisName}: Error: Name is required."
  usage
fi

# Check if the version is provided
if [[ -z ${analysisVersion} ]]; then
  echo "analyze ${analysisName}: Error: Version is required."
  usage
fi

# Assure that the analysis name only consists of letters and numbers
if ! [[ ${analysisName} =~ ^[[:alnum:]]+$ ]]; then
  echo "analyze ${analysisName}: Error: Name can only contain letters and numbers."
  exit 1
fi

# Assure that the analysis report compilation only consists of letters and numbers
if ! [[ ${analysisReportCompilation} =~ ^[[:alnum:]]+$ ]]; then
  echo "analyze ${analysisName}: Report can only contain letters and numbers."
  exit 1
fi

# Assure that the settings profile only consists of letters and numbers
if ! [[ ${settingsProfile} =~ ^[[:alnum:]]+$ ]]; then
  echo "analyze ${analysisName}: Error: Settings profile can only contain letters and numbers."
  exit 1
fi

## Get this "scripts/analysis" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "analyze ${analysisName}: ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${ANALYSIS_SCRIPT_DIR}")}
echo "analyze ${analysisName}: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Assure that there is a download script for the given analysis name argument.
DOWNLOAD_SCRIPT="${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY}/download${analysisName}.sh"
if [ ! -f "${DOWNLOAD_SCRIPT}" ] ; then
  echo "analyze ${analysisName}: Error: No download${analysisName}.sh script in the directory ${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY} for analysis name ${analysisName}."
  exit 1
fi

# Assure that there is a report compilation script for the given report argument.
REPORT_COMPILATION_SCRIPT="${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY}/${analysisReportCompilation}Reports.sh"
if [ ! -f "${REPORT_COMPILATION_SCRIPT}" ] ; then
  echo "analyze ${analysisName}: Error: No ${analysisReportCompilation}Reports.sh script in the directory ${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY} for report name ${analysisReportCompilation}."
  exit 1
fi

# Assure that there is a script file for the given settings profile name.
SETTINGS_PROFILE_SCRIPT="${SCRIPTS_DIR}/${SETTINGS_PROFILE_SCRIPTS_DIRECTORY}/${settingsProfile}.sh"
if [ ! -f "${SETTINGS_PROFILE_SCRIPT}" ] ; then
  echo "analyze ${analysisName}: Error: No ${settingsProfile}.sh script in the directory ${SCRIPTS_DIR}/${SETTINGS_PROFILE_SCRIPTS_DIRECTORY} for settings profile ${settingsProfile}."
  exit 1
fi

# Execute the settings profile script that sets all the neccessary settings variables (overrideable by environment variables).
echo "analyze ${analysisName}: Using analysis settings profile script ${SETTINGS_PROFILE_SCRIPT}"
source "${SETTINGS_PROFILE_SCRIPT}" || exit 1

# Create working directory if it hadn't been created yet
workingDirectory="${analysisName}-${analysisVersion}"
mkdir -p "${workingDirectory}" || exit 2 # Create the working directory only if it doesn't exist
pushd "${workingDirectory}" || exit 2 # Change into the working directory and remember the previous directory
echo "analyze ${analysisName}: Working Directory: $( pwd -P )"

# Setup Tools
source "${SCRIPTS_DIR}/setupNeo4j.sh" || exit 3
source "${SCRIPTS_DIR}/setupJQAssistant.sh" || exit 3
source "${SCRIPTS_DIR}/startNeo4j.sh" || exit 3

# Execute the script "scripts/artifacts/download<analysisName" to download the artifacts that should be analyzed
echo "Downloading artifacts with ${DOWNLOAD_SCRIPT} ..."
source "${DOWNLOAD_SCRIPT}" "${analysisVersion}" || exit 4

# Scan and analyze artifacts when they were changed
source "${SCRIPTS_DIR}/resetAndScanChanged.sh" || exit 5

# Prepare and validate graph database before analyzing and creating reports 
source "${SCRIPTS_DIR}/prepareAnalysis.sh" || exit 6

#########################
# Create Reports
#########################
echo "Creating Reports with ${REPORT_COMPILATION_SCRIPT} ..."
source "${REPORT_COMPILATION_SCRIPT}" || exit 7

# Stop Neo4j at the end
source "${SCRIPTS_DIR}/stopNeo4j.sh"

# Change back to the previous directory where the script was started
popd || exit 8