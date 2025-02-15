#!/usr/bin/env bash

# This is an example for the analysis of a the Typescript project "ant-design".
# It includes the creation of the temporary directory, the working directory, the artifacts download and the analysis itself.

# Note: The first parameter is the version of "ant-design" to analyze.
#       All following parameters are forwarded to the "analyze" command.
# Note: This script is meant to be started in the root directory of this repository.
# Note: This script requires "cURL" ( https://curl.se ) to be installed.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

# Overrideable Defaults
SOURCE_DIRECTORY=${SOURCE_DIRECTORY:-"source"}
echo "analyzerAntDesign: SOURCE_DIRECTORY=${SOURCE_DIRECTORY}"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "analyzerAntDesign: SCRIPTS_DIR=$SCRIPTS_DIR"

# Read the first unnamed input argument containing the version of the project
projectVersion=""
case "${1}" in
  "--"*) ;; # Skipping named command line options to forward them later to the "analyze" command
  *) 
    projectVersion="${1}" 
    echo "analyzerAntDesign: Project version set to ${projectVersion}"
    shift || true
    ;;
esac

if [ -z "${projectVersion}" ]; then
  echo "analyzerAntDesign: Optional parameter <version> is not specified. Detecting latest version..." >&2
  echo "analyzerAntDesign: Usage example: $0 <version> <optional analysis parameter>" >&2
  projectVersion=$( "${SCRIPTS_DIR}/detectLatestGitTag.sh" --url "https://github.com/ant-design/ant-design.git" )
  echo "analyzerAntDesign: Using latest version: ${projectVersion}" >&2
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "analyzerAntDesign: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Create the temporary directory for all analysis projects.
mkdir -p ./temp
cd ./temp

# Create the working directory for this specific analysis.
mkdir -p "./ant-design-${projectVersion}"
cd "./ant-design-${projectVersion}" 

# Create the artifacts directory that will contain the code to be analyzed.
mkdir -p ./artifacts

# Download ant-design source code
./../../scripts/downloader/downloadAntDesign.sh "${projectVersion}"

(
  cd "./${SOURCE_DIRECTORY}//ant-design-${projectVersion}" || exit
  # npm ci is not sufficient for projects like "ant-design" that rely on generating the package-lock
  # Even if this is not standard, this is an acceptable solution since it is only used to prepare scanning.
  # The same applies to "--force" which shouldn't be done normally.
  npm install --ignore-scripts --force --verbose || exit
)

# Start the analysis
./../../scripts/analysis/analyze.sh "${@}"