#!/usr/bin/env bash

# Finds all files and directories to scan and analyze and provides them as comma-separated list.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}

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

if [ -d "${ARTIFACTS_DIRECTORY}" ] ; then
    # Scan all files in the artifacts directory (e.g. *.ear, *.war, *.jar for Java)
    directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")./${ARTIFACTS_DIRECTORY}"
else
    echo "findPathsToScan: Artifacts directory ${ARTIFACTS_DIRECTORY} doesn't exist and will therefore be skipped." >&2
fi

if [ -d "${SOURCE_DIRECTORY}" ] ; then
    # Scan Typescript analysis json data files in the source directory
    typescriptAnalysisFiles="$(find "${SOURCE_DIRECTORY}" -type f -path "*/.reports/jqa/ts-output.json" -exec echo typescript:project::{} \; | tr '\n' ',' | sed 's/,$/\n/')"
    if [ -n "${typescriptAnalysisFiles}" ]; then
        directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${typescriptAnalysisFiles}"
    fi

    # Scan package.json files for npm (nodes package manager) in the source directory
    npmPackageJsonFiles="$(find "${SOURCE_DIRECTORY}" -type d -name node_modules -prune -o -name 'package.json' -print0 | xargs -0 -r -I {} | tr '\n' ',' | sed 's/,$/\n/')"
    if [ -n "${npmPackageJsonFiles}" ]; then
        directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${npmPackageJsonFiles}"
    fi

    # Scan git repositories in the artifacts directory
    if [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "" ] || [ "${IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT}" = "plugin" ] ; then
        gitDirectories="$(find "${SOURCE_DIRECTORY}" -type d -name ".git" -exec echo {} \; | tr '\n' ',' | sed 's/,$/\n/')"
        if [ -n "${gitDirectories}" ]; then
            directoriesAndFilesToScan="$(appendNonEmpty "${directoriesAndFilesToScan}")${gitDirectories}"
        fi
    fi
else
    echo "findPathsToScan: Source directory ${SOURCE_DIRECTORY} doesn't exist and will therefore be skipped." >&2
fi

echo -n "${directoriesAndFilesToScan}"