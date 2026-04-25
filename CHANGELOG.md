# Code Graph Analysis Pipeline - Changelog

This document describes the changes to the Code Graph Analysis Pipeline. The changes are grouped by version and date. The latest version is at the top.

## (unreleased) Introduce neo4j-management domain

### ✨ Highlight

* Introduce `domains/neo4j-management/` as a vertical-slice domain that owns all Neo4j lifecycle management (install, configure, start, stop).

### 🚀 Features

* Move Neo4j management scripts from `scripts/` to `domains/neo4j-management/`:
  `setupNeo4j.sh`, `setupNeo4jInitialPassword.sh`, `configureNeo4j.sh`, `startNeo4j.sh`, `stopNeo4j.sh`,
  `detectNeo4j.sh`, `detectNeo4jWindows.sh`, `waitForNeo4jHttpFunctions.sh`, `useNeo4jHighMemoryProfile.sh`, `testConfigureNeo4j.sh`
* Move Neo4j configuration templates from `scripts/configuration/` to `domains/neo4j-management/configuration/`:
  `template-neo4j.conf`, `template-neo4j-high-memory.conf`, `template-neo4j-low-memory.conf`, `template-neo4j-v4.conf`, `template-neo4j-v4-low-memory.conf`
* Keep `scripts/startNeo4j.sh` and `scripts/stopNeo4j.sh` as **backward-compatible redirect stubs** so existing analysis workspaces continue to work without migration.
* Extend `runTests.sh` to also discover and run test scripts in `domains/` subdirectories.

## v3.5.0 Select analysis domain and npm dev dependency awareness

### ✨ Highlight

* Add `--domain` option to `analyze.sh` for domain-specific analysis by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/551
  * Now you can use --domain to run analysis for a single domain (vertical slice), skipping core reports and other domains. This enables focused, domain-specific analysis that's faster and more resource-efficient. The option works with --report to further narrow the scope (e.g. --domain anomaly-detection --report Csv), and is available in both the CLI and GitHub Actions workflow.

### 🚀 Features

