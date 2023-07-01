# Code Graph Analysis Pipeline

<img src="./images/DALL-E-Mini-Graph-Pipeline-Logo-2.png" align="left" hspace="10" width="180">

Contained within this repository is a comprehensive and automated code graph analysis pipeline. While initially designed to support Java through the utilization of [jQAssistant](https://jqassistant.org/get-started), it is open to extension for further programming languages. The graph database [Neo4j](https://neo4j.com) serves as the foundation for storing and querying the graph, which encompasses all the structural intricacies of the analyzed code. Additionally, Neo4j's [Graph Data Science](https://neo4j.com/product/graph-data-science) provides additional algorithms like community detection to analyze the code structure. The generated reports offer flexibility, ranging from simple query results presented as CSV files to more elaborate Jupyter Notebooks converted to Markdown or PDF formats.

---

## 🚀 Features

- Analyze static code structure, dependencies, metrics, ...
- Fully automated [pipeline](./.github/workflows/code-reports.yml) from tool installation and artifact download to report generation
- Runtime and library independent automation using [shell scripts](./scripts/SCRIPTS.md)
- Comprehensive list of [Cypher queries](./cypher/CYPHER.md)
- Example Analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

### 📖 Jupyter Notebook Reports

- [External Dependencies](./jupyter/ExternalDependencies.ipynb) contains the most and least used external packages, etc. ([Example](./results/AxonFramework-4.7.5/external-dependencies/ExternalDependencies.md))
- [Object Oriented Design Quality Metrics](./jupyter/ObjectOrientedDesignMetrics.ipynb) is  based on [OO Design Quality Metrics by Robert Martin](https://www.semanticscholar.org/paper/OO-Design-Quality-Metrics-Martin-October/18acd7eb21b918c8a5f619157f7e4f6d451d18f8) ([Example](./results/AxonFramework-4.7.5/object-oriented-design-metrics/ObjectOrientedDesignMetrics.md))
- [Overview](./jupyter/Overview.ipynb) contains the number of types and packages, method line count, cyclomatic complexity, etc. ([Example](./results/AxonFramework-4.7.5/overview/Overview.md))
- [Internal Dependencies](./jupyter/InternalDependencies.ipynb) is based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html) including cyclic dependencies ([Example](./results/AxonFramework-4.7.5/internal-dependencies/InternalDependencies.md))
- [Visibility Metrics](./jupyter/VisibilityMetrics.ipynb) is based on [Visibility Metrics and the Importance of Hiding Things](https://dzone.com/articles/visibility-metrics-and-the-importance-of-hiding-th) ([Example](./results/AxonFramework-4.7.5/visibility-metrics/VisibilityMetrics.md))
- [Wordcloud](./jupyter/Wordcloud.ipynb) contains a visual representation of package and class names ([Example](./results/AxonFramework-4.7.5/wordcloud/Wordcloud.md))

### 📖 Graph Data Science Reports

Here are some reports that utilize Neo4j's [Graph Data Science Library](https://neo4j.com/product/graph-data-science):

- [Community Detection](./scripts/reports/CommunityCsv.sh) ([Example](./results/AxonFramework-4.7.5/community-csv/Leiden_Communities.csv))
- [Centrality](./scripts/reports/CommunityCsv.sh) ([Example](./results/AxonFramework-4.7.5/centrality-csv/Centrality_Page_Rank.csv))
- [Similarity](./scripts/reports/SimilarityCsv.sh) ([Example](./results/AxonFramework-4.7.5/similarity-csv/Similarity_Jaccard.csv))

### 📖 Other Reports

- [External Dependencies (CSV)](./scripts/reports/ExternalDependenciesCsv.sh) ([Example](./results/AxonFramework-4.7.5/external-dependencies-csv/External_package_usage_overall.csv))
- [Object Oriented Design Metrics (CSV)](./scripts/reports/ObjectOrientedDesignMetricsCsv.sh) ([Example](./results/AxonFramework-4.7.5/object-oriented-design-metrics-csv/MainSequenceAbstractnessInstabilityDistance.csv))
- [Overview (CSV)](./scripts/reports/OverviewCsv.sh) ([Example](./results/AxonFramework-4.7.5/overview-csv/Cyclomatic_Method_Complexity.csv))
- [Internal Dependencies - Cyclic (CSV)](./scripts/reports/InternalDependenciesCsv.sh) ([Example](./results/AxonFramework-4.7.5/internal-dependencies-csv/CyclicDependenciesUnwinded.csv))
- [Internal Dependencies - Interface Segregation (CSV)](./scripts/reports/InternalDependenciesCsv.sh) ([Example](./results/AxonFramework-4.7.5/internal-dependencies-csv/InterfaceSegregationCandidates.csv))
- [Visibility Metrics (CSV)](./scripts/reports/VisibilityMetricsCsv.sh) ([Example](./results/AxonFramework-4.7.5/visibility-metrics-csv/RelativeVisibilityPerArtifact.csv))

## 🛠 Prerequisites

- Java 17 is required (June 2023 Neo4j 5.x requirement)
- Python and a conda package manager are required for Jupyter Notebook reports
- Chromium will automatically be downloaded if needed for Jupyter Notebook reports in PDF format

## Getting Started

See [Start an analysis](./COMMANDS.md#start-an-analysis) in the [Commands Reference](./COMMANDS.md) on how to start an analysis on your local machine.

## 🏗 Pipeline and Tools

The [Code Reports Pipeline](./.github/workflows/code-reports.yml) utilizes [GitHub Actions](https://docs.github.com/de/actions) to automate the whole analysis process:

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

**Big shout-out** 📣 to all the creators and contributors of these great libraries 👍. Projects like this wouldn't be possible without them. Feel free to [create an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new/choose) if i've forgotten something in the list. 

## 📈 Report Reference

[REPORTS.md](./results/REPORTS.md) lists all Markdown reports inside the [results](./results).

## ⚙️ Script Reference

[SCRIPTS.md](./scripts/SCRIPTS.md) lists all shell scripts of this repository with a description (first comment line). It can updated as described in [Update Markdown Reference](./COMMANDS.md#update-script-reference) of the [Commands Reference](./COMMANDS.md).

## 🔎 Cypher Query Reference

[CYPHER.md](./cypher/CYPHER.md) lists all Cypher queries of this repository with their description (first comment lines). It can updated as described in [Update Cypher Reference](./COMMANDS.md#update-cypher-reference) of the [Commands Reference](./COMMANDS.md).
> [Cypher](https://neo4j.com/docs/getting-started/cypher-intro) is Neo4j’s graph query language that lets you retrieve data from the graph.

## 🛠 Command Reference

[COMMANDS.md](./COMMANDS.md) contains further details on commands and how to do a manual setup.

## 🤔 Questions & Answers

- How can i run an analysis locally?  
  👉 See [Start an analysis](./COMMANDS.md#start-an-analysis) in the [Commands Reference](./COMMANDS.md).

- How can i add an CSV report to the pipeline?  
  👉 Put your new cypher query into the [cypher](./cypher) directory or a suitable (new) sub directory.  
  👉 Create a new CSV report script in the [scripts/reports](./scripts/reports/) directory. Take for example [OverviewCsv.sh](./scripts/reports/OverviewCsv.sh) as a reference.  
  👉 The script will automatically be included because of the directory and its name ending with "Csv.sh".

- How can i add an Jupyter Notebook report to the pipeline?  
  👉 Put your new notebook into the [jupyter](./jupyter) directory.  
  👉 Create a new Jupyter report script in the [scripts/reports](./scripts/reports/) directory. Take [OverviewJupyter.sh](./scripts/reports/OverviewJupyter.sh) as a reference for example.  
  👉 The script will automatically be included because of the directory and its name ending with "Jupyter.sh".

- How can i add another code basis to be analyzed automatically?  
  👉 Create a new artifacts download script in the [scripts/artifacts](./scripts/artifacts) directory. Take for example [downloadAxonFramework.sh](./scripts/downloader/downloadAxonFramework.sh) as a reference.  
  👉 Run the script separately before executing [analyze.sh](./scripts/analysis/analyze.sh) also in the [pipeline](./.github/workflows/code-reports.yml).

- How can i trigger a full rescan of all artifacts?  
  👉 Delete the file `artifactsChangeDetectionHash.txt` in the `artifacts` directory.

- How can PDF generation be skipped to speed up report generation and not depend on chromium?  
  👉 Set environment variable `SKIP_JUPYTER_NOTEBOOK_PDF_GENERATION` to anything except an empty string. Example:  

  ```shell
  export SKIP_JUPYTER_NOTEBOOK_PDF_GENERATION="true"
  ```
