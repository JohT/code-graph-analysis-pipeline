# Code Graph Analysis Pipeline

<img src="./images/DALL-E-Mini-Graph-Pipeline-Logo-2.png" align="left" hspace="10" width="180">

Contained within this repository is a comprehensive and automated code graph analysis pipeline. While initially designed to support Java through the utilization of [jQAssistant](https://jqassistant.github.io/jqassistant/doc), it now also [supports Typescript](https://github.com/jqassistant-plugin/jqassistant-typescript-plugin) and is open to extension for further programming languages. The graph database [Neo4j](https://neo4j.com) serves as the foundation for storing and querying the graph, which encompasses all the structural intricacies of the analyzed code. Additionally, Neo4j's [Graph Data Science](https://neo4j.com/product/graph-data-science) provides additional algorithms like community detection to analyze the code structure. The generated reports offer flexibility, ranging from simple query results presented as CSV files to more elaborate Jupyter Notebooks converted to Markdown or PDF formats.

---

## :sparkles: Features

- Analyze static code structure as a graph
- **🌟New🌟:** Also supports Typescript
- Fully automated [pipeline for Java](./.github/workflows/java-code-analysis.yml) from tool installation to report generation
- Fully automated [pipeline for Typescript](./.github/workflows/typescript-code-analysis.yml) from tool installation to report generation
- Fully automated [local run](./GETTING_STARTED.md)
- More than 130 CSV reports for dependencies, metrics, cycles, annotations, algorithms and many more
- Jupyter notebook reports for dependencies, metrics, visibility and many more
- Graph structure visualization
- Automated reference document generation
- Runtime and library independent automation using [shell scripts](./scripts/SCRIPTS.md)
- Tested on MacOS (zsh), Linux (bash) and Windows (Git Bash)
- Comprehensive list of [Cypher queries](./cypher/CYPHER.md)
- Example analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

### :book: Jupyter Notebook Reports

Here is an overview of reports made with [Jupyter Notebooks](https://jupyter.org). For a detailed reference see [Jupyter Notebook Report Reference](#page_with_curl-jupyter-notebook-report-reference

- [External Dependencies](./results/AxonFramework-4.9.3/external-dependencies-java/ExternalDependenciesJava.md) contains detailed information about external library usage ([Notebook](./jupyter/ExternalDependenciesJava.ipynb)).
- [Internal Dependencies](./results/AxonFramework-4.9.3/internal-dependencies-java/InternalDependenciesJava.md) is based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html) and also includes cyclic dependencies ([Notebook](./jupyter/InternalDependenciesJava.ipynb)).
- [Method Metrics](./results/AxonFramework-4.9.3/method-metrics-java/MethodMetricsJava.md)  shows how the effective number of lines of code and the cyclomatic complexity are distributed across the methods in the code ([Notebook](./jupyter/MethodMetricsJava.ipynb)).
- [Node Embeddings](./results/AxonFramework-4.9.3/node-embeddings-java/NodeEmbeddingsJava.md) shows how to generate node embeddings and to further reduce their dimensionality to be able to visualize them in a 2D plot ([Notebook](./jupyter/NodeEmbeddingsJava.ipynb)).
- [Object Oriented Design Quality Metrics](./results/AxonFramework-4.9.3/object-oriented-design-metrics-java/ObjectOrientedDesignMetricsJava.md) is based on [OO Design Quality Metrics by Robert Martin](https://api.semanticscholar.org/CorpusID:18246616) ([Notebook](./jupyter/ObjectOrientedDesignMetricsJava.ipynb)).
- [Overview](./results/AxonFramework-4.9.3/overview-java/OverviewJava.md) contains overall statistics and details about methods and their complexity. ([Notebook](./jupyter/OverviewJava.ipynb)).
- [Visibility Metrics](./results/AxonFramework-4.9.3/visibility-metrics-java/VisibilityMetricsJava.md) ([Notebook](./jupyter/VisibilityMetricsJava.ipynb)).
- [Wordcloud](./results/AxonFramework-4.9.3/wordcloud/Wordcloud.md) contains a visual representation of package and class names ([Notebook](./jupyter/Wordcloud.ipynb)).

### :book: Graph Data Science Reports

Here are some reports that utilize Neo4j's [Graph Data Science Library](https://neo4j.com/product/graph-data-science). For a detailed reference of all CSV reports see [CSV Cypher Query Report Reference](#page_with_curl-csv-cypher-query-report-reference)

- [Centrality with Page Rank](./results/AxonFramework-4.9.3/centrality-csv/Package_Centrality_Page_Rank.csv) ([Source Script](./scripts/reports/CentralityCsv.sh))
- [Community Detection with Leiden](./results/AxonFramework-4.9.3/community-csv/Package_communityLeidenId_Community__Metrics.csv) ([Source Script](./scripts/reports/CommunityCsv.sh))
- [Node Embeddings with HashGNN](./results/AxonFramework-4.9.3/node-embeddings-csv/Package_Embeddings_HashGNN.csv) ([Source Script](./scripts/reports/NodeEmbeddingsCsv.sh))
- [Similarity with Jaccard](./results/AxonFramework-4.9.3/similarity-csv/Package_Similarity.csv) ([Source Script](./scripts/reports/SimilarityCsv.sh))
- [Topology Sort](./results/AxonFramework-4.9.3/topology-csv/Package_Topological_Sort.csv) ([Source Script](./scripts/reports/TopologicalSortCsv.sh))

## :book: Blog Articles

- [Analyze java dependencies with jQAssistant](https://joht.github.io/johtizen/data/2021/02/21/java-jar-dependency-analysis.html)
- [Analyze java package metrics in a graph database (Part 2)](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)

## :hammer_and_wrench: Prerequisites

- Java 17 is [required for Neo4j](https://neo4j.com/docs/operations-manual/current/installation/requirements/#deployment-requirements-software) (Neo4j 5.x requirement).
- On Windows it is recommended to use the git bash provided by [git for windows](https://github.com/git-guides/install-git#install-git-on-windows).
- [jq](https://github.com/jqlang/jq) the "lightweight and flexible command-line JSON processor" needs to be installed. Latest releases: https://github.com/jqlang/jq/releases/latest. Check using `jq --version`.
- Set environment variable `NEO4J_INITIAL_PASSWORD` to a password of your choice. For example:

  ```shell
  export NEO4J_INITIAL_PASSWORD=neo4j_password_of_my_choice
  ```

  To run Jupyter notebooks, create an `.env` file in the folder from where you open the notebook containing for example: `NEO4J_INITIAL_PASSWORD=neo4j_password_of_my_choice`

### Additional Prerequisites for Python and Jupyter Notebooks

- Python is required for Jupyter Notebook reports.
- A conda package manager like [Miniconda](https://docs.conda.io/projects/miniconda/en/latest) or [Anaconda](https://www.anaconda.com/download)(Recommended for Windows) is required for Jupyter Notebook reports.
- Chromium will automatically be downloaded if needed for Jupyter Notebook PDF reports generation.

### Additional Prerequisites for Graph Visualization

These tools are needed to run the graph visualization scripts of directory [graph-visualization](./graph-visualization):

- [Node.js](https://nodejs.org/en)
- [npm](https://www.npmjs.com)

### Additional Prerequisites for Windows

- Add this line to your `~/.bashrc` file if you are using Anaconda3: `/c/ProgramData/Anaconda3/etc/profile.d/conda.sh`. Try to find a similar script for other conda package managers or versions.
- Run `conda init` in the git bash opened as administrator. Running it in normal mode usually leads to an error message.

### Additional Prerequisites for analyzing Typescript

- Please follow the description on how to create a json file with the static code information
of your Typescript project here: https://github.com/jqassistant-plugin/jqassistant-typescript-plugin  
This could be as simple as running the following command in your Typescript project:

  ```shell
  npx --yes @jqassistant/ts-lce
  ```

- It is recommended to put the cloned source code repository into a directory called `source` within the analysis workspace so that it will also be picked up to import git log data.

- Copy the resulting json file (e.g. `.reports/jqa/ts-output.json`) into the `artifacts/typescript` directory for your analysis work directory. Create the directory, if it doesn't exists. Custom subdirectories within `artifacts/typescript` are also supported.

## :rocket: Getting Started

See [GETTING_STARTED.md](./GETTING_STARTED.md) on how to get started on your local machine.

## :building_construction: Pipeline and Tools

The [Code Structure Analysis Pipeline](./.github/workflows/java-code-analysis.yml) utilizes [GitHub Actions](https://docs.github.com/de/actions) to automate the whole analysis process:

- Use [GitHub Actions](https://docs.github.com/de/actions) Linux Runner
- [Checkout GIT Repository](https://github.com/actions/checkout)
- [Setup Java](https://github.com/actions/setup-java)
- [Setup Python with Conda](https://github.com/conda-incubator/setup-miniconda) package manager [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge)
- Download artifacts and optionally source code that contain the code to be analyzed [scripts/downloader](./scripts/downloader)
- Setup [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Setup [jQAssistant](https://jqassistant.github.io/jqassistant/doc) for Java and [Typescript](https://github.com/jqassistant-plugin/jqassistant-typescript-plugin) analysis ([analysis.sh](./scripts/analysis/analyze.sh))
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
  - [Neo4j Python Driver](https://neo4j.com/docs/api/python-driver)
  - [openTSNE](https://github.com/pavlin-policar/openTSNE)
  - [wordcloud](https://github.com/amueller/word_cloud)
- [Graph Visualization](./graph-visualization/README.md) uses [node.js](https://nodejs.org/de) and the dependencies listed in [package.json](./graph-visualization/package.json).
- [Check links in markdown documentation (GitHub workflow)](./.github/workflows/check-links-in-documentation.yml) uses [markdown-link-check](https://github.com/tcort/markdown-link-check).

**Big shout-out** 📣 to all the creators and contributors of these great libraries 👍. Projects like this wouldn't be possible without them. Feel free to [create an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new/choose) if something is missing or wrong in the list.

## :runner: Command Reference

[COMMANDS.md](./COMMANDS.md) contains further details on commands and how to do a manual setup.

## :page_with_curl: CSV Cypher Query Report Reference

[CSV_REPORTS.md](./results/CSV_REPORTS.md) lists all CSV Cypher query result reports inside the [results](./results) directory. It can be generated as described in [Generate CSV Report Reference](./COMMANDS.md#generate-csv-cypher-query-report-reference).

## :page_with_curl: Jupyter Notebook Report Reference

[JUPYTER_REPORTS.md](./results/JUPYTER_REPORTS.md) lists all Jupyter Notebook reports inside the [results](./results) directory. It can be generated as described in [Generate Jupyter Notebook Report Reference](./COMMANDS.md#generate-jupyter-notebook-report-reference).

## :camera: Image Reference

[IMAGES.md](./results/IMAGES.md) lists all PNG images inside the [results](./results) directory. It can be generated as described in [Generate Image Reference](./COMMANDS.md#generate-image-reference).

## :gear: Script Reference

[SCRIPTS.md](./scripts/SCRIPTS.md) lists all shell scripts of this repository including their first comment line as a description. It can be generated as described in [Generate Script Reference](./COMMANDS.md#generate-script-reference).

## :mag: Cypher Query Reference

[CYPHER.md](./cypher/CYPHER.md) lists all Cypher queries of this repository including their first comment line as a description. It can be generated as described in [Generate Cypher Reference](./COMMANDS.md#generate-cypher-reference).
> [Cypher](https://neo4j.com/docs/getting-started/cypher-intro) is Neo4j’s graph query language that lets you retrieve data from the graph.

## :globe_with_meridians: Environment Variable Reference

[ENVIRONMENT_VARIABLES.md](./scripts/ENVIRONMENT_VARIABLES.md) contains all environment variables that are supported by the scripts including default values and description. It can be generated as described in [Generate Environment Variable Reference](./COMMANDS.md#generate-environment-variable-reference).

## :thinking: Questions & Answers

- How can i run an analysis locally?  
  👉 Check the [prerequisites](#hammer_and_wrench-prerequisites).
  👉 See [Start an analysis](./COMMANDS.md#start-an-analysis) in the [Commands Reference](./COMMANDS.md).
  👉 To get started from scratch see [GETTING_STARTED.md](./GETTING_STARTED.md).

- How can i explore the Graph manually?
  👉 After analysis [start Neo4j](./COMMANDS.md#start-neo4j-graph-database) and open the [Neo4j Web UI](http://localhost:7474/browser).

- How can i add a CSV report to the pipeline?  
  👉 Put your new cypher query into the [cypher](./cypher) directory or a suitable (new) sub directory.  
  👉 Create a new CSV report script in the [scripts/reports](./scripts/reports/) directory. Take for example [OverviewCsv.sh](./scripts/reports/OverviewCsv.sh) as a reference.  
  👉 The script will automatically be included because of the directory and its name ending with "Csv.sh".

- How can i add a Jupyter Notebook report to the pipeline?  
  👉 Put your new notebook into the [jupyter](./jupyter) directory.  
  👉 Create a new Jupyter report script in the [scripts/reports](./scripts/reports/) directory. Take [OverviewJupyter.sh](./scripts/reports/OverviewJupyter.sh) as a reference for example.  
  👉 The script will automatically be included because of the directory and its name ending with "Jupyter.sh".

- How can i analyze a different code basis automatically?  
  👉 Create a new download script like the ones in the [scripts/downloader](./scripts/downloader/) directory. Take for example [downloadAxonFramework.sh](./scripts/downloader/downloadAxonFramework.sh) as a reference for Java projects and [downloadReactRouter.sh](./scripts/downloader/downloadReactRouter.sh) as a reference for Typescript projects.
  👉 After downloading, run [analyze.sh](./scripts/analysis/analyze.sh). You can find these steps also in the [pipeline](./.github/workflows/java-code-analysis.yml) as a reference.

- How can i trigger a full re-scan of all artifacts?  
  👉 Delete the file `artifactsChangeDetectionHash.txt` in the `artifacts` directory.

- How can i enable PDF generation for Jupyter Notebooks (depends on chromium, takes more time)?  
  👉 Set environment variable `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION` to anything except an empty string. Example:  

  ```shell
  export ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION="true"
  ```

  👉 Alternatively prepend your command with `ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION="true"` like:  
  
  ```shell
  ENABLE_JUPYTER_NOTEBOOK_PDF_GENERATION=true ./../../scripts/analysis/analyze.sh
  ```

- How can i disable git log data import?  
  👉 Set environment variable `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT` to `none`. Example:  

  ```shell
  export IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="none"
  ```

  👉 Alternatively prepend your command with `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="none"`:  
  
  ```shell
  IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="none" ./../../scripts/analysis/analyze.sh
  ```

  👉 An in-between option would be to only import monthly aggregated changes using `IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated"`:  
  
  ```shell
  IMPORT_GIT_LOG_DATA_IF_SOURCE_IS_PRESENT="aggregated" ./../../scripts/analysis/analyze.sh
  ```

- Why are some Jupyter Notebook reports skipped?
  👉 The custom Jupyter Notebook metadata property `code_graph_analysis_pipeline_data_validation` can be set to choose a query from [cypher/Validation](./cypher/Validation) that will be executed preliminary to the notebook. If the query leads to at least one result, the validation succeeds and the notebook will be run. If the query leads to no result, the notebook will be skipped.
  For more details see [Data Availability Validation](./COMMANDS.md#data-availability-validation).

## 🕸 Web References

- [Graph Data Science 101: Understanding Graphs and Graph Data Science](https://techfirst.medium.com/graph-data-science-101-understanding-graphs-and-graph-data-science-c25055a9db01)
- [The Story behind Russian Twitter Trolls](https://neo4j.com/blog/story-behind-russian-twitter-trolls)
- [Graphs for Data Science and Machine Learning](https://de.slideshare.net/neo4j/graphs-for-data-science-and-machine-learning)
- [Modularity](https://www.cs.cmu.edu/~ckingsf/bioinfo-lectures/modularity.pdf)
- [Graph Data Science Centrality Algorithms](https://neo4j.com/docs/graph-data-science/2.5/algorithms/centrality)
- [Graph Data Science Community Detection Algorithms](https://neo4j.com/docs/graph-data-science/2.5/algorithms/community)
- [Graph Data Science Community Similarity Algorithms](https://neo4j.com/docs/graph-data-science/2.5/algorithms/similarity)
- [Graph Data Science Community Topological Sort Algorithm](https://neo4j.com/docs/graph-data-science/2.5/algorithms/dag/topological-sort)
- [Node embeddings for Beginners](https://towardsdatascience.com/node-embeddings-for-beginners-554ab1625d98)
