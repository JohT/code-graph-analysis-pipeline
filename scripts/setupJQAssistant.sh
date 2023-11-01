#!/usr/bin/env bash

# Installs (download and unzip) jQAssistant (https://jqassistant.org/get-started).

# Requires download.sh

# Note: This script runs in the current directory. If you want JQassistant to be installed in e.a. the "tools" directory, 
# then create and change it beforehand.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -eo pipefail

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.0.8"} # Neo4j v5: 2.0.3 (june 2023), Neo4j v4: 1.12.2 (april 2023)
JQASSISTANT_CLI_DOWNLOAD_URL=${JQASSISTANT_CLI_DOWNLOAD_URL:-"https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli"} # Download URL for the jQAssistant CLI
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-distribution"} #  Neo4j v5: "jqassistant-commandline-distribution", Neo4j v4: "jqassistant-commandline-neo4jv3"
JQASSISTANT_CLI_DISTRIBUTION=${JQASSISTANT_CLI_DISTRIBUTION:-"bin.zip"} #  Neo4j v5: "bin.zip", Neo4j v4: "distribution.zip"
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "setupJQAssistant: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "setupJQAssistant: Error: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create tools directory if it doesn't exists
    echo "setupJQAssistant: Creating tools directory <${TOOLS_DIRECTORY}> if neccessary"
    mkdir -p "${TOOLS_DIRECTORY}"
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    echo "setupJQAssistant: Error: Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create shared downloads directory if it doesn't exists
    echo "setupJQAssistant: Creating shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> if neccessary"
    mkdir -p "${SHARED_DOWNLOADS_DIRECTORY}"
fi

# Internal constants
JQASSISTANT_INSTALLATION_NAME="${JQASSISTANT_CLI_ARTIFACT}-${JQASSISTANT_CLI_VERSION}"
JQASSISTANT_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}"

# Download and unpack jQAssistant
if [ ! -d "${JQASSISTANT_INSTALLATION_DIRECTORY}" ] ; then    
    jqassistant_cli_fulldownload_url=${JQASSISTANT_CLI_DOWNLOAD_URL}/${JQASSISTANT_CLI_ARTIFACT}/${JQASSISTANT_CLI_VERSION}/${JQASSISTANT_CLI_ARTIFACT}-${JQASSISTANT_CLI_VERSION}-${JQASSISTANT_CLI_DISTRIBUTION}
    jqassistant_cli_fulldownload_file="${JQASSISTANT_INSTALLATION_NAME}.zip"
    source "${SCRIPTS_DIR}/download.sh" --url "${jqassistant_cli_fulldownload_url}" --filename "${jqassistant_cli_fulldownload_file}"

    # Unpack the ZIP file (-q option for less verbose output)
    unzip -q "${SHARED_DOWNLOADS_DIRECTORY}/${jqassistant_cli_fulldownload_file}" -d "${TOOLS_DIRECTORY}"
    
    echo "setupJQAssistant: Installed sucessfully"
else
    echo "setupJQAssistant: ${jqassistant_cli_fulldownload_file} already installed"
fi