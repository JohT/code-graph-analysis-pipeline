#!/usr/bin/env bash

# Executes all steps in the given Jupyter Notebook (ipynb), stores it and converts it to Markdown (md) and PDF.

# Note: The new files will be written into the current directory. 

# Note: The environment variable NEO4J_INITIAL_PASSWORD is required.

# Note: Don't start this script in the same directory as the ipynb files without defining JUPYTER_OUTPUT_FILE_POSTFIX.
#       Otherwise the executed jupyter notebook file would override the original version.
#       The original ones are typically saved with all outputs cleared to be able to better compare their changes with git diff.

# Note: This script uses the conda environment defined in CODEGRAPH_CONDA_ENVIRONMENT (defaults to "codegraph").
#       If the environment hadn't been created yet it will use "environment.yml" 
#       in the same directory as the given jupyter notebook ipynb file
#       to create the environment.

# Requires juypter nbconvert,operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION=${ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION:-""} # Enable PDF generation for Jupyter Notebooks if set to any non empty value like "true" or disable it with "" or "false".
if [ "${ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION}" == "false" ]; then
    ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION="" # Reset PDF generation if explicitly set to false
fi

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "executeJupyterNotebook: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "executeJupyterNotebook: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Read the first input argument containing the name of the cypher file
if [ "$#" -ne 1 ]; then
  echo "executeJupyterNotebook: Usage: $0 <jupyter notebook file>" >&2
  exit 1
fi

# Check the first input argument to be a valid file
if [ ! -f "$1" ] ; then
    echo "executeJupyterNotebook: $1 not found" >&2
    exit 1
fi

# Get Jupyter notebook input file
jupyter_notebook_file=$1
echo "executeJupyterNotebook: jupyter_notebook_file=$jupyter_notebook_file"

# Get ouput file name
JUPYTER_OUTPUT_FILE_POSTFIX=${JUPYTER_OUTPUT_FILE_POSTFIX:-""} # e.g. "" (no postfix), ".nbconvert" or ".output"
echo "executeJupyterNotebook: JUPYTER_OUTPUT_FILE_POSTFIX=$JUPYTER_OUTPUT_FILE_POSTFIX"

# Split input file name up into path, name and extension
jupyter_notebook_file_name=$(basename -- "$jupyter_notebook_file")

jupyter_notebook_file_path=$(dirname -- "$jupyter_notebook_file")
echo "executeJupyterNotebook: jupyter_notebook_file_path=$jupyter_notebook_file_path"

jupyter_notebook_file_extension="${jupyter_notebook_file_name##*.}"
echo "executeJupyterNotebook: jupyter_notebook_file_extension=$jupyter_notebook_file_extension"

jupyter_notebook_file_name="${jupyter_notebook_file_name%.*}"
echo "executeJupyterNotebook: jupyter_notebook_file_name=$jupyter_notebook_file_name"

# Determine output file name and path
jupyter_notebook_output_file_name="${jupyter_notebook_file_name}${JUPYTER_OUTPUT_FILE_POSTFIX}"
echo "executeJupyterNotebook: jupyter_notebook_output_file_name=$jupyter_notebook_output_file_name"

jupyter_notebook_output_file="./${jupyter_notebook_file_name}${JUPYTER_OUTPUT_FILE_POSTFIX}.${jupyter_notebook_file_extension}"
echo "executeJupyterNotebook: jupyter_notebook_output_file=$jupyter_notebook_output_file"

jupyter_notebook_markdown_file="./${jupyter_notebook_file_name}${JUPYTER_OUTPUT_FILE_POSTFIX}.md"
echo "executeJupyterNotebook: jupyter_notebook_markdown_file=$jupyter_notebook_markdown_file"

if [ ! -f "${jupyter_notebook_file_path}/.env" ] ; then
    echo "executeJupyterNotebook: Creating file ${jupyter_notebook_file_path}.env ..."
    echo "NEO4J_INITIAL_PASSWORD=${NEO4J_INITIAL_PASSWORD}" > "${jupyter_notebook_file_path}/.env"
fi

# Create and activate (if necessary) Conda environment as defined in environment variable CODEGRAPH_CONDA_ENVIRONMENT (default "codegraph")
source "${SCRIPTS_DIR}/activateCondaEnvironment.sh"

jupyter --version || exit 1

# Execute the Jupyter Notebook and write it to the output file name
# The environment variable NBCONVERT_PATH is needed to be able to detect a command line execution in the Jupyter Notebook.
# Additionally, it is used to store the offline rendered images in the directory "${jupyter_notebook_file_name}_files".
echo "executeJupyterNotebook: Executing Jupyter Notebook ${jupyter_notebook_output_file_name}..."

mkdir -p "${jupyter_notebook_file_name}_files"
NBCONVERT_PATH="$(pwd)/${jupyter_notebook_file_name}_files" jupyter nbconvert --to notebook \
                  --execute "${jupyter_notebook_file}" \
                  --output "$jupyter_notebook_output_file_name" \
                  --output-dir="./" \
                  --ExecutePreprocessor.timeout=480
echo "executeJupyterNotebook: Successfully executed Jupyter Notebook ${jupyter_notebook_output_file_name}."

# Convert the Jupyter Notebook to Markdown 
jupyter nbconvert --to markdown --no-input "$jupyter_notebook_output_file"

# Remove style blocks from Markdown file
# The inplace option -i of sed doesn't seem to work at least on Mac in this case.
# Therefore the temporary file ".nostyle" is created and then moved to overwrite the original markdown file.
sed -E '/<style( scoped)?>/,/<\/style>/d' "${jupyter_notebook_markdown_file}" > "${jupyter_notebook_markdown_file}.nostyle"
mv -f "${jupyter_notebook_markdown_file}.nostyle" "${jupyter_notebook_markdown_file}"
echo "executeJupyterNotebook: Successfully created Markdown ${jupyter_notebook_markdown_file}.."

# Convert the Jupyter Notebook to PDF
# The environment variable NBCONVERT is needed to be able to detect a command line execution in the Jupyter Notebook.
if [ -n "${ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION}" ]; then
    NBCONVERT=true jupyter nbconvert --to webpdf --no-input --allow-chromium-download --disable-chromium-sandbox "$jupyter_notebook_output_file"
    echo "executeJupyterNotebook: Successfully created PDF ${jupyter_notebook_output_file}."
fi