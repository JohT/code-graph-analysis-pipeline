#!/usr/bin/env bash

# Visualizes the Cypher query result (CSV format) using GraphViz and outputs it as SVG image.
#
# Requires convertQueryResultCsvToGraphVizDotFile.sh
#
# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts/visualization" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts for visualization
echo "visualizeQueryResults: VISUALIZATION_SCRIPTS_DIR=${VISUALIZATION_SCRIPTS_DIR}"

# Read the first unnamed input argument containing the version of the project
inputCsvFileName=""
case "${1}" in
  "--"*) ;; # Skipping named command line options to forward them later to the "convertQueryResultCsvToGraphVizDotFile" command
  *) 
    inputCsvFileName="${1}" 
    shift || true
    ;;
esac

if [ -z "${inputCsvFileName}" ]; then
  echo "visualizeQueryResults: Error: Please specify the CSV query result file as input parameter."
  exit 1
fi

if [ ! -f "${inputCsvFileName}" ]; then
  echo "visualizeQueryResults: Error: CSV file not found: ${inputCsvFileName}"
  exit 1
fi

number_of_input_file_lines=$(wc -l < "${inputCsvFileName}" | awk '{print $1}')
if [ "${number_of_input_file_lines}" -le 1 ]; then
  echo "visualizeQueryResults: Info: Input file is empty. Skipping *.dot and *.svg file generation."
  return 0
fi

echo "visualizeQueryResults: Info: CSV input file: ${inputCsvFileName}"

graphName=$(basename -- "${inputCsvFileName}")
graphName="${graphName%.*}" # Remove file extension
graphName=${graphName//-/_} # Replace all dashes in the graphName by underscores
inputCsvFilePath=$(dirname "${inputCsvFileName}")

echo "visualizeQueryResults: Generating Visualization files ${inputCsvFilePath}/${graphName}.* ..."
source "${VISUALIZATION_SCRIPTS_DIR}/convertQueryResultCsvToGraphVizDotFile.sh" "--filename" "${inputCsvFileName}" "${@}"

if command -v "dot" &> /dev/null ; then
    echo "visualizeQueryResults: Info: Using already installed GraphViz."
    dot -T svg "${inputCsvFilePath}/${graphName}.gv" > "${inputCsvFilePath}/${graphName}.svg"
    return 0
fi

if ! command -v "npx" &> /dev/null ; then
    echo "visualizeQueryResults: Error: Command npx (to run npm locally) not found. It's needed for Graph visualization with GraphViz." >&2
    exit 1
fi

# Run GraphViz command line interface (CLI) wrapped utilizing WASM (WebAssembly) 
# to convert the DOT file to SVG operating system independently.
# Use "npm install" first to create local "node_modules" and be able to run it after that in offline mode.
echo "visualizeQueryResults: Info: Using npx to run GraphViz CLI (Web Assembly Wrapper) for SVG generation."
npm install @hpcc-js/wasm-graphviz-cli@1.2.6 --silent --no-progress --loglevel=error > /dev/null
npx --yes @hpcc-js/wasm-graphviz-cli@1.8.1 -T svg "${inputCsvFilePath}/${graphName}.gv" > "${inputCsvFilePath}/${graphName}.svg"