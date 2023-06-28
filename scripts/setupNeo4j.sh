#!/usr/bin/env bash

# Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community).

# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"5.9.0"}
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"5.9.0"} #Awesome Procedures for Neo4j Plugin, Version needs to be compatible to Neo4j
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"core"} #Awesome Procedures for Neo4j Plugin Edition (Neo4j v4.4.x "all", Neo4j >= v5 "core")
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j/apoc"} #Awesome Procedures for Neo4j Plugin GitHub User/Repository (Neo4j v4.4.x "neo4j-contrib/neo4j-apoc-procedures", Neo4j >= v5 "neo4j/apoc")
NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.4.1"} # Graph Data Science Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_DATA_PATH=${NEO4J_DATA_PATH:-"$( pwd -P )/data"} # Path where Neo4j writes its data to (outside tools dir)
NEO4J_RUNTIME_PATH=${NEO4J_RUNTIME_PATH:-"$( pwd -P )/runtime"} # Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir)
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
SHARED_DOWNLOADS_DIRECTORY="${SHARED_DOWNLOADS_DIRECTORY:-$(dirname "$( pwd )")/downloads}"

NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"}
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"}

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"
NEO4J_CONFIG="${NEO4J_INSTALLATION_DIRECTORY}/conf/neo4j.conf"
NEO4J_APOC_CONFIG="${NEO4J_INSTALLATION_DIRECTORY}/conf/apoc.conf"
NEO4J_APOC_PLUGIN_ARTIFACT="apoc-${NEO4J_APOC_PLUGIN_VERSION}-${NEO4J_APOC_PLUGIN_EDITION}.jar"
NEO4J_GDS_PLUGIN_ARTIFACT="neo4j-graph-data-science-${NEO4J_GDS_PLUGIN_VERSION}.jar"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "setupNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "setupNeo4j: Error: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create tools directory if it doesn't exists
    echo "setupNeo4j: Creating tools directory <${TOOLS_DIRECTORY}> if neccessary"
    mkdir -p "${TOOLS_DIRECTORY}"
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    echo "setupNeo4j: Error: Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create shared downloads directory if it doesn't exists
    echo "setupNeo4j: Creating shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> if neccessary"
    mkdir -p "${SHARED_DOWNLOADS_DIRECTORY}"
fi

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "setupNeo4j: Error: Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your password'."
    exit 1
fi

