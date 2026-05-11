#!/usr/bin/env bash

# Activates the uv-managed .venv environment with all packages from pyproject.toml necessary to run the included Python scripts.

# Note: Requires operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail -o nounset
IFS=$'\n\t'

PYTHON_PACKAGE_MANAGER=${PYTHON_PACKAGE_MANAGER:-"uv"} # Python package manager to use. Options: "uv" (default), "conda". Use "conda" to switch to the Conda-based activation.

if [[ "${PYTHON_PACKAGE_MANAGER}" != "uv" ]]; then
    echo "activateUvEnvironment: Skipping. PYTHON_PACKAGE_MANAGER=${PYTHON_PACKAGE_MANAGER} (expected 'uv')."
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
echo "activateUvEnvironment: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Get the root directory by taking the path of this script and going one directory up.
ROOT_DIRECTORY=${ROOT_DIRECTORY:-"$(dirname "${SCRIPTS_DIR}")"}  # Repository root directory
echo "activateUvEnvironment: ROOT_DIRECTORY=${ROOT_DIRECTORY}"

# Check that uv is available. Hard-fail with install instructions if not.
if ! command -v uv &> /dev/null; then
    echo "activateUvEnvironment: ERROR - 'uv' not found. Install from https://docs.astral.sh/uv/getting-started/installation/"
    exit 1
fi
echo "activateUvEnvironment: uv version=$(uv --version)"

# Install/sync packages from pyproject.toml using the lockfile (frozen = no implicit updates).
echo "activateUvEnvironment: Running uv sync --frozen in ${ROOT_DIRECTORY}"
uv sync --frozen --project "${ROOT_DIRECTORY}"

# Include operating system functions to detect Windows / Git Bash.
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

# Activate the .venv created by uv.
# On Windows (Git Bash/WSL) the activate script lives under Scripts/, on Unix under bin/.
if isWindows; then
    venvActivate="${ROOT_DIRECTORY}/.venv/Scripts/activate"
else
    venvActivate="${ROOT_DIRECTORY}/.venv/bin/activate"
fi

if [ ! -f "${venvActivate}" ]; then
    echo "activateUvEnvironment: ERROR - venv activate script not found at ${venvActivate}"
    exit 1
fi

echo "activateUvEnvironment: Activating venv from ${venvActivate}"
# shellcheck disable=SC1090
source "${venvActivate}"
echo "activateUvEnvironment: Python=$(python --version 2>&1)"
