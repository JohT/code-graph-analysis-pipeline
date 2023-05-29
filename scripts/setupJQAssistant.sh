#!/usr/bin/env bash

# Installs (download and unzip) jQAssistant (https://jqassistant.org/get-started).

# Be aware that this script runs in the current directory. 
# If you want JQassistant to be installed in the "tools" directory, then create and change it beforehand.

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"1.12.2"} # Version 1.12.2 is the current version (april 2023)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create tools directory if it doesn't exists
    echo "Creating tools directory <${TOOLS_DIRECTORY}> if neccessary"
    mkdir -p "${TOOLS_DIRECTORY}"
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    echo "Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create shared downloads directory if it doesn't exists
    echo "Creating shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> if neccessary"
    mkdir -p "${SHARED_DOWNLOADS_DIRECTORY}"
fi

# Internal constants
JQASSISTANT_INSTALLATION_NAME="jqassistant-commandline-neo4jv3-${JQASSISTANT_CLI_VERSION}"
JQASSISTANT_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}"

# Download and unpack jQAssistant
if [ ! -d "${JQASSISTANT_INSTALLATION_DIRECTORY}" ] ; then
    
    # Download jQAssistant 
    if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" ] ; then
        echo "Downloading ${JQASSISTANT_INSTALLATION_NAME}.zip"

        # Download jQAssistant
        # With the option "-L" a redirection will be followed automatically
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli/jqassistant-commandline-neo4jv3/$JQASSISTANT_CLI_VERSION/jqassistant-commandline-neo4jv3-$JQASSISTANT_CLI_VERSION-distribution.zip || exit 1
    else
        echo "${JQASSISTANT_INSTALLATION_NAME} already downloaded"
    fi

    # Unpack the ZIP file (-q option for less verbose output)
    unzip -q "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" -d "${TOOLS_DIRECTORY}"
else
    echo "${JQASSISTANT_INSTALLATION_NAME}.zip already installed"
fi