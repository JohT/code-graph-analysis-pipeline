#!/usr/bin/env bash

# Extracts the environment variable declarations including default values from a script file and appends it to a markdown file as table columns.

# Note: If called with "clear" instead of a filename then the generated markdown reference documentation file is deleted.
#       This is helpful to start over with the generation of a new document.

# Markdown file name
markdownFile="ENVIRONMENT_VARIABLES.md"

# If the first command line option is "clear" (instead of a filename) then delete the markdown file.
if [[ "$1" == "clear" ]] ; then
    echo "findEnvironmentVariables: Clear existing ${markdownFile}..."
    rm -f "${markdownFile}" || echo "findEnvironmentVariables: Error: Failed to remove ${markdownFile}." || exit 1
    return 0
fi

# Get the file to search for environment variables from the first (and only) command line option
filePath="$1"

# Check if the given file exists
if [ -z "${filePath}" ] ; then
    echo "findEnvironmentVariables: Please provide a file name."
    exit 1
fi

# Check if the given file exists
if [ ! -f "./${filePath}" ] ; then
    echo "findEnvironmentVariables: File ${filePath} doesn't exist."
    exit 1
fi

# Create the markdown file if it doesn't exist with the header of the table
if [ ! -f "./${markdownFile}" ] ; then
    echo "findEnvironmentVariables: Creating ${markdownFile}..."
    { 
        echo "# Environment Variables Reference" 
        echo ""
        echo "This document serves as a reference for all environment variables that are supported by the script files."
        echo "It provides a table listing each environment variable, its default value and its corresponding description provided as a inline comment."
        echo "This file was generated with the script [appendEnvironmentVariables.sh](./appendEnvironmentVariables.sh) and [generateEnvironmentVariableReference.sh](./generateEnvironmentVariableReference.sh)."
        echo ""
        echo "| Environment Variable Name           | Default                             | Description                                            |"
        echo "| ----------------------------------- | ----------------------------------- | ------------------------------------------------------ |"
    } > ${markdownFile}
fi

# Regular expression that extracts the environment variable name (1st group), its default value (2nd group) and its description (3rd group)
regular_expression='^[[:space:]]*([A-Za-z_][A-Za-z0-9_]*)=\${[A-Za-z_][A-Za-z0-9_]*:-"([^"]*)"}[[:space:]]*#*[[:space:]]*(.*)'

environmentVariables=$(\
    # Use grep to find lines with the pattern you specified
    grep -E "${regular_expression}" "$filePath" |
    # Use sed to extract the variable name and default value
    sed -E "s/${regular_expression}/\1;\2;\3/" |
    # Use awk to format the output as requested
    awk -F ';' '{ printf "%-37s | %-35s | %s |\n", $1, $2, $3 }'\
)

# Iterate over each environment variable line by line
while IFS= read -r environmentVariable; do
    # Extract the name of the environment variable out of the markdown table line format.
    environmentVariableName=$(echo -n "${environmentVariable}" | tr -s " " | cut -d "|" -f 1)
    # Check if the environment variable is already in the output markdown file.
    if ! grep -q "${environmentVariableName}" "$markdownFile"; then
        # Append the previously found environment variable to the markdown file since it isn't in there yet.
        echo "${environmentVariable}" >> ${markdownFile}
    fi
done <<< "$environmentVariables"