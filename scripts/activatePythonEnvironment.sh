#!/usr/bin/env bash

# Activates the .venv environment (Python build-in virtual environments) with all packages necessary to run the included Jupyter Notebooks and Python scripts.

# Note: If the environment hadn't been created yet, it will use "requirements.txt" from the root directory to create the environment.

# Requires operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV=${USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV:-"false"} # Use "venv" for virtual Python environments ("true") or use an already prepared (e.g. conda) environment (default, "false").

if [ "${USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV}" = "false" ]; then
    echo "activatePythonEnvironment: Skipping activation. An already activated environment and installed dependencies are expected e.g. by using conda (USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV=false)."
    # "return" needs to be used here instead of "exit".
    # This script is included in another script by using "source". 
    # "exit" would end the main script, "return" just ends this sub script.
    return 0
fi

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "activatePythonEnvironment: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the root directory by taking the path of this script and going one directory up.
ROOT_DIRECTORY=${ROOT_DIRECTORY:-"$(dirname "${SCRIPTS_DIR}")"} # Repository directory containing the Jupyter Notebooks
echo "activatePythonEnvironment: ROOT_DIRECTORY=${ROOT_DIRECTORY}"

# Get the file name of the environment description file for the conda package and environment manager 
# that contains all dependencies and their versions.
PYTHON_ENVIRONMENT_FILE=${PYTHON_ENVIRONMENT_FILE:-"${ROOT_DIRECTORY}/requirements.txt"} # Pip (package manager for Python) environment file path
if [ ! -f "${PYTHON_ENVIRONMENT_FILE}" ] ; then
    echo "activatePythonEnvironment: Couldn't find environment file ${PYTHON_ENVIRONMENT_FILE}."
    exit_failed
fi

deactivate_conda_if_necessary() {
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
    echo "activatePythonEnvironment: pathToConda=${pathToConda} (for deactivation)"

    scriptExtension=$(ifWindows ".bat" "")
    echo "activatePythonEnvironment: scriptExtension=${scriptExtension}"

    if "${pathToConda}conda" deactivate >/dev/null 2>&1; then
        # Call "deactivate" a second time to also deactivate the "base" environment
        "${pathToConda}conda" deactivate >/dev/null 2>&1;
        echo "activatePythonEnvironment: Conda deactivated"
    else
        echo "activatePythonEnvironment: Conda not found. Deactivation skipped"
    fi
}

VENV_DIRECTORY=".venv"

# Create the virtual environment if needed
if [ ! -d "${ROOT_DIRECTORY}/${VENV_DIRECTORY}" ]; then
    deactivate_conda_if_necessary
    echo "activatePythonEnvironment: Creating ${VENV_DIRECTORY} environment..."
    python -m venv "${ROOT_DIRECTORY}/${VENV_DIRECTORY}"
else
    echo "activatePythonEnvironment: Already created ${VENV_DIRECTORY} environment."
fi

# Activate the virtual environment if needed
if [ "${VIRTUAL_ENV}" != "${ROOT_DIRECTORY}/${VENV_DIRECTORY}" ]; then
    echo "activatePythonEnvironment: Activate ${VENV_DIRECTORY} environment..."
    source "${ROOT_DIRECTORY}/${VENV_DIRECTORY}/bin/activate"
else
    echo "activatePythonEnvironment: Already activated ${VENV_DIRECTORY} environment."
fi

# Install the virtual environment if needed
if pip install --dry-run --no-deps --requirement "${PYTHON_ENVIRONMENT_FILE}" 2>/dev/null | grep -q "Would install"; then
    echo "activatePythonEnvironment: Install environment dependencies..."
    pip install -q --requirement "${PYTHON_ENVIRONMENT_FILE}"
else
    echo "activatePythonEnvironment: Already installed environment dependencies."
fi

echo "activatePythonEnvironment: Python installation: $(which python)"