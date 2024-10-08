# Code Graph Analysis Pipeline - Commands

<!-- TOC -->

- [Start an Analysis](#start-an-analysis)
    - [Command Line Options](#command-line-options)
    - [Notes](#notes)
    - [Examples](#examples)
        - [Start an analysis with CSV reports only](#start-an-analysis-with-csv-reports-only)
        - [Start an analysis with Jupyter reports only](#start-an-analysis-with-jupyter-reports-only)
        - [Start an analysis with PDF generation](#start-an-analysis-with-pdf-generation)
        - [Start an analysis without importing git log data](#start-an-analysis-without-importing-git-log-data)
        - [Only run setup and explore the Graph manually](#only-run-setup-and-explore-the-graph-manually)
- [Generate Markdown References](#generate-markdown-references)
    - [Generate Cypher Reference](#generate-cypher-reference)
    - [Generate Script Reference](#generate-script-reference)
    - [Generate CSV Cypher Query Report Reference](#generate-csv-cypher-query-report-reference)
    - [Generate Jupyter Notebook Report Reference](#generate-jupyter-notebook-report-reference)
    - [Generate Image Reference](#generate-image-reference)
    - [Generate Environment Variable Reference](#generate-environment-variable-reference)
- [Validate Links in Markdown](#validate-links-in-markdown)
- [Manual Setup](#manual-setup)
    - [Setup Neo4j Graph Database](#setup-neo4j-graph-database)
    - [Start Neo4j Graph Database](#start-neo4j-graph-database)
    - [Setup jQAssistant Java Code Analyzer](#setup-jqassistant-java-code-analyzer)
    - [Download Maven Artifacts to analyze](#download-maven-artifacts-to-analyze)
    - [Sort out jar files containing external libraries](#sort-out-jar-files-containing-external-libraries)
    - [Download Typescript project to analyze](#download-typescript-project-to-analyze)
    - [Reset the database and scan the java artifacts](#reset-the-database-and-scan-the-java-artifacts)
    - [Import git data](#import-git-data)
        - [Import aggregated git log](#import-aggregated-git-log)
        - [Parameter](#parameter)
        - [Environment Variable](#environment-variable)
        - [Resolving git files to code files](#resolving-git-files-to-code-files)
- [Database Queries](#database-queries)
    - [Cypher Shell](#cypher-shell)
    - [HTTP API](#http-api)
    - [executeQueryFunctions.sh](#executequeryfunctionssh)
- [Stop Neo4j](#stop-neo4j)
- [Jupyter Notebook](#jupyter-notebook)
    - [Create a report with executeJupyterNotebookReport.sh](#create-a-report-with-executejupyternotebookreportsh)
        - [Data Availability Validation](#data-availability-validation)
    - [Execute a Notebook with executeJupyterNotebook.sh](#execute-a-notebook-with-executejupyternotebooksh)
    - [Manually setup the environment using Conda](#manually-setup-the-environment-using-conda)
    - [Executing Jupyter Notebooks with nbconvert](#executing-jupyter-notebooks-with-nbconvert)
- [References](#references)
- [Other Commands](#other-commands)
    - [Information about a process that listens to a specific local port](#information-about-a-process-that-listens-to-a-specific-local-port)
    - [Kill process that listens to a specific local port](#kill-process-that-listens-to-a-specific-local-port)
    - [Memory Estimation](#memory-estimation)

<!-- /TOC -->

## Start an Analysis

An analysis is started with the script [analyze.sh](./scripts/analysis/analyze.sh).
To run all analysis steps simple execute the following command:

```shell
./../../scripts/analysis/analyze.sh
```

👉 See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example script that combines all the above steps for a Java Project.
👉 See [scripts/examples/analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh) as an example script that combines all the above steps for a Typescript Project.  
👉 See [Code Structure Analysis Pipeline](./.github/workflows/java-code-analysis.yml) on how to do this within a GitHub Actions Workflow.

### Command Line Options

The [analyze.sh](./scripts/analysis/analyze.sh) command comes with these command line options:

- `--report Csv` only generates CSV reports. This speeds up the report generation and doesn't depend on Python, Jupyter Notebook or any other related dependencies. The default value os `All` to generate all reports. `Jupiter` will only generate Jupyter Notebook reports. `DatabaseCsvExport` exports the whole graph database as a CSV file (performance intense, check if there are security concerns first).

- `--profile Neo4jv4` uses the older long term support (june 2023) version v4.4.x of Neo4j and suitable compatible versions of plugins and JQAssistant. `Neo4jv5` will explicitly select the newest (june 2023) version 5.x of Neo4j. Without setting
a profile, the newest versions will be used. Profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4jv5-continue-on-scan-errors` is based on the default profile (`Neo4jv5`) but uses the jQAssistant configuration template [template-neo4jv5-jqassistant-continue-on-error.yaml](./scripts/configuration/template-neo4jv5-jqassistant-continue-on-error.yaml) to continue on scan error instead of failing fast. This is temporarily useful when there is a known error that needs to be ignored. It is still recommended to use the default profile and fail fast if there is something wrong. Profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--explore` activates the "explore" mode where no reports are generated. Furthermore, Neo4j won't be stopped at the end of the script and will therefore continue running.  This makes it easy to just set everything up but then use the running Neo4j server to explore the data manually.

### Notes

- Be sure to use Java 17 for Neo4j v5 and Java 11 for Neo4j v4
- Use your own initial Neo4j password
- For more details have a look at the script [analyze.sh](./scripts/analysis/analyze.sh)

### Examples

#### Start an analysis with CSV reports only

If only the CSV reports are needed, that are the result of Cypher queries and don't need any further dependencies (like Python)
the analysis can be speeded up with:

```shell
./../../scripts/analysis/analyze.sh --report Csv
```

#### Start an analysis with Jupyter reports only

If only the Jupyter reports are needed e.g. when the CSV reports had already been generated, the this can be done with:

```shell
./../../scripts/analysis/analyze.sh --report Jupyter
```

#### Start an analysis with PDF generation

Note: Generating a PDF from a Jupyter notebook using [nbconvert](https://nbconvert.readthedocs.io) takes some time and might even fail due to a timeout error.

```shell
ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION=true ./../../scripts/analysis/analyze.sh
```

#### Start an analysis without importing git log data

To speed up analysis and get a smaller data footprint you can switch of git log data import of the "source" directory (if present) with `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="none"` as shown below or choose `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated"` to reduce data size by only importing monthly grouped changes instead of all commits.

```shell
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="none" ./../../scripts/analysis/analyze.sh
```

#### Only run setup and explore the Graph manually

To prepare everything for analysis including installation, configuration and preparation queries to explore the graph manually
without report generation use this command:

```shell
./../../scripts/analysis/analyze.sh --explore
```

## Generate Markdown References

### Generate Cypher Reference

Change into the [cypher](./cypher/) directory e.g. with `cd cypher` and then execute the script [generateCypherReference.sh](./scripts/documentation/generateCypherReference.sh) with the following command:

```script
./../scripts/documentation/generateCypherReference.sh
```

### Generate Script Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateScriptReference.sh](./scripts/documentation/generateScriptReference.sh) with the following command:

```script
./documentation/generateScriptReference.sh
```

### Generate CSV Cypher Query Report Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateCsvReportReference.sh](./scripts/documentation/generateCsvReportReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [java-code-analysis.yml](.github/workflows/java-code-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateCsvReportReference.sh
```

### Generate Jupyter Notebook Report Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateJupyterReportReference.sh](./scripts/documentation/generateJupyterReportReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [java-code-analysis.yml](.github/workflows/java-code-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateJupyterReportReference.sh
```

### Generate Image Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateImageReference.sh](./scripts/documentation/generateImageReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [java-code-analysis.yml](.github/workflows/java-code-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateImageReference.sh
```

### Generate Environment Variable Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh) with the following command:

```script
./documentation/generateEnvironmentVariableReference.sh
```

## Validate Links in Markdown

The following command shows how to use [markdown-link-check](https://github.com/tcort/markdown-link-check) to for example check the links in the [README.md](./README.md) file:

```script
npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json README.md COMMANDS.md GETTING_STARTED.md
```

## Manual Setup

The manual setup is only documented for completeness. It isn't needed since the analysis also covers download, installation and configuration of all needed tools.

If any of the script are not allowed to be executed use `chmod +x ./scripts/` followed by the script file name to grant execution.

### Setup Neo4j Graph Database

Use [setupNeo4j.sh](./scripts/setupNeo4j.sh) to download [Neo4j](https://neo4j.com/download-center) and install the plugins [APOC](https://neo4j.com/labs/apoc/4.4) and [Graph Data Science](https://neo4j.com/product/graph-data-science).
This script requires the environment variable NEO4J_INITIAL_PASSWORD to be set. It sets the initial password with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

### Start Neo4j Graph Database

Use [startNeo4j.sh](./scripts/startNeo4j.sh) to start the locally installed [Neo4j](https://neo4j.com/download-center) Graph database.
It runs the script with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

### Setup jQAssistant Java Code Analyzer

Use [setupJQAssistant.sh](./scripts/setupJQAssistant.sh) to download [jQAssistant](https://jqassistant.github.io/jqassistant/current).

### Download Maven Artifacts to analyze

Use [downloadMavenArtifact.sh](./scripts/downloadMavenArtifact.sh) with the following mandatory options
to download a Maven artifact into the artifacts directory:

- `-g <maven group id>`
- `-a <maven artifact name>`
- `-v <maven artifact version>`
- `-t <maven artifact type (optional, defaults to jar)>`
- `-d <target directory for the downloaded file (optional, defaults to "artifacts")>`

### Sort out jar files containing external libraries

After collecting all the Java artifacts it might be needed to sort out external libraries you don't want to analyze directly.
For that you can use [sortOutExternalJavaJarFiles.sh](./scripts/sortOutExternalJavaJarFiles.sh). It needs to be started in the directory of the jar files ("artifacts") of you analysis workspace and will create a new directory called "ignored-jars" besides the "artifacts" directory so that those jars don't get analyzed.

Here is an example that can be started from your temp analysis workspace and that will filter out all jar files that don't contain any `org.neo4j` package:

```script
cd artifacts; ./../../../scripts/sortOutExternalJavaJarFiles.sh org.neo4j
```

### Download Typescript project to analyze

Use [downloadTypescriptProject.sh](./scripts/downloader/downloadTypescriptProject.sh) with the following options
to download a Typescript project using git clone and prepare it for analysis:

- `--url` Git clone URL (required)
- `--version` Version of the project
- `--tag` Tag to switch to after "git clone" (optional, default = version)
- `--project` Name of the project/repository (optional, default = clone url file name without .git extension)
- `--packageManager` One of "npm", "pnpm" or "yarn". (optional, default = "npm")

Here is an example:

```shell
./../../downloadTypescriptProject.sh \
  --url https://github.com/remix-run/react-router.git \
  --version 6.24.0 \
  --tag "react-router@6.24.0" \
  --packageManager pnpm
```

### Reset the database and scan the java artifacts

Use [resetAndScan.sh](./scripts/resetAndScan.sh) to scan the local `artifacts` directory with the previously downloaded Java artifacts and write the data into the local Neo4J Graph database using jQAssistant. It also uses some jQAssistant "concepts" to
enhance the data further with relationships between artifacts and packages.

Be aware that this script deletes all previous relationships and nodes in the local Neo4j Graph database.

### Import git data

Use [importGit.sh](./scripts/importGit.sh) to import git data into the Graph.
It uses `git log` to extract commits, their authors and the names of the files changed with them. These are stored in an intermediate CSV file and are then imported into Neo4j with the following schema:

```Cypher
(Git:Log:Author)-[:AUTHORED]->(Git:Log:Commit)->[:CONTAINS_CHANGED]->(Git:Log:File)
(Git:Log:Commit)-[:HAS_PARENT]->(Git:Log:Commit)
(Git:Repository)-[:HAS_COMMIT]->(Git:Log:Commit)
(Git:Repository)-[:HAS_AUTHOR]->(Git:Log:Author)
(Git:Repository)-[:HAS_FILE]->(Git:Log:File)
```

👉**Note:** Commit messages containing `[bot]` are filtered out to ignore changes made by bots.

#### Import aggregated git log

Instead of importing every single commit, changes can be grouped by month including their commit count. This is in many cases sufficient and reduces data size and processing time significantly. To do this, set the environment variable `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` to `aggregated`. If you don't want to set the environment variable globally, then you can also prepend the command with it like this (inside the analysis workspace directory contained within temp):

```shell
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated" ./../../scripts/importGit.sh
```

Here is the resulting schema:

```Cypher
(Git:Log:Author)-[:AUTHORED]->(Git:Log:ChangeSpan)-[:CONTAINS_CHANGED]->(Git:Log:File)
(Git:Repository)-[:HAS_CHANGE_SPAN]->(Git:Log:ChangeSpan)
(Git:Repository)-[:HAS_AUTHOR]->(Git:Log:Author)
(Git:Repository)-[:HAS_FILE]->(Git:Log:File)
```

#### Parameter

The optional parameter `--source directory-path-to-the-source-folder-containing-git-repositories` can be used to select a different directory for the repositories. By default, the `source` directory within the analysis workspace directory is used. This command only needs the git history to be present. Therefore, `git clone --bare` is sufficient. If the `source` directory is also used for code analysis (like for Typescript) then a full git clone is of course needed.

#### Environment Variable

- `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` supports the values `none`, `aggregated`, `full` and `plugin` (default). With it, you can switch off git import (`none`), import aggregated data for a smaller memory footprint (`aggregated`), import all commits with git log in a simple way (`full`) or let a plugin take care of git data (`plugin`= `""`=default) .

#### Resolving git files to code files

After git log data has been imported successfully, [Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher](./cypher/GitLog/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher) is used to try to resolve the imported git file names to  code files. This first attempt will cover most cases, but not all of them. With this approach it is, for example, not possible to distinguish identical file names in different Java jars from the git source files of a mono repo.

You can use [List_unresolved_git_files.cypher](./cypher/GitLog/List_unresolved_git_files.cypher) to find code files that couldn't be matched to git file names and [List_ambiguous_git_files.cypher](./cypher/GitLog/List_ambiguous_git_files.cypher) to find ambiguously resolved git files. If you have any idea on how to improve this feel free to [open an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new).

## Database Queries

### Cypher Shell

With `cypher-shell` CLI provided by Neo4j a query based on a file can simply be made with the following command.
Be sure to replace `path/to/local/neo4j` and `password` with your settings.

```shell
cat ./cypher/Get_Graph_Data_Science_Library_Version.cypher | path/to/local/neo4j/bin/cypher-shell -u neo4j -p password --format plain
```

Query parameter can be added with the option `--param`. Here is an example:

```shell
cat ./cypher/Get_Graph_Data_Science_Library_Version.cypher | path/to/local/neo4j/bin/cypher-shell -u neo4j -p password --format plain --param {a: 1}
```

For a full list of options use the help function:

```shell
path/to/local/neo4j/bin/cypher-shell --help
```

### HTTP API

Use [executeQuery.sh](./scripts/executeQuery.sh) to execute a Cypher query from the file given as an argument.
It uses `curl` and `jq` to access the [HTTP API of Neo4j](https://neo4j.com/docs/http-api/current/query).
Here is an example:

```shell
./scripts/executeQuery.sh ./cypher/Get_Graph_Data_Science_Library_Version.cypher
```

Query parameters can be added as arguments after the file name. Here is an example:

```shell
./scripts/executeQuery.sh ./cypher/Get_Graph_Data_Science_Library_Version.cypher a=1
```

### executeQueryFunctions.sh

The script [executeQueryFunctions.sh](./scripts/executeQueryFunctions.sh) contains functions to simplify the
call of [executeQuery.sh](./scripts/executeQuery.sh) for different purposes. For example, `execute_cypher_summarized`
prints out the results on the console in a summarized manner and `execute_cypher_expect_results` fails when there are no results.

The script also provides an API abstraction that defaults to [HTTP](#http-api), but can easily be switched to [cypher-shell](#cypher-shell).

Query parameters can be added as arguments after the file name. Here is an example:

```shell
source "${SCRIPTS_DIR}/executeQueryFunctions.sh"
execute_cypher ./cypher/Get_Graph_Data_Science_Library_Version.cypher a=1
```

## Stop Neo4j

Use [stopNeo4j.sh](./scripts/stopNeo4j.sh) to stop the locally running Neo4j Graph Database. It does nothing if the database is already stopped. It runs the script with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

## Jupyter Notebook

### Create a report with executeJupyterNotebookReport.sh

The script [executeJupyterNotebookReport.sh](./scripts/executeJupyterNotebookReport.sh) combines:

- creating a directory within the "reports" directory
- data availability validation using [executeQueryFunctions.sh](#executequeryfunctionssh)
- executing and converting the given Notebook using [executeJupyterNotebook.sh](#execute-a-notebook-with-executejupyternotebooksh)

Here is an example on how to run the report [Wordcloud.ipynb](./jupyter/Wordcloud.ipynb):

```shell
./scripts/executeJupyterNotebookReport.sh  --jupyterNotebook Wordcloud.ipynb
```

#### Data Availability Validation

[Jupyter Notebooks](https://jupyter.org) can have additional custom tags within their [metadata section](https://ipython.readthedocs.io/en/3.x/notebook/nbformat.html#metadata). Opening these files with a text editor unveils that typically at the end of the file. Some editors also support editing them directly. Here, the optional metadata property `code_graph_analysis_pipeline_data_validation` is used to specify which data validation query in the [cypher/Validation](./cypher/Validation/) directory should be used. Without this property, the data validation step is skipped. If a validation is specified, it will be executed before the Jupyter Notebook is executed. If the query has at least one result, the validation is seen as successful. Otherwise, the Jupyter Notebook will not be executed.

This is helpful for Jupyter Notebook reports that are specific to a programming language or other specific data prerequisites. The Notebook will be skipped if there is no data available which would otherwise lead to confusing and distracting reports with empty tables and figures.

You can search the messages `Validation succeeded` or `Validation failed` inside the log to get detailed information which Notebook had been skipped for which reason.

### Execute a Notebook with executeJupyterNotebook.sh

[executeJupyterNotebook.sh](./scripts/executeJupyterNotebook.sh) executes a Jupyter Notebook in the command line and convert it to different formats like Markdown and PDF (optionally). It takes care of [setting up the environment](#manually-setup-the-environment-using-conda) and [uses nbconvert](#executing-jupyter-notebooks-with-nbconvert) to execute the notebook and convert it to other file formats under the hood.

Here is an example on how to use [executeJupyterNotebook.sh](./scripts/executeJupyterNotebook.sh) to for example run [Wordcloud.ipynb](./jupyter/Wordcloud.ipynb):

```shell
./scripts/executeJupyterNotebook.sh ./jupyter/Wordcloud.ipynb
```

### Manually setup the environment using Conda

[Conda](https://conda.io) provides package, dependency, and environment management for any language. Here, it is used to setup the environment for Juypter Notebooks.

- Setup environment

  ```shell
  conda create --name codegraph jupyter numpy matplotlib nbconvert nbconvert-webpdf
  conda activate codegraph
  ```

  or by using the environment file [codegraph-environment.yml](./jupyter/environment.yml):

  ```shell
  conda env create --file ./jupyter/environment.yml
  conda activate codegraph
  ```

- Export full environment.yml

  ```shell
  conda env export --name codegraph > full-codegraph-environment.yml
  ```

- Export only explicit environment.yml

  ```shell
  conda env export --from-history --name codegraph | grep -v "^prefix: " > explicit-codegraph-environment.yml
  ```

### Executing Jupyter Notebooks with nbconvert

[nbconvert](https://nbconvert.readthedocs.io) converts Jupyter Notebooks to other static formats including HTML, LaTeX, PDF, Markdown, reStructuredText, and more.

- Install pandoc used by nbconvert for LaTeX support (Mac)

  ```shell
  brew install pandoc mactex
  ```

- Start Jupyter Notebook

  ```shell
  jupyter notebook
  ```

- Create new Notebook with executed cells

  ```shell
  jupyter nbconvert --to notebook --execute ./jupyter/first-neo4j-tryout.ipynb
  ```

- Convert Notebook with executed cells to PDF

  ```shell
  jupyter nbconvert --to pdf ./jupyter/first-neo4j-tryout.nbconvert.ipynb
  ```

## References

- [Conda](https://conda.io)
- [jQAssistant](https://jqassistant.github.io/jqassistant/current)
- [Jupyter Notebook](https://jupyter.org)
- [Jupyter Notebook - Using as a command line tool](https://nbconvert.readthedocs.io/en/latest/usage.html)
- [Jupyter Notebook - Installing TeX for PDF conversion](https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex)
- [Jupyter Notebook Format - Metadata](https://ipython.readthedocs.io/en/3.x/notebook/nbformat.html#metadata)
- [Integrate Neo4j with Jupyter Notebook](https://medium.com/@technologydata25/connect-neo4j-to-jupyter-notebook-c178f716d6d5)
- [Hello World](https://nicolewhite.github.io/neo4j-jupyter/hello-world.html)
- [Managing environments with Conda](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
- [Neo4j - Download](https://neo4j.com/download-center)
- [Neo4j - HTTP API](https://neo4j.com/docs/http-api/current/query)
- [How to Use Conda With Github Actions](https://autobencoder.com/2020-08-24-conda-actions)
- [Older database download link (neo4j community)](https://community.neo4j.com/t/older-database-download-link/43334/9)

## Other Commands

### Information about a process that listens to a specific local port

```shell
ps -p $( lsof -t -i:7474 -sTCP:LISTEN )
```

### Kill process that listens to a specific local port

```shell
kill -9 $( lsof -t -i:7474 -sTCP:LISTEN )
```

### Memory Estimation

Reference: [Neo4j memory estimation](https://neo4j.com/docs/operations-manual/4.4/performance/memory-configuration)

```shell
NEO4J_HOME=tools/neo4j-community-4.4.20 tools/neo4j-community-4.4.20/bin/neo4j-admin memrec
```
