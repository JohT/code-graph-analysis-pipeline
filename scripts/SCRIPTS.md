# Scripts Reference

This document serves as a reference for all scripts in the current directory and its subdirectories.
It provides a table listing each script file and its corresponding description found in the first comment line.
This file was generated with the script [generateScriptReference.sh](./generateScriptReference.sh).

Script | Directory | Description
-------|-----------|------------
| [activateCondaEnvironment.sh](./activateCondaEnvironment.sh) |  | Activates the Conda (Python package manager) environment "codegraph" with all packages needed to execute the Jupyter Notebooks. |
| [analyze.sh](./analysis/analyze.sh) | analysis | Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation. |
| [cleanupAfterReportGeneration.sh](./cleanupAfterReportGeneration.sh) |  | Cleans up after report generation. This includes deleting empty files or in case no file is left deleting the report folder. |
| [copyPackageJsonFiles.sh](./copyPackageJsonFiles.sh) |  | Copies all package.json files inside the source directory into the artifacts/npm-package-json directory. |
| [copyReportsIntoResults.sh](./copyReportsIntoResults.sh) |  | Copies the results from the temp directory to the results directory grouped by the analysis name. |
| [createAggregatedGitLogCsv.sh](./createAggregatedGitLogCsv.sh) |  | Uses git log to create a comma separated values (CSV) file containing aggregated changes, their author name and email address, year and month for all the files that were changed. |
| [createGitLogCsv.sh](./createGitLogCsv.sh) |  | Uses git log to create a comma separated values (CSV) file containing all commits, their author, email address, date and all the file names that were changed with it. |
| [detectChangedFiles.sh](./detectChangedFiles.sh) |  | Detect changed files in the artifacts directory or in a given list of paths  |
| [appendEnvironmentVariables.sh](./documentation/appendEnvironmentVariables.sh) | documentation | Extracts the environment variable declarations including default values from a script file and appends it to a markdown file as table columns. |
| [generateCsvReportReference.sh](./documentation/generateCsvReportReference.sh) | documentation | Generates "CSV_REPORTS.md" containing a reference to all CSV cypher query reports in this directory and its subdirectories. |
| [generateCypherReference.sh](./documentation/generateCypherReference.sh) | documentation | Generates "CYPHER.md" containing a reference to all Cypher files in this directory and its subdirectories. |
| [generateEnvironmentVariableReference.sh](./documentation/generateEnvironmentVariableReference.sh) | documentation | Runs "appendEnvironmentVariable.sh" for every script file in the current directory and its sub directories. |
| [generateImageReference.sh](./documentation/generateImageReference.sh) | documentation | Generates "IMAGES.md" containing a reference to all images (PNG) in this directory and its subdirectories. |
| [generateJupyterReportReference.sh](./documentation/generateJupyterReportReference.sh) | documentation | Generates "JUPYTER_REPORTS.md" containing a reference to all Jupyter Notebook Markdown reports in this directory and its subdirectories. |
| [generateReportReferences.sh](./documentation/generateReportReferences.sh) | documentation | Triggers the regeneration of all reference documentations for the reports inside the "results" directory. |
| [generateScriptReference.sh](./documentation/generateScriptReference.sh) | documentation | Generates "SCRIPTS.md" containing a reference to all scripts in this directory and its subdirectories. |
| [download.sh](./download.sh) |  | Downloads a file into the directory of the environment variable SHARED_DOWNLOADS_DIRECTORY (or default "../downloads"). |
| [downloadMavenArtifact.sh](./downloadMavenArtifact.sh) |  | Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central) |
| [downloadAntDesign.sh](./downloader/downloadAntDesign.sh) | downloader | Downloads the Typescript project ant-design (https://github.com/ant-design/ant-design) from GitHub using git clone. |
| [downloadAxonFramework.sh](./downloader/downloadAxonFramework.sh) | downloader | Downloads AxonFramework (https://developer.axoniq.io/axon-framework) artifacts from Maven Central. |
| [downloadReactRouter.sh](./downloader/downloadReactRouter.sh) | downloader | Downloads react-router (https://github.com/remix-run/react-router) from GitHub using git clone. |
| [downloadTypescriptProject.sh](./downloader/downloadTypescriptProject.sh) | downloader | Downloads the given version of a Typescript project from a git repository using git clone. |
| [analyzeAntDesign.sh](./examples/analyzeAntDesign.sh) | examples | This is an example for the analysis of a the Typescript project "ant-design". |
| [analyzeAxonFramework.sh](./examples/analyzeAxonFramework.sh) | examples | This is an example for an analysis of AxonFramework  |
| [analyzeReactRouter.sh](./examples/analyzeReactRouter.sh) | examples | This is an example for the analysis of a the Typescript project "react-router". |
| [detectLatestGitTag.sh](./examples/detectLatestGitTag.sh) | examples | Returns the latest tag of a remote repository given by its url. |
| [executeJupyterNotebook.sh](./executeJupyterNotebook.sh) |  | Executes all steps in the given Jupyter Notebook (ipynb), stores it and converts it to Markdown (md) and PDF. |
| [executeJupyterNotebookReport.sh](./executeJupyterNotebookReport.sh) |  | Executes the given Jupyter Notebook and puts all resulting files (ipynb, md, pdf) into an accordingly named directory within the "results" directory. |
| [executeQuery.sh](./executeQuery.sh) |  | Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format. |
| [executeQueryFunctions.sh](./executeQueryFunctions.sh) |  | Provides functions to execute Cypher queries using either "executeQuery.sh" or Neo4j's "cypher-shell".  |
| [findPathsToScan.sh](./findPathsToScan.sh) |  | Finds all files and directories to scan and analyze and provides them as comma-separated list. |
| [importGit.sh](./importGit.sh) |  | Coordinates the import of git data from the given --source directory where one ore more git repositories are located and the value of the environment variable IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT. |
| [operatingSystemFunctions.sh](./operatingSystemFunctions.sh) |  | Provides operating system dependent functions e.g. to detect Windows. |
| [parseCsvFunctions.sh](./parseCsvFunctions.sh) |  | Provides functions to parse strings in CSV format.  |
| [prepareAnalysis.sh](./prepareAnalysis.sh) |  | Prepares and validates the graph database before analysis  |
| [Default.sh](./profiles/Default.sh) | profiles | Sets (if any) settings variables for a default analysis. |
| [Neo4jv4.sh](./profiles/Neo4jv4.sh) | profiles | Sets all settings variables for an analysis with Neo4j v4.4.x (long term support (LTS) version as of may 2023). |
| [Neo4jv5.sh](./profiles/Neo4jv5.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023). |
| [projectionFunctions.sh](./projectionFunctions.sh) |  | Provides functions to create and delete Graph Projections for Neo4j Graph Data Science. |
| [ArtifactDependenciesCsv.sh](./reports/ArtifactDependenciesCsv.sh) | reports | Executes "Artifact_Dependencies" Cypher queries to get the "artifact-dependencies-csv" CSV reports. |
| [CentralityCsv.sh](./reports/CentralityCsv.sh) | reports | Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [CommunityCsv.sh](./reports/CommunityCsv.sh) | reports | Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [ExternalDependenciesCsv.sh](./reports/ExternalDependenciesCsv.sh) | reports | Executes "External_Dependencies" Cypher queries to get the "external-dependencies-csv" CSV reports. |
| [GraphVisualization.sh](./reports/GraphVisualization.sh) | reports | Creates the "graph-visualization" report (ipynb, md, pdf) based on the Jupyter Notebook "ArtifactDependencies.ipynb". |
| [InternalDependenciesCsv.sh](./reports/InternalDependenciesCsv.sh) | reports | Executes "Internal_Dependencies" Cypher queries to get the "internal-dependencies-csv" CSV reports. |
| [JavaCsv.sh](./reports/JavaCsv.sh) | reports | Executes "Java" Cypher queries to get the "java-csv" CSV reports. |
| [NodeEmbeddingsCsv.sh](./reports/NodeEmbeddingsCsv.sh) | reports | Generates node embeddings using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [ObjectOrientedDesignMetricsCsv.sh](./reports/ObjectOrientedDesignMetricsCsv.sh) | reports | Executes "Metrics" Cypher queries to get the "object-oriented-design-metrics-csv" CSV reports. |
| [OverviewCsv.sh](./reports/OverviewCsv.sh) | reports | Executes "Overview" Cypher queries to get the "overview-csv" CSV reports. |
| [SimilarityCsv.sh](./reports/SimilarityCsv.sh) | reports | Looks for similarity using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [TopologicalSortCsv.sh](./reports/TopologicalSortCsv.sh) | reports | Applies the Topological Sorting algorithm for directed acyclic graphs (DAG) to order code units by their dependencies |
| [VisibilityMetricsCsv.sh](./reports/VisibilityMetricsCsv.sh) | reports | Executes "Visibility" Cypher queries to get the "visibility-metrics-csv" CSV reports. |
| [AllReports.sh](./reports/compilations/AllReports.sh) | compilations | Runs all report scripts. |
| [CsvReports.sh](./reports/compilations/CsvReports.sh) | compilations | Runs all CSV report scripts (no Python and Chromium required). |
| [DatabaseCsvExportReports.sh](./reports/compilations/DatabaseCsvExportReports.sh) | compilations | Exports the whole graph database as a CSV file using the APOC procedure "apoc.export.csv.all" |
| [JupyterReports.sh](./reports/compilations/JupyterReports.sh) | compilations | Runs all Jupyter Notebook report scripts. |
| [VisualizationReports.sh](./reports/compilations/VisualizationReports.sh) | compilations | Runs all Visualization reports. |
| [resetAndScan.sh](./resetAndScan.sh) |  | Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph. |
| [resetAndScanChanged.sh](./resetAndScanChanged.sh) |  | Executes "resetAndScan.sh" only if "detectChangedFiles.sh" returns detected changes. |
| [scanTypescript.sh](./scanTypescript.sh) |  | Executes the npm package @jqassistant/ts-lc using npx to scan the Typescript projects in the source directory and create an intermediate json data file for the jQAssistant Typescript plugin. |
| [setupJQAssistant.sh](./setupJQAssistant.sh) |  | Installs (download and unzip) jQAssistant (https://jqassistant.github.io/jqassistant/current). |
| [setupNeo4j.sh](./setupNeo4j.sh) |  | Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community). |
| [setupNeo4jInitialPassword.sh](./setupNeo4jInitialPassword.sh) |  | Sets the initial password for the local Neo4j Graph Database (https://neo4j.com/download-center/#community). |
| [sortOutExternalJavaJarFiles.sh](./sortOutExternalJavaJarFiles.sh) |  | Sorts out jar files that don't contain one of the given package names (e.g. external libraries) and moves them into the IGNORED_JARS_DIRECTORY.  |
| [startNeo4j.sh](./startNeo4j.sh) |  | Starts the local Neo4j Graph Database.  |
| [stopNeo4j.sh](./stopNeo4j.sh) |  | Stops the local Neo4j Graph Database.  |
| [waitForNeo4jHttpFunctions.sh](./waitForNeo4jHttpFunctions.sh) |  | Waits until the HTTP Transactions API of Neo4j Graph Database is available. |
