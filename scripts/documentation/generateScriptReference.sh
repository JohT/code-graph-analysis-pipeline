#!/usr/bin/env bash

# Generates "SCRIPTS.md" containing a reference to all scripts in this directory and its subdirectories.
# This script was generated by Chat-GPT after some messages back and forth and then tuned manually.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

# Markdown file name
markdown_file="SCRIPTS.md"

{ 
  echo "# Scripts Reference" 
  echo ""
  echo "This document serves as a reference for all scripts in the current directory and its subdirectories."
  echo "It provides a table listing each script file and its corresponding description found in the first comment line."
  echo "This file was generated with the script [generateScriptReference.sh](./generateScriptReference.sh)."
  echo ""
  echo "Script | Directory | Description"
  echo "-------|-----------|------------" 
} > ${markdown_file}

# Loop through all script files in the current directory
find . -type f -name "*.sh" | sort | while read -r script_file; do
    # Get the description of the script file
    description=$(awk 'NR>1 && /^ *#/{sub(/^ *# ?/,""); print; exit}' "$script_file")

    # Extract the script file name without the path
    filename=$(basename "$script_file")
    
    # Extract the script file path without the name
    pathname=$(dirname "$script_file")
    last_path_segment=$(basename "$pathname")
    
    # Create a link to the script file in the table
    link="[${filename}](${script_file})"
    
    # Add the script file and its description to the Markdown table
    echo "| ${link} | ${last_path_segment%%.} | ${description//|/\\|} |" >> ${markdown_file}
done
