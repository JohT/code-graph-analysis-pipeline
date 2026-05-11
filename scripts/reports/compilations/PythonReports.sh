#!/usr/bin/env bash

# Runs all Python report scripts (no Chromium required).
# Discovers and executes Python report scripts matching *Python.sh or *Python.py patterns
# from the "reports" directory (REPORTS_SCRIPT_DIR) and all "domains" subdirectories (DOMAINS_DIRECTORY),
# recursively throughout their directory trees.
# When ANALYSIS_DOMAIN is set, runs only reports from that specific domain.
# Skips domains listed in ANALYSIS_DOMAINS_TO_SKIP.
#
# Requires: activateCondaEnvironment.sh, activateUvEnvironment.sh, and Python scripts matching:
#   ${REPORTS_SCRIPT_DIR}/**/*Python.sh or ${REPORTS_SCRIPT_DIR}/**/*Python.py
#   ${DOMAINS_DIRECTORY}/**/*Python.sh or ${DOMAINS_DIRECTORY}/**/*Python.py

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"} # Prefix to start a log group. Defaults to GitHub Actions log group start command.
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"} # Prefix to end a log group. Defaults to GitHub Actions log group end command.

# Local constants
SCRIPT_NAME=$(basename "${0}")

## Get this "scripts/reports/compilations" directory if not already set.
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR:-$(dirname -- "${REPORT_COMPILATIONS_SCRIPT_DIR}")}
SCRIPTS_DIR=${SCRIPTS_DIR:-$(dirname -- "${REPORTS_SCRIPT_DIR}")}

# Get the "domains" directory that contains analysis and report scripts by functionality.
DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY:-"${REPORTS_SCRIPT_DIR}/../../domains"}

echo "${LOG_GROUP_START}$(date +'%Y-%m-%dT%H:%M:%S') Initialize Python Reports";
echo "${SCRIPT_NAME}: REPORT_COMPILATIONS_SCRIPT_DIR=${REPORT_COMPILATIONS_SCRIPT_DIR}"
echo "${SCRIPT_NAME}: REPORTS_SCRIPT_DIR=${REPORTS_SCRIPT_DIR}"
echo "${SCRIPT_NAME}: SCRIPTS_DIR=${SCRIPTS_DIR}"
echo "${SCRIPT_NAME}: DOMAINS_DIRECTORY=${DOMAINS_DIRECTORY}"
echo "${SCRIPT_NAME}: ANALYSIS_DOMAIN=${ANALYSIS_DOMAIN}"
echo "${SCRIPT_NAME}: ANALYSIS_DOMAINS_TO_SKIP=${ANALYSIS_DOMAINS_TO_SKIP:-}"

# Create and activate (if necessary) a virtual environment (Conda or uv).
# For Conda, the environment name is taken from the environment variable CODEGRAPH_CONDA_ENVIRONMENT (default "codegraph")
# and the dependencies are listed in the root directory file "conda-environment.yml".
# For uv (default), the dependencies are listed in the root directory file "pyproject.toml".
time source "${SCRIPTS_DIR}/activateCondaEnvironment.sh"
time source "${SCRIPTS_DIR}/activateUvEnvironment.sh"

echo "${LOG_GROUP_END}";

# Run all Python report scripts (filename ending with Python.sh or Python.py) in the REPORTS_SCRIPT_DIR and DOMAINS_DIRECTORY directories.
# When a specific analysis domain is selected, only run reports for that domain's directory.
# Otherwise, run reports from both the general reports directory and all domains.
if [ -n "${ANALYSIS_DOMAIN}" ]; then
    # Skip if the selected domain is also in the exclusion list
    if [[ ",${ANALYSIS_DOMAINS_TO_SKIP:-}," == *",${ANALYSIS_DOMAIN},"* ]]; then
        echo "${SCRIPT_NAME}: Skipping domain '${ANALYSIS_DOMAIN}' (listed in ANALYSIS_DOMAINS_TO_SKIP)."
        analysisReportScriptDirectories=()
    else
        analysisReportScriptDirectories=( "${DOMAINS_DIRECTORY}/${ANALYSIS_DOMAIN}" )
    fi
else
    analysisReportScriptDirectories=( "${REPORTS_SCRIPT_DIR}" "${DOMAINS_DIRECTORY}" )
fi

for directory in "${analysisReportScriptDirectories[@]}"; do
    if [ ! -d "${directory}" ]; then
        echo "${SCRIPT_NAME}: Error: Directory ${directory} does not exist. Please check your REPORTS_SCRIPT_DIR and DOMAIN_DIRECTORY settings."
        exit 1
    fi

    # Run all Python report scripts for the selected directory.
    find "${directory}" -type f \( -name "*Python.sh" -o -name "*Python.py" \) | sort | while read -r report_script_file; do
        report_script_filename=$(basename -- "${report_script_file}");
        report_script_filename="${report_script_filename%.*}" # Remove file extension

        # Skip scripts belonging to an excluded domain
        if [ -n "${ANALYSIS_DOMAINS_TO_SKIP:-}" ]; then
            IFS=',' read -ra domainsToSkip <<< "${ANALYSIS_DOMAINS_TO_SKIP}"
            skipThisScript=false
            for domainToSkip in "${domainsToSkip[@]}"; do
                if [[ "${report_script_file}" == *"/${domainToSkip}/"* ]]; then
                    echo "${SCRIPT_NAME}: Skipping ${report_script_filename} (domain '${domainToSkip}' is in ANALYSIS_DOMAINS_TO_SKIP)."
                    skipThisScript=true
                    break
                fi
            done
            if ${skipThisScript}; then
                continue
            fi
        fi

        echo "${LOG_GROUP_START}$(date +'%Y-%m-%dT%H:%M:%S') Create Python Report ${report_script_filename}";
        echo "${SCRIPT_NAME}: $(date +'%Y-%m-%dT%H:%M:%S') Starting ${report_script_filename}...";

        source "${report_script_file}"

        echo "${SCRIPT_NAME}: $(date +'%Y-%m-%dT%H:%M:%S') Finished ${report_script_filename}";
        echo "${LOG_GROUP_END}";
    done
done
