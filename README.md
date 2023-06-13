# Code Graph Analysis Pipeline

<div style="display: flex;">
  <div style="flex: 1; margin-right: 10px;">
    <img src="./images/DALL-E-Mini-Graph-Pipeline-Logo.png" alt="Codegraph Pipeline" width="180">
  </div>
  <div style="flex: 4;">
    <p>
    Contained within this repository is a comprehensive and automated code graph analysis pipeline. While initially designed to support Java through the utilization of <a href="https://jqassistant.org/get-started" rel="nofollow">jQAssistant</a>, its capabilities extend beyond that particular language. The graph database <a href="https://neo4j.com" rel="nofollow">Neo4j</a> serves as the foundation for storing and querying the graph, which encompasses all the structural intricacies of the analyzed code. Additionally, Neo4j's <a href="https://neo4j.com/product/graph-data-science" rel="nofollow">Graph Data Science</a> integration maximizes the utilization of its features. The generated reports offer flexibility, ranging from simple query results presented as CSV files to more elaborate Jupyter Notebooks converted to Markdown or PDF formats.
    </p>
  </div>
</div>

---

## 🚀 Features

- Analyze static code structure, dependencies, metrics, ...
- Fully automated [pipeline](./.github/workflows/code-reports.yml) including tool installation and report generation
- Runtime and library independent automation using [shell scripts](./scripts/SCRIPTS.md)
- [Object Oriented Design Quality Metrics](./jupyter/ObjectOrientedDesignMetrics.ipynb) report based on [OO Design Quality Metrics by Robert Martin](https://www.semanticscholar.org/paper/OO-Design-Quality-Metrics-Martin-October/18acd7eb21b918c8a5f619157f7e4f6d451d18f8)
- [Visibility Metrics](./jupyter/VisibilityMetrics.ipynb) reports based on [Visibility Metrics and the Importance of Hiding Things](https://dzone.com/articles/visibility-metrics-and-the-importance-of-hiding-th)
- [Package Dependencies](./jupyter/PackageDependencies.ipynb) report based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html)
- [Graph Data Science](https://neo4j.com/product/graph-data-science) reports for [Community Detection](./scripts/reports/CommunityCsv.sh), [Centrality](./scripts/reports/CommunityCsv.sh) and [Similarity](./scripts/reports/SimilarityCsv.sh)
- Comprehensive list of [Cypher queries](./cypher/CYPHER.md)
- Example Analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

## 🛠 Prerequisites

- Java 11 is required (June 2023 Neo4j 4.x requirement)
- Python with a conda package manager is needed for Jupyter Notebook reports
- Chromium will automatically be downloaded if needed for Jupyter Notebook reports in PDF format.

## Getting Started

See [Start an analysis](./COMMANDS.md#start-an-analysis) in the [Commands Reference](./COMMANDS.md) on how to start
an analysis on your local machine.

## 🏗 Pipeline and Tools

The [Code Reports Pipeline](./.github/workflows/code-reports.yml) utilizes [GitHub Actions](https://docs.github.com/de/actions) to automate the whole analysis process:

- Use [GitHub Actions](https://docs.github.com/de/actions) Linux Runner
- [Checkout GIT Repository](https://github.com/actions/checkout)
- [Setup Java](https://github.com/actions/setup-java)
- [Setup Python with Conda](https://github.com/conda-incubator/setup-miniconda) package manager [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge)
- Setup [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Setup [jQAssistant](https://jqassistant.org/get-started) for Java Analysis ([analysis.sh](./scripts/analysis/analyze.sh))
- Start [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Trigger Artifacts download that contain the code to be analyzed [scripts/artifacts](./scripts/artifacts/)
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

**Big shout-out** 📣 to all the creators and contributors of these great libraries 👍. Projects like these wouldn't be possible without them. Feel free to [create an issue](https://github.com/JohT/code-graph-analysis-pipeline/issues/new/choose) if i've forgotten something in the list. 

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

- How can i add an CSV report to the pipeline?  
👉 Put your new cypher query into the [cypher](./cypher) directory or a suitable (new) sub directory.  
👉 Create a new CSV report script in the [scripts/reports](./scripts/reports/) directory. Take for example [OverviewCsv.sh](./scripts/reports/OverviewCsv.sh) as a reference.
👉 The script will automatically be included because of the directory and its name ending with "Csv.sh".

- How can i add an Jupyter Notebook report to the pipeline?  
👉 Put your new notebook into the [jupyter](./jupyter) directory.  
👉 Create a new Jupyter report script in the [scripts/reports](./scripts/reports/) directory. Take [OverviewJupyter.sh](./scripts/reports/OverviewJupyter.sh) as a reference for example.  
👉 The script will automatically be included because of the directory and its name ending with "Jupyter.sh".

- How can i add another code base to analyze?
👉 Create an new artifacts download script in the [scripts/artifacts](./scripts/artifacts) directory. Take [downloadAxonFramework.](./scripts/artifacts/downloadAxonFramework.sh) as a reference for example.
👉 The script will be triggered when the [analyze](./scripts/analysis/analyze.sh) command 

- How can i trigger a full rescan of all artifacts?
👉 Delete the file `artifactsChangeDetectionHash.txt` in the temporary `arctifacts` directory.
