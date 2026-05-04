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
#       It selects the report compilation, a named group of reports. Besides the default "All" there are e.g. "Csv" and "Markdown".
#       This makes it possible to run only a subset of the reports. For example "Csv" won't need python to be set up and runs therefore much faster.
#       Implemented is this as a script in "scripts/reports/compilations" that starts with the report compilation name followed by "Reports.sh".

# Note: The argument "--profile" is optional. The default value is "Default". 
#       It selects a settings profile that sets all suitable variables for the analysis.
#       This makes it possible to run an analysis with e.g. Neo4j v4 or v5. Further profiles might come in future.
#       Implemented is this as a script in "scripts/profiles" that starts with the settings profile name followed by ".sh".

# Note: The argument "--explore" is optional. It is a switch that is deactivated by default.
#       It activates "explore" mode where no reports are executed and Neo4j keeps running (skip stop step).
#       This makes it easy to just set everything up but then use the running Neo4j server to explore the data manually.

# Note: The argument "--domain" is optional. The default value is "" (empty = all domains run unchanged).
#       It selects a single analysis domain (a subdirectory of "domains/") to run reports for, following a vertical-slice approach.
#       When set, only that domain's report scripts run; core reports from "scripts/reports/" and other domains are skipped.
#       The domain option can be combined with "--report" e.g. "--domain anomaly-detection --report Csv".
#       Only a single domain can be selected. The domain name must match a subdirectory of the "domains" directory.

# Note: The argument "--exclude-domain" is optional.
#       It accepts a comma-separated list of domain names (subdirectories of "domains/") to skip during report generation.
#       When not set and no --domain is specified, the default skipped domains are: anomaly-detection,node-embeddings,graph-algorithms.
#       When not set and --domain is specified, no domains are skipped by default.
#       Pass an empty string "" to disable all exclusions. Domain names must match subdirectories under "domains/".
#       Results in the exported environment variable ANALYSIS_DOMAINS_TO_SKIP (comma-separated).

# Note: The script and its sub scripts are designed to be as efficient as possible 
#       when it comes to subsequent executions.
#       Existing downloads, installations, scans and processes will be detected.

# Requires domains/neo4j-management/setupNeo4j.sh,setupJQAssistant.sh,domains/neo4j-management/startNeo4j.sh,resetAndScanChanged.sh,prepareAnalysis.sh,domains/neo4j-management/stopNeo4j.sh,compilations/*.sh,profiles/*.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable variables with directory names
REPORTS_SCRIPTS_DIRECTORY=${REPORTS_SCRIPTS_DIRECTORY:-"reports"} # Working directory containing the generated reports
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY=${REPORT_COMPILATIONS_SCRIPTS_DIRECTORY:-"compilations"} # Repository directory that contains scripts that execute selected report generation scripts
SETTINGS_PROFILE_SCRIPTS_DIRECTORY=${SETTINGS_PROFILE_SCRIPTS_DIRECTORY:-"profiles"} # Repository directory that contains scripts containing settings
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"} # Working directory containing the artifacts to be analyzed
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"} # Prefix to start a log group. Defaults to GitHub Actions log group start command.
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"} # Prefix to end a log group. Defaults to GitHub Actions log group end command.

