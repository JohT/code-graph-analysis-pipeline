#!/usr/bin/env bash

# This script triggers the installation of dependencies for JavaScript projects in the source folder.
# It supports npm, pnpm and yarn and will skip other projects.

# This script is used inside .github/workflows/public-analyze-code-graph.yml (December 2025)
# If you want to delete all node_modules directories in the source folder, run:
# find "./${SOURCE_DIRECTORY}" -type d -name node_modules -prune -exec rm -rf {} +

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Constants (defaults also defined in sub scripts)
LOG_GROUP_START=${LOG_GROUP_START:-"::group::"}
LOG_GROUP_END=${LOG_GROUP_END:-"::endgroup::"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

# Local constants
SCRIPT_NAME=$(basename "${0}")

fail() {
    local ERROR_COLOR='\033[0;31m' # red
    local DEFAULT_COLOR='\033[0m'
    local errorMessage="${1}"
    echo -e "${ERROR_COLOR}${SCRIPT_NAME}: Error: ${errorMessage}${DEFAULT_COLOR}" >&2
    exit 1
}

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
            fail "Unknown argument: ${arg}"
    esac
done

if [ ! -d "./${SOURCE_DIRECTORY}" ]; then
    fail "This script needs to run inside the analysis directory with an already existing source directory in it. Change into that directory or use ./init.sh to set up an analysis."
fi

dry_run_info=""
if [ "${dry_run}" = true ] ; then
    echo "${SCRIPT_NAME}: Info: Dry run mode enabled."
    dry_run_info=" (dry run)"
fi

# Returns 0 (success) if "private": true is set in package.json, otherwise 1 (false).
# Pass the directory of the package.json file as first argument (default=.=current directory).
is_private_package_json() {
  directory=${1:-.}
  node -e "process.exit(require(require('path').resolve('${directory}/package.json')).private ? 0 : 1)"
}

# Install node package manager (npm) dependencies by finding all directories with package-lock.json files and running "npm ci" in them.
find "./${SOURCE_DIRECTORY}" -type d -name "node_modules" -prune -o -type f -name "package-lock.json" -print | sort | while read -r lock_file; do
    lock_file_directory=$(dirname -- "${lock_file}")
    if is_private_package_json "${lock_file_directory}" ; then
        echo "${SCRIPT_NAME}: Info: Skipping npm install in private package ${lock_file_directory}."
        continue
    fi
    (
        cd "${lock_file_directory}"
        echo "${LOG_GROUP_START}$(date +'%Y-%m-%dT%H:%M:%S') Installing JavaScript dependencies with npm in ${lock_file_directory}${dry_run_info}";
        if [ "${dry_run}" = true ] ; then
            echo "${SCRIPT_NAME}: Info: Dry run mode - skipping npm ci in ${lock_file_directory}."
        else
            if ! command -v "npm" &> /dev/null ; then
                fail "Command npm (Node Package Manager) not found. It's needed to install JavaScript dependencies."
            fi
            npm ci --no-scripts || true
        fi
        echo "${LOG_GROUP_END}";
    )
done

# Install pnpm dependencies by finding all directories with pnpm-lock.yaml files and running "pnpm install --frozen-lockfile" in them.
find "./${SOURCE_DIRECTORY}" -type d -name "node_modules" -prune -o -type f -name "pnpm-lock.yaml" -print | sort | while read -r lock_file; do
    lock_file_directory=$(dirname -- "${lock_file}")
    # Run pnpm also in private packages since they might trigger the installation of dependencies in monorepos.
    (
        cd "${lock_file_directory}"
        echo "${LOG_GROUP_START}$(date +'%Y-%m-%dT%H:%M:%S') Installing JavaScript dependencies with pnpm in ${lock_file_directory}${dry_run_info}";
        if [ "${dry_run}" = true ] ; then
            echo "${SCRIPT_NAME}: Info: Dry run mode - skipping pnpm install in ${lock_file_directory}."
        else
            if ! command -v "pnpm" &> /dev/null ; then
                fail "Command pnpm (Performant Node.js Package Manager) not found. It's needed to install JavaScript dependencies."
            fi
            pnpm install --frozen-lockfile --ignore-scripts || true
        fi
        echo "${LOG_GROUP_END}";
    )
done

# Install yarn dependencies by finding all directories with yarn.lock files and running "yarn install --frozen-lockfile" in them.
find "./${SOURCE_DIRECTORY}" -type d -name "node_modules" -prune -o -type f -name "yarn.lock" -print | sort | while read -r lock_file; do
    lock_file_directory=$(dirname -- "${lock_file}")
    if is_private_package_json "${lock_file_directory}" ; then
        echo "${SCRIPT_NAME}: Info: Skipping yarn install in private package ${lock_file_directory}."
        continue
    fi
    (
        cd "${lock_file_directory}"
        echo "${LOG_GROUP_START}$(date +'%Y-%m-%dT%H:%M:%S') Installing JavaScript dependencies with yarn in ${lock_file_directory}${dry_run_info}";
        if [ "${dry_run}" = true ] ; then
            echo "${SCRIPT_NAME}: Info: Dry run mode - skipping yarn install in ${lock_file_directory}."
        else
            if ! command -v "yarn" &> /dev/null ; then
                fail "Command yarn (Yet Another Resource Negotiator) not found. It's needed to install JavaScript dependencies."
            fi
            yarn install --frozen-lockfile --ignore-scripts || true
        fi
        echo "${LOG_GROUP_END}";
    )
done