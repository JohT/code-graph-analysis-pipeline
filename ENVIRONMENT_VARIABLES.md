# Environment Variables Reference

This document serves as a reference for all environment variables that are supported by the script files.
It provides a table listing each environment variable, its default value and its corresponding description provided as a inline comment.
This file was generated with the script [appendEnvironmentVariables.sh](./scripts/documentation/appendEnvironmentVariables.sh) and [generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh).

Environment Variable Name | Default | Description
------------------------- | ------- | -----------
REPORTS_DIRECTORY | reports | 
SCRIPTS_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/../../scripts | Repository directory containing the shell scripts
ANOMALY_DETECTION_FEATURE_CYPHER_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/features | 
ANOMALY_DETECTION_QUERY_CYPHER_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/queries | 
ANOMALY_DETECTION_LABEL_CYPHER_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/labels | 
ANOMALY_DETECTION_SUMMARY_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/summary | Contains everything (scripts, queries, templates) to create the Markdown summary report for anomaly detection
MARKDOWN_INCLUDES_DIRECTORY | includes | Subdirectory that contains Markdown files to be included by the Markdown template for the report.
ANOMALY_DETECTION_GRAPHS_DIR | ${ANOMALY_DETECTION_SCRIPT_DIR}/graphs | Contains everything (scripts, queries, templates) to create the Markdown summary report for anomaly detection
VISUALIZATION_SCRIPTS_DIR | ${SCRIPTS_DIR}/visualization | Repository directory containing the shell scripts for visualization
MARKDOWN_SCRIPTS_DIR | ${SCRIPTS_DIR}/markdown | 
EXTERNAL_DEPENDENCIES_QUERY_CYPHER_DIR | ${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/queries | 
EXTERNAL_DEPENDENCIES_SUMMARY_DIR | ${EXTERNAL_DEPENDENCIES_SCRIPT_DIR}/summary | Contains everything (scripts, queries, templates) to create the Markdown summary report for external dependencies
GIT_HISTORY_SUMMARY_DIR | ${GIT_HISTORY_SCRIPT_DIR}/summary | Contains everything (scripts, templates) to create the Markdown summary report
SOURCE_DIRECTORY | source | Get the source repository directory (defaults to "source")
IMPORT_DIRECTORY | import | 
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT | plugin | Select how to import git log data. Options: "none", "aggregated", "full" and "plugin". Default="plugin".
PROJECTION_CYPHER_DIR | ${GRAPH_ALGORITHMS_SCRIPT_DIR}/../../cypher/Dependencies_Projection | 
GRAPH_ALGORITHMS_SUMMARY_DIR | ${GRAPH_ALGORITHMS_SCRIPT_DIR}/summary | 
INTERNAL_DEPENDENCIES_SUMMARY_DIR | ${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/summary | Contains everything (scripts, templates) to create the Markdown summary report
INTERNAL_DEPENDENCIES_GRAPHS_DIR | ${INTERNAL_DEPENDENCIES_SCRIPT_DIR}/graphs | Contains everything (scripts, queries) to create graph visualizations
JAVA_SUMMARY_DIR | ${JAVA_SCRIPT_DIR}/summary | Contains everything (scripts, templates) to create the Markdown summary report
NEO4J_EDITION | community | Choose "community" or "enterprise"
NEO4J_VERSION | 2026.01.4 | 
DATA_DIRECTORY | $( pwd -P )/data | Path where Neo4j writes its data to (outside tools dir)
RUNTIME_DIRECTORY | $( pwd -P )/runtime | Path where Neo4j puts runtime data to (e.g. logs) (outside tools dir)
NEO4J_HTTP_PORT | 7474 | Neo4j HTTP API port for executing queries
NEO4J_HTTPS_PORT | 7473 | Neo4j HTTPS port for encrypted querying
NEO4J_BOLT_PORT | 7687 | Neo4j's own "Bolt Protocol" port
NEO4J_CONFIG_TEMPLATE | template-neo4j.conf | Name of the template file ("configuration" folder) for the Neo4j configuration. Defaults to "template-neo4j.conf".
TOOLS_DIRECTORY | tools | Tools directory name used to detect the analysis workspace
NEO4J_APOC_PLUGIN_VERSION | 2026.01.4 | Awesome Procedures On Cypher (APOC) Plugin version number. Version needs to be compatible to Neo4j and usually matches its version number.
NEO4J_APOC_PLUGIN_EDITION | core | Awesome Procedures On Cypher (APOC) for Neo4j Plugin Edition (Neo4j v4.4.x "all", Neo4j >= v5 "core")
NEO4J_APOC_PLUGIN_GITHUB | neo4j/apoc | Awesome Procedures On Cypher (APOC) for Neo4j Plugin GitHub User/Repository (Neo4j v4.4.x "neo4j-contrib/neo4j-apoc-procedures", Neo4j >= v5 "neo4j/apoc")
NEO4J_GDS_PLUGIN_VERSION | 2.27.0 | Graph Data Science (GDS) Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_OPEN_GDS_PLUGIN_VERSION | 2.26.0 | Graph Data Science (GDS) Plugin Version 2.4.x of is compatible with Neo4j 5.x
NEO4J_GDS_PLUGIN_EDITION | open | Graph Data Science (GDS) Plugin Edition: "open" for OpenGDS, "full" for the full version with Neo4j license
NODE_EMBEDDINGS_SUMMARY_DIR | ${NODE_EMBEDDINGS_SCRIPT_DIR}/summary | 
ARTIFACTS_DIRECTORY | artifacts | 
PREPARE_CONDA_ENVIRONMENT | true | Wether to prepare a Python environment with Conda if needed (default, "true") or use an already prepared Conda environment ("false")
JUPYTER_NOTEBOOK_DIRECTORY | ${SCRIPTS_DIR}/../jupyter | Repository directory containing the Jupyter Notebooks
CONDA_ENVIRONMENT_FILE | ${JUPYTER_NOTEBOOK_DIRECTORY}/../conda-environment.yml | Conda (package manager for Python) environment file path
CODEGRAPH_CONDA_ENVIRONMENT | codegraph | Name of the conda environment to use for code graph analysis
USE_VIRTUAL_PYTHON_ENVIRONMENT_VENV | false | Use "venv" for virtual Python environments ("true") or use an already prepared (e.g. conda) environment (default, "false").
PYTHON_ENVIRONMENT_FILE | ${ROOT_DIRECTORY}/requirements.txt | Pip (package manager for Python) environment file path
REPORTS_SCRIPTS_DIRECTORY | reports | Working directory containing the generated reports
REPORT_COMPILATIONS_SCRIPTS_DIRECTORY | compilations | Repository directory that contains scripts that execute selected report generation scripts
SETTINGS_PROFILE_SCRIPTS_DIRECTORY | profiles | Repository directory that contains scripts containing settings
LOG_GROUP_START | ::group:: | Prefix to start a log group. Defaults to GitHub Actions log group start command.
LOG_GROUP_END | ::endgroup:: | Prefix to end a log group. Defaults to GitHub Actions log group end command.
DOMAINS_DIRECTORY | ${SCRIPTS_DIR}/../domains | 
ARTIFACTS_CHANGE_DETECTION_HASH_FILE | artifactsChangeDetectionHash.txt | !DEPRECATED! Use CHANGE_DETECTION_HASH_FILE.
CHANGE_DETECTION_HASH_FILE_PATH | ./${ARTIFACTS_DIRECTORY}/${CHANGE_DETECTION_HASH_FILE} | Default path of the file that contains the hash code of the file list for change detection. Can be overridden by a command line option.
ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION |  | Enable PDF generation for Jupyter Notebooks if set to any non empty value like "true" or disable it with "" or "false".
JUPYTER_OUTPUT_FILE_POSTFIX |  | e.g. "" (no postfix), ".nbconvert" or ".output"
REPORTS_SCRIPT_DIR | ${SCRIPTS_DIR}/reports | Repository directory containing the report scripts
NEO4J_HTTP_TRANSACTION_ENDPOINT | db/neo4j/tx/commit | Since Neo4j v5: "db/<name>/tx/commit", Neo4j v4: "db/data/transaction/commit"
JQASSISTANT_CLI_VERSION | 2.9.0 | 
JQASSISTANT_CLI_ARTIFACT | jqassistant-commandline-neo4jv5 | 
JQASSISTANT_CONFIG_TEMPLATE | template-neo4jv5-jqassistant-continue-on-error.yaml | 
programmingLanguage | Java | Set to default value "Java" if not set since it is optional
NEO4J_INITIAL_PASSWORD |  | Neo4j login password that was set to replace the temporary initial password
TYPESCRIPT_SCAN_HEAP_MEMORY | 4096 | Heap memory in megabytes for Typescript scanning with (Node.js process). Defaults to 4096 MB.
JQASSISTANT_CLI_DOWNLOAD_URL | https://repo1.maven.org/maven2/com/buschmais/jqassistant/cli | Download URL for the jQAssistant CLI
JQASSISTANT_CLI_DISTRIBUTION | distribution.zip | Neo4j v5 & v4: "distribution.zip"
IGNORED_JARS_DIRECTORY | ./../ignored-jars | Directory to move the filtered out .jar files to