# Function to display script usage
usage() {
  local exitCode="${1:-1}"
  echo "Usage: $0 [--report <type>] [--profile <name>] [--domain <name>] [--exclude-domain <list>] [--explore] [--keep-running] [--help]"
  echo ""
  echo "Options:"
  echo "  --report <type>           Report compilation to run. Default: All"
  echo "                            Available types: All, Csv, Python, Visualization, Markdown, ..."
  echo "                            Implemented as scripts/reports/compilations/<type>Reports.sh"
  echo "  --profile <name>          Settings profile to use. Default: Default"
  echo "                            Available profiles: Default, Neo4jv5, Neo4jv4, ..."
  echo "                            Implemented as scripts/profiles/<name>.sh"
  echo "  --domain <name>           Run only this domain's reports (vertical-slice). Default: all domains"
  echo "                            Must match a subdirectory of the domains/ directory."
  echo "  --exclude-domain <list>   Comma-separated list of domain names to skip. Default (no --domain): anomaly-detection,node-embeddings,graph-algorithms"
  echo "                            Default (with --domain): empty (no exclusions). Pass \"\" to skip nothing."
  echo "                            Exported as ANALYSIS_DOMAINS_TO_SKIP."
  echo "  --explore                 Skip report generation and keep Neo4j running for manual exploration."
  echo "  --keep-running            Keep Neo4j running after the analysis completes."
  echo "  --help                    Print this usage information and exit."
  echo ""
  echo "Environment variables (optional, overrideable):"
  echo "  REPORTS_SCRIPTS_DIRECTORY, REPORT_COMPILATIONS_SCRIPTS_DIRECTORY, SETTINGS_PROFILE_SCRIPTS_DIRECTORY"
  echo "  ARTIFACTS_DIRECTORY, SOURCE_DIRECTORY, LOG_GROUP_START, LOG_GROUP_END"
  echo ""
  echo "Examples:"
  echo "  $0"
  echo "    # Full analysis with all defaults (ANALYSIS_DOMAINS_TO_SKIP=anomaly-detection,node-embeddings,graph-algorithms)"
  echo "  $0 --domain git-history --report Csv --keep-running"
  echo "    # Run only CSV reports for git-history domain, keep Neo4j running"
  echo "  $0 --exclude-domain \"anomaly-detection,node-embeddings\""
  echo "    # Run all domains except anomaly-detection and node-embeddings"
  echo "  $0 --exclude-domain \"\""
  echo "    # Run all domains (override default exclusions)"
  echo "  $0 --help"
  echo "    # Print this help and exit 0"
  exit "${exitCode}"
}

# Default values
analysisReportCompilation="All"
settingsProfile="Default"
selectedAnalysisDomain=""
exploreMode=false
keepRunning=false
excludeDomainsExplicitlySet=false
selectedExcludedDomains=""

# Function to check if a parameter value is missing (either empty or another option starting with --)
is_missing_value_parameter() {
  case "${2:-}" in
    ''|--*) return 0 ;; # missing value
    *) return 1 ;; # value is present
  esac
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --report)
      if is_missing_value_parameter "$1" "$2"; then
        echo "analyze: Error: --report requires a value."
        usage
      fi
      analysisReportCompilation="$2"
      shift
      ;;
    --profile)
      if is_missing_value_parameter "$1" "$2"; then
        echo "analyze: Error: --profile requires a value."
        usage
      fi
      settingsProfile="$2"
      shift
      ;;
    --explore)
      exploreMode=true
      shift
      ;;
    --keep-running)
      keepRunning=true
      shift
      ;;
    --domain)
      if is_missing_value_parameter "$1" "$2"; then
        echo "analyze: Error: --domain requires a value."
        usage
      fi
      selectedAnalysisDomain="$2"
      shift
      ;;
    --exclude-domain)
      if [[ $# -lt 2 ]] || [[ "${2:-}" == --* ]]; then
        echo "analyze: Error: --exclude-domain requires a value (use \"\" for none)."
        usage
      fi
      excludeDomainsExplicitlySet=true
      selectedExcludedDomains="${2}"
      shift
      ;;
    --help)
      usage 0
      ;;
    *)
      echo "analyze: Error: Unknown option: ${key}"
      usage
      ;;
  esac
  shift || true # ignore error when there are no more arguments
done

# Assure that the analysis report compilation only consists of letters and numbers
if ! [[ ${analysisReportCompilation} =~ ^[-[:alnum:]]+$ ]]; then
  echo "analyze: Report can only contain letters and numbers."
  exit 1
fi

