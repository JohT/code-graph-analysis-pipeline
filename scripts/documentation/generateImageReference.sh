#!/usr/bin/env bash

# Generates "IMAGES.md" containing a reference to all images (PNG) in this directory and its subdirectories.

# Markdown file name
markdown_file="IMAGES.md"

{ 
  echo "# Image Reference" 
  echo ""
  echo "This document serves as a reference for all images (PNG) in the current directory and its subdirectories."
  echo "It provides a table listing each file and the analysis it belongs to."
  echo "This file was generated with the script [generateImageReference.sh](./../scripts/documentation/generateImageReference.sh)."
  echo ""
  echo "Image  | Analysis |"
  echo "-------|----------|" 
} > ${markdown_file}

# Loop through all Markdown files in the current directory
find . -type f -name "*.png" | sort | while read -r image_file; do
    # Trim leading and trailing whitespace
    description=$(echo "${description}" | awk '{$1=$1;print}')

    # Extract the script file name without the path
    filename=$(basename "$image_file")
    
    if [ "$filename" = "${markdown_file}" ]; then
      continue
    fi
    
    # Extract the script file path without the name
    pathname=$(dirname "$image_file")
    
    # Extract the second part of the path after ./ that contains the analysis directory name
    analysisname=$(echo "${pathname}" | cut -d/ -f2)

    # Create a link to the script file in the table
    link="[${filename}](${image_file})"
    
    # Add the script file and its description to the Markdown table
    echo "| ${link} | ${analysisname%%.} |" >> ${markdown_file}
done