# Download and extract Neo4j
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then

    # Download Neo4j 
    if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}-unix.tar.gz" ] ; then
        echo "setupNeo4j: Downloading ${NEO4J_INSTALLATION_NAME}"

        # Download Neo4j
        # With the option "-L" a redirection will be followed automatically
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}-unix.tar.gz" "https://dist.neo4j.org/${NEO4J_INSTALLATION_NAME}-unix.tar.gz" || exit 1
    else
        echo "setupNeo4j: ${NEO4J_INSTALLATION_NAME} already downloaded"
    fi

    downloaded_neo4j_archive="${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}-unix.tar.gz"

    # Check downloaded file size to be at least 100 bytes
    downloaded_file_size=$(wc -c "${downloaded_neo4j_archive}")
    if [[ "$downloaded_file_size" -le 100 ]]; then
        echo "setupNeo4j: Error: Failed to download ${NEO4J_INSTALLATION_NAME}: Invalid Filesize."
        rm -f "${downloaded_neo4j_archive}"
        exit 1
    fi

    # Extract the tar file
    tar -xf "${downloaded_neo4j_archive}" --directory "${TOOLS_DIRECTORY}"

    # Fail if Neo4j hadn't been downloaded successfully
    if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
        echo "setupNeo4j: Error: Failed to download ${NEO4J_INSTALLATION_NAME} from ${NEO4J_DOWNLOAD_BASE_URL} into ${TOOLS_DIRECTORY}"
        exit 1
    fi

    # Extract the first component of the version number (=major version number)
    NEO4J_MAJOR_VERSION_NUMBER=$(echo "$NEO4J_VERSION" | cut -d'.' -f1)

    # Configure all paths with data that changes (database data, logs, ...) to be in the outside "data" directory
    # instead of inside the neo4j directory
    echo "setupNeo4j: Configuring dynamic settings (data directories, ports, ...)"

    if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
        echo "setupNeo4j: Neo4j v5 or higher detected"
        {
            echo ""
            echo "# Paths of data directories in the installation (v5)"
            echo "server.directories.data=${NEO4J_DATA_PATH}"
            echo "server.directories.logs=${NEO4J_RUNTIME_PATH}/logs"
            echo "server.directories.dumps.root=${NEO4J_RUNTIME_PATH}/dumps"
            echo "server.directories.run=${NEO4J_RUNTIME_PATH}/run"
            echo "server.directories.transaction.logs.root=${NEO4J_DATA_PATH}/transactions"
            echo ""
            echo "# Ports Configuration (v5)"
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
            echo "dbms.directories.data=${NEO4J_DATA_PATH}"
            echo "dbms.directories.logs=${NEO4J_RUNTIME_PATH}/logs"
            echo "dbms.directories.dumps.root=${NEO4J_RUNTIME_PATH}/dumps"
            echo "dbms.directories.run=${NEO4J_RUNTIME_PATH}/run"
            echo "dbms.directories.transaction.logs.root=${NEO4J_DATA_PATH}/transactions"
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

    echo "setupNeo4j: Configuring static settings (memory, procedure permittions, ...)"
    if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
        cat "${SCRIPTS_DIR}/templates/template-neo4j.conf" >> "${NEO4J_CONFIG}"
    else
        cat "${SCRIPTS_DIR}/templates/template-neo4j-v4.conf" >> "${NEO4J_CONFIG}"
    fi

    # Set initial password for user "neo4j" otherwise the default password "neo4j" would need to be changed immediately (prompt).
    # This needs to be done after the configuration changes.
    source ${SCRIPTS_DIR}/setupNeo4jInitialPassword.sh
else
    echo "setupNeo4j: ${NEO4J_INSTALLATION_NAME} already installed"
fi

# Download and Install the Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then

    # Download the Neo4j Plugin "Awesome Procedures for Neo4j"
    if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then
        # Download the Neo4j Plugin "Awesome Procedures for Neo4j"
        echo "setupNeo4j: Downloading ${NEO4J_APOC_PLUGIN_ARTIFACT}"
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" https://github.com/${NEO4J_APOC_PLUGIN_GITHUB}/releases/download/${NEO4J_APOC_PLUGIN_VERSION}/apoc-${NEO4J_APOC_PLUGIN_VERSION}-${NEO4J_APOC_PLUGIN_EDITION}.jar  || exit 1
    else
        echo "setupNeo4j: ${NEO4J_APOC_PLUGIN_ARTIFACT} already downloaded"
    fi
    
    # Check downloaded file size to be at least 100 bytes
    downloaded_file_size=$(wc -c "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}")
    if [[ "$downloaded_file_size" -le 100 ]]; then
        echo "setupNeo4j: Error: Failed to download ${NEO4J_APOC_PLUGIN_ARTIFACT}: Invalid Filesize."
        rm -f "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}"
        exit 1
    fi

    # Uninstall previously installed Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
    rm -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/apoc*.jar"

    # Install the Neo4j Plugin "Awesome Procedures for Neo4j"
    echo "setupNeo4j: Installing ${NEO4J_APOC_PLUGIN_ARTIFACT}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" "${NEO4J_INSTALLATION_DIRECTORY}/plugins"

    # Fail if Neo4j Plugin "Awesome Procedures for Neo4j" (APOC) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Error: Failed to download and install ${NEO4J_APOC_PLUGIN_ARTIFACT}"
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
else 
    echo "setupNeo4j: ${NEO4J_APOC_PLUGIN_ARTIFACT} already installed"
fi

# Download and Install the Neo4j Plugin "Graph Data Science" (GDS)
if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_GDS_PLUGIN_ARTIFACT}" ] ; then
    
    # Download the Neo4j Plugin "Graph Data Science" (GDS)
    if [ ! -f "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Downloading ${NEO4J_GDS_PLUGIN_ARTIFACT}"
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}" https://github.com/neo4j/graph-data-science/releases/download/${NEO4J_GDS_PLUGIN_VERSION}/${NEO4J_GDS_PLUGIN_ARTIFACT}  || exit 1
    else
        echo "setupNeo4j: ${NEO4J_GDS_PLUGIN_ARTIFACT} already downloaded"
    fi
    
    # Check downloaded file size to be at least 100 bytes
    downloaded_file_size=$(wc -c "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}" | awk '{print $1}')
    if [[ "$downloaded_file_size" -le 100 ]]; then
        echo "setupNeo4j: Error: Failed to download ${NEO4J_GDS_PLUGIN_ARTIFACT}. Invalid Filesize."
        rm -f "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}"
        exit 1
    fi

    # Uninstall previously installed Neo4j Plugin "Graph Data Science" (GDS)
    rm -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/neo4j-graph-data-science*.jar"
    
    # Install the Neo4j Plugin "Graph Data Science" (GDS)
    echo "setupNeo4j: Installing ${NEO4J_GDS_PLUGIN_ARTIFACT}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}" "${NEO4J_INSTALLATION_DIRECTORY}/plugins"

    # Fail if Neo4j Plugin "Graph Data Science" (GDS) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_GDS_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Error: Failed to download and install ${NEO4J_GDS_PLUGIN_ARTIFACT}"
        exit 1
    fi
else 
    echo "setupNeo4j: ${NEO4J_GDS_PLUGIN_ARTIFACT} already installed"
fi