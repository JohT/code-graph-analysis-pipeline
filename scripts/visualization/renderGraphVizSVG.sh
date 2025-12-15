#!/usr/bin/env bash

# Renders the given GraphViz file as a SVG image.
#
# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Local constants
SCRIPT_NAME=$(basename "${0}")

# Read the first unnamed input argument containing the version of the project
inputGvFileName="${1}"

if [ -z "${inputGvFileName}" ]; then
  echo "${SCRIPT_NAME}: Error: Please specify the GraphViz *.gv file as input parameter."
  exit 1
fi

if [ ! -f "${inputGvFileName}" ]; then
  echo "${SCRIPT_NAME}: Error: GraphViz file not found: ${inputGvFileName}"
  exit 1
fi

number_of_input_file_lines=$(wc -l < "${inputGvFileName}" | awk '{print $1}')
if [ "${number_of_input_file_lines}" -le 1 ]; then
  echo "${SCRIPT_NAME}: Info: Input file is empty. Skipping *.svg file generation."
  return 0
fi

echo "${SCRIPT_NAME}: Rendering ${inputGvFileName}..."

graphName=$(basename -- "${inputGvFileName}")
graphName="${graphName%.*}" # Remove file extension
graphName=${graphName//-/_} # Replace all dashes in the graphName by underscores
inputGvFilePath=$(dirname "${inputGvFileName}")

if command -v "dot" &> /dev/null ; then
    echo "${SCRIPT_NAME}: Info: Rendering ${inputGvFileName} using preinstalled GraphViz dot command line interface..."
    dot -T svg "${inputGvFilePath}/${graphName}.gv" > "${inputGvFilePath}/${graphName}.svg"
    return 0
fi

if ! command -v "npx" &> /dev/null ; then
    echo "${SCRIPT_NAME}: Error: Command npx (to run npm locally) not found. It's needed for Graph visualization with GraphViz." >&2
    exit 1
fi

# Run GraphViz command line interface (CLI) wrapped utilizing WASM (WebAssembly) 
# to convert the DOT file to SVG operating system independently.
# Use "npm install" first to create local "node_modules" and be able to run it after that in offline mode.
echo "${SCRIPT_NAME}: Info: Rendering ${inputGvFileName} using npx to run GraphViz CLI Web Assembly Wrapper..."
npm install @hpcc-js/wasm-graphviz-cli@1.2.6 --silent --no-progress --loglevel=error > /dev/null
npx --yes @hpcc-js/wasm-graphviz-cli@1.8.0 -T svg "${inputGvFilePath}/${graphName}.gv" > "${inputGvFilePath}/${graphName}.svg"