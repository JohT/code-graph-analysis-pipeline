# Scripts Reference

This document serves as a reference for all scripts in the current directory and its subdirectories.
It provides a table listing each script file and its corresponding description found in the first comment line.

Script | Directory | Description
-------|-----------|------------
| [analyze.sh](./analysis/analyze.sh) | analysis | Coordinates the end-to-end analysis process, encompassing tool installation, graph generation, and report generation. |
| [downloadAxonFramework.sh](./artifacts/downloadAxonFramework.sh) | artifacts | Downloads AxonFramework (https://developer.axoniq.io/axon-framework) artifacts from Maven Central. |
| [copyReportsIntoResults.sh](./copyReportsIntoResults.sh) |  | Copies the results from the temp directory to the results directory grouped by the analysis name. |
| [detectChangedArtifacts.sh](./detectChangedArtifacts.sh) |  | Detect changed files in the artifacts directory with a text file containing the last hash code of the contents. |
| [downloadMavenArtifact.sh](./downloadMavenArtifact.sh) |  | Downloads an artifact from Maven Central (https://mvnrepository.com/repos/central) |
| [executeJupyterNotebook.sh](./executeJupyterNotebook.sh) |  | Executes all steps in the given Jupyter Notebook (ipynb), stores it and converts it to Markdown (md) and PDF. |
| [executeQuery.sh](./executeQuery.sh) |  | Utilizes Neo4j's HTTP API to execute a Cypher query from an input file and provides the results in CSV format. |
| [executeQueryFunctions.sh](./executeQueryFunctions.sh) |  | Provides functions to execute Cypher queries using either "executeQuery.sh" or Neo4j's "cypher-shell".  |
| [generateCypherReference.sh](./generateCypherReference.sh) |  | Generates "CYPHER.md" containing a reference to all Cypher files in this directory and its subdirectories. |
| [generateMarkdownReference.sh](./generateMarkdownReference.sh) |  | Generates "REPORTS.md" containing a reference to all scripts in this directory and its subdirectories. |
| [generateScriptReference.sh](./generateScriptReference.sh) |  | Generates "SCRIPTS.md" containing a reference to all scripts in this directory and its subdirectories. |
| [prepareAnalysis.sh](./prepareAnalysis.sh) |  | Prepares and validates the graph database before analysis  |
| [CentralityCsv.sh](./reports/CentralityCsv.sh) | reports | Looks for centrality using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [CommunityCsv.sh](./reports/CommunityCsv.sh) | reports | Detects communities using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [DatabaseCsvExport.sh](./reports/DatabaseCsvExport.sh) | reports | Exports the whole graph database as a CSV file using the APOC procedure "apoc.export.csv.all" |
| [ExternalDependenciesCsv.sh](./reports/ExternalDependenciesCsv.sh) | reports | Executes "Package_Usage" Cypher queries to get the "package-dependencies" CSV reports. |
| [ExternalDependenciesJupyter.sh](./reports/ExternalDependenciesJupyter.sh) | reports | Creates the "overview" report (ipynb, md, pdf) based on the Jupyter Notebook "Overview.ipynb". |
| [ObjectOrientedDesignMetricsCsv.sh](./reports/ObjectOrientedDesignMetricsCsv.sh) | reports | Executes "Metrics" Cypher queries to get the "object-oriented-design-metrics" CSV reports. |
| [ObjectOrientedDesignMetricsJupyter.sh](./reports/ObjectOrientedDesignMetricsJupyter.sh) | reports | Creates the "object-oriented-design-metrics" report (ipynb, md, pdf) based on the Jupyter Notebook "ObjectOrientedDesignMetrics.ipynb". |
| [OverviewCsv.sh](./reports/OverviewCsv.sh) | reports | Executes "Package_Usage" Cypher queries to get the "package-dependencies" CSV reports. |
| [OverviewJupyter.sh](./reports/OverviewJupyter.sh) | reports | Creates the "overview" report (ipynb, md, pdf) based on the Jupyter Notebook "Overview.ipynb". |
| [PackageDependenciesCsv.sh](./reports/PackageDependenciesCsv.sh) | reports | Executes "Package_Usage" Cypher queries to get the "package-dependencies" CSV reports. |
| [PackageDependenciesJupyter.sh](./reports/PackageDependenciesJupyter.sh) | reports | Creates the "package-dependencies" report (ipynb, md, pdf) based on the Jupyter Notebook "PackageDependencies.ipynb". |
| [SimilarityCsv.sh](./reports/SimilarityCsv.sh) | reports | Looks for similarity using the Graph Data Science Library of Neo4j and creates CSV reports. |
| [VisibilityMetricsCsv.sh](./reports/VisibilityMetricsCsv.sh) | reports | Executes "Visibility" Cypher queries to get the "visibility-metrics" CSV reports. |
| [VisibilityMetricsJupyter.sh](./reports/VisibilityMetricsJupyter.sh) | reports | Creates the "visibility-metrics" report (ipynb, md, pdf) based on the Jupyter Notebook "VisibilityMetrics.ipynb". |
| [WordcloudJupyter.sh](./reports/WordcloudJupyter.sh) | reports | Creates the "overview" report (ipynb, md, pdf) based on the Jupyter Notebook "Overview.ipynb". |
| [AllReports.sh](./reports/compilations/AllReports.sh) | compilations | Runs all report scripts. |
| [CsvReports.sh](./reports/compilations/CsvReports.sh) | compilations | Runs all CSV report scripts (no Python and Chromium required). |
| [JupyterReports.sh](./reports/compilations/JupyterReports.sh) | compilations | Runs all Jupyter Notebook report scripts. |
| [resetAndScan.sh](./resetAndScan.sh) |  | Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph. |
| [resetAndScanChanged.sh](./resetAndScanChanged.sh) |  | Executes "resetAndScan.sh" only if "detectChangedArtifacts.sh" returns detected changes. |
| [resetAndScanMemgraph.sh](./resetAndScanMemgraph.sh) |  | Deletes all data in the Neo4j graph database and rescans the downloaded artifacts to create a new graph. |
| [setupJQAssistant.sh](./setupJQAssistant.sh) |  | Installs (download and unzip) jQAssistant (https://jqassistant.org/get-started). |
| [setupNeo4j.sh](./setupNeo4j.sh) |  | Installs (download, unpack, get plugins, configure) a local Neo4j Graph Database (https://neo4j.com/download-center/#community). |
| [setupNeo4jInitialPassword.sh](./setupNeo4jInitialPassword.sh) |  | Sets the initial password for the local Neo4j Graph Database (https://neo4j.com/download-center/#community). |
| [startNeo4j.sh](./startNeo4j.sh) |  | Starts the local Neo4j Graph Database.  |
| [stopNeo4j.sh](./stopNeo4j.sh) |  | Stops the local Neo4j Graph Database.  |
| [waitForNeo4jHttp.sh](./waitForNeo4jHttp.sh) |  | Waits until the HTTP Transactions API of Neo4j Graph Database is available. |
