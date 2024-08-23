#!/usr/bin/env bash

# Copies all package.json files inside the source directory into the artifacts/npm-package-json directory.
# It retains the original folder structure where the package.json files were in.

# This script "jq" ( https://stedolan.github.io/jq ).

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
ARTIFACTS_DIRECTORY=${ARTIFACTS_DIRECTORY:-"artifacts"}
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}
NPM_PACKAGE_JSON_ARTIFACTS_DIRECTORY=${NPM_PACKAGE_JSON_ARTIFACTS_DIRECTORY:-"npm-package-json"} # Subdirectory of "artifacts" containing the npm package.json files to scan

# Check if the repository is actually a git repository
if [ ! -d "${SOURCE_DIRECTORY}" ]; then
  echo "copyPackageJsonFiles: No ${SOURCE_DIRECTORY} directory. Skipping copy of package.json files."
  return 0
fi

(
    cd "./${SOURCE_DIRECTORY}"
    
    echo "copyPackageJsonFiles: Existing package.json files will be copied from from ${SOURCE_DIRECTORY} to ../${ARTIFACTS_DIRECTORY}/${NPM_PACKAGE_JSON_ARTIFACTS_DIRECTORY}"
    echo "copyPackageJsonFiles: Author will be removed as workaround for https://github.com/jqassistant-plugin/jqassistant-npm-plugin/issues/5"
    
    for file in $( find -L . -type d -name node_modules -prune -o -name 'package.json' -print0 | xargs -0 -r -I {}); do
        fileDirectory=$(dirname "${file}")
        targetDirectory="../${ARTIFACTS_DIRECTORY}/${NPM_PACKAGE_JSON_ARTIFACTS_DIRECTORY}/${fileDirectory}"
        # echo "copyPackageJsonFiles: Copying ${file} to ${targetDirectory}"

        mkdir -p "${targetDirectory}"
        cp -rf "${file}" "${targetDirectory}"

        # Workaround until the following issue is resolved:
        # https://github.com/jqassistant-plugin/jqassistant-npm-plugin/issues/5
        fileName=$(basename "${file}")
        jq 'del(.author)' "${targetDirectory}/${fileName}" > "${targetDirectory}/${fileName}.edited"
        jq 'del(.contributors)' "${targetDirectory}/${fileName}.edited" > "${targetDirectory}/${fileName}"
        rm -f "${targetDirectory}/${fileName}.edited"
    done
)