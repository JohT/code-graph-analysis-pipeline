#!/usr/bin/env bash

# Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation.
# - Download and setup Neo4j and JQAssistant
# - Trigger artifacts download
# - Scan and analyze the artifacts to create the graph 
# - Trigger all requested reports

# Note: Everything is done in the current directory. 
#       It is recommended to create an empty directory (preferrable "temp") 
#       and change into it prior to starting this script.

# Note: The first argument "--name" is requried. It is used to create the working directory 
#       as well as to find the script "scripts/artifacts/download<name>.sh" to download the artifacts.

# Note: The second argument "--version" is optional. 
#       It is appended to the working directory to further distinguish the results.

# Note: The script and its sub scripts are designed to be as efficient as possible 
#       when it comes to subsequent executions.
#       Existing downloads, installations, artifacts, scans and processes will be detected.

# Overrideable environment variables (optional, defaults also defined in sub scripts where needed)
NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.9.0"}
JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.0.3"} # 2.0.3 is the newest version (june 2023) compatible with Neo4j v5

# Overrideable environment variables for ports (optional, defaults also defined in sub scripts where needed)
# Override them if you need to run multiple neo4j database servers in parallel.
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} 
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"}
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"}
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/neo4j/tx/commit"} # Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit",

# Overrideable environment variables for the Neo4j APOC plugin (optional, defaults also defined in sub scripts where needed)
# Override them if you want to use Neo4j v4 instead of v5
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"core"} #Awesome Procedures for Neo4j Plugin Edition (Neo4j v4.4.x "all", Neo4j >= v5 "core")
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j/apoc"} #Awesome Procedures for Neo4j Plugin GitHub User/Repository (Neo4j v4.4.x "neo4j-contrib/neo4j-apoc-procedures", Neo4j >= v5 "neo4j/apoc")

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.4.0"} # Graph Data Science Plugin Version 2.4.x of is compatible with Neo4j 5.x

ARTIFACT_SCRIPTS_DIRECTORY=${ARTIFACT_SCRIPTS_DIRECTORY:-"artifacts"}
REPORTS_SCRIPTS_DIRECTORY=${REPORTS_SCRIPTS_DIRECTORY:-"reports"}
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY=${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY:-"compilations"}

# Function to display script usage
usage() {
  echo "Usage: $0 --name <name> --version <version> [--report <All (default), Csv, Jupyter,...>]"
  exit 1
}

# Default values
analysisReportCompilation="All"

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
    *)
      echo "Error (analyze): Unknown option: ${key}"
      usage
      ;;
  esac
  shift
done

# Check if the name is provided
if [[ -z ${analysisName} ]]; then
  echo "Error (analyze): Name is required."
  usage
fi

# Check if the version is provided
if [[ -z ${analysisVersion} ]]; then
  echo "Error (analyze): Version is required."
  usage
fi

# Assure that the analysis name only consists of letters and numbers
if ! [[ ${analysisName} =~ ^[[:alnum:]]+$ ]]; then
  echo "Error (analyze): Name can only contain letters and numbers."
  exit 1
fi

# Assure that the analysis report compilation only consists of letters and numbers
if ! [[ ${analysisReportCompilation} =~ ^[[:alnum:]]+$ ]]; then
  echo "Error (analyze): Report can only contain letters and numbers."
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

# Assure that there is a download script for the given analysis name.
if [ ! -f "${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY}/download${analysisName}.sh" ] ; then
  echo "Error (analyze): No download${analysisName}.sh script in the directory ${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY} for analysis name ${analysisName}."
  exit 1
fi

# Assure that there is a download script for the given analysis name argument.
DOWNLOAD_SCRIPT="${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY}/download${analysisName}.sh"
if [ ! -f "${DOWNLOAD_SCRIPT}" ] ; then
  echo "Error (analyze): No download${analysisName}.sh script in the directory ${SCRIPTS_DIR}/${ARTIFACT_SCRIPTS_DIRECTORY} for analysis name ${analysisName}."
  exit 1
fi

# Assure that there is a report compilation script for the given report argument.
REPORT_COMPILATION_SCRIPT="${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY}/${analysisReportCompilation}Reports.sh"
if [ ! -f "${REPORT_COMPILATION_SCRIPT}" ] ; then
  echo "Error (analyze): No ${analysisReportCompilation}Reports.sh script in the directory ${SCRIPTS_DIR}/${REPORTS_SCRIPTS_DIRECTORY}/${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY} for report name ${analysisReportCompilation}."
  exit 1
fi

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