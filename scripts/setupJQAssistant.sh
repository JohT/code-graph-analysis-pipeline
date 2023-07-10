#!/usr/bin/env bash

# Installs (download and unzip) jQAssistant (https://jqassistant.org/get-started).

# Be aware that this script runs in the current directory. 
# If you want JQassistant to be installed in the "tools" directory, then create and change it beforehand.

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.0.4"} # Neo4j v5: 2.0.3 (june 2023), Neo4j v4: 1.12.2 (april 2023)
JQASSISTANT_CLI_DOWNLOAD_URL=${JQASSISTANT_CLI_DOWNLOAD_URL:-"https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli"}
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-distribution"} #  Neo4j v5: "jqassistant-commandline-distribution", Neo4j v4: "jqassistant-commandline-neo4jv3"
JQASSISTANT_CLI_DISTRIBUTION=${JQASSISTANT_CLI_DISTRIBUTION:-"bin.zip"} #  Neo4j v5: "bin.zip", Neo4j v4: "distribution.zip"
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

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
    
    # Download jQAssistant 
    if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" ] ; then
        jqassistant_cli_fulldownload_url=${JQASSISTANT_CLI_DOWNLOAD_URL}/${JQASSISTANT_CLI_ARTIFACT}/${JQASSISTANT_CLI_VERSION}/${JQASSISTANT_CLI_ARTIFACT}-${JQASSISTANT_CLI_VERSION}-${JQASSISTANT_CLI_DISTRIBUTION}
        echo "setupJQAssistant: Downloading ${JQASSISTANT_INSTALLATION_NAME}.zip from ${jqassistant_cli_fulldownload_url}"
        
        # Download jQAssistant
        # With the option "-L" a redirection will be followed automatically
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" "${jqassistant_cli_fulldownload_url}"
    else
        echo "setupJQAssistant: ${JQASSISTANT_INSTALLATION_NAME} already downloaded"
    fi

    downloaded_file_size=$(wc -c "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" | awk '{print $1}')
    if [[ "${downloaded_file_size}" -le 1000 ]]; then
        echo "setupJQAssistant: Error: Failed to download ${JQASSISTANT_INSTALLATION_NAME}. Invalid Filesize"
        rm -f "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip"
        exit 1
    fi

    # Unpack the ZIP file (-q option for less verbose output)
    unzip -q "${SHARED_DOWNLOADS_DIRECTORY}/${JQASSISTANT_INSTALLATION_NAME}.zip" -d "${TOOLS_DIRECTORY}"
else
    echo "setupJQAssistant: ${JQASSISTANT_INSTALLATION_NAME}.zip already installed"
fi