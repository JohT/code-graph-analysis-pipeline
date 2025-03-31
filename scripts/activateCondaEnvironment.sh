#!/usr/bin/env bash

# Activates the Conda (Python package manager) environment "codegraph" with all packages needed to execute the Jupyter Notebooks.

# Note: This script uses the conda environment defined in CODEGRAPH_CONDA_ENVIRONMENT (defaults to "codegraph").
#       If the environment hadn't been created yet it will use "environment.yml" 
#       in the same directory as the given jupyter notebook ipynb file
#       to create the environment.

# Requires operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "activateCondaEnvironment: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the "jupyter" directory by taking the path of this script and going two directory up and then to "jupyter".
JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY:-"${SCRIPTS_DIR}/../jupyter"} # Repository directory containing the Jupyter Notebooks
echo "activateCondaEnvironment: JUPYTER_NOTEBOOK_DIRECTORY=${JUPYTER_NOTEBOOK_DIRECTORY}"

# Get the file name of the environment description file for the conda package and environment manager 
# that contains all dependencies and their versions.
CONDA_ENVIRONMENT_FILE=${CONDA_ENVIRONMENT_FILE:-"${JUPYTER_NOTEBOOK_DIRECTORY}/environment.yml"} # Conda (package manager for Python) environment file path
if [ ! -f "${CONDA_ENVIRONMENT_FILE}" ] ; then
    echo "activateCondaEnvironment: Couldn't find environment file ${CONDA_ENVIRONMENT_FILE}."
    exit 2
fi

# Define conda environment to use for code structure analysis. Default "codegraph"
CODEGRAPH_CONDA_ENVIRONMENT=${CODEGRAPH_CONDA_ENVIRONMENT:-"codegraph"} # Name of the conda environment to use for code graph analysis
echo "activateCondaEnvironment: CONDA_PREFIX=${CONDA_PREFIX}"
echo "activateCondaEnvironment: Current conda environment=${CONDA_DEFAULT_ENV}"
echo "activateCondaEnvironment: Target conda environment=${CODEGRAPH_CONDA_ENVIRONMENT}"

# TODO Find out, if conda updates (when needed) should also be done here instead of just returning 0.
# if [ "${CONDA_DEFAULT_ENV}" = "${CODEGRAPH_CONDA_ENVIRONMENT}" ] ; then
#     echo "activateCondaEnvironment: Skipping activation. Target conda environment ${CODEGRAPH_CONDA_ENVIRONMENT} is already activated."
#     # "return" needs to be used here instead of "exit".
#     # This script is included in another script by using "source". 
#     # "exit" would end the main script, "return" just ends this sub script.
#     return 0
# fi 

# Include operation system function to for example detect Windows.
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

# Determine the path to "conda"
if [ -n "${CONDA}" ]; then
    if isWindows; then
        pathToConda="${CONDA}\\Scripts\\" # the trailing backslash character is required
    else
        pathToConda="${CONDA}/bin/" # the trailing slash character is required
    fi
else
    pathToConda=""
fi
echo "activateCondaEnvironment: pathToConda=${pathToConda}"

scriptExtension=$(ifWindows ".bat" "")
echo "activateCondaEnvironment: scriptExtension=${scriptExtension}"

# Activate conda shell hook. Also resets CONDA_DEFAULT_ENV to base. 
# Thats why CONDA_DEFAULT_ENV (base) is never equal to CODEGRAPH_CONDA_ENVIRONMENT (codegraph).
eval "$(${pathToConda}conda${scriptExtension} shell.bash hook)"
echo "activateCondaEnvironment: Current conda environment after shell hook=${CONDA_DEFAULT_ENV}"

# If missing, create Conda environment for code graph analysis
# Note: The curly braces are grouping the outputs of both (piped) operations together to suppress them later (dev/null).
if "${pathToConda}conda" env list | grep "${CODEGRAPH_CONDA_ENVIRONMENT} " >/dev/null 2>&1; then
    echo "activateCondaEnvironment: Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT} has already been created."
    
    # Check if the declaration in the environment file matches the actual environment to find out if it needs to be updated.
    if "${pathToConda}conda" compare --name "${CODEGRAPH_CONDA_ENVIRONMENT}" "${CONDA_ENVIRONMENT_FILE}" >/dev/null 2>&1; then
        echo "activateCondaEnvironment: Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT} is up-to-date."
    else
        echo "activateCondaEnvironment: Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT} needs to be updated."
        "${pathToConda}conda" env update --file "${CONDA_ENVIRONMENT_FILE}" --name ${CODEGRAPH_CONDA_ENVIRONMENT} --prune
    fi
else
    echo "activateCondaEnvironment: Creating Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT}..."
    "${pathToConda}conda" env create --file "${CONDA_ENVIRONMENT_FILE}" --name "${CODEGRAPH_CONDA_ENVIRONMENT}"
fi

# Activate code graph Conda environment
echo "activateCondaEnvironment: Activating Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT}"
"${pathToConda}conda" activate ${CODEGRAPH_CONDA_ENVIRONMENT}

if [ "${CONDA_DEFAULT_ENV}" != "${CODEGRAPH_CONDA_ENVIRONMENT}" ] ; then
    echo "activateCondaEnvironment: Retry activating Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT} with plain 'conda' command"
    conda activate ${CODEGRAPH_CONDA_ENVIRONMENT}
fi

if [ "${CONDA_DEFAULT_ENV}" = "${CODEGRAPH_CONDA_ENVIRONMENT}" ] ; then
    echo "activateCondaEnvironment: Activated Conda environment: ${CONDA_DEFAULT_ENV}"
else
    echo "activateCondaEnvironment: Error: Failed to activate Conda environment ${CODEGRAPH_CONDA_ENVIRONMENT}. ${CONDA_DEFAULT_ENV} still active."
    exit 1
fi