# External Dependencies Domain

This directory contains the implementation and resources for analysing external dependencies within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, and report templates needed for this analysis live here.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [externalDependenciesCsv.sh](./externalDependenciesCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [externalDependenciesPython.sh](./externalDependenciesPython.sh): Entry point for Python-based chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [externalDependenciesMarkdown.sh](./externalDependenciesMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

- [explore](./explore/): Original Jupyter notebooks for interactive, exploratory analysis. Marked with `code_graph_analysis_pipeline_data_validation: ValidateAlwaysFalse` so they are not automatically executed by the pipeline.
- [queries](./queries/): All Cypher queries for identifying and quantifying external dependencies. These are self-contained copies from [cypher/External_Dependencies/](../../cypher/External_Dependencies/).
- [summary](./summary/): Markdown template and assembly script for the summary report.

## Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline ([scripts/prepareAnalysis.sh](../../scripts/prepareAnalysis.sh)) and are **not** set up by this domain.

### Graph database

- Neo4j must be running and accessible at `bolt://localhost:7687`.
- `NEO4J_INITIAL_PASSWORD` environment variable must be set.
- Artifacts must already have been scanned and loaded by jQAssistant, creating `DEPENDS_ON` relationships between `Type` nodes.

### Node labels (Java)

The following labels must exist on `Type` nodes before external dependency analysis can run. They are created by Cypher queries in [cypher/Types/](../../cypher/Types/):

- `PrimitiveType` — primitive types like `int`, `boolean`
- `Void` — void return type
- `JavaType` — built-in Java standard library types (e.g. `java.lang.*`, `java.util.*`)
- `ResolvedDuplicateType` — deduplicated types that appear in multiple jars

Without these labels, `Label_external_types_and_annotations.cypher` cannot correctly distinguish external types from internal and built-in ones.

### Relationship weight properties (Java)

The following properties must exist on `DEPENDS_ON` relationships between `Package` nodes. They are set by Cypher queries in [cypher/DependsOn_Relationship_Weights/](../../cypher/DependsOn_Relationship_Weights/):

- `weight` — sum of type-level dependency weights between two packages
- `weightInterfaces` — subset of `weight` attributable to interface dependencies

### TypeScript enrichment

For TypeScript projects, the following must be completed by [cypher/Typescript_Enrichment/](../../cypher/Typescript_Enrichment/):

- Module properties set on `Module` nodes: `namespace`, `moduleName`, `isNodeModule`, `isExternalImport`
- `IS_IMPLEMENTED_IN` relationships linking `ExternalModule` nodes to their resolved internal `Module` nodes
- `DEPENDS_ON` relationships propagated to resolved modules
- NPM packages linked to their corresponding `ExternalModule` nodes via `PROVIDED_BY_NPM_DEPENDENCY`

### General enrichment

- `name` and `extension` properties on `File` nodes — set by [cypher/General_Enrichment/](../../cypher/General_Enrichment/).

## What This Domain Produces

### CSV reports (`reports/external-dependencies/`)

One CSV file per Cypher query covering:

- **Java packages**: overall usage, spread, per-artifact, per-type, distribution, aggregated, Maven POM declared dependencies
- **TypeScript modules and namespaces**: overall usage, spread, per-internal-module, aggregated
- **Package management**: `package.json` dependency occurrence and combinations

### SVG charts (`reports/external-dependencies/`)

Python-generated charts from [externalDependencyCharts.py](./externalDependencyCharts.py):

- **Java**: pie charts for most-used and most-spread packages (by types and by packages, with drill-down into "others"), stacked bar charts for per-artifact breakdown, scatter plots for aggregated usage patterns
- **TypeScript**: pie charts for modules and namespaces (usage and spread, with drill-down)

### Markdown summary (`reports/external-dependencies/external_dependencies_report.md`)

A structured report designed to be readable by both humans and AI agents. Includes key findings, tables, chart references, and architectural recommendations such as Hexagonal Architecture patterns and Anti-Corruption Layer candidates.
