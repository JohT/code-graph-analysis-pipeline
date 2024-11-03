# Code Graph Analysis Pipeline - Getting started guide

This document describes the steps to get started as quickly as possible. 
For more details on what you can do with this pipeline see [README](./README.md).
For more details on how the commands work in detail see [COMMANDS](./COMMANDS.md).

## 🛠 Prerequisites

Please read through the [Prerequisites](./README.md#hammer_and_wrench-prerequisites) in the [README](./README.md) file for what is required to run the scripts.

## The easiest way to get started

Just run one of the following examples in the directory of this file:

- [./scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) (Java event-sourcing library)
- [./scripts/examples/analyzeAntDesign.sh](./scripts/examples/analyzeAntDesign.sh) (Typescript UI library)
- [./scripts/examples/analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh) (Typescript React library)

Use these optional command line options as you like:

- (Recommended) Only create CSV reports and skip Python and Node.js dependent reports. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh --report CSV
  ```

- Only explore the graph manually in the [browser](http://localhost:7474/browser). Skip all automated reports. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh --explore
  ```

- Add the version number of the project to pick a specific one. Example:

  ```shell
  ./scripts/examples/analyzeAxonFramework.sh 4.10.1
  ```

## Start an own analysis

1. Create a directory for all analysis projects.

    ```shell
    mkdir temp
    cd temp
    ```

1. Create a working directory for your specific analysis.
  
    ```shell
    mkdir MyFirstAnalysis
    cd MyFirstAnalysis
    ```

1. Choose an initial password for Neo4j if not already done.

    ```shell
    export NEO4J_INITIAL_PASSWORD=theinitialpasswordthatihavechosenforneo4j
    ```

1. Create the `artifacts` directory for the code to be analyzed (without `cd` afterwards).

    ```shell
    mkdir artifacts
    ```

1. Move the artifacts (e.g. Java jars json files) you want to analyze into the `artifacts` directory.

1. If you want to analyze Typescript code, create a symbolic link inside the `source` directory that points to the Typescript project or copy the project into it.

1. If you want to include git data like changed files and authors, create a symbolic link inside the `source` directory that points to the repository or clone it in the `source` directory. If you already have your Typescript project in there, you of course don't have to do it twice. If you are analyzing Java artifacts (no source needed), it is sufficient to use a bare clone that only contains the git history without the sources using `git clone --bare`.

1. Alternatively to the steps above, run an already predefined download script

    ```shell
    ./../../scripts/downloader/downloadAxonFramework.sh <version>
    ```

1. Optionally use a script to download artifacts from Maven ([details](./COMMANDS.md#download-maven-artifacts-to-analyze)).

1. Start the analysis.

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

👉 See [scripts/examples/analyzeAxonFramework.sh](./scripts/examples/analyzeAxonFramework.sh) as an example script that combines all the above steps for a Java Project.
👉 See [scripts/examples/analyzeReactRouter.sh](./scripts/examples/analyzeReactRouter.sh) as an example script that combines all the above steps for a Typescript Project.
👉 See [scripts/examples/analyzeAntDesign.sh](./scripts/examples/analyzeAntDesign.sh) as an example script that combines all the above steps for a large scale monorepo Typescript Project.
👉 See [Code Structure Analysis Pipeline](./.github/workflows/java-code-analysis.yml) on how to do this within a GitHub Actions Workflow.
