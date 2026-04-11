#!/usr/bin/env bash

# Extracts the environment variable declarations including default values from a script file and appends it to a markdown file as table columns.

# Note: If called with "clear" instead of a filename then the generated markdown reference documentation file is deleted.
#       This is helpful to start over with the generation of a new document.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

SCRIPT_NAME="appendEnvironmentVariables"
MARKDOWN_FILE="ENVIRONMENT_VARIABLES.md"

# If the first command line option is "clear" (instead of a filename) then delete the markdown file.
if [ "$1" = "clear" ] ; then
    echo "${SCRIPT_NAME}: Clear existing ${MARKDOWN_FILE}..."
    rm -f "${MARKDOWN_FILE}" || { echo "${SCRIPT_NAME}: Error: Failed to remove ${MARKDOWN_FILE}."; return 1; }
    return 0
fi

# Get the file to search for environment variables from the first (and only) command line option
filePath="$1"

# Check if the given file exists
if [ -z "${filePath}" ] ; then
    echo "${SCRIPT_NAME}: Please provide a file name."
    return 1
fi

# Check if the given file exists
if [ ! -f "./${filePath}" ] ; then
    echo "${SCRIPT_NAME}: File ${filePath} doesn't exist."
    return 1
fi

# Create the markdown file if it doesn't exist with the header of the table
if [ ! -f "./${MARKDOWN_FILE}" ] ; then
    echo "${SCRIPT_NAME}: Creating ${MARKDOWN_FILE}..."
    { 
        echo "# Environment Variables Reference" 
        echo ""
        echo "This document serves as a reference for all environment variables that are supported by the script files."
        echo "It provides a table listing each environment variable, its default value and its corresponding description provided as a inline comment."
        echo "This file was generated with the script [appendEnvironmentVariables.sh](./scripts/documentation/appendEnvironmentVariables.sh) and [generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh)."
        echo ""
        echo "Environment Variable Name | Default | Description"
        echo "------------------------- | ------- | -----------"
    } > ${MARKDOWN_FILE}
fi

# Regular expression that extracts the environment variable name (1st group), its default value (2nd group)
# and its description (3rd group). Keep this strict — we only accept double-quoted literal defaults.
regular_expression='^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=\$\{[A-Za-z_][A-Za-z0-9_]*:-\"([^\"]*)\"\}[[:space:]]*#*[[:space:]]*(.*)'

# Probe first so that "no matches" is not treated as a fatal error, while genuine grep/sed/awk
# failures are still detected and propagated (we rely on `set -o pipefail`).
if grep -q -E "${regular_expression}" "${filePath}"; then
    if ! environmentVariables=$( \
        grep -E "${regular_expression}" "${filePath}" | \
        sed -E "s/${regular_expression}/\1;\2;\3/" | \
        awk -F ';' '{ printf "%s | %s | %s\n", $1, $2, $3 }' \
    ); then
        echo "${SCRIPT_NAME}: Error: Failed to parse environment variables from ${filePath}."
        return 1
    fi
else
    grep_exit=$?
    if [ "${grep_exit}" -eq 1 ]; then
        # No matches found — not an error; continue with empty result set.
        environmentVariables=""
    else
        # grep encountered a real error (exit code 2 or other) — surface it.
        echo "${SCRIPT_NAME}: Error: grep failed with exit status ${grep_exit} while scanning ${filePath}."
        return 1
    fi
fi

# Iterate over each environment variable line by line
while IFS= read -r environmentVariable; do
    # Extract the name of the environment variable out of the markdown table line format.
    environmentVariableName=$(echo -n "${environmentVariable}" | tr -s " " | cut -d "|" -f 1)
    # Check if the environment variable is already in the output markdown file.
    if ! grep -q "${environmentVariableName}" "${MARKDOWN_FILE}"; then
        # Append the previously found environment variable to the markdown file since it isn't in there yet.
        echo "${environmentVariable}" >> ${MARKDOWN_FILE}
    fi
done <<< "$environmentVariables"
