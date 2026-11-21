# Cyclic Dependencies Domain

## Why This Matters

Cyclic dependencies (A → B → A) create tight coupling between code units, increase complexity, make testing difficult, and prevent modular decomposition. Breaking cycles reduces maintenance burden, improves testability, and clarifies the architecture. This domain identifies cycles across abstraction levels and ranks them by removal effort, enabling prioritized refactoring.

## Overview

This domain is focused exclusively on cyclic dependency detection and prioritization across all abstraction levels:

- **Java Package Cyclic Dependencies**: Mutual dependency cycles between Java packages - with metrics to prioritize which backward dependencies to remove.
- **Java Artifact Cyclic Dependencies**: Cyclic dependencies at the artifact (JAR) level - the coarsest and most critical abstraction.
- **TypeScript Module Cyclic Dependencies**: Cycle groups among TypeScript modules, with the same prioritization metrics as the Java package view.
- **SCIP Semantic Index Module Cyclic Dependencies**: Cycle groups among SCIP Semantic Index modules (directory-level), with the same prioritization metrics.
- **SCIP Semantic Index Directory Cyclic Dependencies**: Cyclic dependencies between directories and their contained files in SCIP Semantic Index.
- **SCIP Semantic Index Artifact Cyclic Dependencies**: Cyclic dependencies at the SCIP artifact level - coarsest abstraction for SCIP-indexed codebases.

> **Broader internal dependency analysis** (interface segregation, widely used types, path finding, topological sort) is in the [`internal-dependencies`](../internal-dependencies/README.md) domain.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [cyclicDependenciesCsv.sh](./cyclicDependenciesCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [cyclicDependenciesMarkdown.sh](./cyclicDependenciesMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).
- [cyclicDependenciesVisualization.sh](./cyclicDependenciesVisualization.sh): Entry point for visualizing cyclic dependencies. Discovered by `VisualizationReports.sh` (`*Visualization.sh` pattern).

## Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain.

- Neo4j running with scanned artifacts loaded
- `scripts/prepareAnalysis.sh` executed prior to this domain

For Java and TypeScript analysis, additionally:

- `DEPENDS_ON` relationships between `Type`, `Package`, and `Artifact` nodes

For SCIP Semantic Index analysis, additionally:

- SCIP index imported via the [`scip-index-import`](../scip-index-import/README.md) domain
- `SemanticCodeIndexModule`, `SemanticCodeIndexArtifact`, `SemanticCodeIndexInternalType`, `SemanticCodeIndexInternalFile`, and `SemanticCodeIndexFunction` nodes present
- `DEPENDS_ON` relationships between `SemanticCodeIndexInternalSymbol` nodes (types and functions)
- File nodes with `directory` property populated

## Execution Order

1. **`cyclicDependenciesCsv.sh`** - runs Cypher queries, writes CSV files
2. **`cyclicDependenciesMarkdown.sh`** - assembles the final Markdown report

## What This Domain Produces

Output into `reports/cyclic-dependencies/`:

- **CSV data**: Cyclic dependency detection at applicable abstraction levels (varies by data present: Java packages/artifacts, TypeScript modules, SCIP modules/directories/artifacts)
  - Overview tables: cycle groups with prioritization metrics
  - Breakdown: individual dependency pairs within cycles
  - Backward-only: removal candidates per cycle
- **Graph visualizations**: SVG diagrams of top cycle pairs (forward/backward dependencies highlighted)
- **`cyclic_dependencies_report.md`**: Assembled summary with cycle definitions, prioritization guidance, and conditional sections per abstraction level detected
