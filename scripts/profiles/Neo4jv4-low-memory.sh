#!/usr/bin/env bash

# Sets all settings variables for an analysis with Neo4j v4.4.x (long term support (LTS) version as of may 2023).
# The chosen settings are tested to be compatible and working.

NEO4J_VERSION=${NEO4J_VERSION:-"4.4.42"} # Neo4j Graph Database Version. Current versions: >= 2025.03.0. Version 4.4.42 and 5.26.5 are the previous LTS (long term support) versions as of April 2025.
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/data/transaction/commit"}
NEO4J_CONFIG_TEMPLATE=${NEO4J_CONFIG_TEMPLATE:-"template-neo4j-v4-low-memory.conf"}

# Awesome Procedures (APOC) Plugin for Neo4j
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"4.4.0.15"}
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"all"}
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j-contrib/neo4j-apoc-procedures"}

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.3.4"}
NEO4J_OPEN_GDS_PLUGIN_VERSION=${NEO4J_OPEN_GDS_PLUGIN_VERSION:-"2.6.8"}
NEO4J_GDS_PLUGIN_EDITION=${NEO4J_GDS_PLUGIN_EDITION:-"open"}

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"1.12.2"}
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-neo4jv4"}
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4jv4-jqassistant.yaml"}