#!/usr/bin/env bash

# Sets the initial Neo4j password via neo4j-admin dbms set-initial-password.
# 
# This script sets the password while the database is stopped. If the password was set
# via neo4j-admin (e.g., after admin import), it will be marked as "expired" and must
# be cleared via clearNeo4jPasswordExpiration.sh before queries can run.
#
# Optional workflow (if CLEAR_PASSWORD_EXPIRATION=1):
#   1. Set the initial password via neo4j-admin
#   2. Start Neo4j
#   3. Call clearNeo4jPasswordExpiration.sh to clear the "expired" flag
#
# Note: The environment variable NEO4J_INITIAL_PASSWORD needs to be set.

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

NEO4J_EDITION=${NEO4J_EDITION:-"community"} # Choose "community" or "enterprise"
NEO4J_VERSION=${NEO4J_VERSION:-"2026.10.2"}
TOOLS_DIRECTORY=${TOOLS_DIRECTORY:-"tools"} # Get the tools directory (defaults to "tools")
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"}

# Internal constants
NEO4J_INSTALLATION_NAME="neo4j-${NEO4J_EDITION}-${NEO4J_VERSION}"
NEO4J_INSTALLATION_DIRECTORY="${TOOLS_DIRECTORY}/${NEO4J_INSTALLATION_NAME}"

## Get this domain directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
NEO4J_MANAGEMENT_DIR=${NEO4J_MANAGEMENT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Domain directory containing the neo4j management scripts
SCRIPTS_DIR=${SCRIPTS_DIR:-"${NEO4J_MANAGEMENT_DIR}/../../scripts"} # Repository directory containing the shared shell scripts
echo "setupNeo4jInitialPassword: SCRIPTS_DIR=$SCRIPTS_DIR"

# Check if environment variable is set
if [ -z "${NEO4J_INITIAL_PASSWORD}" ]; then
    echo "Requires environment variable NEO4J_INITIAL_PASSWORD to be set first. Use 'export NEO4J_INITIAL_PASSWORD=<your-own-password>'."
    exit 1
fi

# Check if Neo4j is installed. Exit if not.
if [ ! -d "${NEO4J_INSTALLATION_DIRECTORY}" ] ; then
    echo "Neo4j not found in ${NEO4J_INSTALLATION_DIRECTORY}. Please run setupNeo4j.sh first."
    exit 1
fi

# Print the environment variable NEO4J_HOME that is used to execute the command
echo "setupNeo4jInitialPassword: Using ${NEO4J_INSTALLATION_DIRECTORY} as NEO4J_HOME"

# Extract the first component of the version number (=major version number)
NEO4J_MAJOR_VERSION_NUMBER=$(echo "$NEO4J_VERSION" | cut -d'.' -f1)
echo "setupNeo4jInitialPassword: Neo4j version ${NEO4J_MAJOR_VERSION_NUMBER} detected"

# Include operation system function to for example detect Windows.
# shellcheck disable=SC1091
source "${SCRIPTS_DIR}/operatingSystemFunctions.sh"

scriptExtension=$(ifWindows ".bat" "")

# Check if the first component is greater than or equal to 5
if [[ "$NEO4J_MAJOR_VERSION_NUMBER" -ge 5 ]]; then
    echo "setupNeo4jInitialPassword: Neo4j v5 or higher used"
    # Neo4j version >= 5
    # Set the initial password using a temporary NEO4J_HOME environment variable pointing to the current setup
    # shellcheck disable=SC2034
    NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}"; "${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin${scriptExtension}" dbms set-initial-password "${NEO4J_INITIAL_PASSWORD}"
else
    echo "setupNeo4jInitialPassword: Neo4j v4 or lower used"
    # Neo4j version < 5
    # Set the initial password using a temporary NEO4J_HOME environment variable pointing to the current setup
    # shellcheck disable=SC2034
    NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}"; "${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j-admin${scriptExtension}" set-initial-password "${NEO4J_INITIAL_PASSWORD}"
fi

echo "setupNeo4jInitialPassword: Initial password set successfully"

# If requested, start Neo4j and clear the password expiration flag
# This is typically used after neo4j-admin database import full
if [ "${CLEAR_PASSWORD_EXPIRATION:-0}" = "1" ]; then
    echo "setupNeo4jInitialPassword: Starting Neo4j to clear password expiration flag..."
    
    # Start Neo4j (do not fail if already started)
    if ! NEO4J_HOME="${NEO4J_INSTALLATION_DIRECTORY}" "${NEO4J_INSTALLATION_DIRECTORY}/bin/neo4j${scriptExtension}" start --verbose 2>&1 | grep -q "already started\|started in"; then
        # If start command showed anything other than "already started", it may have failed
        # but we'll continue and let the clear expiration script handle it
        :
    fi
    
    # Clear the password expiration flag using dedicated script
    clear_expiration_script="${NEO4J_MANAGEMENT_DIR}/clearNeo4jPasswordExpiration.sh"
    if ! bash "${clear_expiration_script}"; then
        echo "setupNeo4jInitialPassword: Warning: Could not clear password expiration flag" >&2
        # Don't exit - the flag can be cleared on first query attempt
    fi
fi

