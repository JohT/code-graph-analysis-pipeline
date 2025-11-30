#!/usr/bin/env bash

# Uses Maven to download specified Maven artifacts from Maven Central.
# The artifacts are specified in the first argument as comma separated Maven coordinates.
# Details on the Maven coordinates format: https://maven.apache.org/guides/mini/guide-naming-conventions.html
# The downloaded files are written into the "artifacts" directory of the current analysis directory.

# This script is used inside .github/workflows/public-analyze-code-graph.yml (November 2025)

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"}
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"}
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}

# Local constants
SCRIPT_NAME=$(basename "${0}")

fail() {
  local ERROR_COLOR='\033[0;31m' # red
  local DEFAULT_COLOR='\033[0m'
  local errorMessage="${1}"
  echo -e "${ERROR_COLOR}${SCRIPT_NAME}: Error: ${errorMessage}${DEFAULT_COLOR}" >&2
  exit 1
}

maven_artifacts=""
dry_run=false

# Input Arguments: Parse the command-line arguments
while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        --dry-run)
            dry_run=true
            shift
            ;;
        *)
            if [ -z "${maven_artifacts}" ]; then
                # The first unnamed input argument contains the comma separated Maven artifact coordinates to download
                maven_artifacts="${arg}"
                #echo "${SCRIPT_NAME}: maven_artifacts: ${maven_artifacts}"
            else
                fail "Unknown argument: ${arg}"
            fi
            shift
            ;;
    esac
done

if [ -z "${maven_artifacts}" ]; then
    fail "No Maven artifacts specified to download. Please provide a comma-separated list of Maven coordinates (groupId:artifactId:version)."
fi

if [ ! -d "./${ARTIFACTS_DIRECTORY}" ]; then
    fail "This script needs to run inside the analysis directory with an already existing artifacts directory in it. Change into that directory or use ./init.sh to set up an analysis."
fi

if ! command -v "mvn" &> /dev/null ; then
    fail "Command mvn (Maven) not found. It's needed to download Maven artifacts from Maven Central."
fi

dry_run_info=""
if [ "${dry_run}" = true ] ; then
    echo "${SCRIPT_NAME}: Info: Dry run mode enabled."
    dry_run_info=" (dry run)"
fi

# Process each Maven artifact coordinate
echo "${maven_artifacts}" | tr ',' '\n' | while read -r maven_artifact; do
    maven_artifact=$(echo "$maven_artifact" | xargs)
    
    # Check if the maven artifact "coordinate" contains exactly two colons
    colon_count=$(echo "${maven_artifact}" | tr -cd ':' | wc -c)
    if [ "${colon_count}" -ne 2 ]; then
        fail "Invalid Maven artifact coordinates: '${maven_artifact}'. It should be in the format 'groupId:artifactId:version'."
    fi

    echo "${LOG_GROUP_START}Downloading Maven artifact ${maven_artifact}${dry_run_info}"
    if [ "${dry_run}" = false ] ; then
        mvn --quiet dependency:copy -Dartifact="${maven_artifact}" -DoutputDirectory="./${ARTIFACTS_DIRECTORY}" -Dtransitive=false -Dsilent=true
    fi
    echo "${LOG_GROUP_END}"
done