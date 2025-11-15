# Code Graph Analysis Pipeline - Getting started guide

This document describes the steps to get started as quickly as possible.  
👉 For more details on what else you can do see [README](./README.md).  
👉 For more details on how the commands work in detail see [COMMANDS](./COMMANDS.md).

## 🛠 Prerequisites

Please read through the [Prerequisites](./README.md#hammer_and_wrench-prerequisites) in the [README](./README.md) file for what is required to run the scripts or simply run the [checkCompatibility.sh](./scripts/checkCompatibility.sh) script to verify that your environment is set up correctly.

## The easiest way to get started

Just run one of the following examples in the directory of this file:

- Java Event-Sourcing Framework: [./scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh)
- Typescript UI Library: [./scripts/examples/analyzeAntDesign.sh](./scripts/examples/analyzeAntDesign.sh)
- Typescript React Library: [./scripts/examples/analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh)

Use these optional command line options as needed:

- (Recommended) Only create CSV reports and skip Python and Node.js dependent reports. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh --report CSV
  ```

- Only explore the graph manually in the browser (`http://localhost:7474/browser`). Skip all automated reports. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh --explore
  ```

- Add the version number of the project to pick a specific one. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh 4.10.1
  ```

## Start an own analysis

### 1. Setup

- Choose an initial password for Neo4j if not already done.

    ```shell
    export NEO4J_INITIAL_PASSWORD=theinitialpasswordthatihavechosenforneo4j
    ```

- Initialize you analysis project using [./init.sh](./init.sh).

    ```shell
    ./init.sh MyAnalysisProjectName
    ```

- Change into the analysis directory.

    ```shell
    cd ./temp/MyAnalysisProjectName
    ```

### 2. Prepare the code to be analyzed

- Move the artifacts (e.g. Java jars json files) you want to analyze into the `artifacts` directory.

- If you want to analyze Typescript code, create a symbolic link inside the `source` directory that points to the Typescript project. Alternatively you can also copy the project into the `source` directory.

- If you want to include git data like changed files and authors, create a symbolic link inside the `source` directory that points to the repository or clone it into the `source` directory. If you already have your Typescript project in there, you of course don't have to do it twice. If you are analyzing Java artifacts (full source not needed), it is sufficient to use a bare clone that only contains the git history without the sources using `git clone --bare`. If you want to focus on one branch, use `--branch branch-name` to checkout the branch and `--single-branch` to only fetch the history of that branch.

- Alternatively to the steps above, run an already predefined download script

    ```shell
    ./../../scripts/downloader/downloadAxonFramework.sh <version>
    ```

- Optionally use a script to download artifacts from Maven ([details](./COMMANDS.md#download-maven-artifacts-to-analyze)).

### Start the analysis

- Without any additional dependencies:

  ```shell
  ./../../scripts/analysis/analyze.sh --report Csv
  ```

- Jupyter notebook reports when Python and Conda (or venv) are installed (and Chromium Browser for PDF generation):

  ```shell
  ./../../scripts/analysis/analyze.sh --report Jupyter
  ```

- Python reports when Python and Conda (or venv) are installed (without Chromium Browser for PDF generation):

  ```shell
  ./../../scripts/analysis/analyze.sh --report Python
  ```

- Graph visualizations with GraphViz installed or npx to run it indirectly:

  ```shell
  ./../../scripts/analysis/analyze.sh --report Visualization
  ```

- Markdown reports:

  ```shell
  ./../../scripts/analysis/analyze.sh --report Markdown
  ```

- All reports with Python, Conda (or venv), Node.js and npm installed:

  ```shell
  ./../../scripts/analysis/analyze.sh
  ```

- To explore the database yourself without any automatically generated reports and no additional requirements:

  ```shell
  ./../../scripts/analysis/analyze.sh --explore
  ```

👉 Open your browser and login to your local Neo4j Web UI (`http://localhost:7474/browser`) with "neo4j" as user and the initial password you've chosen.

## GitHub Actions

👉 See [Code Structure Analysis Pipeline](./.github/workflows/internal-java-code-analysis.yml) on how to do this within a GitHub Actions Workflow.
