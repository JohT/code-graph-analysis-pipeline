# Code Graph Analysis Pipeline

<img src="./images/DALL-E-Mini-Graph-Pipeline-Logo-2.png" align="left" hspace="10" width="180">

Contained within this repository is a comprehensive and automated code graph analysis pipeline. While initially designed to support Java through the utilization of [jQAssistant](https://jqassistant.org/get-started), it is open to extension for further programming languages. The graph database [Neo4j](https://neo4j.com) serves as the foundation for storing and querying the graph, which encompasses all the structural intricacies of the analyzed code. Additionally, Neo4j's [Graph Data Science](https://neo4j.com/product/graph-data-science) provides additional algorithms like community detection to analyze the code structure. The generated reports offer flexibility, ranging from simple query results presented as CSV files to more elaborate Jupyter Notebooks converted to Markdown or PDF formats.

---

## ✨ Features

- Analyze static code structure as a graph
- Fully automated [pipeline](./.github/workflows/code-structure-analysis.yml) from tool installation to report generation
- Comprehensive reports including dependencies, metrics and graph structure visualization
- Automated reference document generation
- Runtime and library independent automation using [shell scripts](./scripts/SCRIPTS.md)
- Comprehensive list of [Cypher queries](./cypher/CYPHER.md)
- Example analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

### 📖 Jupyter Notebook Reports

Here is an overview of reports made with [Jupyter Notebooks](https://jupyter.org). For a detailed reference see [Jupyter Notebook Report Reference](#📈-jupyter-notebook-report-reference) below.

- [External Dependencies](./results/AxonFramework-4.8.0/external-dependencies/ExternalDependencies.md) contains detailed information about external library usage ([Notebook](./jupyter/ExternalDependencies.ipynb))
- [Object Oriented Design Quality Metrics](./results/AxonFramework-4.8.0/object-oriented-design-metrics/ObjectOrientedDesignMetrics.md) is based on [OO Design Quality Metrics by Robert Martin](https://www.semanticscholar.org/paper/OO-Design-Quality-Metrics-Martin-October/18acd7eb21b918c8a5f619157f7e4f6d451d18f8) ([Notebook](./jupyter/ObjectOrientedDesignMetrics.ipynb))
- [Overview](./results/AxonFramework-4.8.0/overview/Overview.md) contains overall statistics and details about methods and their complexity. ([Notebook](./jupyter/Overview.ipynb))
- [Internal Dependencies](./results/AxonFramework-4.8.0/internal-dependencies/InternalDependencies.md) is based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html) including cyclic dependencies ([Notebook](./jupyter/InternalDependencies.ipynb))
- [Visibility Metrics](./results/AxonFramework-4.8.0/visibility-metrics/VisibilityMetrics.md) is based on [Visibility Metrics and the Importance of Hiding Things](https://dzone.com/articles/visibility-metrics-and-the-importance-of-hiding-th) ([Notebook](./jupyter/VisibilityMetrics.ipynb))
- [Wordcloud](./results/AxonFramework-4.8.0/wordcloud/Wordcloud.md) contains a visual representation of package and class names ([Notebook](./jupyter/Wordcloud.ipynb))

### 📖 Graph Data Science Reports

Here are some reports that utilize Neo4j's [Graph Data Science Library](https://neo4j.com/product/graph-data-science). For a detailed reference of all CSV reports see [CSV Cypher Query Report Reference](#📃-csv-cypher-query-report-reference) below. 

- [Community Detection with Leiden](./results/AxonFramework-4.8.0/community-csv/Leiden_Communities.csv) ([Source Script](./scripts/reports/CommunityCsv.sh))
- [Centrality with Page Rank](./results/AxonFramework-4.8.0/centrality-csv/Centrality_Page_Rank.csv) ([Source Script](./scripts/reports/CentralityCsv.sh))
- [Similarity with Jaccard](./results/AxonFramework-4.8.0/similarity-csv/Similarity_Jaccard.csv) ([Source Script](./scripts/reports/SimilarityCsv.sh))

## 🛠 Prerequisites

- Java 17 is [required for Neo4j](https://neo4j.com/docs/operations-manual/current/installation/requirements/#deployment-requirements-software) (Neo4j 5.x requirement).
- On Windows it is recommended to use the git bash provided by [git for windows](https://gitforwindows.org).
- [jq](https://github.com/jqlang/jq) the "lightweight and flexible command-line JSON processor" needs to be installed. Latest releases: https://github.com/jqlang/jq/releases/latest. Check using `jq --version`.
- Set environment variable `NEO4J_INITIAL_PASSWORD` to a password of your choice. For example:
  ```shell
  export NEO4J_INITIAL_PASSWORD=neo4j_password_of_my_choice
  ```
  To run Jupyter notebooks, create an `.env` file in the folder from where you open the notebook containing for example: `NEO4J_INITIAL_PASSWORD=neo4j_password_of_my_choice`

### Further Prerequisites for Python and Jupyter Notebooks

- Python is required for Jupyter Notebook reports.
- A conda package manager like [Miniconda](https://docs.conda.io/projects/miniconda/en/latest) or [Anaconda](https://www.anaconda.com/download)(Recommended for Windows) is required for Jupyter Notebook reports.
- Chromium will automatically be downloaded if needed for Jupyter Notebook PDF reports generation.

### Further Prerequisites for Graph Visualization

These tools are needed to run the graph visualization scripts of directory [graph-visualization](./graph-visualization):

- [Node.js](https://nodejs.org/en)
- [npm](https://www.npmjs.com)

### Hints for Windows

- Add this line to your `~/.bashrc` file if you are using Anaconda3: `/c/ProgramData/Anaconda3/etc/profile.d/conda.sh`. Try to find a similar script for other conda package managers or versions.
- Run `conda init` in the git bash opened as administrator. Running it in normal mode usually leads to an error message.

## 🚀 Getting Started

See [GETTING_STARTED.md](./GETTING_STARTED.md) on how to get started on your local machine.

## 🏗 Pipeline and Tools

The [Code Structure Analysis Pipeline](./.github/workflows/code-structure-analysis.yml) utilizes [GitHub Actions](https://docs.github.com/de/actions) to automate the whole analysis process:

- Use [GitHub Actions](https://docs.github.com/de/actions) Linux Runner
- [Checkout GIT Repository](https://github.com/actions/checkout)
- [Setup Java](https://github.com/actions/setup-java)
- [Setup Python with Conda](https://github.com/conda-incubator/setup-miniconda) package manager [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge)
- Download artifacts that contain the code to be analyzed [scripts/artifacts](./scripts/downloader/)
- Setup [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Setup [jQAssistant](https://jqassistant.org/get-started) for Java Analysis ([analysis.sh](./scripts/analysis/analyze.sh))
- Start [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Generate CSV Reports [scripts/reports](./scripts/reports) using the command line JSON parser [jq](https://jqlang.github.io/jq)
- Generate [Jupyter Notebook](https://jupyter.org) reports using these libraries specified in the [environment.yml](./jupyter/environment.yml):
  - [Python](https://www.python.org)
  - [jupyter](https://jupyter.org)
  - [matplotlib](https://matplotlib.org)
  - [nbconvert](https://nbconvert.readthedocs.io)
  - [numpy](https://numpy.org)
  - [pandas](https://pandas.pydata.org)
  - [pip](https://pip.pypa.io/en/stable)
  - [monotonic](https://github.com/atdt/monotonic)
  - [py2neo](https://py2neo.org)
  - [wordcloud](https://github.com/amueller/word_cloud)
- [Graph Visualization](./graph-visualization/README.md) uses [node.js](https://nodejs.org/de) and the dependencies listed in [package.json](./graph-visualization/package.json).

**Big shout-out** 📣 to all the creators and contributors of these great libraries 👍. Projects like this wouldn't be possible without them. Feel free to [create an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new/choose) if i've forgotten something in the list. 

## 🛠 Command Reference

[COMMANDS.md](./COMMANDS.md) contains further details on commands and how to do a manual setup.

## 📃 CSV Cypher Query Report Reference

[CSV_REPORTS.md](./results/CSV_REPORTS.md) lists all CSV Cypher query result reports inside the [results](./results) directory. It can be generated as described in [Generate CSV Report Reference](./COMMANDS.md#generate-csv-cypher-query-report-reference).

## 📈 Jupyter Notebook Report Reference

[JUPYTER_REPORTS.md](./results/JUPYTER_REPORTS.md) lists all Jupyter Notebook reports inside the [results](./results) directory. It can be generated as described in [Generate Jupyter Notebook Report Reference](./COMMANDS.md#generate-jupyter-notebook-report-reference).

## 📈 Image Reference

[IMAGES.md](./results/IMAGES.md) lists all PNG images inside the [results](./results) directory. It can be generated as described in [Generate Image Reference](./COMMANDS.md#generate-image-reference).

## ⚙️ Script Reference

[SCRIPTS.md](./scripts/SCRIPTS.md) lists all shell scripts of this repository including their first comment line as a description. It can be generated as described in [Generate Script Reference](./COMMANDS.md#generate-script-reference).

## 🔎 Cypher Query Reference

[CYPHER.md](./cypher/CYPHER.md) lists all Cypher queries of this repository including their first comment line as a description. It can be generated as described in [Generate Cypher Reference](./COMMANDS.md#generate-cypher-reference).
> [Cypher](https://neo4j.com/docs/getting-started/cypher-intro) is Neo4j’s graph query language that lets you retrieve data from the graph.

## ⚙️ Environment Variable Reference

[ENVIRONMENT_VARIABLES.md](./scripts/ENVIRONMENT_VARIABLES.md) contains all environment variables that are supported by the scripts including default values and description. It can be generated as described in [Generate Environment Variable Reference](./COMMANDS.md#generate-environment-variable-reference).

## 🤔 Questions & Answers

- How can i run an analysis locally?  
  👉 See [Start an analysis](./COMMANDS.md#start-an-analysis) in the [Commands Reference](./COMMANDS.md).

- How can i add a CSV report to the pipeline?  
  👉 Put your new cypher query into the [cypher](./cypher) directory or a suitable (new) sub directory.  
  👉 Create a new CSV report script in the [scripts/reports](./scripts/reports/) directory. Take for example [OverviewCsv.sh](./scripts/reports/OverviewCsv.sh) as a reference.  
  👉 The script will automatically be included because of the directory and its name ending with "Csv.sh".

- How can i add a Jupyter Notebook report to the pipeline?  
  👉 Put your new notebook into the [jupyter](./jupyter) directory.  
  👉 Create a new Jupyter report script in the [scripts/reports](./scripts/reports/) directory. Take [OverviewJupyter.sh](./scripts/reports/OverviewJupyter.sh) as a reference for example.  
  👉 The script will automatically be included because of the directory and its name ending with "Jupyter.sh".

- How can i add another code basis to be analyzed automatically?  
  👉 Create a new artifacts download script in the [scripts/downloader](./scripts/downloader/) directory. Take for example [downloadAxonFramework.sh](./scripts/downloader/downloadAxonFramework.sh) as a reference.  
  👉 Run the script separately before executing [analyze.sh](./scripts/analysis/analyze.sh) also in the [pipeline](./.github/workflows/code-structure-analysis.yml).

- How can i trigger a full rescan of all artifacts?  
  👉 Delete the file `artifactsChangeDetectionHash.txt` in the `artifacts` directory.

- How can PDF generation for Jupyter Notebooks be enabled (depends on chromium, takes more time)?  
  👉 Set environment variable `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` to anything except an empty string. Example:  

  ```shell
  export ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION="true"
  ```

  👉 Alternatively prepend your command with `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION="true"` like:  
  
  ```shell
  ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION=true ./../../scripts/analysis/analyze.sh
  ```
