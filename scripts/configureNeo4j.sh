#!/usr/bin/env bash

# Configures a (local) Neo4j Community Edition Graph Database (https://neo4j.com/download-center/#community).
# 
# Main input is the environment variable NEO4J_CONFIG_TEMPLATE: 
# - The name of the template file ("scripts/configuration" folder) for the Neo4j configuration. 
# - Defaults to "template-neo4j.conf". 
# - The template configuration will be appended to the end of the Neo4j configuration file.
#
# Prerequisites:
# - Intended to be sourced from within another script like the setupNeo4j.sh script 
# - Neo4j has been installed 
# - The tools directory has been created
#
# Example Usage:
# - NEO4J_CONFIG_TEMPLATE=template-neo4j-high-memory.conf ./../../scripts/configureNeo4j.sh
#
# When run for the first time, the original configuration will be backed up and all configuration entries will be set.
# When run again (re-configuration), the template configuration at the end if the script is executed again.
#
# Requires operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"2026.01.4"}

DATA_DIRECTORY=${DATA_DIRECTORY:-"$( pwd -P )/data"} # Path where Neo4j writes its data to (outside tools dir)
RUNTIME_DIRECTORY=${RUNTIME_DIRECTORY:-"$( pwd -P )/runtime"} # Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"$( pwd -P )/import"} # The name of the directory that is used to import data (e.g. CSV) files. Defaults to "import".
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"} # Neo4j HTTPS port for encrypted querying
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"} # Neo4j's own "Bolt Protocol" port

NEO4J_CONFIG_TEMPLATE=${NEO4J_CONFIG_TEMPLATE:-"template-neo4j.conf"} # Name of the template file ("configuration" folder) for the Neo4j configuration. Defaults to "template-neo4j.conf".

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
SCRIPT_NAME="configureNeo4j"
#echo "${SCRIPT_NAME}: SCRIPTS_DIR=${SCRIPTS_DIR}"

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"
NEO4J_CONFIG="${NEO4J_INSTALLATION_DIRECTORY}/conf/neo4j.conf"
NEO4J_MAJOR_VERSION_NUMBER=$(echo "${NEO4J_VERSION}" | cut -d'.' -f1) # First part of the version number (=major version number)
NEO4J_CONFIG_TEMPLATE_PATH="${SCRIPTS_DIR}/configuration/${NEO4J_CONFIG_TEMPLATE}"

# Include operation system functions like "convertPosixToWindowsPathIfNecessary".
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

fail() {
  local ERROR_COLOR='\033[0;31m' # red
  local DEFAULT_COLOR='\033[0m'
  local errorMessage="${1}"
  echo -e "${ERROR_COLOR}${SCRIPT_NAME}: Error: ${errorMessage}${DEFAULT_COLOR}" >&2
  exit 1
}

insert_hint_that_the_configuration_is_script_managed() {
    local file="$1"
    local tempFile
    tempFile="$(mktemp)"
    
    awk '
        BEGIN { 
            separator_count = 0 
            separator_pattern = "^#\\*{11,}$"
        }
        {
            if ($0 ~ separator_pattern) {
                separator_count++
                if (separator_count == 2) {
                    print "#"
                    print "# This file had been configured with the configureNeo4j.sh script of code-graph-analysis-pipeline."
                    print "# Manual changes to this file might be overwritten when the script is executed again since the script is designed to update the configuration according to the template configuration."
                    print "# Please check the documentation of the configureNeo4j.sh script for more details."
                }
            }

            print
        }
    ' "${file}" > "${tempFile}" && mv "${tempFile}" "$file"
}

