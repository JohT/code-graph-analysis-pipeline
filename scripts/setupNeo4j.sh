#!/usr/bin/env bash

# Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community).

# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Requires download.sh,setupNeo4jInitialPassword.sh,operatingSystemFunctions.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"2025.11.2"}

NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"2025.11.2"} # Awesome Procedures On Cypher (APOC) Plugin version number. Version needs to be compatible to Neo4j and usually matches its version number.
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"core"} # Awesome Procedures On Cypher (APOC) for Neo4j Plugin Edition (Neo4j v4.4.x "all", Neo4j >= v5 "core")
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j/apoc"} # Awesome Procedures On Cypher (APOC) for Neo4j Plugin GitHub User/Repository (Neo4j v4.4.x "neo4j-contrib/neo4j-apoc-procedures", Neo4j >= v5 "neo4j/apoc")

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.23.0"} # Graph Data Science (GDS) Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_OPEN_GDS_PLUGIN_VERSION=${NEO4J_OPEN_GDS_PLUGIN_VERSION:-"2.24.0"} # Graph Data Science (GDS) Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_GDS_PLUGIN_EDITION=${NEO4J_GDS_PLUGIN_EDITION:-"open"} # Graph Data Science (GDS) Plugin Edition: "open" for OpenGDS, "full" for the full version with Neo4j license

DATA_DIRECTORY=${DATA_DIRECTORY:-"$( pwd -P )/data"} # Path where Neo4j writes its data to (outside tools dir)
RUNTIME_DIRECTORY=${RUNTIME_DIRECTORY:-"$( pwd -P )/runtime"} # Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
IMPORT_DIRECTORY=${IMPORT_DIRECTORY:-"$( pwd -P )/import"} # The name of the directory that is used to import data (e.g. CSV) files. Defaults to "import".
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"} # Neo4j HTTPS port for encrypted querying
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"} # Neo4j's own "Bolt Protocol" port

NEO4J_CONFIG_TEMPLATE=${NEO4J_CONFIG_TEMPLATE:-"template-neo4j.conf"} # Name of the template file ("configuration" folder) for the Neo4j configuration. Defaults to "template-neo4j.conf".

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"
NEO4J_CONFIG="${NEO4J_INSTALLATION_DIRECTORY}/conf/neo4j.conf"
NEO4J_PLUGINS="${NEO4J_INSTALLATION_DIRECTORY}/plugins"
NEO4J_APOC_CONFIG="${NEO4J_INSTALLATION_DIRECTORY}/conf/apoc.conf"
NEO4J_APOC_PLUGIN_ARTIFACT="apoc-${NEO4J_APOC_PLUGIN_VERSION}-${NEO4J_APOC_PLUGIN_EDITION}.jar"
NEO4J_MAJOR_VERSION_NUMBER=$(echo "$NEO4J_VERSION" | cut -d'.' -f1) # First part of the version number (=major version number)

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Repository directory containing the shell scripts
echo "setupNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "setupNeo4j: Error: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create tools directory if it doesn't exists
    echo "setupNeo4j: Creating tools directory <${TOOLS_DIRECTORY}> if necessary"
    mkdir -p "${TOOLS_DIRECTORY}"
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    echo "setupNeo4j: Error: Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create shared downloads directory if it doesn't exists
    echo "setupNeo4j: Creating shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> if necessary"
    mkdir -p "${SHARED_DOWNLOADS_DIRECTORY}"
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "setupNeo4j: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Include operation system function to for example detect Windows.
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

# Download and extract Neo4j
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then

    neo4jInstallationSystemPostfix=$(ifWindows "windows.zip" "unix.tar.gz")
    neo4jDownloadArchiveFileName="${NEO4J_INSTALLATION_NAME}-${neo4jInstallationSystemPostfix}"
    echo "setupNeo4j: Using Neo4j distribution ${neo4jDownloadArchiveFileName}"

    source "${SCRIPTS_DIR}/download.sh" --url "https://dist.neo4j.org/${neo4jDownloadArchiveFileName}" || exit 1
    
    if [[ ${neo4jInstallationSystemPostfix} == "unix.tar.gz" ]]; then
        # Extract the unix tar file
        tar -xf "${SHARED_DOWNLOADS_DIRECTORY}/${neo4jDownloadArchiveFileName}" --directory "${TOOLS_DIRECTORY}" || exit 1
    else
        # Unpack the windows ZIP file (-q option for less verbose output, ignore warnings (backslash) with || true)
        unzip -q "${SHARED_DOWNLOADS_DIRECTORY}/${neo4jDownloadArchiveFileName}" -d "${TOOLS_DIRECTORY}" || true
    fi

    # Fail if Neo4j hadn't been downloaded successfully
    if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
        echo "setupNeo4j: Error: Failed to download ${NEO4J_INSTALLATION_NAME} from ${NEO4J_DOWNLOAD_BASE_URL} into ${TOOLS_DIRECTORY}"
        exit 1
    fi

    echo "setupNeo4j: Commenting out configuration properties that will later be replaced or are not needed"
    if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
        sed -i.backup '/^server\.directories\.import=/ s/^/# defined in the directory section further below #/' "${NEO4J_CONFIG}"
        sed -i.backup '/^db\.tx_log\.rotation\.retention_policy=/ s/^/# defined in the transaction section further below #/' "${NEO4J_CONFIG}"
    else
        sed -i.backup '/^dbms\.directories\.import=/ s/^/# defined in the directory section further below #/' "${NEO4J_CONFIG}"
        sed -i.backup '/^dbms\.tx_log\.rotation\.retention_policy=/ s/^/# defined in the transaction section further below #/' "${NEO4J_CONFIG}"
    fi
    # Remove the backup file
    rm -f "${NEO4J_CONFIG}.backup"

    # Configure all paths with data that changes (database data, logs, ...) to be in the outside "data" directory
    # instead of inside the neo4j directory
    echo "setupNeo4j: Configuring dynamic settings (data directories, ports, ...)"

    neo4jDataPath=$(convertPosixToWindowsPathIfNecessary "${DATA_DIRECTORY}")
    neo4jLogsPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/logs")
    neo4jDumpsPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/dumps")
    neo4jRunPath=$(convertPosixToWindowsPathIfNecessary "${RUNTIME_DIRECTORY}/run")
    neo4jTransactionsPath=$(convertPosixToWindowsPathIfNecessary "${DATA_DIRECTORY}/transactions")
    neo4jImportPath=$(convertPosixToWindowsPathIfNecessary "${IMPORT_DIRECTORY}")
    
    # Create import directory in case it doesn't exist.
    # The import needs to be configured even if its not used since it will be configured below and validated by Neo4j.
    mkdir -p "${IMPORT_DIRECTORY}"

    if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
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

    echo "setupNeo4j: Appending configuration template ${NEO4J_CONFIG_TEMPLATE} (memory, procedure permissions, ...)"
    cat "${SCRIPTS_DIR}/configuration/${NEO4J_CONFIG_TEMPLATE}" >> "${NEO4J_CONFIG}"

    # Set initial password for user "neo4j" otherwise the default password "neo4j" would need to be changed immediately (prompt).
    # This needs to be done after the configuration changes.
    source "${SCRIPTS_DIR}/setupNeo4jInitialPassword.sh"

    echo "setupNeo4j: Installed successfully"
