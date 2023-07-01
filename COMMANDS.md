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

<span style="font-size:1.8em;">&#128214;</span>
See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example for all the above steps. See [code-reports Pipeline](./.github/workflows/code-reports.yml) on how to do this within a GitHub Actions Workflow.

<span style="font-size:1.6em;">&#9432;</span>
Add the command line argument `--report Csv` of [analyze.sh](./scripts/analysis/analyze.sh) to only generate CSV reports. This speeds up the report generation and doesn't depend on Python, Jupyter Notebook or any other related dependencies.

<span style="font-size:1.6em;">&#9432;</span>
Add the command line argument `--profile Neo4jv4` of [analyze.sh](./scripts/analysis/analyze.sh) if you want to use the older long term support (june 2023) version v4.4.x of Neo4j and compatible versions of plugins and JQAssistant.

### Notes

- Be sure to use Java 17 for Neo4j v5 and Java 11 for Neo4j v4
- Use your own initial Neo4j password
- For more details have a look at the script [analyze.sh](./scripts/analysis/analyze.sh)

Have a look at [code-reports.yml](./.github/workflows/code-reports.yml) for all details about setup steps and full automation.

## Generate Markdown References

### Update Cypher Reference

Change into the [cypher](./cypher/) directory e.g. with `cd cypher` and then execute the script [generateCypherReference.sh](./scripts/generateCypherReference.sh) with the following command:

```script
./../scripts/generateCypherReference.sh
```

### Update Script Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateScriptReference.sh](./scripts/generateScriptReference.sh) with the following command:

```script
./../scripts/generateScriptReference.sh
```

### Update Markdown Reference

Change into the [results](./results/) directory e.g. with `cd results` and then execute the script [generateMarkdownReference.sh](./scripts/generateMarkdownReference.sh) with the following command:

👉**Note:** This script is automatically triggered at the end of [copyReportsIntoResults.sh](./scripts/copyReportsIntoResults.sh)
which is included in the pipeline [code-reports.yml](.github/workflows/code-reports.yml) and doesn't need to be executed manually normally.


```script
./../scripts/generateScriptReference.sh
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

### HTTP API

Use [executeQuery.sh](./scripts/executeQuery.sh) to execute a Cypher query from the file given as an argument.
It uses `curl` and `jq` to access the HTTP API of Neo4j.
Here is an example:

```shell
./scripts/executeQuery.sh ./cypher/Get_Graph_Data_Science_Library_Version.cypher
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