append_configuration_from_template() {
    echo "${SCRIPT_NAME}: Appending configuration template ${NEO4J_CONFIG_TEMPLATE} (memory, procedure permissions, ...)"
    local EYE_CATCHER_COMMENT_PREFIX="# The following configuration entries were taken from"

    # Check if a template configuration had already been appended by looking for the eye-catcher comment. 
    # If it is already there, then delete the old template configuration including the eye-catcher and append the new one again to update it. 
    # This way this function is idempotent, the configuration is always up to date with the template and there are no duplicate entries.
    if grep -q "^${EYE_CATCHER_COMMENT_PREFIX}" "${NEO4J_CONFIG}"; then
        echo "${SCRIPT_NAME}: Deleting old configuration that had been appended from the template before since the eye-catcher comment was found. This ensures that there are no duplicate entries and that the configuration is up to date with the template."
        sed -i.edit.backup "/^${EYE_CATCHER_COMMENT_PREFIX}/,/^# End of configuration from ${NEO4J_CONFIG_TEMPLATE}/d" "${NEO4J_CONFIG}"
        if grep -q '^$' "${NEO4J_CONFIG}"; then
            sed -i.edit.backup '$d' "${NEO4J_CONFIG}" # Delete the last line of the config if it is an empty line
        fi
        rm -f "${NEO4J_CONFIG}.edit.backup" # The backup is created even if not needed to be compatible with both GNU sed and BSD sed (e.g. on
    fi

    # Append first an eye-catcher comment to the configuration file to indicate that the configuration is script-managed 
    # and that manual changes might be overwritten.
    {
        echo ""
        echo "${EYE_CATCHER_COMMENT_PREFIX} '${NEO4J_CONFIG_TEMPLATE}' by the script ${SCRIPT_NAME}."
        echo "# WARNING: Manual changes below this line might be overwritten when the script is executed again."
        echo ""
    } >> "${NEO4J_CONFIG}"

    cat "${NEO4J_CONFIG_TEMPLATE_PATH}" >> "${NEO4J_CONFIG}"
}

if [ -z "${TOOLS_DIRECTORY}" ]; then
    fail "Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
