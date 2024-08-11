#!/usr/bin/env bash

# Patches jQAssistant Typescript Plugin as a workaround for https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/125

# Note: As soon as the issue is resolved, this file and its call can be deleted.

# Requires "apply"

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "setupJQAssistant: SCRIPTS_DIR=$SCRIPTS_DIR"

if ! command -v "npx" &> /dev/null ; then
    echo "patchJQAssistantTypescriptPlugin Error: Command npx not found. It's needed to install @jqassistant/ts-lce temporarily."
fi

echo "patchJQAssistantTypescriptPlugin: Installing jQAssistant Typescript Plugin @jqassistant/ts-lce using npx"
jqassistant_typescript_plugin_installation_path=$(npx --yes --package @jqassistant/ts-lce@1.2.0 which jqa-ts-lce)
echo "patchJQAssistantTypescriptPlugin: jqassistant_typescript_plugin_installation_path=${jqassistant_typescript_plugin_installation_path}"

jqassistant_typescript_plugin_bin_path=$(dirname -- "${jqassistant_typescript_plugin_installation_path}")
jqassistant_typescript_plugin_utils_file_to_patch_relative="${jqassistant_typescript_plugin_bin_path}/../@jqassistant/ts-lce/dist/src/core/utils/project.utils.js"
echo "patchJQAssistantTypescriptPlugin: jqassistant_typescript_plugin_utils_file_to_patch_relative=${jqassistant_typescript_plugin_utils_file_to_patch_relative}"

jqassistant_typescript_plugin_utils_path_resolved=$( CDPATH=. cd -- "$(dirname -- "${jqassistant_typescript_plugin_utils_file_to_patch_relative}")" && pwd -P )
jqassistant_typescript_plugin_utils_file_to_patch="${jqassistant_typescript_plugin_utils_path_resolved}/project.utils.js"
echo "patchJQAssistantTypescriptPlugin: jqassistant_typescript_plugin_utils_file_to_patch=${jqassistant_typescript_plugin_utils_file_to_patch}"

echo "patchJQAssistantTypescriptPlugin: Patching jQAssistant Typescript Plugin @jqassistant/ts-lce"
patch --forward -p1 "${jqassistant_typescript_plugin_utils_file_to_patch_relative}" -i "${SCRIPTS_DIR}/patches/@jqassistant+ts-lce+1.2.0.patch" || true
echo "patchJQAssistantTypescriptPlugin: Successfully patched jQAssistant Typescript Plugin @jqassistant/ts-lce"