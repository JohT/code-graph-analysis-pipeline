# Scripts Reference

This document serves as a reference for all scripts in the repository and its subdirectories.
It provides a table listing each script file and its corresponding description found in the first comment line.
This file was generated with the script [generateScriptReference.sh](./scripts/documentation/generateScriptReference.sh).

Script | Directory | Description
------ | --------- | -----------
[anomalyDetectionCsv.sh](./domains/anomaly-detection/anomalyDetectionCsv.sh) | anomaly-detection | Pipeline that coordinates anomaly detection using the Graph Data Science Library of Neo4j.
[anomalyDetectionMarkdown.sh](./domains/anomaly-detection/anomalyDetectionMarkdown.sh) | anomaly-detection | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[anomalyDetectionPython.sh](./domains/anomaly-detection/anomalyDetectionPython.sh) | anomaly-detection | Pipeline that coordinates anomaly detection using the Graph Data Science Library of Neo4j.
[anomalyDetectionVisualization.sh](./domains/anomaly-detection/anomalyDetectionVisualization.sh) | anomaly-detection | This script is dynamically triggered by "VisualizationReports.sh" when report "All" or "Visualization" is enabled.
[renderArchitecture.sh](./domains/anomaly-detection/documentation/renderArchitecture.sh) | documentation | Renders the described Graph in Architecture.gv as a SVG image.
[anomalyDetectionGraphs.sh](./domains/anomaly-detection/graphs/anomalyDetectionGraphs.sh) | graphs | Executes selected anomaly detection Cypher queries for GraphViz visualization.
[anomalyDetectionSummary.sh](./domains/anomaly-detection/summary/anomalyDetectionSummary.sh) | summary | Creates a Markdown report that contains all results of all the anomaly detection methods.
[externalDependenciesCsv.sh](./domains/external-dependencies/externalDependenciesCsv.sh) | external-dependencies | Executes Cypher queries to generate external dependency CSV reports.
[externalDependenciesMarkdown.sh](./domains/external-dependencies/externalDependenciesMarkdown.sh) | external-dependencies | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[externalDependenciesPython.sh](./domains/external-dependencies/externalDependenciesPython.sh) | external-dependencies | Generates external dependency charts as SVG files using Python.
[externalDependenciesSummary.sh](./domains/external-dependencies/summary/externalDependenciesSummary.sh) | summary | Creates a Markdown report summarising all external dependency analysis results.
[gitHistoryCsv.sh](./domains/git-history/gitHistoryCsv.sh) | git-history | Executes GitLog Cypher statistics queries to produce git history CSV reports.
[gitHistoryMarkdown.sh](./domains/git-history/gitHistoryMarkdown.sh) | git-history | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[gitHistoryPython.sh](./domains/git-history/gitHistoryPython.sh) | git-history | Generates git history charts as SVG files using Python.
[createAggregatedGitLogCsv.sh](./domains/git-history/import/createAggregatedGitLogCsv.sh) | import | Uses git log to create a comma separated values (CSV) file containing aggregated changes, their author name and email address, year and month for all the files that were changed.
[createGitLogCsv.sh](./domains/git-history/import/createGitLogCsv.sh) | import | Uses git log to create a comma separated values (CSV) file containing all commits, their author, email address, date and all the file names that were changed with it.
[importGit.sh](./domains/git-history/import/importGit.sh) | import | Coordinates the import of git data from the given --source directory where one ore more git repositories are located and the value of the environment variable IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT.
[gitHistorySummary.sh](./domains/git-history/summary/gitHistorySummary.sh) | summary | Creates a Markdown report summarising all git history analysis results.
[internalDependenciesGraphs.sh](./domains/internal-dependencies/graphs/internalDependenciesGraphs.sh) | graphs | Executes internal dependency and path finding Cypher queries for GraphViz visualization.
[internalDependenciesCsv.sh](./domains/internal-dependencies/internalDependenciesCsv.sh) | internal-dependencies | Pipeline that coordinates internal dependency analysis using Cypher queries and the
[internalDependenciesMarkdown.sh](./domains/internal-dependencies/internalDependenciesMarkdown.sh) | internal-dependencies | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[internalDependenciesPython.sh](./domains/internal-dependencies/internalDependenciesPython.sh) | internal-dependencies | Generates path finding charts as SVG files using Python.
[internalDependenciesVisualization.sh](./domains/internal-dependencies/internalDependenciesVisualization.sh) | internal-dependencies | This script is dynamically triggered by "VisualizationReports.sh" when report "All" or "Visualization" is enabled.
[internalDependenciesSummary.sh](./domains/internal-dependencies/summary/internalDependenciesSummary.sh) | summary | Creates a Markdown report summarising all internal dependency analysis results.
[artifactDependenciesCsv.sh](./domains/java/artifactDependenciesCsv.sh) | java | Executes artifact dependency Cypher queries to produce CSV reports for Java artifact analysis.
[javaCsv.sh](./domains/java/javaCsv.sh) | java | Executes Java code quality and method metrics Cypher queries to produce CSV reports.
[javaMarkdown.sh](./domains/java/javaMarkdown.sh) | java | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[javaPython.sh](./domains/java/javaPython.sh) | java | Generates Java analysis charts as SVG files using Python.
[javaSummary.sh](./domains/java/summary/javaSummary.sh) | summary | Creates a Markdown report summarising all Java code quality, method metrics, and artifact dependency analysis results.
[configureNeo4j.sh](./domains/neo4j-management/configureNeo4j.sh) | neo4j-management | Configures a (local) Neo4j Community Edition Graph Database (https://neo4j.com/download-center/#community).
[detectNeo4j.sh](./domains/neo4j-management/detectNeo4j.sh) | neo4j-management | Detects if Neo4j is running and outputs its installation directory.
[detectNeo4jWindows.sh](./domains/neo4j-management/detectNeo4jWindows.sh) | neo4j-management | Detects if Neo4j is running on Windows from WSL or Git Bash.
[setupNeo4j.sh](./domains/neo4j-management/setupNeo4j.sh) | neo4j-management | Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community).
[setupNeo4jInitialPassword.sh](./domains/neo4j-management/setupNeo4jInitialPassword.sh) | neo4j-management | Sets the initial password for the local Neo4j Graph Database (https://neo4j.com/download-center/#community).
[startNeo4j.sh](./domains/neo4j-management/startNeo4j.sh) | neo4j-management | Starts the local Neo4j Graph Database. 
[stopNeo4j.sh](./domains/neo4j-management/stopNeo4j.sh) | neo4j-management | Stops the local Neo4j Graph Database. 
[testConfigureNeo4j.sh](./domains/neo4j-management/testConfigureNeo4j.sh) | neo4j-management | Tests "configureNeo4j.sh".
[useNeo4jHighMemoryProfile.sh](./domains/neo4j-management/useNeo4jHighMemoryProfile.sh) | neo4j-management | Use the high memory profile and apply its configuration template on the local 
[waitForNeo4jHttpFunctions.sh](./domains/neo4j-management/waitForNeo4jHttpFunctions.sh) | neo4j-management | Waits until the HTTP Transactions API of Neo4j Graph Database is available.
[nodeEmbeddingsCsv.sh](./domains/node-embeddings/nodeEmbeddingsCsv.sh) | node-embeddings | Generates node embeddings using the Neo4j Graph Data Science Library and writes CSV reports.
[nodeEmbeddingsMarkdown.sh](./domains/node-embeddings/nodeEmbeddingsMarkdown.sh) | node-embeddings | This script is dynamically triggered by "MarkdownReports.sh" when report "All" or "Markdown" are enabled.
[nodeEmbeddingsPython.sh](./domains/node-embeddings/nodeEmbeddingsPython.sh) | node-embeddings | Generates 2D UMAP scatter plots of node embeddings stored in Neo4j as SVG files.
[nodeEmbeddingsSummary.sh](./domains/node-embeddings/summary/nodeEmbeddingsSummary.sh) | summary | Creates a Markdown report summarising node embedding properties present in the graph.
[init.sh](./init.sh) |  | Initializes a new analysis project by creating all necessary directories based on the given input parameter with the analysis name. 
[activateCondaEnvironment.sh](./scripts/activateCondaEnvironment.sh) | scripts | Activates the Conda (Python package manager) environment "codegraph" with all packages needed to run the included Jupyter Notebooks and Python scripts.
[activatePythonEnvironment.sh](./scripts/activatePythonEnvironment.sh) | scripts | Activates the .venv environment (Python build-in virtual environments) with all packages necessary to run the included Jupyter Notebooks and Python scripts.
[analyze.sh](./scripts/analysis/analyze.sh) | analysis | Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation.
[checkCompatibility.sh](./scripts/checkCompatibility.sh) | scripts | Check environment dependencies and tool availability.
[cleanupAfterReportGeneration.sh](./scripts/cleanupAfterReportGeneration.sh) | scripts | Cleans up after report generation. This includes deleting empty files or in case no file is left deleting the report folder.
[cloneGitRepository.sh](./scripts/cloneGitRepository.sh) | scripts | Provides safe-guarded (security checked parameters) git repository cloning.
[detectChangedFiles.sh](./scripts/detectChangedFiles.sh) | scripts | Detect changed files in the artifacts directory or in a given list of paths 
[appendEnvironmentVariables.sh](./scripts/documentation/appendEnvironmentVariables.sh) | documentation | Extracts the environment variable declarations including default values from a script file and appends it to a markdown file as table columns.
[generateCypherReference.sh](./scripts/documentation/generateCypherReference.sh) | documentation | Generates "CYPHER.md" containing a reference to all Cypher files in all directories and subdirectories.
[generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh) | documentation | Runs "appendEnvironmentVariables.sh" for every script file in all directories and subdirectories.
[generateScriptReference.sh](./scripts/documentation/generateScriptReference.sh) | documentation | Generates "SCRIPTS.md" containing a reference to all scripts in all directories and subdirectories.
[download.sh](./scripts/download.sh) | scripts | Downloads a file into the directory of the environment variable SHARED_DOWNLOADS_DIRECTORY (or default "../downloads").
[downloadMavenArtifact.sh](./scripts/downloadMavenArtifact.sh) | scripts | Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central)
[downloadMavenArtifacts.sh](./scripts/downloadMavenArtifacts.sh) | scripts | Uses Maven to download specified Maven artifacts from Maven Central.
[downloadAntDesign.sh](./scripts/downloader/downloadAntDesign.sh) | downloader | Downloads the Typescript project ant-design (https://github.com/ant-design/ant-design) from GitHub using git clone.
[downloadAxonFramework.sh](./scripts/downloader/downloadAxonFramework.sh) | downloader | Downloads AxonFramework (https://developer.axoniq.io/axon-framework) artifacts from Maven Central.
[downloadReactRouter.sh](./scripts/downloader/downloadReactRouter.sh) | downloader | Downloads react-router (https://github.com/remix-run/react-router) from GitHub using git clone.
[downloadTypescriptProject.sh](./scripts/downloader/downloadTypescriptProject.sh) | downloader | Downloads the given version of a Typescript project from a git repository using git clone.
[analyzeAntDesign.sh](./scripts/examples/analyzeAntDesign.sh) | examples | This is an example for the analysis of a the Typescript project "ant-design".
[analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) | examples | This is an example for the analysis of the Java event-sourcing library "AxonFramework". 
[analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh) | examples | This is an example for the analysis of a the Typescript project "react-router".
[detectLatestGitTag.sh](./scripts/examples/detectLatestGitTag.sh) | examples | Returns the latest tag of a remote repository given by its url.
[executeJupyterNotebook.sh](./scripts/executeJupyterNotebook.sh) | scripts | Executes all steps in the given Jupyter Notebook (ipynb), stores it and converts it to Markdown (md) and PDF.
[executeJupyterNotebookReport.sh](./scripts/executeJupyterNotebookReport.sh) | scripts | Executes the given Jupyter Notebook and puts all resulting files (ipynb, md, pdf) into an accordingly named directory within the "results" directory.
[executeQuery.sh](./scripts/executeQuery.sh) | scripts | Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format.
[executeQueryFunctions.sh](./scripts/executeQueryFunctions.sh) | scripts | Provides functions to execute Cypher queries using either "executeQuery.sh" or Neo4j's "cypher-shell". 
[findPathsToScan.sh](./scripts/findPathsToScan.sh) | scripts | Finds all files and directories to scan and analyze and provides them as comma-separated list.
[installJavaScriptDependencies.sh](./scripts/installJavaScriptDependencies.sh) | scripts | This script triggers the installation of dependencies for JavaScript projects in the source folder.
[embedMarkdownIncludes.sh](./scripts/markdown/embedMarkdownIncludes.sh) | markdown | Processes template markdown (sysin) replacing placeholders like "<!-- include:intro.md -->" or "<!-- include:intro.md\|fallback.md -->" with the contents of the specified markdown files. The files to include needs to be in the "includes" subdirectory.
[formatQueryResultAsMarkdownTable.sh](./scripts/markdown/formatQueryResultAsMarkdownTable.sh) | markdown | Takes the input stream (Cypher query result in JSON format) and formats it as a Markdown table.
[testEmbedMarkdownIncludes.sh](./scripts/markdown/testEmbedMarkdownIncludes.sh) | markdown | Tests template processing for markdown by embedding includes.
[testFormatQueryResultAsMarkdownTable.sh](./scripts/markdown/testFormatQueryResultAsMarkdownTable.sh) | markdown | Tests formatting of Cypher query results as Markdown table.
[operatingSystemFunctions.sh](./scripts/operatingSystemFunctions.sh) | scripts | Provides operating system dependent functions e.g. to detect Windows.
[parseCsvFunctions.sh](./scripts/parseCsvFunctions.sh) | scripts | Provides functions to parse strings in CSV format. 
[prepareAnalysis.sh](./scripts/prepareAnalysis.sh) | scripts | Prepares and validates the graph database before analysis 
[Default.sh](./scripts/profiles/Default.sh) | profiles | Sets (if any) settings variables for a default analysis.
[Neo4j-latest-continue-on-scan-errors.sh](./scripts/profiles/Neo4j-latest-continue-on-scan-errors.sh) | profiles | Sets all settings variables for an analysis with the latest version of Neo4j.
[Neo4j-latest-high-memory.sh](./scripts/profiles/Neo4j-latest-high-memory.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
[Neo4j-latest-low-memory-continue-on-scan-errors.sh](./scripts/profiles/Neo4j-latest-low-memory-continue-on-scan-errors.sh) | profiles | Sets all settings variables for a low memory, continue-on-error analysis with the latest version of Neo4j.
[Neo4j-latest-low-memory.sh](./scripts/profiles/Neo4j-latest-low-memory.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
[Neo4j-latest.sh](./scripts/profiles/Neo4j-latest.sh) | profiles | Sets all settings variables for an analysis with the latest version of Neo4j.
[Neo4jv4-low-memory.sh](./scripts/profiles/Neo4jv4-low-memory.sh) | profiles | Sets all settings variables for an analysis with Neo4j v4.4.x (long term support (LTS) version as of may 2023).
[Neo4jv4.sh](./scripts/profiles/Neo4jv4.sh) | profiles | Sets all settings variables for an analysis with Neo4j v4.4.x (long term support (LTS) version as of may 2023).
[Neo4jv5-continue-on-scan-errors.sh](./scripts/profiles/Neo4jv5-continue-on-scan-errors.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
[Neo4jv5-low-memory.sh](./scripts/profiles/Neo4jv5-low-memory.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
[Neo4jv5.sh](./scripts/profiles/Neo4jv5.sh) | profiles | Sets all settings variables for an analysis with Neo4j v5.x (newest version as of june 2023).
[projectionFunctions.sh](./scripts/projectionFunctions.sh) | scripts | Provides functions to create and delete Graph Projections for Neo4j Graph Data Science.
[CentralityCsv.sh](./scripts/reports/CentralityCsv.sh) | reports | Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports.
[CommunityCsv.sh](./scripts/reports/CommunityCsv.sh) | reports | Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports.
[OverviewCsv.sh](./scripts/reports/OverviewCsv.sh) | reports | Executes "Overview" Cypher queries to get the "overview-csv" CSV reports.
[SimilarityCsv.sh](./scripts/reports/SimilarityCsv.sh) | reports | Looks for similarity using the Graph Data Science Library of Neo4j and creates CSV reports.
[AllReports.sh](./scripts/reports/compilations/AllReports.sh) | compilations | Runs all report scripts.
[CsvReports.sh](./scripts/reports/compilations/CsvReports.sh) | compilations | Runs all CSV report scripts (no Python and Chromium required).
[DatabaseCsvExportReports.sh](./scripts/reports/compilations/DatabaseCsvExportReports.sh) | compilations | Exports the whole graph database as a CSV file using the APOC procedure "apoc.export.csv.all"
[JupyterReports.sh](./scripts/reports/compilations/JupyterReports.sh) | compilations | Runs all Jupyter Notebook report scripts.
[MarkdownReports.sh](./scripts/reports/compilations/MarkdownReports.sh) | compilations | Runs all Markdown report scripts (no Chromium required, no Python required).
[PythonReports.sh](./scripts/reports/compilations/PythonReports.sh) | compilations | Runs all Python report scripts (no Chromium required).
[VisualizationReports.sh](./scripts/reports/compilations/VisualizationReports.sh) | compilations | Runs all Visualization reports.
[resetAndScan.sh](./scripts/resetAndScan.sh) | scripts | Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph.
[resetAndScanChanged.sh](./scripts/resetAndScanChanged.sh) | scripts | Executes "resetAndScan.sh" only if "detectChangedFiles.sh" returns detected changes.
[runTests.sh](./scripts/runTests.sh) | scripts | Runs all test scripts (no Python and Chromium required).
[scanTypescript.sh](./scripts/scanTypescript.sh) | scripts | Executes the npm package @jqassistant/ts-lc using npx to scan the Typescript projects in the source directory and create an intermediate json data file for the jQAssistant Typescript plugin.
[setupJQAssistant.sh](./scripts/setupJQAssistant.sh) | scripts | Installs (download and unzip) jQAssistant (https://jqassistant.github.io/jqassistant/current).
[sortOutExternalJavaJarFiles.sh](./scripts/sortOutExternalJavaJarFiles.sh) | scripts | Sorts out jar files that don't contain one of the given package names (e.g. external libraries) and moves them into the IGNORED_JARS_DIRECTORY. 
[startNeo4j.sh](./scripts/startNeo4j.sh) | scripts | Deprecated: startNeo4j.sh has been moved to domains/neo4j-management/.
[stopNeo4j.sh](./scripts/stopNeo4j.sh) | scripts | Deprecated: stopNeo4j.sh has been moved to domains/neo4j-management/.
[testAnalyzeDomainOption.sh](./scripts/testAnalyzeDomainOption.sh) | scripts | Tests "--domain" command line option of "analyze.sh".
[testCloneGitRepository.sh](./scripts/testCloneGitRepository.sh) | scripts | Tests "cloneGitRepository.sh".
[testDetectChangedFiles.sh](./scripts/testDetectChangedFiles.sh) | scripts | Tests "detectChangedFiles.sh".
[testDownloadMavenArtifacts.sh](./scripts/testDownloadMavenArtifacts.sh) | scripts | Tests "downloadMavenArtifacts.sh".
[testFilenameReferences.sh](./scripts/testFilenameReferences.sh) | scripts | Tests: scan all *.sh files (current directory including subdirectories)
[testInstallJavaScriptDependencies.sh](./scripts/testInstallJavaScriptDependencies.sh) | scripts | Tests "installJavaScriptDependencies.sh".
[convertQueryResultCsvToGraphVizDotFile.sh](./scripts/visualization/convertQueryResultCsvToGraphVizDotFile.sh) | visualization | Converts a Cypher query result in CSV format to a GraphViz DOT (https://graphviz.org/doc/info/lang.html) file for Visualization including layout templates.
[renderGraphVizSVG.sh](./scripts/visualization/renderGraphVizSVG.sh) | visualization | Renders the given GraphViz file as a SVG image.
[visualizeQueryResults.sh](./scripts/visualization/visualizeQueryResults.sh) | visualization | Visualizes the Cypher query result (CSV format) using GraphViz and outputs it as SVG image.