fi
if [ ! -d "${TOOLS_DIRECTORY}" ]; then
    fail "Tools directory <${TOOLS_DIRECTORY}> does not exist. Please install Neo4j first by running the setupNeo4j.sh script which will create the tools directory if necessary."
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    fail "Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
fi
if [ ! -d "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    fail "Shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> does not exist. Please install Neo4j first by running the setupNeo4j.sh script which will create the shared downloads directory if necessary."
fi

# Fail if Neo4j hadn't been downloaded yet
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
    fail "${NEO4J_INSTALLATION_NAME} is not installed into ${TOOLS_DIRECTORY} yet. Please run the setupNeo4j.sh script first to download and install Neo4j."
fi

if [ ! -f "${NEO4J_CONFIG_TEMPLATE_PATH}" ]; then
    fail "Configuration template file ${NEO4J_CONFIG_TEMPLATE} does not exist in the scripts/configuration folder. Please make sure it exists and is correctly named:\n${NEO4J_CONFIG_TEMPLATE_PATH}"
fi

# Create a backup of the original configuration file before any modification in case there is none yet.
if [ ! -f "${NEO4J_CONFIG}.original.backup" ]; then
    cp "${NEO4J_CONFIG}" "${NEO4J_CONFIG}.original.backup"
    echo "${SCRIPT_NAME}: First time configuration. Created backup of the original configuration file at ${NEO4J_CONFIG}.original.backup"
else 
    echo "${SCRIPT_NAME}: Re-Configuration because ${NEO4J_CONFIG}.original.backup already exists."
    append_configuration_from_template
    echo "${SCRIPT_NAME}: Configuration template replaced successfully."
    return 0
fi

echo "${SCRIPT_NAME}: Commenting out configuration properties that will later be replaced or are not needed"
if [ "${NEO4J_MAJOR_VERSION_NUMBER}" -ge 5 ]; then
    sed -i.edit.backup '/^server\.directories\.import=/ s/^/# defined in the directory section further below #/' "${NEO4J_CONFIG}"
    sed -i.edit.backup '/^db\.tx_log\.rotation\.retention_policy=/ s/^/# defined in the transaction section further below #/' "${NEO4J_CONFIG}"
else
    sed -i.edit.backup '/^dbms\.directories\.import=/ s/^/# defined in the directory section further below #/' "${NEO4J_CONFIG}"
    sed -i.edit.backup '/^dbms\.tx_log\.rotation\.retention_policy=/ s/^/# defined in the transaction section further below #/' "${NEO4J_CONFIG}"
fi
# Remove the edit backup file
rm -f "${NEO4J_CONFIG}.edit.backup"

# Configure all paths with data that changes (database data, logs, ...) to be in the outside "data" directory
# instead of inside the neo4j directory
echo "${SCRIPT_NAME}: Configuring dynamic settings (data directories, ports, ...)"

neo4jDataPath=$(convertPosixToWindowsPathIfNecessary "${DATA_DIRECTORY}")
neo4jLogsPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/logs")
neo4jDumpsPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/dumps")
neo4jRunPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/run")
neo4jTransactionsPath=$(convertPosixToWindowsPathIfNecessary "${DATA_DIRECTORY}/transactions")
neo4jImportPath=$(convertPosixToWindowsPathIfNecessary "${IMPORT_DIRECTORY}")

# Create import directory in case it doesn't exist.
# The import needs to be configured even if its not used since it will be configured below and validated by Neo4j.
mkdir -p "${IMPORT_DIRECTORY}"

if [ "${NEO4J_MAJOR_VERSION_NUMBER}" -ge 5 ]; then
    echo "setupNeo4j: Neo4j v5 or higher detected"
    {
        echo ""
        echo "# Paths of data directories in the installation (> v5)"
        echo "server.directories.data=${neo4jDataPath}"
        echo "server.directories.logs=${neo4jLogsPath}"
        echo "server.directories.dumps.root=${neo4jDumpsPath}"
        echo "server.directories.run=${neo4jRunPath}"
        echo "server.directories.transaction.logs.root=${neo4jTransactionsPath}"
        echo "server.directories.import=${neo4jImportPath}"
        echo ""
        echo "# Ports Configuration (> v5)"
        echo "server.bolt.listen_address=:${NEO4J_BOLT_PORT}"
        echo "server.bolt.advertised_address=:${NEO4J_BOLT_PORT}"
        echo "server.http.listen_address=:${NEO4J_HTTP_PORT}"
        echo "server.http.advertised_address=:${NEO4J_HTTP_PORT}"
        echo "server.https.listen_address=:${NEO4J_HTTPS_PORT}"
        echo "server.https.advertised_address=:${NEO4J_HTTPS_PORT}"
    } >> "${NEO4J_CONFIG}"    
else
    echo "setupNeo4j: Neo4j v4 or lower detected"
    {
        echo ""
        echo "# Paths of data directories in the installation"
        echo "dbms.directories.data=${neo4jDataPath}"
        echo "dbms.directories.logs=${neo4jLogsPath}"
        echo "dbms.directories.dumps.root=${neo4jDumpsPath}"
        echo "dbms.directories.run=${neo4jRunPath}"
        echo "dbms.directories.transaction.logs.root=${neo4jTransactionsPath}"
        echo "dbms.directories.import=${neo4jImportPath}"
        echo ""
        echo "# Ports Configuration"
        echo "dbms.connector.bolt.listen_address=:${NEO4J_BOLT_PORT}"
        echo "dbms.connector.bolt.advertised_address=:${NEO4J_BOLT_PORT}"
        echo "dbms.connector.http.listen_address=:${NEO4J_HTTP_PORT}"
        echo "dbms.connector.http.advertised_address=:${NEO4J_HTTP_PORT}"
        echo "dbms.connector.https.listen_address=:${NEO4J_HTTPS_PORT}"
        echo "dbms.connector.https.advertised_address=:${NEO4J_HTTPS_PORT}"
    } >> "${NEO4J_CONFIG}"
fi

append_configuration_from_template
insert_hint_that_the_configuration_is_script_managed "${NEO4J_CONFIG}"

echo "${SCRIPT_NAME}: Configuration successfully updated."