# Assure that the settings profile only consists of letters and numbers
if ! [[ ${settingsProfile} =~ ^[-[:alnum:]]+$ ]]; then
  echo "analyze: Error: Settings profile can only contain letters and numbers."
  exit 1
fi

# Assure that the selected analysis domain only consists of letters, numbers, and hyphens (if specified).
if [ -n "${selectedAnalysisDomain}" ]; then
  case "${selectedAnalysisDomain}" in
    *[!A-Za-z0-9-]*)
      echo "analyze: Error: Domain '${selectedAnalysisDomain}' can only contain letters, numbers, and hyphens."
      exit 1
      ;;
  esac
fi

# Validate --exclude-domain format: each segment must match ^[A-Za-z0-9-]+$ (empty string is allowed)
if [ -n "${selectedExcludedDomains}" ]; then
  # Detect empty segments from leading/trailing commas or double commas before splitting
  case "${selectedExcludedDomains}" in
    ,*|*,|*,,*)
      echo "analyze: Error: --exclude-domain contains an empty segment (check for leading/trailing commas or double commas)."
      exit 1
      ;;
  esac
  IFS=',' read -ra excludedDomainSegments <<< "${selectedExcludedDomains}"
  for excludedDomainSegment in "${excludedDomainSegments[@]}"; do
    case "${excludedDomainSegment}" in
      *[!A-Za-z0-9-]*)
        echo "analyze: Error: Excluded domain segment '${excludedDomainSegment}' can only contain letters, numbers, and hyphens (no spaces or special characters)."
        exit 1
        ;;
    esac
  done
fi

# Check if there is something to scan and analyze
if [ ! -d "${ARTIFACTS_DIRECTORY}" ] && [ ! -d "${SOURCE_DIRECTORY}" ] ; then
    echo "analyze: Neither ${ARTIFACTS_DIRECTORY} nor the ${SOURCE_DIRECTORY} directory exist. Please download artifacts/sources first."
    exit 1
fi

echo "${LOG_GROUP_START}Start Analysis"
echo "analyze: analysisReportCompilation=${analysisReportCompilation}"
echo "analyze: settingsProfile=${settingsProfile}"
echo "analyze: selectedAnalysisDomain=${selectedAnalysisDomain}"
echo "analyze: exploreMode=${exploreMode}"
echo "analyze: keepRunning=${keepRunning}"

# Print warning if --explore and --keep-running are used together
if ${exploreMode} && ${keepRunning}; then
  echo "analyze: Warning: --explore implies --keep-running. The --keep-running option is redundant."
fi

## Get this "scripts/analysis" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "analyze: ANALYSIS_SCRIPT_DIR=${ANALYSIS_SCRIPT_DIR}"

# Get the "scripts" directory by taking the path of this script and going one directory up.
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${ANALYSIS_SCRIPT_DIR}")} # Repository directory containing the shell scripts
echo "analyze: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Resolve the analysis domains directory. Can be overridden by the environment variable DOMAINS_DIRECTORY.
DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY:-"${SCRIPTS_DIR}/../domains"}
echo "analyze: DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY}"

