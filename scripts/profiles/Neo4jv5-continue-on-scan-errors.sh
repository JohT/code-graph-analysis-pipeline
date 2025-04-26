#!/usr/bin/env bash

# Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
# The chosen settings are tested to be compatible and working.

NEO4J_VERSION=${NEO4J_VERSION:-"5.26.5"} # Neo4j Graph Database Version. Current versions: >= 2025.03.0. Version 4.4.42 and 5.26.5 are the previous LTS (long term support) versions as of April 2025.
NEO4J_HTTP_TRANSACTION_ENDPOINT=${NEO4J_HTTP_TRANSACTION_ENDPOINT:-"db/neo4j/tx/commit"}
NEO4J_CONFIG_TEMPLATE=${NEO4J_CONFIG_TEMPLATE:-"template-neo4j.conf"}

# Awesome Procedures (APOC) Plugin for Neo4j
NEO4J_APOC_PLUGIN_VERSION=${NEO4J_APOC_PLUGIN_VERSION:-"5.26.5"}
NEO4J_APOC_PLUGIN_EDITION=${NEO4J_APOC_PLUGIN_EDITION:-"core"}
NEO4J_APOC_PLUGIN_GITHUB=${NEO4J_APOC_PLUGIN_GITHUB:-"neo4j/apoc"}

NEO4J_GDS_PLUGIN_VERSION=${NEO4J_GDS_PLUGIN_VERSION:-"2.15.0"}
NEO4J_OPEN_GDS_PLUGIN_VERSION=${NEO4J_OPEN_GDS_PLUGIN_VERSION:-"2.13.4"}
NEO4J_GDS_PLUGIN_EDITION=${NEO4J_GDS_PLUGIN_EDITION:-"open"}

JQASSISTANT_CLI_VERSION=${JQASSISTANT_CLI_VERSION:-"2.7.0-RC1"}
JQASSISTANT_CLI_ARTIFACT=${JQASSISTANT_CLI_ARTIFACT:-"jqassistant-commandline-neo4jv5"}
JQASSISTANT_CONFIG_TEMPLATE=${JQASSISTANT_CONFIG_TEMPLATE:-"template-neo4j-latest-jqassistant-continue-on-error.yaml"}