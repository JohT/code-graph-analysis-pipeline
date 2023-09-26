# Code Graph Analysis Pipeline - Commands

## Start an analysis

1. Create a directory for all analysis projects

    ```shell
    mkdir temp
    cd temp
    ```

1. Create a working directory for your specific analysis
  
    ```shell
    mkdir MyFirstAnalysis
    cd MyFirstAnalysis
    ```

1. Choose an initial password for Neo4j

    ```shell
    export NEO4J_INITIAL_PASSWORD=theinitialpasswordthatihavechosenforneo4j
    ```

1. Create the `artifacts` directory for the code to be analyzed (without `cd` afterwards)

    ```shell
    mkdir artifacts
    ```

1. Move the artifacts you want to analyze into the `artifacts` directory

1. Optionally run a predefined script to download artifacts

    ```shell
    ./../../scripts/downloader/downloadAxonFramework.sh <version>
    ```

1. Optionally use a script to download artifacts from Maven ([details](#download-maven-artifacts-to-analyze))

1. Start the analysis

    ```shell
    ./../../scripts/analysis/analyze.sh
    ```

👉 See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example script that combines all the above steps.  
👉 See [Code Structure Analysis Pipeline](./.github/workflows/code-structure-analysis.yml) on how to do this within a GitHub Actions Workflow.

### Command Line Options

The [analyze.sh](./scripts/analysis/analyze.sh) command comes with these command line options:

- `--report Csv` only generates CSV reports. This speeds up the report generation and doesn't depend on Python, Jupyter Notebook or any other related dependencies. The default value os `All` to generate all reports. `Jupiter` will only generate Jupyter Notebook reports. `DatabaseCsvExport` exports the whole graph database as a CSV file (performance intense, check if there are security concerns first).

- `--profile Neo4jv4` uses the older long term support (june 2023) version v4.4.x of Neo4j and suitable compatible versions of plugins and JQAssistant. `Neo4jv5` will explicitly select the newest (june 2023) version 5.x of Neo4j. Without setting
a profile, the newest versions will be used. Profiles are scripts that can be found in the directory [scripts/profiles](./scripts/profiles/).

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

#### Start an analysis without PDF generation

Generating a PDF from a Jupyter notebook using [nbconvert](https://nbconvert.readthedocs.io) might take a while or even fail due to a timeout error. Here is an example on how to skip PDF generation:

```shell
SKIP_JUPYTER_NOTEBOOK_PDF_GENERATION=true ./../../scripts/analysis/analyze.sh
```

#### Setup everything to explore the graph manually

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
which is included in the pipeline [code-structure-analysis.yml](.github/workflows/code-structure-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateCsvReportReference.sh
```

### Generate Jupyter Notebook Report Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateJupyterReportReference.sh](./scripts/documentation/generateJupyterReportReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [code-structure-analysis.yml](.github/workflows/code-structure-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateJupyterReportReference.sh
```

### Generate Image Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateImageReference.sh](./scripts/documentation/generateImageReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [code-structure-analysis.yml](.github/workflows/code-structure-analysis.yml) and doesn't need to be executed manually normally.

```script
./../scripts/documentation/generateImageReference.sh
```

### Generate Environment Variable Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh) with the following command:

```script
./documentation/generateEnvironmentVariableReference.sh
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

Use [setupJQAssistant.sh](./scripts/setupJQAssistant.sh) to download [jQAssistant](https://jqassistant.org/get-started).

### Download Maven Artifacts to analyze

Use [downloadMavenArtifact.sh](./scripts/downloadMavenArtifact.sh) with the following mandatory options
to download a Maven artifact into the artifacts directory:

- `-g <maven group id>`
- `-a <maven artifact name>`
- `-v <maven artifact version>`
- `-t <maven artifact type (optional, defaults to jar)>`
- `-d <target directory for the downloaded file (optional, defaults to "artifacts")>`

### Reset the database and scan the java artifacts

Use [resetAndScan.sh](./scripts/resetAndScan.sh) to scan the local `artifacts` directory with the previously downloaded Java artifacts and write the data into the local Neo4J Graph database using jQAssistant. It also uses some jQAssistant "concepts" to
enhance the data further with relationships between artifacts and packages.

Be aware that this script deletes all previous relationships and nodes in the local Neo4j Graph database.

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

### executeQueryFunctions

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

### Commands

- Setup environment

  ```shell
  conda create --name codegraph jupyter numpy matplotlib nbconvert nbconvert-webpdf
  conda activate codegraph
  ```

  or by using the environment file [codegraph-environment.yml](./jupyter/codegraph-environment.yml):

  ```shell
  conda env create --file ./jupyter/codegraph-environment.yml
  conda activate codegraph
  ```

- Export full environment.yml

  ```shell
  conda env export --name codegraph > full-codegraph-environment.yml
  ```

- Export only explicit environment.yml

  ```shell
  conda env export --from-history --name codegraph | grep -v "^prefix: " > codegraph-environment.yml
  ```

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

- Shell script to execute and convert a Jupyter notebook file
  
  Use [executeJupyterNotebook.sh](./scripts/executeJupyterNotebook.sh) like this:

  ```shell
  ./scripts/executeJupyterNotebook.sh ./jupyter/first-neo4j-tryout.ipynb
  ```

## References

- [Managing environments with Conda](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
- [Jupyter Notebook - Using as a command line tool](https://nbconvert.readthedocs.io/en/latest/usage.html)
- [Jupyter Notebook - Installing TeX for PDF conversion](https://nbconvert.readthedocs.io/en/latest/install.html#installing-tex)
- [Integrate Neo4j with Jupyter notebook](https://medium.com/@technologydata25/connect-neo4j-to-jupyter-notebook-c178f716d6d5)
- [Hello World](https://nicolewhite.github.io/neo4j-jupyter/hello-world.html)
- [py2neo](https://pypi.org/project/py2neo/)
- [The Py2neo Handbook](https://py2neo.org/2021.1/)
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
