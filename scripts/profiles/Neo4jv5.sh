#!/usr/bin/env bash

# Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
# The chosen settings are tested to be compatible and working.

NEO4J_VERSION=${NEO4J_VERSION:-"5.16.0"} # Version 5.9.0 is the current version of june 2023
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/neo4j/tx/commit"} # Since Neo4j v5 it is "db/<name>/tx/commit"

# Overrideable settings variables for ports (optional, defaults also defined in sub scripts where needed)
# Override them if you need to run multiple neo4j database servers in parallel.
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"} # Neo4j HTTPS port for encrypted querying
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"} # Neo4j's own "Bolt Protocol" port

# Awesome Procedures (APOC) Plugin for Neo4j
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"5.17.0"} # Version number matches Neo4j version since 5.x
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"core"} # Since Neo4j v5 the core edition is updated with Neo4j
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j/apoc"} # Core edition was moved to "neo4j/apoc" for Neo4j v5

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.5.7"}  # Version 2.4.0 is the newest version of june 2023 and compatible with Neo4j v5
NEO4J_OPEN_GDS_PLUGIN_VERSION=${NEO4J_OPEN_GDS_PLUGIN_VERSION:-"2.6.0+51"} # Graph Data Science Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_GDS_PLUGIN_EDITION=${NEO4J_GDS_PLUGIN_EDITION:-"open"}  # Graph Data Science Plugin Edition: "open" for OpenGDS, "full" for the full version with Neo4j license

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.0.10"}  # Version 2.0.3 is the newest version (june 2023) compatible with Neo4j v5
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-distribution"} # Since jQAssistant CLI v2: "jqassistant-commandline-distribution"
JQASSISTANT_CLI_DISTRIBUTION=${JQASSISTANT_CLI_DISTRIBUTION:-"bin.zip"} # Since jQAssistant CLI v2: "bin.zip"
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4jv5-jqassistant.yaml"} # Name of the template file for the jqassistant configuration