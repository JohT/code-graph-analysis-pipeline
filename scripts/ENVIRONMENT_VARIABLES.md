# Environment Variables Reference

This document serves as a reference for all environment variables that are supported by the script files.
It provides a table listing each environment variable, its default value and its corresponding description provided as a inline comment.
This file was generated with the script [appendEnvironmentVariables.sh](./appendEnvironmentVariables.sh) and [generateEnvironmentVariableReference.sh](./generateEnvironmentVariableReference.sh).

| Environment Variable Name           | Default                             | Description                                            |
| ----------------------------------- | ----------------------------------- | ------------------------------------------------------ |
JUPYTER_NOTEBOOK_DIRECTORY            | ${SCRIPTS_DIR}/../jupyter           | Repository directory containing the Jupyter Notebooks |
CODEGRAPH_CONDA_ENVIRONMENT           | codegraph                           | Name of the conda environment to use for code graph analysis |
REPORTS_SCRIPTS_DIRECTORY             | reports                             | Working directory containing the generated reports |
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY | compilations                        | Repository directory that contains scripts that execute selected report generation scripts |
SETTINGS_PROFILE_SCRIPTS_DIRECTORY    | profiles                            | Repository directory that contains scripts containing settings |
ARTIFACTS_DIRECTORY                   | artifacts                           | Working directory containing the artifacts to be analyzed |
RESULTS_DIRECTORY                     | results                             | Repository directory containing the final analysis report results |
REPORTS_DIRECTORY                     | reports                             | Working directory where the analysis reports are written to  |
ARTIFACTS_CHANGE_DETECTION_HASH_FILE  | artifactsChangeDetectionHash.txt    | Name of the file that contains the hash code of the file list for change detection |
SOURCE_DIRECTORY                      | source                              | Get the source repository directory (defaults to "source") |
ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION |                                     | Enable PDF generation for Jupyter Notebooks if set to any non empty value e.g. "true" |
JUPYTER_OUTPUT_FILE_POSTFIX           |                                     | e.g. "" (no postfix), ".nbconvert" or ".output" |
REPORTS_SCRIPT_DIR                    | ${SCRIPTS_DIR}/reports              | Repository directory containing the report scripts |
CYPHER_DIR                            | ${SCRIPTS_DIR}/../cypher            |  |
NEO4J_HTTP_PORT                       | 7474                                | Neo4j HTTP API port for executing queries |
NEO4J_HTTP_TRANSACTION_ENDPOINT       | db/neo4j/tx/commit                  | Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit" |
TYPESCRIPT_ARTIFACTS_DIRECTORY        | typescript                          | Subdirectory of "artifacts" containing the typescript analysis result json files for import |
NEO4J_EDITION                         | community                           | Choose "community" or "enterprise" |
NEO4J_VERSION                         | 5.20.0                              |  |
TOOLS_DIRECTORY                       | tools                               | Get the tools directory (defaults to "tools") |
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT | full                                | Select how to import git log data. Options: "none", "aggregated", "full". Default="full". |
NEO4J_HTTPS_PORT                      | 7473                                | Neo4j HTTPS port for encrypted querying |
NEO4J_BOLT_PORT                       | 7687                                | Neo4j's own "Bolt Protocol" port |
NEO4J_APOC_PLUGIN_VERSION             | 4.4.0.15                            | Version number matches Neo4j version |
NEO4J_APOC_PLUGIN_EDITION             | all                                 | Since Neo4j v5 only the core edition is maintained |
NEO4J_APOC_PLUGIN_GITHUB              | neo4j-contrib/neo4j-apoc-procedures | Location for the old plugins compatible to Neo4j v4 |
NEO4J_GDS_PLUGIN_VERSION              | 2.3.4                               | Graph Data Science Plugin Version 2.3.x is compatible with Neo4j 4.4.x |
NEO4J_OPEN_GDS_PLUGIN_VERSION         | 2.6.8                               | Open package variant of the graph-data-science plugin for Neo4j (https://github.com/JohT/open-graph-data-science-packaging). Since version 2.4. compatible with Neo4j 5.x. |
NEO4J_GDS_PLUGIN_EDITION              | open                                | Graph Data Science Plugin Edition: "open" for OpenGDS, "full" for the full version with Neo4j license |
JQASSISTANT_CLI_VERSION               | 1.12.2                              | Version 1.12.2 is the newest version (may 2023) compatible with Neo4j v4 |
JQASSISTANT_CLI_ARTIFACT              | jqassistant-commandline-neo4jv4     | For Neo4j 4: "jqassistant-commandline-neo4jv4" |
JQASSISTANT_CONFIG_TEMPLATE           | template-neo4jv4-jqassistant.yaml   | Name of the template file for the jqassistant configuration |
programmingLanguage                   | Java                                | Set to default value "Java" if not set since it is optional |
SCRIPTS_DIR                           | ${REPORTS_SCRIPT_DIR}/..            | Repository directory containing the shell scripts |
GRAPH_VISUALIZATION_DIRECTORY         | ${SCRIPTS_DIR}/../graph-visualization | Repository directory containing the Jupyter Notebooks |
NEO4J_BOLT_URI                        | bolt://localhost:${NEO4J_BOLT_PORT} | Neo4j's own "Bolt Protocol" address |
NEO4J_USER                            | neo4j                               | Neo4j login user |
NEO4J_INITIAL_PASSWORD                |                                     | Neo4j login password that was set to replace the temporary initial password |
JQASSISTANT_CLI_DOWNLOAD_URL          | https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli | Download URL for the jQAssistant CLI |
JQASSISTANT_CLI_DISTRIBUTION          | distribution.zip                    | Neo4j v5 & v4: "distribution.zip" |
NEO4J_DATA_PATH                       | $( pwd -P )/data                    | Path where Neo4j writes its data to (outside tools dir) |
NEO4J_RUNTIME_PATH                    | $( pwd -P )/runtime                 | Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir) |
