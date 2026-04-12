#!/usr/bin/env bash

# Use the high memory profile and apply its configuration template on the local 
# Neo4j Community Edition Graph Database (https://neo4j.com/download-center/#community).
# 
# Prerequisites:
# - Run within the analysis workspace directory
# - Neo4j needs to be installed
#
# Example Usage:
# - ./../../domains/neo4j-management/useNeo4jHighMemoryProfile.sh
#
# Requires configureNeo4j.sh

# Fail on any error ("-e" = exit on first error, "-o pipefail" exist on errors within piped commands)
set -o errexit -o pipefail

## Get this domain directory if not already set
# Even if $BASH_SOURCE is made for Bourne-like shells it is also supported by others and therefore here the preferred solution. 
# CDPATH reduces the scope of the cd command to potentially prevent unintended directory changes.
# This way non-standard tools like readlink aren't needed.
NEO4J_MANAGEMENT_DIR=${NEO4J_MANAGEMENT_DIR:-$( CDPATH=. cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P )} # Domain directory containing the neo4j management scripts
SCRIPTS_DIR=${SCRIPTS_DIR:-"${NEO4J_MANAGEMENT_DIR}/../../scripts"} # Repository directory containing the shared shell scripts

# shellcheck disable=SC2034
NEO4J_CONFIG_TEMPLATE=template-neo4j-high-memory.conf
. "${NEO4J_MANAGEMENT_DIR}/configureNeo4j.sh"