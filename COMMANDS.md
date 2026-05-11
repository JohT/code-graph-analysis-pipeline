# Code Graph Analysis Pipeline - Commands

<!-- TOC -->

- [Start an Analysis](#start-an-analysis)
    - [Command Line Options](#command-line-options)
    - [Notes](#notes)
    - [Examples](#examples)
        - [Start an analysis with CSV reports only](#start-an-analysis-with-csv-reports-only)
        - [Start an analysis with Python reports only](#start-an-analysis-with-python-reports-only)
        - [Start an analysis without importing git log data](#start-an-analysis-without-importing-git-log-data)
        - [Only run setup and explore the Graph manually](#only-run-setup-and-explore-the-graph-manually)
        - [Only run the reports of one specific domain](#only-run-the-reports-of-one-specific-domain)
        - [Only run the CSV reports of one specific domain](#only-run-the-csv-reports-of-one-specific-domain)
        - [Rerun reports without restarting Neo4j](#rerun-reports-without-restarting-neo4j)
        - [Run all reports except slow/optional domains](#run-all-reports-except-slowoptional-domains)
        - [Run all domains except specific ones](#run-all-domains-except-specific-ones)
- [Generate Markdown References](#generate-markdown-references)
    - [Generate Cypher Reference](#generate-cypher-reference)
    - [Generate Script Reference](#generate-script-reference)
    - [Generate Environment Variable Reference](#generate-environment-variable-reference)
- [Validate Links in Markdown](#validate-links-in-markdown)
- [Manual Setup](#manual-setup)
    - [Setup Neo4j Graph Database](#setup-neo4j-graph-database)
    - [Change Neo4j configuration template](#change-neo4j-configuration-template)
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
- [References](#references)
- [Other Commands](#other-commands)
    - [Information about a process that listens to a specific local port](#information-about-a-process-that-listens-to-a-specific-local-port)
    - [Kill process that listens to a specific local port](#kill-process-that-listens-to-a-specific-local-port)
    - [Memory Estimation](#memory-estimation)

<!-- /TOC -->

## Start an Analysis

Before starting an analysis, setup your analysis as described in the [Getting Started](./GETTING_STARTED.md) guide.
An analysis is then started with the script [analyze.sh](./scripts/analysis/analyze.sh).
To run all analysis steps simple execute the following command:

```shell
./../../scripts/analysis/analyze.sh
```

**Hint:** Within the analysis workspace directory you can simply run `analyze.sh` directly without the `../../` prefix since the script is also available in the analysis workspace.

👉 See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example script that combines all the above steps for a Java Project.
👉 See [scripts/examples/analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh) as an example script that combines all the above steps for a Typescript Project.  
👉 See [Code Structure Analysis Pipeline](./.github/workflows/internal-java-code-analysis.yml) on how to do this within a GitHub Actions Workflow.

### Command Line Options

The [analyze.sh](./scripts/analysis/analyze.sh) command comes with these command line options:

- `--report Csv` only generates CSV reports. This speeds up the report generation and doesn't depend on Python or any other related dependencies. The default value is `All` to generate all reports. `DatabaseCsvExport` exports the whole graph database as a CSV file (performance intense, check if there are security concerns first).

- `--profile Neo4jv4` uses the older long term support (june 2023) version v4.4.x of Neo4j and suitable compatible versions of plugins and JQAssistant. Without specifying a profile, the newest versions will be used. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4jv5` uses the older long term support (march 2025) version v5.26.x of Neo4j and suitable compatible versions of plugins and JQAssistant. Without specifying a profile, the newest versions will be used. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4j-latest-continue-on-scan-errors` is based on the default profile (`Neo4j-latest`) but uses the jQAssistant configuration template [template-neo4jv5-jqassistant-continue-on-error.yaml](./scripts/configuration/template-neo4jv5-jqassistant-continue-on-error.yaml) to continue on scan error instead of failing fast. This is temporarily useful when there is a known error that needs to be ignored. It is still recommended to use the default profile and fail fast if there is something wrong. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4j-latest-low-memory` is based on the default profile (`Neo4j-latest`) but uses only half of the memory (RAM) as configured in [template-neo4j-low-memory.conf](./domains/neo4j-management/configuration/template-neo4j-low-memory.conf). This is useful for the analysis of smaller codebases with less resources. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4j-latest-low-memory-continue-on-scan-errors` is based on the default profile (`Neo4j-latest`) but uses only half of the memory (RAM) as configured in [template-neo4j-low-memory.conf](./domains/neo4j-management/configuration/template-neo4j-low-memory.conf) and the jQAssistant configuration template [template-neo4jv5-jqassistant-continue-on-error.yaml](./scripts/configuration/template-neo4jv5-jqassistant-continue-on-error.yaml) to continue on scan error instead of failing fast. This is temporarily useful when there is a known error that needs to be ignored. It is still recommended to use the default profile and fail fast if there is something wrong. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--profile Neo4j-latest-high-memory` is based on the default profile (`Neo4j-latest`) but uses more memory (RAM) as configured in [template-neo4j-high-memory.conf](./domains/neo4j-management/configuration/template-neo4j-high-memory.conf). This is useful for the analysis of larger codebases with more resources. Other profiles can be found in the directory [scripts/profiles](./scripts/profiles/).

- `--explore` activates the "explore" mode where no reports are generated. Furthermore, Neo4j won't be stopped at the end of the script and will therefore continue running.  This makes it easy to just set everything up but then use the running Neo4j server to explore the data manually.

- `--keep-running` skips the Neo4j stop step at the end of the script. Neo4j keeps running after analysis completes. Useful when running reports repeatedly (e.g. during development) to avoid the overhead of stopping and restarting Neo4j each time. Note: `--explore` implies `--keep-running`; combining both is redundant.

- `--domain anomaly-detection` selects a single analysis domain (a subdirectory of [domains/](./domains/)) to run reports for, following a vertical-slice approach. When set, only that domain's report scripts run; core reports from `scripts/reports/` and other domains are skipped. The domain option composes with `--report` to further narrow down which reports are generated, e.g. `--domain anomaly-detection --report Csv`. When not specified, all domains and reports run unchanged. The selected domain name is passed to report compilation scripts via the environment variable `ANALYSIS_DOMAIN`. Available domains can be found in the [domains/](./domains/) directory.

- `--exclude-domain anomaly-detection,node-embeddings` specifies a comma-separated list of domain names to skip during report generation. By default (when neither `--domain` nor `--exclude-domain` is set), slow/optional domains are skipped: `anomaly-detection`, `node-embeddings`, and `graph-algorithms`. When `--domain` is specified, no domains are excluded by default (only the selected domain runs). Pass an empty string `--exclude-domain ""` to override defaults and skip nothing. The domain names must match subdirectories under [domains/](./domains/). Unrecognized domains are warned about but do not cause errors. The list is exported as the environment variable `ANALYSIS_DOMAINS_TO_SKIP` to all report compilation scripts.

### Notes

- Be sure to use Java 21 for Neo4j v2025, Java 17 for v5 and Java 11 for v4. Details see [Neo4j System Requirements / Java](https://neo4j.com/docs/operations-manual/current/installation/requirements/#deployment-requirements-java).
- Use your own initial Neo4j password
- For more details have a look at the script [analyze.sh](./scripts/analysis/analyze.sh)

### Examples

#### Start an analysis with CSV reports only

If only the CSV reports are needed, that are the result of Cypher queries and don't need any further dependencies (like Python)
the analysis can be speeded up with:

```shell
./../../scripts/analysis/analyze.sh --report Csv
```

#### Start an analysis with Python reports only

If you only need Python reports, e.g. to get expressive charts, you can run the Python reports independently with:

```shell
./../../scripts/analysis/analyze.sh --report Python
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

#### Only run the reports of one specific domain

To only run the reports of a single analysis domain (vertical slice, no additional Python or Node.js dependencies for core reports):

```shell
./../../scripts/analysis/analyze.sh --domain anomaly-detection
```

#### Only run the CSV reports of one specific domain

To further narrow down to only one report type within a specific domain:

```shell
./../../scripts/analysis/analyze.sh --domain anomaly-detection --report Csv
```

#### Rerun reports without restarting Neo4j

When iterating on reports during development, use `--keep-running` to skip the Neo4j stop step and avoid the overhead of restarting it on the next run:

```shell
./../../scripts/analysis/analyze.sh --domain git-history --report Csv --keep-running
```

#### Run all reports except slow/optional domains

To run analysis with all domains enabled (overriding the default exclusions of anomaly-detection, node-embeddings, and graph-algorithms):

```shell
./../../scripts/analysis/analyze.sh --exclude-domain ""
```

#### Run all domains except specific ones

To skip specific domains during analysis (e.g., skip anomaly-detection and node-embeddings but run everything else):

```shell
./../../scripts/analysis/analyze.sh --exclude-domain "anomaly-detection,node-embeddings"
```

## Generate Markdown References

### Generate Cypher Reference

Execute the script [generateCypherReference.sh](./scripts/documentation/generateCypherReference.sh) from the root directory with the following command:

```script
./scripts/documentation/generateCypherReference.sh
```

### Generate Script Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateScriptReference.sh](./scripts/documentation/generateScriptReference.sh) with the following command:

```script
./documentation/generateScriptReference.sh
```

### Generate Environment Variable Reference

Change into the [scripts](./scripts/) directory e.g. with `cd scripts` and then execute the script [generateEnvironmentVariableReference.sh](./scripts/documentation/generateEnvironmentVariableReference.sh) with the following command:

```script
./documentation/generateEnvironmentVariableReference.sh
```

## Validate Links in Markdown

The following command shows how to use [markdown-link-check](https://github.com/tcort/markdown-link-check) to for example check the links in the [README.md](./README.md) file:

```script
npx --yes markdown-link-check --quiet --progress --config=markdown-lint-check-config.json README.md COMMANDS.md GETTING_STARTED.md INTEGRATION.md CHANGELOG.md
```

## Manual Setup

The manual setup is only documented for completeness. It isn't needed since the analysis also covers download, installation and configuration of all needed tools.

If any of the script are not allowed to be executed use `chmod +x ./scripts/` followed by the script file name to grant execution.

### Setup Python Environment with uv (default)

[uv](https://docs.astral.sh/uv/) is the default Python package manager. Install it once:

```shell
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then sync all dependencies from `pyproject.toml` into a local `.venv`:

```shell
uv sync --frozen
```

To verify the lockfile is consistent with `pyproject.toml`:

```shell
uv lock --check
```

### Setup Python Environment with Conda (optional)

Set `PYTHON_PACKAGE_MANAGER=conda` to use Conda instead of uv. Create and activate the environment manually:

```shell
conda env update --file conda-environment.yml --prune
conda activate codegraph
```

### Setup Neo4j Graph Database

Use [setupNeo4j.sh](./domains/neo4j-management/setupNeo4j.sh) to download [Neo4j](https://neo4j.com/download-center) and install the plugins [APOC](https://neo4j.com/labs/apoc/4.4) and [Graph Data Science](https://neo4j.com/product/graph-data-science).
This script requires the environment variable NEO4J_INITIAL_PASSWORD to be set. It sets the initial password with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

### Change Neo4j configuration template

Use [configureNeo4j.sh](./domains/neo4j-management/configureNeo4j.sh) to apply a different Neo4j configuration template from the [domains/neo4j-management/configuration](./domains/neo4j-management/configuration/) directory. This can be useful to optimize Neo4j for different workloads. Example:

```shell
NEO4J_CONFIG_TEMPLATE=template-neo4j-high-memory.conf ./domains/neo4j-management/configureNeo4j.sh
```

**Hint:** In case you want to switch to the high memory profile as in the example, there is a simpler solution. Just run `useNeo4jHighMemoryProfile.sh` from the analysis workspace directory which will set the environment variable `NEO4J_CONFIG_TEMPLATE` and run `configureNeo4j.sh` for you.

### Start Neo4j Graph Database

Use [startNeo4j.sh](./domains/neo4j-management/startNeo4j.sh) to start the locally installed [Neo4j](https://neo4j.com/download-center) Graph database.
It runs the script with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

**Hint:** Within the analysis workspace directory you can simply run `startNeo4j.sh` directly without the `../../` prefix since the script is also available in the analysis workspace.

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

Use [importGit.sh](./domains/git-history/import/importGit.sh) to import git data into the Graph.
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
IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated" ./../../domains/git-history/import/importGit.sh
```

Here is the resulting schema:

```Cypher
(Git:Log:Author)-[:AUTHORED]->(Git:Log:ChangeSpan)-[:CONTAINS_CHANGED]->(Git:Log:File)
(Git:Repository)-[:HAS_CHANGE_SPAN]->(Git:Log:ChangeSpan)
(Git:Repository)-[:HAS_AUTHOR]->(Git:Log:Author)
(Git:Repository)-[:HAS_FILE]->(Git:Log:File)
```

#### Parameter

The optional parameter `--source directory-path-to-the-source-folder-containing-git-repositories` can be used to select a different directory for the repositories. By default, the `source` directory within the analysis workspace directory is used. This command only needs the git history to be present. Therefore, `git clone --bare` is sufficient. If the `source` directory is also used for code analysis (like for Typescript) then a full git clone is of course needed. Additionally, if you want to focus on a specific version or branch, use `--branch branch-name` to checkout the branch and `--single-branch` to exclude other branches before importing the git log data.

#### Environment Variable

- `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` supports the values `none`, `aggregated`, `full` and `plugin` (default). With it, you can switch off git import (`none`), import aggregated data for a smaller memory footprint (`aggregated`), import all commits with git log in a simple way (`full`) or let a plugin take care of git data (`plugin`= `""`=default) .

#### Resolving git files to code files

After git log data has been imported successfully, [Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher](./domains/git-history/queries/enrichment/Add_RESOLVES_TO_relationships_to_git_files_for_Java.cypher) is used to try to resolve the imported git file names to  code files. This first attempt will cover most cases, but not all of them. With this approach it is, for example, not possible to distinguish identical file names in different Java jars from the git source files of a mono repo.

You can use [List_unresolved_git_files.cypher](./domains/git-history/queries/statistics/List_unresolved_git_files.cypher) to find code files that couldn't be matched to git file names and [List_ambiguous_git_files.cypher](./domains/git-history/queries/statistics/List_ambiguous_git_files.cypher) to find ambiguously resolved git files. If you have any idea on how to improve this feel free to [open an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new).

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

Use [stopNeo4j.sh](./domains/neo4j-management/stopNeo4j.sh) to stop the locally running Neo4j Graph Database. It does nothing if the database is already stopped. It runs the script with a temporary `NEO4J_HOME` environment variable to not interfere with a possibly globally installed Neo4j installation.

**Hint:** Within the analysis workspace directory you can run `stopNeo4j.sh` directly without the `../../` prefix since the script is also directly available in the analysis workspace.

## References

- [uv - Python package manager](https://docs.astral.sh/uv/)
- [uv - Installation](https://docs.astral.sh/uv/getting-started/installation/)
- [Conda](https://conda.io)
- [jQAssistant](https://jqassistant.github.io/jqassistant/current)
- [Bite-Sized Neo4j for Data Scientists](https://neo4j.com/video/bite-sized-neo4j-for-data-scientists)
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
