# Code Graph Analysis Pipeline - Getting started guide

This document describes the steps to get started as quickly as possible. 
For more details on what you can do with this pipeline see [README](./README.md).
For more details on how the commands work in detail see [COMMANDS](./COMMANDS.md).

## 🛠 Prerequisites

Please read through the [Prerequisites](./README.md#🛠-prerequisites) in the [README](./README.md) file for what is required to run the scripts.

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

  - Without any additional dependencies:

    ```shell
    ./../../scripts/analysis/analyze.sh --report Csv
    ```

  - Jupyter notebook reports when Python and Conda are installed:

    ```shell
    ./../../scripts/analysis/analyze.sh --report Jupyter
    ```

  - Graph visualizations when Node.js and npm are installed:

    ```shell
    ./../../scripts/analysis/analyze.sh --report Jupyter
    ```

  - All reports with Python, Conda, Node.js and npm installed:

    ```shell
    ./../../scripts/analysis/analyze.sh
    ```

  - To explore the database yourself without any automatically generated reports and no additional requirements:

    ```shell
    ./../../scripts/analysis/analyze.sh --explore
    ```

    Then open your browser and login to your [local Neo4j Web UI](http://localhost:7474/browser) with "neo4j" as user and the initial password you've chosen.

👉 See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example script that combines all the above steps.  
👉 See [Code Structure Analysis Pipeline](./.github/workflows/code-structure-analysis.yml) on how to do this within a GitHub Actions Workflow.