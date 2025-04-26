# Code Graph Analysis Pipeline - Changelog

This document describes the changes to the Code Graph Analysis Pipeline. The changes are grouped by version and date. The latest version is at the top.

## v2.1.4

### 🛠 Fix

* [Remove debug prints](https://github.com/JohT/code-graph-analysis-pipeline/commit/4d0a419dc4344e1008ad9d08f8a572421758b191)

## v2.1.3

### 🚀 Feature

* Improve git history rendering by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/371
* Add git history csv reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/372
  * Add git history CSV reports ([7ea6c28](https://github.com/JohT/code-graph-analysis-pipeline/pull/372/commits/7ea6c2823bdf0bda4012e13a629d5f29fd8a86c3))
  * Use PREPARE_CONDA_ENVIRONMENT to fully skip conda ([2d0b800](https://github.com/JohT/code-graph-analysis-pipeline/pull/372/commits/2d0b800c48beb80164dd9a5c8f5d145d6923b991))

### 🛠 Fix

* Fix missing pairwise changed dependencies by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/368
  * Calculate p-values only if there are enough samples ([71d3519](https://github.com/JohT/code-graph-analysis-pipeline/pull/368/commits/71d3519d50c7336e083841aaada0f3d8619fd0ec))
* Fix git commitCount to only contain unique hashes ([14dceef](https://github.com/JohT/code-graph-analysis-pipeline/pull/372/commits/14dceef6c7eb38a376606a068b484f917cf8551b)) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/372

### 📦 Dependency Updates

* Update jQAssistant TypeScript Plugin to v1.4.0-M2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/364
* Update dependency com.buschmais.jqassistant.cli:jqassistant-commandline-neo4jv5 to v2.7.0-RC1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/366
* Update actions/setup-java digest to c5195ef by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/365

## v2.1.2

### 🚀 Feature

[Compare pairwise changed files with their dependency weights](https://github.com/JohT/code-graph-analysis-pipeline/pull/362/commits/7e5886904bcfe503a73dfba654aa972418f064b0) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/362:   
The [GitHistoryGeneral.ipynb](https://github.com/JohT/code-graph-analysis-pipeline/blob/cb47f814332f517807b9e144df352f68146cddfe/jupyter/GitHistoryGeneral.ipynb) notebook now includes a section that analyzes pairwise file changes alongside their code dependencies (e.g., imports). It calculates correlations, p-values, and visualizes the results using a scatter plot.

### 🛠 Fix

[Fix missing git changes due to not reliably present label](https://github.com/JohT/code-graph-analysis-pipeline/pull/362/commits/5242804ad517b82b928e7ebd87c9d64b1d2f8a0e) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/362

### 📦 Dependency Updates

* Update Node.js to v23.11.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/355
* Update dependency com.buschmais.jqassistant.cli:jqassistant-commandline-neo4jv5 to v2.7.0-M1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/359
* Update Neo4j and APOC to 5.26.5 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/360
* Update dependency JohT/open-graph-data-science-packaging to v2.13.4 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/361

## v2.1.1

### 🚀 Features

* Auto update Conda Environment by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/353
  * [Update conda environment if its outdated compared to the `environment.yml`](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/7f5b2811963b94631d7bb4ef4da57bad98a8f0d4): Previously, Jupyter notebooks failed to import libraries that had been added lately. An already existing Conda environment "codegraph" was sufficient, even it was outdated. Now, it will automatically be updated if necessary so that there are no more import errors. 
  * [Add PREPARE_CONDA_ENVIRONMENT to skip Conda environment setup](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/f13df113a691b55168dbc02cf5b94d5d838b688e): Previously, Conda environment activation was skipped when the `codegraph` environment was already active. Now, `PREPARE_CONDA_ENVIRONMENT="false` needs to be set additionally to explicitly skip that part. This is needed in GitHub Action pipelines because `conda init` doesn't work as expected but is taken care of by [setup-miniconda](https://github.com/marketplace/actions/setup-miniconda#important).
  * [Introduce script testing](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/7b735b0abfa037e090580ca5e5cfc80835b80e16): The first (for now framework-free) script test is implemented in the pipeline 🎉.

* Improve git history treemap visualizations and uncover pairwise changed files by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/352
  * [Add CHANGED_TOGETHER_WITH edge for git file nodes](https://github.com/JohT/code-graph-analysis-pipeline/pull/352/commits/10e202e45e5d4ba602b6023277f63ddf60c97f2e): With this change, there is now the new relationship `CHANGED_TOGETHER_WITH` between `File` nodes (git as well as code) including a property `commitCount` on how often they were changed together. This adds an additional way of uncovering dependencies of files, besides code dependencies via imports.

### 📈 Reports

* Improve git history treemap visualizations and uncover pairwise changed files by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/352
  * [Add plot highlighting directories with very few authors](https://github.com/JohT/code-graph-analysis-pipeline/pull/352/commits/46290acd5451ce7e4628f118cd67846bc47e535d)
  * [Add treemap plot that shows commit counts of pairwise changed files](https://github.com/JohT/code-graph-analysis-pipeline/pull/352/commits/30349a77160acd1cde612c199c74b3c67f4cafdb): Now you can additionally see which areas in the code base where changed in conjunction with at least one other file.

### ⚙️ Optimizations

* Auto update Conda Environment by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/353
  * [Improve change file detection](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/41260dfb02dc6ed7f4f3ff88ff463330b809efd3): 
    * Log output is now colored (red = error, dark grey = info)
    * Given `--paths` are now validated
    * File statistics are now correctly extracted for MacOS and Linux

* Improve git history treemap visualizations and uncover pairwise changed files by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/352
  * [Change default svg rendering size to 1080x1080](https://github.com/JohT/code-graph-analysis-pipeline/pull/352/commits/b898b1611717497e2176b368db8ab5bd27a017e8)

### 🛠 Fixes

* Auto update Conda Environment by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/353
  * [Defer download URL check for offline mode](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/a1d141fee5398fd32c57a453c39aa78f40b63d2c): Previously, it was not possible to get an artifact from the download script in offline mode, even if it had already been downloaded and ready to use in the cache. This is now resolved by deferring the check of the URL until right before the actual download, since it needs an internet connection.
  * [Fix wrong variable for Jupyter notebook directory](https://github.com/JohT/code-graph-analysis-pipeline/pull/353/commits/59571c42f9b7c2f9bbb67554a08c1643deb56bb4): Conda environment creation still used an old variable from another file that kept working since these files are called consecutively. However, can break easily and is now resolved.

### 📦 Dependency Updates

* Update actions/download-artifact digest to 95815c3 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/351
* Update actions/cache digest to 5a3ec84 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/350

## v2.1.0 (2025-03-22) Public GitHub Actions Workflow, GraphViz Visualization and Git History Treemaps

For all details see: https://github.com/JohT/code-graph-analysis-pipeline/releases/tag/v2.1.0

### 🚀 Features

* Graph Visualization with GraphViz by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/301
* Provide re-useable public workflow for code graph analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/306
* Add retention-days parameter to analysis workflows by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/310
* Remove "results" directory in favor of the new separate code-graph-analysis-examples repository by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/317

### 📈 Reports

* Add git history file overview treemap by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/323

### ⚙️ Optimization

* Minimize Neo4j transaction log disk space utilization by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/294
* Provide low memory profile by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/303
* Add renovate preset to update the public reusable GitHub Workflow by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/312
* Migrate renovate config by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/313
* Improve Documentation by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/349

### 🛠 Fixes

* Fix renaming issues and missing hidden files by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/307
* Improve Logging by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/319
* Further improve logging by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/320

## v2.0.0 (2024-12-15) TypeScript Source Code Analysis

For all details see: https://github.com/JohT/code-graph-analysis-pipeline/releases/tag/v2.0.0

### 🌟 Highlights 🌟

* ✨[TypeScript](https://github.com/jqassistant-plugin/jqassistant-typescript-plugin) ✨ Source Code Analysis (experimental)
* [Git](https://github.com/kontext-e/jqassistant-git-plugin) data included
* [Npm package.json](https://github.com/jqassistant-plugin/jqassistant-npm-plugin) data included
* Multiple source folders
* Symbolic links
* Incoming and Outgoing dependencies considering Java subpackages
* [Path finding algorithms](https://neo4j.com/docs/graph-data-science/current/algorithms/pathfinding) reports
* [Bridges](https://neo4j.com/docs/graph-data-science/current/algorithms/bridges) centrality algorithm report
* JavaEE and Spring REST endpoint reports

### 🚀 Features

* Skip analysis for empty projections by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/114
* Small Improvements by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/117
* Incoming and outgoing package dependencies with sub packages by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/124
* Introduce Typescript Analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/112
* Separate report reference documentation generation by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/143
* Add optional data validation before Jupyter notebook execution. by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/144
* Assure that t-SNE perplexity parameter is lower than the sample size for small graphs by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/147
* Use pnpm as package manager for react-router by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/148
* Migrate from sklearn.manifold TSNE to openTSNE for visualizing node embeddings by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/155
* Provide script to import git log as csv by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/157
* Add parent git commit nodes and connect them by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/159
* Use latest stable open graph-data-science version 2.6.7 by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/161
* Use latest stable open-graph-data-science version 2.6.8 by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/162
* Ignore duplicate Typescript analysis json files scan by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/173
* Fix missing declarationCount property on DEPENDS_ON relationships by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/183
* Add file distance to DEPENDS_ON relationships by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/184
* Support npm package.json files by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/185
* Add script to sort out external Java jar libraries. by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/186
* Support multiple source directories by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/178
* Support Typescript scan for existing sources without clone by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/191
* Refine nodes and relationships for multi typescript project graphs by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/194
* Support scanning files outside "artifacts" and switch to plugin for git data by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/195
* Use Renovate to update jQAssistant plugins by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/198
* Fix error when tsconfig has file as reference path. by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/200
* Improve useability by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/203
* Auto detect latest git tag if no version is specified by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/208
* Detect, mark and filter test related modules in Typescript analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/209
* Improve file and npm relationships for Typescript projects by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/210
* Add statistics about resolved external Typescript modules by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/215
* Scan every Typescript source directory separately. by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/224
* Support scanning large code bases by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/229
* Improvements for Typescript by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/231
* Support Typescript version numbers by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/223
* Scan each contained Typescript package when the scan of the whole source repository failed by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/244
* Fix missing support for dashes in profile names. by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/245
* Improve RESOLVES_TO relationships between external and internal Typescript modules by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/248
* Improve internal dependencies reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/255
* Fix minor Typescript issues by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/259
* Improve naming of external Typescript nodes by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/260
* Improve Typescript scanning and git import by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/265
* Improvements for large scala Typescript analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/268
* Fix missing IS_IMPLEMENTED_IN relationship for Typescript declarations by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/277
* Fix broken link check using workaround by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/279
* Install Typescript project dependencies explicitly by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/280
* Update jQAssistant TypeScript Plugin to v1.3.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/282
* Add details to algorithm result code unit names by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/285

### 📈 Reports

* Add reports containing JavaEE and Spring REST resources  by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/102
* Add Graph visualizations for Typescript Modules  by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/142
* Add graph data science algorithms for Typescript by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/137
* Add external dependencies reports for Typescript by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/154
* Add internal dependencies reports for Typescript by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/167
* Add Overview reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/174
* Add visibility reports for Typescript by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/175
* Introduce path finding algorithm reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/216
* Add Bridges centrality algorithm report by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/283

## v1.0.1 (2023-12-16) Fix Graph Visualization

For all details see: https://github.com/JohT/code-graph-analysis-pipeline/releases/tag/v1.0.1

### ⚙️ Optimization

* Update and add old results by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/91
* Improve visualization error handling by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/89

### 🛠 Fixes

* Fix JavaScript Graph Visualization by running it after all CSV reports that write data into the Graph by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/89

### 📦 Dependency Updates

* Update dependency AxonFramework/AxonFramework to v4.9.1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/90

## v1.0.0 (2023-12-09) First major version release

### 🚀 Features

* Update to Neo4j v5 and jQAssistant CLI 2.0 by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/6
* Introduce explore mode to start a manual analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/13/commits/53d60458589d5bfae07958fad57f0533f9eb9cb1
* Support for open packaged graph-data-science plugin by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/15
* Support query parameters by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/42

### 📈 Reports

* Graph Visualization by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/24
* Render visualization as png using puppeteer by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/26
* Add artifact reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/31
* Add node embeddings reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/47
* Add reports with metrics about detected communities by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/73
* Add java specific queries and reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/83

### 📖 Documentation

* Auto-generate reference documentation by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/22
* Bring documentation up-to-date by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/74

### ⚙️ Optimization

* Rename "package dependencies" to "internal dependencies" by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/12
* Separate artifacts and their download from the analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/13
* Performance Tuning by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/19
* Update old analysis reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/23
* Parametrize Topological Sort by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/51
* Refine Community Detection by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/52
* Fail-fast approach for error handling by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/54
* Optimize centrality reports using in-memory mutate by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/55
* Optimize Similarity using in-memory mutation by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/60
* Minor improvements and refinements by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/88

### 🛠 Fixes

* Fix missing Jupyter reports by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/72

## v0.9.0 (2023-06-26) Initial Release Version

For all details see: https://github.com/JohT/code-graph-analysis-pipeline/releases/tag/v0.9.0

### 🚀 Features

* Analyze static code structure, dependencies, metrics, ...
* Fully automated [pipeline](./.github/workflows/code-reports.yml) from tool installation and artifact download to report generation
* Runtime and library independent automation using [shell scripts](./scripts/SCRIPTS.md)
* Comprehensive list of [Cypher queries](./cypher/CYPHER.md)
* Example Analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

### 📖 Jupyter Notebook Reports

* [External Dependencies](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/external-dependencies-java/ExternalDependenciesJava.md) contains detailed information about external library usage ([Notebook](./jupyter/ExternalDependenciesJava.ipynb)).
* [Object Oriented Design Quality Metrics](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/object-oriented-design-metrics-java/ObjectOrientedDesignMetricsJava.md) is based on [OO Design Quality Metrics by Robert Martin](https://api.semanticscholar.org/CorpusID:18246616) ([Notebook](./jupyter/ObjectOrientedDesignMetricsJava.ipynb)).
* [Overview](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/overview-java/OverviewJava.md) contains overall statistics and details about methods and their complexity. ([Notebook](./jupyter/OverviewJava.ipynb)).
* [Internal Dependencies](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-java/InternalDependenciesJava.md) is based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html) and also includes cyclic dependencies ([Notebook](./jupyter/InternalDependenciesJava.ipynb)).
* [Visibility Metrics](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/visibility-metrics-java/VisibilityMetricsJava.md) ([Notebook](./jupyter/VisibilityMetricsJava.ipynb)).
* [Wordcloud](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/wordcloud/Wordcloud.md) contains a visual representation of package and class names ([Notebook](./jupyter/Wordcloud.ipynb)).

### 📖 Graph Data Science Reports

Here are some reports that utilize Neo4j's [Graph Data Science Library](https://neo4j.com/product/graph-data-science):

* [Centrality](./scripts/reports/CentralityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/centrality-csv/Package_Centrality_Page_Rank.csv))
* [Community Detection](./scripts/reports/CommunityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/community-csv/Package_communityLeidenId_Community__Metrics.csv))
* [Similarity](./scripts/reports/SimilarityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/similarity-csv/Package_Similarity.csv))

### 📖 Other Reports

* [External Dependencies (CSV)](./scripts/reports/ExternalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/external-dependencies-csv/External_package_usage_overall.csv))
* [Object Oriented Design Metrics (CSV)](./scripts/reports/ObjectOrientedDesignMetricsCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/object-oriented-design-metrics-csv/MainSequenceAbstractnessInstabilityDistanceJava.csv))
* [Overview (CSV)](./scripts/reports/OverviewCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/overview-csv/Cyclomatic_Method_Complexity.csv))
* [Internal Dependencies - Cyclic (CSV)](./scripts/reports/PackageDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-csv/Cyclic_Dependencies_Breakdown_Backward_Only.csv))
* [Internal Dependencies - Interface Segregation (CSV)](./scripts/reports/PackageDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-csv/InterfaceSegregationCandidates.csv))
* [Visibility Metrics (CSV)](./scripts/reports/VisibilityMetricsCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/visibility-metrics-csv/RelativeVisibilityPerArtifact.csv))
