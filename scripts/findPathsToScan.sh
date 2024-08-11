#!/usr/bin/env bash

# Finds all files and directories to scan and analyze and provides them as comma-separated list.
# This includes the scan of Typescript projects that leads to the intermediate json data file for jQAssistant.

# Uses: patchJQAssistantTypescriptPlugin.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "findPathsToScan SCRIPTS_DIR=${SCRIPTS_DIR}" >&2

# This function returns the argument followed by a comma (separator) if it is not empty 
# and just an empty string otherwise.
appendNonEmpty() {
    if [ -n "${1}" ] ; then
        echo "${1},"
    else
        echo ""
    fi
}

# Collect all files and directories to scan
directoriesAndFilesToScan=""

if [ -d "./${ARTIFACTS_DIRECTORY}" ] ; then
    # Scan all files in the artifacts directory (e.g. *.ear, *.war, *.jar for Java)
    directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")./${ARTIFACTS_DIRECTORY}"
else
    echo "findPathsToScan: Artifacts directory ${ARTIFACTS_DIRECTORY} doesn't exist and will therefore be skipped." >&2
fi

if [ -d "./${SOURCE_DIRECTORY}" ] ; then
    if command -v "npx" &> /dev/null ; then
        # TODO: Remove patchJQAssistantTypescriptPlugin when issue is resolved: https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/125
        source "${SCRIPTS_DIR}/patchJQAssistantTypescriptPlugin.sh" >&2
        echo "findPathsToScan: Scanning Typescript source using @jqassistant/ts-lce..." >&2
        ( cd "./${SOURCE_DIRECTORY}" && npx --yes @jqassistant/ts-lce@1.2.0 --extension React >"./../runtime/logs/jqassistant-typescript-scan.log" 2>&1 || exit )
    else
        echo "findPathToScan Error: Command npx not found. It's needed to execute @jqassistant/ts-lce to scan Typescript projects."
    fi

    # Scan Typescript analysis json data files in the source directory
    typescriptAnalysisFiles="$(find "./${SOURCE_DIRECTORY}" -type f -path "*/.reports/jqa/ts-output.json" -exec echo typescript:project::{} \; | tr '\n' ',' | sed 's/,$/\n/')"
    if [ -n "${typescriptAnalysisFiles}" ]; then
        directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${typescriptAnalysisFiles}"
    fi

    # Scan package.json files for npm (nodes package manager) in the source directory
    # # TODO The following lines can be reactivated when the following issue is resolved:
    # https://github.com/jqassistant-plugin/jqassistant-npm-plugin/issues/5
    #npmPackageJsonFiles="$(find "${SOURCE_DIRECTORY}" -type d -name node_modules -prune -o -name 'package.json' -print0 | xargs -0 -r -I {} | tr '\n' ',' | sed 's/,$/\n/')"
    #if [ -n "${npmPackageJsonFiles}" ]; then
    #    directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${npmPackageJsonFiles}"
    #fi

    # Scan git repositories in the artifacts directory
    if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "" ] || [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "plugin" ] ; then
        gitDirectories="$(find "./${SOURCE_DIRECTORY}" -type d -name ".git" -exec echo {} \; | tr '\n' ',' | sed 's/,$/\n/')"
        if [ -n "${gitDirectories}" ]; then
            directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${gitDirectories}"
        fi
    fi
else
    echo "findPathsToScan: Source directory ${SOURCE_DIRECTORY} doesn't exist and will therefore be skipped." >&2
fi

echo -n "${directoriesAndFilesToScan}"