#!/usr/bin/env bash

# Sets all settings variables for an analysis with Neo4j v4.4.x (long term support (LTS) version as of may 2023).
# The chosen settings are tested to be compatible and working.

NEO4J_VERSION=${NEO4J_VERSION:-"4.4.20"} # Version 4.4.x is the current long term support (LTS) version (may 2023)
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/data/transaction/commit"} # Since Neo4j v5 it is "db/<name>/tx/commit"

# Overrideable settings variables for ports (optional, defaults also defined in sub scripts where needed)
# Override them if you need to run multiple neo4j database servers in parallel.
NEO4J_HTTP_PORT=${NEO4J_HTTP_PORT:-"7474"} # Neo4j HTTP API port for executing queries
NEO4J_HTTPS_PORT=${NEO4J_HTTPS_PORT:-"7473"} # Neo4j HTTPS port for encrypted querying
NEO4J_BOLT_PORT=${NEO4J_BOLT_PORT:-"7687"} # Neo4j's own "Bolt Protocol" port

# Awesome Procedures (APOC) Plugin for Neo4j
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"4.4.0.15"} # Version number matches Neo4j version
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"all"} # Since Neo4j v5 only the core edition is maintained
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j-contrib/neo4j-apoc-procedures"} # Location for the old plugins compatible to Neo4j v4

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.3.4"} # Graph Data Science Plugin Version 2.3.x is compatible with Neo4j 4.4.x
NEO4J_GDS_PLUGIN_EDITION=${NEO4J_GDS_PLUGIN_EDITION:-"full"}  # Graph Data Science Plugin Edition: "open" for OpenGDS, "full" for the full version with Neo4j license

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"1.12.2"}  # Version 1.12.2 is the newest version (may 2023) compatible with Neo4j v4
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-neo4jv4"} # For Neo4j 4: "jqassistant-commandline-neo4jv4"
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4jv4-jqassistant.yaml"} # Name of the template file for the jqassistant configuration