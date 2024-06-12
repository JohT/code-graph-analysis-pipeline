#!/usr/bin/env bash

# Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation.
# - Download and setup Neo4j and JQAssistant
# - Scan and analyze the contents of the artifacts and source directory to create the graph 
# - Trigger all requested reports

# Note: Everything is done in the current (=working) directory and one directory above (shared downloads). 
#       It is recommended to create an empty directory (preferable "temp") and
#       within that another one for the analysis (e.g. "MyCodebaseName-Version")
#       and change into it prior to starting this script.

# Note: The argument "--report" is optional. The default value is "All". 
#       It selects the report compilation, a named group of reports. Besides the default "All" there are e.g. "Csv" and "Jupyter".
#       This makes it possible to run only a subset of the reports. For example "Csv" won't need python to be set up and runs therefore much faster.
#       Implemented is this as a script in "scripts/reports/compilations" that starts with the report compilation name followed by "Reports.sh".

# Note: The argument "--profile" is optional. The default value is "Default". 
#       It selects a settings profile that sets all suitable variables for the analysis.
#       This makes it possible to run an analysis with e.g. Neo4j v4 instead of v5. Further profiles might come in future.
#       Implemented is this as a script in "scripts/profiles" that starts with the settings profile name followed by ".sh".

# Note: The argument "--explore" is optional. It is a switch that is deactivated by default.
#       It activates "explore" mode where no reports are executed and Neo4j keeps running (skip stop step).
#       This makes it easy to just set everything up but then use the running Neo4j server to explore the data manually.

# Note: The script and its sub scripts are designed to be as efficient as possible 
#       when it comes to subsequent executions.
#       Existing downloads, installations, scans and processes will be detected.

# Requires setupNeo4j.sh,setupJQAssistant.sh,startNeo4j.sh,resetAndScanChanged.sh,prepareAnalysis.sh,stopNeo4j.sh,comilations/*.sh,profiles/*.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable variables with directory names
REPORTS_SCRIPTS_DIRECTORY=${REPORTS_SCRIPTS_DIRECTORY:-"reports"} # Working directory containing the generated reports
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY=${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY:-"compilations"} # Repository directory that contains scripts that execute selected report generation scripts
SETTINGS_PROFILE_SCRIPTS_DIRECTORY=${SETTINGS_PROFILE_SCRIPTS_DIRECTORY:-"profiles"} # Repository directory that contains scripts containing settings
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Working directory containing the artifacts to be analyzed

# Function to display script usage
usage() {
  echo "Usage: $0 [--report <All (default), Csv, Jupyter,...>] [--profile <Default, Neo4jv5, Neo4jv4,...>] [--explore]"
  exit 1
}

# Default values
analysisReportCompilation="All"
settingsProfile="Default"
exploreMode=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --report)
      analysisReportCompilation="$2"
      shift
      ;;
    --profile)
      settingsProfile="$2"
      shift
      ;;
    --explore)
      exploreMode=true
      shift
      ;;
    *)
      echo "analyze: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Assure that the analysis report compilation only consists of letters and numbers
if ! [[ ${analysisReportCompilation} =~ ^[[:alnum:]]+$ ]]; then
  echo "analyze: Report can only contain letters and numbers."
  exit 1
fi

# Assure that the settings profile only consists of letters and numbers
if ! [[ ${settingsProfile} =~ ^[[:alnum:]]+$ ]]; then
  echo "analyze: Error: Settings profile can only contain letters and numbers."
  exit 1
fi

# Check if Neo4j is installed
if [ ! -d "${ARTIFACTS_DIRECTORY}" ] ; then
    echo "analyze: The ${ARTIFACTS_DIRECTORY} directory doesn't exist. Please download artifacts first."
    exit 1
fi

echo "analyze: analysisReportCompilation=${analysisReportCompilation}"
echo "analyze: settingsProfile=${settingsProfile}"
echo "analyze: exploreMode=${exploreMode}"

## Get this "scripts/analysis" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "analyze: ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${ANALYSIS_SCRIPT_DIR}")} # Repository directory containing the shell scripts
echo "analyze: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Assure that there is a report compilation script for the given report argument.
REPORT_COMPILATION_SCRIPT="${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY}/${analysisReportCompilation}Reports.sh"
if [ ! -f "${REPORT_COMPILATION_SCRIPT}" ] ; then
  echo "analyze: Error: No ${analysisReportCompilation}Reports.sh script in the directory ${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY} for report name ${analysisReportCompilation}."
  exit 1
fi

# Assure that there is a script file for the given settings profile name.
SETTINGS_PROFILE_SCRIPT="${SCRIPTS_DIR}/${SETTINGS_PROFILE_SCRIPTS_DIRECTORY}/${settingsProfile}.sh"
if [ ! -f "${SETTINGS_PROFILE_SCRIPT}" ] ; then
  echo "analyze: Error: No ${settingsProfile}.sh script in the directory ${SCRIPTS_DIR}/${SETTINGS_PROFILE_SCRIPTS_DIRECTORY} for settings profile ${settingsProfile}."
  exit 1
fi

# Execute the settings profile script that sets all the necessary settings variables (overrideable by environment variables).
echo "analyze: Using analysis settings profile script ${SETTINGS_PROFILE_SCRIPT}"
source "${SETTINGS_PROFILE_SCRIPT}"

# Setup Tools
source "${SCRIPTS_DIR}/setupNeo4j.sh"
source "${SCRIPTS_DIR}/setupJQAssistant.sh"
source "${SCRIPTS_DIR}/startNeo4j.sh"

# Scan and analyze artifacts when they were changed
source "${SCRIPTS_DIR}/resetAndScanChanged.sh"

# Prepare and validate graph database before analyzing and creating reports 
source "${SCRIPTS_DIR}/prepareAnalysis.sh"

if ${exploreMode}; then
  echo "analyze: Explore mode activated. Report generation will be skipped. Neo4j keeps running."
  exit 0
fi

#########################
# Create Reports
#########################
echo "analyze: Creating Reports with ${REPORT_COMPILATION_SCRIPT} ..."
source "${REPORT_COMPILATION_SCRIPT}"

# Stop Neo4j at the end
source "${SCRIPTS_DIR}/stopNeo4j.sh"