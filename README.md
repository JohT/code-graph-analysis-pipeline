# Code Graph Analysis Pipeline

<img src="./images/DALL-E-Mini-Graph-Pipeline-Logo.png" align="left" hspace="8" width="180">

Contained within this repository is a comprehensive and automated code graph analysis pipeline. While initially designed to support Java through the utilization of [jQAssistant](https://jqassistant.org/get-started), its capabilities extend beyond that particular language. The graph database [Neo4j](https://neo4j.com) serves as the foundation for storing and querying the graph, which encompasses all the structural intricacies of the analyzed code. Additionally, Neo4j's [Graph Data Science](https://neo4j.com/product/graph-data-science) integration maximizes the utilization of its features. The generated reports offer flexibility, ranging from simple query results presented as CSV files to more elaborate Jupyter Notebooks converted to Markdown or PDF formats.

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

- Java 11 is required
- Python with a conda package manager is needed for Jupyter Notebook reports
- Chromium will automatically be downloaded if needed for Jupyter Notebook reports in PDF format.

## 🏗 Pipeline

The [Code Reports Pipeline](./.github/workflows/code-reports.yml) utilizes [GitHub Actions](https://docs.github.com/de/actions) to automate the whole analysis process:

- Use Linux Runner
- Setup Java
- Setup Python
- Setup Conda package manager [Mambaforge](https://github.com/conda-forge/miniforge#mambaforge)
- Setup [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Setup [jQAssistant](https://jqassistant.org/get-started) for Java Analysis ([analysis.sh](./scripts/analysis/analyze.sh))
- Start [Neo4j](https://neo4j.com) Graph Database ([analysis.sh](./scripts/analysis/analyze.sh))
- Trigger (Java) artifacts download that contain the code to be analyzed [scripts/artifacts](./scripts/artifacts/)
- Generate Reports [scripts/reports](./scripts/reports/)

## 📈 Report Reference

[REPORTS.md](./reports/REPORTS.md) lists all Markdown reports inside the [results](./reports).

## ⚙️ Script Reference

[SCRIPTS.md](./scripts/SCRIPTS.md) lists all shell scripts of this repository with a description (first comment line).

## 🔎 Cypher Query Reference

[CYPHER.md](./cypher/CYPHER.md) lists all Cypher queries of this repository with their description (first comment lines).
> [Cypher](https://neo4j.com/docs/getting-started/cypher-intro) is Neo4j’s graph query language that lets you retrieve data from the graph.

## 🛠 Command Reference

[COMMANDS.md](./COMMANDS.md) contains further details on commands and how to do a manual setup. 