# When a specific analysis domain is selected, validate that it matches an existing subdirectory of the domains directory.
# ANALYSIS_DOMAIN is empty when no domain is selected, causing all domains to run unchanged.
ANALYSIS_DOMAIN=""
if [ -n "${selectedAnalysisDomain}" ]; then
  if [ ! -d "${DOMAINS_DIRECTORY}/${selectedAnalysisDomain}" ]; then
    availableAnalysisDomains=$(find "${DOMAINS_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort | tr '\n' ' ')
    echo "analyze: Error: Selected domain '${selectedAnalysisDomain}' does not match any subdirectory in ${DOMAINS_DIRECTORY}."
    echo "analyze: Available domains: ${availableAnalysisDomains}"
    exit 1
  fi
  ANALYSIS_DOMAIN="${selectedAnalysisDomain}"
  echo "analyze: ANALYSIS_DOMAIN=${ANALYSIS_DOMAIN}"
fi

# Resolve the effective domain exclusion list.
# Priority:
# 1. --exclude-domain was explicitly set (even if empty) → use as-is
# 2. --domain was set → no default skipping (empty)
# 3. Otherwise → apply default slow/optional domains to skip
if ${excludeDomainsExplicitlySet}; then
  resolvedExcludedDomains="${selectedExcludedDomains}"
elif [ -n "${ANALYSIS_DOMAIN}" ]; then
  resolvedExcludedDomains=""
else
  resolvedExcludedDomains="anomaly-detection,node-embeddings,graph-algorithms"
fi

# Validate excluded domain names (explicit --exclude-domain only). Fail-fast like --domain does.
if ${excludeDomainsExplicitlySet} && [ -n "${resolvedExcludedDomains}" ]; then
  IFS=',' read -ra excludedDomainNamesToCheck <<< "${resolvedExcludedDomains}"
  for excludedDomainNameToCheck in "${excludedDomainNamesToCheck[@]}"; do
    if [ ! -d "${DOMAINS_DIRECTORY}/${excludedDomainNameToCheck}" ]; then
      availableAnalysisDomains=$(find "${DOMAINS_DIRECTORY}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | sort | tr '\n' ' ')
      echo "analyze: Error: Excluded domain '${excludedDomainNameToCheck}' does not match any subdirectory in ${DOMAINS_DIRECTORY}."
      echo "analyze: Available domains: ${availableAnalysisDomains}"
      exit 1
    fi
  done
fi

# Warn if --domain and --exclude-domain both reference the same domain (exclude wins)
if [ -n "${ANALYSIS_DOMAIN}" ] && [ -n "${resolvedExcludedDomains}" ]; then
  if [[ ",${resolvedExcludedDomains}," == *",${ANALYSIS_DOMAIN},"* ]]; then
    echo "analyze: Warning: Selected domain '${ANALYSIS_DOMAIN}' is also in the exclude list. The domain will be skipped."
  fi
fi

# Export resolved exclusion list so compilation scripts can filter domains
export ANALYSIS_DOMAINS_TO_SKIP="${resolvedExcludedDomains}"
export ANALYSIS_DOMAIN
echo "analyze: ANALYSIS_DOMAINS_TO_SKIP=${ANALYSIS_DOMAINS_TO_SKIP}"

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
echo "${LOG_GROUP_END}"

# Setup Tools
echo "${LOG_GROUP_START}Setup Tools"
source "${DOMAINS_DIRECTORY}/neo4j-management/setupNeo4j.sh"
source "${SCRIPTS_DIR}/setupJQAssistant.sh"
source "${DOMAINS_DIRECTORY}/neo4j-management/startNeo4j.sh"
echo "${LOG_GROUP_END}"

# Scan and analyze artifacts when they were changed
echo "${LOG_GROUP_START}Scan and Analyze Changed Artifacts"
source "${SCRIPTS_DIR}/resetAndScanChanged.sh"
echo "${LOG_GROUP_END}"

# Prepare and validate graph database before analyzing and creating reports 
echo "${LOG_GROUP_START}Prepare Analysis"
source "${SCRIPTS_DIR}/prepareAnalysis.sh"
echo "${LOG_GROUP_END}"

if ${exploreMode}; then
  echo "analyze: Explore mode activated. Report generation will be skipped. Neo4j keeps running."
  exit 0
fi

#########################
# Create Reports
#########################
source "${REPORT_COMPILATION_SCRIPT}"

# Stop Neo4j at the end (unless --keep-running is set)
echo "${LOG_GROUP_START}Finishing Analysis"
if ${keepRunning}; then
  echo "analyze: Neo4j will keep running (--keep-running is set)."
else
  source "${DOMAINS_DIRECTORY}/neo4j-management/stopNeo4j.sh"
fi
echo "${LOG_GROUP_END}"