* Distinguish between dev and non dev NPM package dependencies by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/547
* [Add Neo4j-latest-low-memory-continue-on-scan-errors profile for troubleshooting](https://github.com/JohT/code-graph-analysis-pipeline/pull/547/commits/b8ab8b6845bfdb9db7c3c09765cf9bafe4728f3d) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/547

### ⚙️ Optimizations

* [Scan npm package.json before Typescript code](https://github.com/JohT/code-graph-analysis-pipeline/pull/547/commits/b43da5fe87ee2cb48ff778690d33fc1905856e8e) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/547
  * This fixes the data dependent XOException where jqassistant-typescript-plugin creates multiple :File nodes with the same fileName property, leading to an exception in jqassistant-npm-plugin

### 📦 Dependency Updates

* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.8 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/543
* Update actions/cache digest to 6682284 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/542
* Update jQAssistant TypeScript Plugin to v1.4.4 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/550
* Update dependency remix-run/react-router to v7.13.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/549
* Update dependency neo4j/graph-data-science to v2.27.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/545

## v3.4.0 NPM package insights and modularized external dependencies analysis

### ✨ Highlight

* [Analyze npm package dependencies](https://github.com/JohT/code-graph-analysis-pipeline/pull/539/commits/ea6d2db0c8877fc1e7ac8f116876c505361c6dca): Adds NPM package-level dependency analysis alongside the existing TypeScript module analysis. Initially implements longest dependency-path detection and topological sorting to provide a fast, package-level overview of the project's architecture and dependency chains. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/539

### 🚀 Features

* [Add external dependencies analysis modularized as domain](https://github.com/JohT/code-graph-analysis-pipeline/pull/538/commits/3ee0a10421f46d410375801b505886bae8f5413a): The new external-dependencies "domain" (vertical-slice) packages Cypher queries, CSV/Markdown report generation, and Python-based SVG chart generation for analyzing external dependency usage for Java and TypeScript codebases. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/538
* [Modularize Neo4j configuration and support profile changes](https://github.com/JohT/code-graph-analysis-pipeline/pull/535/commits/e582aaa2a3f51afc3f6026b20f99475983a12c2f): With `useNeo4jHighMemoryProfile.sh` you can now switch to the new high memory profile without redoing the whole analysis. This is helpful when you reach memory limits within your first analysis attempt and want to fix that in a simple way. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/535

### ⚙️ Optimizations

* [Add TypeScript module project info to longest path visualization](https://github.com/JohT/code-graph-analysis-pipeline/pull/539/commits/d53826ce56126be17340cf900f88a38ffbaadbe2) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/539
* [Add batch sizes to all transactional write operations for memory management](https://github.com/JohT/code-graph-analysis-pipeline/pull/539/commits/d32fbe64b2088ec73576f1f579910709a34e00b6) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/539
* [Improved fail-fast when running all tests](https://github.com/JohT/code-graph-analysis-pipeline/pull/535/commits/052c0e20cd091d8af5714e050335b5173e0a4dac) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/535
* [Support direct and sourced test runs](https://github.com/JohT/code-graph-analysis-pipeline/pull/535/commits/53721dc45f19443473e97173acbfd7f32ffe95b4): You can now run each test case directly without getting an error that the script needs to be sourced. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/535

### 🛠 Fixes

* [Fix wrong denominator for external module usage](https://github.com/JohT/code-graph-analysis-pipeline/pull/538/commits/4315584a95dceecff4721d317e48d77647d6c31c) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/538
* [Fix misleading project scoped percentage](https://github.com/JohT/code-graph-analysis-pipeline/pull/538/commits/13fc50841e9966362fbe2bdd96855f78c8a61db3) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/538
* [Fix missing cases in external package usage](https://github.com/JohT/code-graph-analysis-pipeline/pull/538/commits/70128faddfdb8fb41bc3877a13543b96c7691578) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/538
* [Avoid self-loops in CHANGED_TOGETHER_WITH edges](https://github.com/JohT/code-graph-analysis-pipeline/pull/539/commits/47fb79c8c3b98d35369279815238077bba0fbd3b) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/539
* [Fix temporary directory name in maven test](https://github.com/JohT/code-graph-analysis-pipeline/pull/535/commits/8faf9c2ebf2cf6a3a80772075d6f2b514bf0744b) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/535
* [Fix documentation grammar issues](https://github.com/JohT/code-graph-analysis-pipeline/pull/535/commits/68c78123684f401228ba663c57fe7ca868a308e5) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/535

### 📦 Dependency Updates

* Update actions/setup-node action to v6.3.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/536
* Update dependency AxonFramework/AxonFramework to v5.0.3 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/531

## v3.3.2 Add Strongly Connected Components Detection + Stability Fixes

### 🚀 Features

* [Add strongly connected components community detection](https://github.com/JohT/code-graph-analysis-pipeline/pull/534/commits/40999467686cce303f76f3db880ebf2372b7f82c) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/534
* [Add high-memory profile for large codebases](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/56cb4a4845e7b05a077798a03d6687b450920efb): This new profile configures Neo4j to use more memory (24 GB heap, 18 GB transaction memory, 3 GB page cache) and is intended for large codebases. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529

### ⚙️ Optimizations

* [Remove weight property for weakly connected components](https://github.com/JohT/code-graph-analysis-pipeline/pull/534/commits/94648f7f320acd3e1545b8285f3d88290e302d28) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/534
* Remove workaround for npm packages by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/533
* [Add test that verifies file name references](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/4b0c3744dc853914e313113b422d1b9ed2a2b0ee): Some of the bugs below were caused by misspelled file name references. This new test checks the scripts and fails if referenced Cypher or YAML files are missing. By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529

### 🛠 Fixes

* [Fix typos in weakly connected components estimation](https://github.com/JohT/code-graph-analysis-pipeline/pull/534/commits/4b211a11ebaa790c3fa8e65fea31678281eedabe) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/534
* Fix TypeScript module `DEPENDS_ON` loop and missing weights by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/532
* [Disable usage reports by default](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/8ebe2487c2ad27a0863b725601c208b4ebcaffb1): `dbms.usage_report.enabled=false` is now added to the configuration to explicitly disable usage reporting.
* [Fix typo in module dependency relationship name](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/4e7bfe3c287472e1d99baef8d44b8d0994deea73) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529
* [Fix incorrect jqassistant config file name](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/dc623353c8a927506b0d3f8516b245dfc70e2b32) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529
* [Fix Cypher file name for setting degreeRank properties](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/e3cbe9dc77735bb042402b66191c5bd4dab087be) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529
* [Verify missing Git:File property createdAtEpoch](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/baa2356ba96e0866dec45bdb713e69389dce5a70) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529
* [Fix misspelled Cypher file in anomaly detection for TypeScript](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/e5253393f3a47378369301189ac0f2bf08b0a0e1) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529
* [Fix overwritten cardinality when updating existing module dependencies](https://github.com/JohT/code-graph-analysis-pipeline/pull/529/commits/9aa6d95a03857ad3befe3e780dcc3f691b85163d) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/529

### 📦 Dependency Updates

* Update actions/setup-node action to v6.2.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/521
* Update Neo4j and APOC to 2026.01.4 (major) by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/522
* Update dependency pip to v26 [SECURITY] by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/515
* Update dependency neo4j/graph-data-science to v2.26.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/524
* Update dependency pip to v26.0.1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/525
* Update python-machine-learning-libs by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/481
* Update dependency nbconvert to v7.17.0 [SECURITY] by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/519
* Update dependency neo4j to v6 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/505
* Update dependency remix-run/react-router to v7.13.1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/527
* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.7 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/530

## v3.3.1 Topological Sort Correction and Report Upgrades for Anomaly Detection

### 🛠 Fix

* Fix topological sort only applied to connected components of one member type by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/516

### 🚀 Feature

* [Add overall graph projection statistics to anomaly detection reports](https://github.com/JohT/code-graph-analysis-pipeline/pull/516/commits/ed63d69a1444b18cf166572c3eb7aff79787ac2e) in https://github.com/JohT/code-graph-analysis-pipeline/pull/516

### 📦 Dependency Updates

* Update dependency remix-run/react-router to v7.13.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/507
* Update actions/cache digest to cdf6c1f by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/509
* Update dependency AxonFramework/AxonFramework to v5.0.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/514
* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.6 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/513
* Update dependency com.buschmais.jqassistant.cli:jqassistant-commandline-neo4jv5 to v2.9.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/518
* Update actions/checkout digest to de0fac2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/517
* Update python-visualization-libs by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/495

## v3.3.0 Improved Anomaly Detection with Architectural Code Metrics

### 🚀 Improved Anomaly Detection with Architectural Code Metrics

* Introduces new anomaly detection features based on code semantics and graph structure, including abstractness (Robert C. Martin metrics) and weakly/strongly connected components.
* Refines abstractness modeling by weighting abstract classes at 70%, better reflecting real-world inheritance and implementation patterns.
* Adds hierarchical and architectural insights via topological ordering of strongly connected components, enabling layer-based analysis of code dependencies.
* Improves data quality by automatically removing constant, non-informative features during data preparation.

### 📦 Dependency Updates

* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.4 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/510
* Update dependency com.buschmais.jqassistant.cli:jqassistant-commandline-neo4jv5 to v2.9.0-RC1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/506
* Update conda-incubator/setup-miniconda digest to fc2d68f by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/512
* Update actions/setup-java digest to be666c2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/511

## v3.2.0 Improved node embeddings

### 🚀 New Features

* Improve Node Embeddings by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/503 for Java & TypeScript demos
  * Introduced GraphSAGE node embedding algorithm
  * Added UMAP-based projections (replacing t-SNE; removed related dependencies)
  * Improved embedding comparison plots with better coloring and annotations
  * Integrated community metrics directly into embedding visualizations
  * Optimized projection creation performance for faster analysis

### 📦 Dependency Updates

* Update Neo4j and APOC to 2025.11.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/500
* Update dependency typing-extensions to v4.15.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/499
* Update dependency neo4j/graph-data-science to v2.24.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/496
* Update dependency renovate to v42 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/502
* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.1 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/501
* Update dependency renovate to v42.71.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/504

## v3.1.2 Enhanced Anomaly Detection and Dependency Metrics

### 🚀 New Features

#### 📊 CSV Query Reports for Anomaly Detection

By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/485

* Added CSV query reports to anomaly detection outputs.
* For every node with an `anomalyScore`, a corresponding `anomalyRank` is now generated.
* Introduced `TopAnomalies.csv`, listing the highest-anomaly nodes of the same kind.
* Included `AnomalyArchetypeTopOutlier.csv` and `AnomalyArchetypeTopBridge.csv`, now aligned with the other archetype reports.

#### 📦 Automatic JavaScript Dependency Installation

By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/486

* JavaScript dependencies are now installed automatically when cloning a source repository.
* When the reusable GitHub Actions workflow is triggered with the `source-repository` input, dependencies are installed as needed.
* Supports npm, pnpm, and yarn.

#### 📈 Enhanced Anomaly Detection Distributions

By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/497

* Improved feature distribution plots for anomaly detection.
* Added degree distribution plots, including outlier examples for better insight.

#### 🔗 New Connectivity Metrics for Code Nodes

By @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/497

* `dependencyDegree` — Sum of `incomingDependencies` and `outgoingDependencies`.
* `dependencyDegreeWeighted` — Sum of `incomingDependenciesWeight` and `outgoingDependenciesWeight`.
* `dependencyDegreeRank` — Rank by degree (1 = highest degree, 2 = second highest, etc.).

### 📦 Dependency Updates

* Update dependency @hpcc-js/wasm-graphviz-cli to v1.8.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/484
* Update GitHub Artifact Actions (major) by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/491
* Update dependency matplotlib to v3.10.8 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/483
* Update dependency markdown-link-check to v3.14.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/476
* Update conda-incubator/setup-miniconda digest to 8352349 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/487
* Update pnpm/action-setup action to v4.2.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/488
* Update actions/cache action to v5 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/489
* Update actions/setup-node action to v6 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/490
* Update dependency remix-run/react-router to v7 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/493
* Update actions/checkout action to v6 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/492
* Update dependency neo4j/apoc by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/494

## v3.1.1 Ignore empty maven artifacts

### 🛠 Fix

* Ignore empty maven artifacts by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/482

### 📦 Dependency Updates

* Update dependency plotly to v6.5.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/479
* Update dependency AxonFramework/AxonFramework to v5 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/410

## v3.1.0 New Input Parameters for Maven Artifacts and Git Repositories

### 🚀 New Features

#### Input Parameters for Maven Artifacts

You can now analyze already published Maven artifacts without manually downloading and uploading them. Simply provide comma-separated Maven coordinates via the new `maven-artifacts` input parameter.

#### Input Parameters for Git Source Repositories

Including a repository's Git history or adding a repo to the `source` folder is now much easier. Use the new parameters to automatically clone a repository as part of the workflow:

* `source-repository`
* `source-repository-branch`
* `source-repository-history-only`

These options eliminate manual repository downloads and enable more automated, repeatable analyses. Details see https://github.com/JohT/code-graph-analysis-pipeline/pull/477

### 📦 Dependency Updates

* Update dependency @hpcc-js/wasm-graphviz-cli to v1.7.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/478
* Update actions/setup-java digest to f2beeb2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/480

## v3.0.2 Machine Learning Insights with improved documentation

### 🚀 Feature

* [Add anomaly detector input feature visualization](https://github.com/JohT/code-graph-analysis-pipeline/pull/474/commits/a53aa52deca0a9a6193e7dcff4c2157ddd0a716c) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/474
  * Adds a 2D scatter plot that projects the Isolation Forest model's input features into two dimensions and highlights detected anomalies in red — so you can "see what the anomaly detector sees."

### 📖 Documentation

* [Add pipeline architecture overview to Markdown summary report](https://github.com/JohT/code-graph-analysis-pipeline/pull/474/commits/98c842564291b63ede4d9ab5aac6e9b67bce68f0) by @JohT in https://github.com/JohT/code-graph-analysis-pipeline/pull/474
  * The report now includes an appendix section with a visualization of the anomaly detection pipeline architecture.

### 📦 Dependency Updates

* Update dependency neo4j/graph-data-science to v2.23.0 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/473
* Update dependency remix-run/react-router to v6.30.2 by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/472
* Update actions/checkout digest to 93cb6ef by @renovate in https://github.com/JohT/code-graph-analysis-pipeline/pull/475

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
* Fully automated [pipeline](./.github/workflows/public-analyze-code-graph.yml) from tool installation and artifact download to report generation
* Runtime and library independent automation using [shell scripts](./SCRIPTS.md)
* Comprehensive list of [Cypher queries](./CYPHER.md)
* Example Analysis for [AxonFramework](https://github.com/AxonFramework/AxonFramework)

### 📖 Jupyter Notebook Reports

* [External Dependencies](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/external-dependencies-java/ExternalDependenciesJava.md) contains detailed information about external library usage ([Notebook](./domains/external-dependencies/explore/ExternalDependenciesJava.ipynb)).
* [Object Oriented Design Quality Metrics](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/object-oriented-design-metrics-java/ObjectOrientedDesignMetricsJava.md) is based on [OO Design Quality Metrics by Robert Martin](https://api.semanticscholar.org/CorpusID:18246616) ([Notebook](./domains/internal-dependencies/explore/ObjectOrientedDesignMetricsJava.ipynb)).
* [Overview](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/overview-java/OverviewJava.md) contains overall statistics and details about methods and their complexity. ([Notebook](./jupyter/OverviewJava.ipynb)).
* [Internal Dependencies](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-java/InternalDependenciesJava.md) is based on [Analyze java package metrics in a graph database](https://joht.github.io/johtizen/data/2023/04/21/java-package-metrics-analysis.html) and also includes cyclic dependencies ([Notebook](./domains/internal-dependencies/explore/InternalDependenciesJava.ipynb)).
* [Visibility Metrics](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/visibility-metrics-java/VisibilityMetricsJava.md) ([Notebook](./domains/internal-dependencies/explore/VisibilityMetricsJava.ipynb)).
* [Wordcloud](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/wordcloud/Wordcloud.md) contains a visual representation of package and class names ([Notebook](./domains/internal-dependencies/explore/Wordcloud.ipynb)).

### 📖 Graph Data Science Reports

Here are some reports that utilize Neo4j's [Graph Data Science Library](https://neo4j.com/product/graph-data-science):

* [Centrality](./scripts/reports/CentralityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/centrality-csv/Package_Centrality_Page_Rank.csv))
* [Community Detection](./scripts/reports/CommunityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/community-csv/Package_communityLeidenId_Community__Metrics.csv))
* [Similarity](./scripts/reports/SimilarityCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/similarity-csv/Package_Similarity.csv))

### 📖 Other Reports

* [External Dependencies (CSV)](./domains/external-dependencies/externalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/external-dependencies-csv/External_package_usage_overall.csv))
* [Overview (CSV)](./scripts/reports/OverviewCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/overview-csv/Cyclomatic_Method_Complexity.csv))
* [Internal Dependencies - Cyclic (CSV)](./domains/internal-dependencies/internalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-csv/Cyclic_Dependencies_Breakdown_Backward_Only.csv))
* [Internal Dependencies - Interface Segregation (CSV)](./domains/internal-dependencies/internalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/internal-dependencies-csv/InterfaceSegregationCandidates.csv))
* [Object Oriented Design Metrics (CSV)](./domains/internal-dependencies/internalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/object-oriented-design-metrics-csv/MainSequenceAbstractnessInstabilityDistanceJava.csv))
* [Visibility Metrics (CSV)](./domains/internal-dependencies/internalDependenciesCsv.sh) ([Example](https://github.com/JohT/code-graph-analysis-examples/blob/main/analysis-results/AxonFramework/latest/visibility-metrics-csv/RelativeVisibilityPerArtifact.csv))
