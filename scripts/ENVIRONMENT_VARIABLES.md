# Environment Variables Reference

This document serves as a reference for all environment variables that are supported by the script files.
It provides a table listing each environment variable, its default value and its corresponding description provided as a inline comment.
This file was generated with the script [appendEnvironmentVariables.sh](./appendEnvironmentVariables.sh) and [generateEnvironmentVariableReference.sh](./generateEnvironmentVariableReference.sh).

| Environment Variable Name           | Default                             | Description                                            |
| ----------------------------------- | ----------------------------------- | ------------------------------------------------------ |
PREPARE_CONDA_ENVIRONMENT             | true                                | Wether to prepare a Python environment with Conda if needed (default, "true") or use an already prepared Conda environment ("false") |
JUPYTER_NOTEBOOK_DIRECTORY            | ${SCRIPTS_DIR}/../jupyter           | Repository directory containing the Jupyter Notebooks |
CONDA_ENVIRONMENT_FILE                | ${JUPYTER_NOTEBOOK_DIRECTORY}/../conda-environment.yml | Conda (package manager for Python) environment file path |
CODEGRAPH_CONDA_ENVIRONMENT           | codegraph                           | Name of the conda environment to use for code graph analysis |
USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV   | false                               | Use "venv" for virtual Python environments ("true") or use an already prepared (e.g. conda) environment (default, "false"). |
PYTHON_ENVIRONMENT_FILE               | ${ROOT_DIRECTORY}/requirements.txt  | Pip (package manager for Python) environment file path |
REPORTS_SCRIPTS_DIRECTORY             | reports                             | Working directory containing the generated reports |
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY | compilations                        | Repository directory that contains scripts that execute selected report generation scripts |
SETTINGS_PROFILE_SCRIPTS_DIRECTORY    | profiles                            | Repository directory that contains scripts containing settings |
ARTIFACTS_DIRECTORY                   | artifacts                           | Working directory containing the artifacts to be analyzed |
SOURCE_DIRECTORY                      | source                              |  |
LOG_GROUP_START                       | ::group::                           | Prefix to start a log group. Defaults to GitHub Actions log group start command. |
LOG_GROUP_END                         | ::endgroup::                        | Prefix to end a log group. Defaults to GitHub Actions log group end command. |
NPM_PACKAGE_JSON_ARTIFACTS_DIRECTORY  | npm-package-json                    | Subdirectory of "artifacts" containing the npm package.json files to scan |
ARTIFACTS_CHANGE_DETECTION_HASH_FILE  | artifactsChangeDetectionHash.txt    | !DEPRECATED! Use CHANGE_DETECTION_HASH_FILE. |
CHANGE_DETECTION_HASH_FILE_PATH       | ./${ARTIFACTS_DIRECTORY}/${CHANGE_DETECTION_HASH_FILE} | Default path of the file that contains the hash code of the file list for change detection. Can be overridden by a command line option. |
ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION |                                     | Enable PDF generation for Jupyter Notebooks if set to any non empty value like "true" or disable it with "" or "false". |
JUPYTER_OUTPUT_FILE_POSTFIX           |                                     | e.g. "" (no postfix), ".nbconvert" or ".output" |
REPORTS_DIRECTORY                     | reports                             |  |
REPORTS_SCRIPT_DIR                    | ${SCRIPTS_DIR}/reports              | Repository directory containing the report scripts |
CYPHER_DIR                            | ${SCRIPTS_DIR}/../cypher            |  |
MARKDOWN_SCRIPTS_DIR                  | ${SCRIPTS_DIR}/markdown             |  |
NEO4J_HTTP_PORT                       | 7474                                | Neo4j HTTP API port for executing queries |
NEO4J_HTTP_TRANSACTION_ENDPOINT       | db/neo4j/tx/commit                  | Since Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit" |
IMPORT_DIRECTORY                      | import                              |  |
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT | plugin                              | Select how to import git log data. Options: "none", "aggregated", "full" and "plugin". Default="plugin". |
NEO4J_VERSION                         | 2025.11.2                           | Neo4j Graph Database Version. Current versions: >= 2025.03.0. Version 4.4.42 and 5.26.5 are the previous LTS (long term support) versions as of April 2025. |
NEO4J_CONFIG_TEMPLATE                 | template-neo4j.conf                 |  |
NEO4J_APOC_PLUGIN_VERSION             | 2025.11.2                           |  |
NEO4J_APOC_PLUGIN_EDITION             | core                                |  |
NEO4J_APOC_PLUGIN_GITHUB              | neo4j/apoc                          |  |
NEO4J_GDS_PLUGIN_VERSION              | 2.24.0                              |  |
NEO4J_OPEN_GDS_PLUGIN_VERSION         | 2.24.0                              |  |
NEO4J_GDS_PLUGIN_EDITION              | open                                |  |
JQASSISTANT_CLI_VERSION               | 2.9.0-RC1                           |  |
JQASSISTANT_CLI_ARTIFACT              | jqassistant-commandline-neo4jv5     |  |
JQASSISTANT_CONFIG_TEMPLATE           | template-neo4j-latest-jqassistant-continue-on-error.yaml |  |
programmingLanguage                   | Java                                | Set to default value "Java" if not set since it is optional |
VISUALIZATION_SCRIPTS_DIR             | ${SCRIPTS_DIR}/visualization        | Repository directory containing the shell scripts for visualization |
DOMAINS_DIRECTORY                     | ${REPORTS_SCRIPT_DIR}/../../domains |  |
NEO4J_INITIAL_PASSWORD                |                                     | Neo4j login password that was set to replace the temporary initial password |
TOOLS_DIRECTORY                       | tools                               | Get the tools directory (defaults to "tools") |
TYPESCRIPT_SCAN_HEAP_MEMORY           | 4096                                | Heap memory in megabytes for Typescript scanning with (Node.js process). Defaults to 4096 MB. |
JQASSISTANT_CLI_DOWNLOAD_URL          | https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli | Download URL for the jQAssistant CLI |
JQASSISTANT_CLI_DISTRIBUTION          | distribution.zip                    | Neo4j v5 & v4: "distribution.zip" |
NEO4J_EDITION                         | community                           | Choose "community" or "enterprise" |
DATA_DIRECTORY                        | $( pwd -P )/data                    | Path where Neo4j writes its data to (outside tools dir) |
RUNTIME_DIRECTORY                     | $( pwd -P )/runtime                 | Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir) |
NEO4J_HTTPS_PORT                      | 7473                                | Neo4j HTTPS port for encrypted querying |
NEO4J_BOLT_PORT                       | 7687                                | Neo4j's own "Bolt Protocol" port |
IGNORED_JARS_DIRECTORY                | ./../ignored-jars                   | Directory to move the filtered out .jar files to |
