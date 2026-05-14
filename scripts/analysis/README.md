# Documentation for Analysis Process

This directory contains resources and documentation related to the core analysis orchestration process within the Code Graph Analysis Pipeline project.

## Generate Documentation Graphs

To generate documentation diagrams as SVG files, use the [renderDocumentationGraphs.sh](./renderDocumentationGraphs.sh) script in this directory. It renders the following graphs:

- [analysis_process_graph.gv](./analysis_process_graph.gv) → [analysis_process_graph.svg](./analysis_process_graph.svg)
- [getting_started_flow.gv](./getting_started_flow.gv) → [getting_started_flow.svg](./getting_started_flow.svg)

### Analysis Process Graph

The [analysis_process_graph.gv](./analysis_process_graph.gv) describes the runtime orchestration flow. The generated [analysis_process_graph.svg](./analysis_process_graph.svg) visualizes:

- **5 Pipeline Phases**: Setup, Scan & Analysis, Prepare, Report Generation, and Cleanup
- **Script Dependencies**: How [analyze.sh](./analyze.sh) orchestrates the analysis workflow
- **Domain Extensibility**: Dynamic report script discovery mechanism (example shown with anomaly-detection domain)

The SVG file is embedded in project documentation ([README.md](../../README.md) and [COMMANDS.md](../../COMMANDS.md)).

### Getting Started Flow Diagram

The [getting_started_flow.gv](./getting_started_flow.gv) describes the user's getting started workflow. The generated [getting_started_flow.svg](./getting_started_flow.svg) visualizes:

- **Prerequisites**: Required and optional dependencies (Neo4j, Java, jQAssistant, Bash, and optional Python, Node.js, GraphViz)
- **Setup Phase**: NEO4J_INITIAL_PASSWORD export and init.sh script execution
- **Prepare Code Phase**: Placing artifacts (JARs), source code (TypeScript/git), with alternative download scripts
- **Analysis Phase**: Running analyze.sh with various report types (CSV, Python, Visualization, Markdown, or All)
- **Access Results**: Neo4j Web UI login and generated reports

The SVG file can be embedded in project documentation (e.g., [GETTING_STARTED.md](../../GETTING_STARTED.md)).

## Maintenance

:warning: The `.gv` files are manually maintained. The SVG files need to be regenerated manually when changes are made to the `.gv` files using the [renderDocumentationGraphs.sh](./renderDocumentationGraphs.sh) script above.