else
    echo "setupNeo4j: ${NEO4J_INSTALLATION_NAME} already installed"
fi

# Download and Install the Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
if [ ! -f "${NEO4J_PLUGINS}/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then

    source "${SCRIPTS_DIR}/download.sh" --url "https://github.com/${NEO4J_APOC_PLUGIN_GITHUB}/releases/download/${NEO4J_APOC_PLUGIN_VERSION}/${NEO4J_APOC_PLUGIN_ARTIFACT}" || exit 1

    # Uninstall previously installed Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
    rm -f "${NEO4J_PLUGINS}/apoc*.jar"

    # Install the Neo4j Plugin "Awesome Procedures for Neo4j"
    echo "setupNeo4j: Installing ${NEO4J_APOC_PLUGIN_ARTIFACT}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" "${NEO4J_INSTALLATION_DIRECTORY}/plugins"

    # Fail if Neo4j Plugin "Awesome Procedures for Neo4j" (APOC) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_PLUGINS}/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Error: Failed to install ${NEO4J_APOC_PLUGIN_ARTIFACT}"
        exit 1
    fi

    # Configure Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
    echo "setupNeo4j: Configuring Neo4j Plugin ${NEO4J_APOC_PLUGIN_ARTIFACT} (APOC)"
    {
         echo "# Reference: https://neo4j.com/docs/apoc/current/config/#_apoc_export_file_enabled"
         echo ""
         echo "# Enables writing local files to disk for file export. Default=false"
         echo "apoc.export.file.enabled=true"
    } >> "${NEO4J_APOC_CONFIG}"

    echo "setupNeo4j: Awesome Procedures for Neo4j (APOC) installed successfully"
else 
    echo "setupNeo4j: ${NEO4J_APOC_PLUGIN_ARTIFACT} already installed"
fi

# Download and install the Neo4j plugin "Graph Data Science" (GDS)
if [[ ${NEO4J_GDS_PLUGIN_EDITION} == "open" ]]; then
    neo4jGraphDataScienceDownloadUrl="https://github.com/JohT/open-graph-data-science-packaging/releases/download/v${NEO4J_OPEN_GDS_PLUGIN_VERSION}"
    neo4jGraphDataScienceReleaseArtifact="open-graph-data-science-${NEO4J_OPEN_GDS_PLUGIN_VERSION}-for-neo4j-${NEO4J_MAJOR_VERSION_NUMBER}.jar"
else
    neo4jGraphDataScienceDownloadUrl="https://github.com/neo4j/graph-data-science/releases/download/${NEO4J_GDS_PLUGIN_VERSION}"
    neo4jGraphDataScienceReleaseArtifact="neo4j-graph-data-science-${NEO4J_GDS_PLUGIN_VERSION}.jar"
fi

if [ ! -f "${NEO4J_PLUGINS}/${neo4jGraphDataScienceReleaseArtifact}" ] ; then
    # Download the Neo4j Plugin "Graph Data Science" (GDS)
    source "${SCRIPTS_DIR}/download.sh" --url "${neo4jGraphDataScienceDownloadUrl}/${neo4jGraphDataScienceReleaseArtifact}" || exit 1

    # Uninstall previously installed Neo4j Plugin "Graph Data Science" (GDS)
    rm -f "${NEO4J_PLUGINS}/*graph-data-science*.jar"
    
    # Install the Neo4j Plugin "Graph Data Science" (GDS)
    echo "setupNeo4j: Installing ${neo4jGraphDataScienceReleaseArtifact}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${neo4jGraphDataScienceReleaseArtifact}" "${NEO4J_PLUGINS}"

    # Fail if Neo4j Plugin "Graph Data Science" (GDS) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_PLUGINS}/${neo4jGraphDataScienceReleaseArtifact}" ] ; then
        echo "setupNeo4j: Error: Failed to install ${neo4jGraphDataScienceReleaseArtifact}"
        exit 1
    fi

    echo "setupNeo4j: Graph Data Science (GDS) installed successfully"
else 
    echo "setupNeo4j: ${neo4jGraphDataScienceReleaseArtifact} already installed"
fi