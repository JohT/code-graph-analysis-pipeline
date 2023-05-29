#!/usr/bin/env bash

# Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community).

# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (april 2023)
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"4.4.0.15"} #Awesome Procedures for Neo4j Plugin Version 4.4.0.x of is compatible with Neo4j 4.4.x
NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.3.4"} # Graph Data Science Plugin Version 2.3.x of is compatible with Neo4j 4.4.x
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
NEO4J_APOC_PLUGIN_ARTIFACT="apoc-${NEO4J_APOC_PLUGIN_VERSION}-all.jar"
NEO4J_GDS_PLUGIN_ARTIFACT="neo4j-graph-data-science-${NEO4J_GDS_PLUGIN_VERSION}.jar"

## Get this "scripts" directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
SCRIPTS_DIR=${SCRIPTS_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )}
echo "setupNeo4j: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if TOOLS_DIRECTORY variable is set
if [ -z "${TOOLS_DIRECTORY}" ]; then
    echo "setupNeo4j: Requires variable TOOLS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create tools directory if it doesn't exists
    echo "setupNeo4j: Creating tools directory <${TOOLS_DIRECTORY}> if neccessary"
    mkdir -p "${TOOLS_DIRECTORY}"
fi

# Check if SHARED_DOWNLOADS_DIRECTORY variable is set
if [ -z "${SHARED_DOWNLOADS_DIRECTORY}" ]; then
    echo "setupNeo4j: Requires variable SHARED_DOWNLOADS_DIRECTORY to be set. If it is the current directory, then use a dot to reflect that."
    exit 1
else
    # Create shared downloads directory if it doesn't exists
    echo "setupNeo4j: Creating shared downloads directory <${SHARED_DOWNLOADS_DIRECTORY}> if neccessary"
    mkdir -p "${SHARED_DOWNLOADS_DIRECTORY}"
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

    # Extract the tar file
    tar -xf "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}-unix.tar.gz" --directory "${TOOLS_DIRECTORY}"

    # Fail if Neo4j hadn't been downloaded successfully
    if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
        echo "setupNeo4j: Failed to download ${NEO4J_INSTALLATION_NAME} from ${NEO4J_DOWNLOAD_BASE_URL} into ${TOOLS_DIRECTORY}"
        exit 1
    fi

    # Configure all paths with data that changes (database data, logs, ...) to be in the outside "data" directory
    # instead of inside the neo4j directory
    echo "setupNeo4j: Configuring dynamic settings (data directories, ports, ...)"
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
         echo ""
         echo "# Paths of data directories in the installation (v5)"
         echo "server.directories.data=${NEO4J_DATA_PATH}"
         echo "server.directories.logs=${NEO4J_RUNTIME_PATH}/logs"
         echo "server.directories.dumps.root=${NEO4J_RUNTIME_PATH}/dumps"
         echo "server.directories.run=${NEO4J_RUNTIME_PATH}/run"
         echo "server.directories.transaction.logs.root=${NEO4J_DATA_PATH}/transactions"
         echo ""
         echo "# Ports Configuration (v5)"
         echo "server.connector.bolt.listen_address=:${NEO4J_BOLT_PORT}"
         echo "server.connector.bolt.advertised_address=:${NEO4J_BOLT_PORT}"
         echo "server.connector.http.listen_address=:${NEO4J_HTTP_PORT}"
         echo "server.connector.http.advertised_address=:${NEO4J_HTTP_PORT}"
         echo "server.connector.https.listen_address=:${NEO4J_HTTPS_PORT}"
         echo "server.connector.https.advertised_address=:${NEO4J_HTTPS_PORT}"

    } >> "${NEO4J_CONFIG}"

    echo "setupNeo4j: Configuring static settings (memory, procedure permittions, ...)"
    cat "${SCRIPTS_DIR}/templates/template-neo4j.conf" >> "${NEO4J_CONFIG}"

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
        echo "setupNeo4j: Downloading ${NEO4J_APOC_PLUGIN_ARTIFACT}"

        # Download the Neo4j Plugin "Awesome Procedures for Neo4j"
        echo "setupNeo4j: Downloading ${NEO4J_APOC_PLUGIN_ARTIFACT}"
        curl -L --fail-with-body -o "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/${NEO4J_APOC_PLUGIN_VERSION}/apoc-${NEO4J_APOC_PLUGIN_VERSION}-all.jar  || exit 1
    else
        echo "setupNeo4j: ${NEO4J_APOC_PLUGIN_ARTIFACT} already downloaded"
    fi
    
    # Uninstall previously installed Neo4j Plugin "Awesome Procedures for Neo4j" (APOC)
    rm -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/apoc*.jar"

    # Install the Neo4j Plugin "Awesome Procedures for Neo4j"
    echo "setupNeo4j: Installing ${NEO4J_APOC_PLUGIN_ARTIFACT}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_APOC_PLUGIN_ARTIFACT}" "${NEO4J_INSTALLATION_DIRECTORY}/plugins"

    # Fail if Neo4j Plugin "Awesome Procedures for Neo4j" (APOC) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_APOC_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Failed to download and install ${NEO4J_APOC_PLUGIN_ARTIFACT}"
        exit 1
    fi
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
    
    # Uninstall previously installed Neo4j Plugin "Graph Data Science" (GDS)
    rm -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/neo4j-graph-data-science*.jar"
    
    # Install the Neo4j Plugin "Graph Data Science" (GDS)
    echo "setupNeo4j: Installing ${NEO4J_GDS_PLUGIN_ARTIFACT}"
    cp -R "${SHARED_DOWNLOADS_DIRECTORY}/${NEO4J_GDS_PLUGIN_ARTIFACT}" "${NEO4J_INSTALLATION_DIRECTORY}/plugins"

    # Fail if Neo4j Plugin "Graph Data Science" (GDS) hadn't been downloaded successfully
    if [ ! -f "${NEO4J_INSTALLATION_DIRECTORY}/plugins/${NEO4J_GDS_PLUGIN_ARTIFACT}" ] ; then
        echo "setupNeo4j: Failed to download and install ${NEO4J_GDS_PLUGIN_ARTIFACT}"
        exit 1
    fi
else 
    echo "setupNeo4j: ${NEO4J_GDS_PLUGIN_ARTIFACT} already installed"
fi