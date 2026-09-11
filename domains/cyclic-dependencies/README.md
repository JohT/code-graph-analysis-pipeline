# Cyclic Dependencies Domain

This directory contains the implementation and resources for analysing **cyclic dependencies** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, shell scripts, and report templates needed for this analysis live here.

This domain is focused exclusively on cyclic dependency detection and prioritisation across all abstraction levels:

- **Java Package Cyclic Dependencies**: Mutual dependency cycles between Java packages — with metrics to prioritise which backward dependencies to remove.
- **Java Artifact Cyclic Dependencies**: Cyclic dependencies at the artifact (JAR) level — the coarsest and most critical abstraction.
- **TypeScript Module Cyclic Dependencies**: Cycle groups among TypeScript modules, with the same prioritisation metrics as the Java package view.
- **SCIP Semantic Index Module Cyclic Dependencies**: Cycle groups among SCIP Semantic Index modules (directory-level), with the same prioritisation metrics.
- **SCIP Semantic Index Artifact Cyclic Dependencies**: Cyclic dependencies at the SCIP artifact level — coarsest abstraction for SCIP-indexed codebases.

> **Broader internal dependency analysis** (interface segregation, widely used types, path finding, topological sort) is in the [`internal-dependencies`](../internal-dependencies/README.md) domain.

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [cyclicDependenciesCsv.sh](./cyclicDependenciesCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [cyclicDependenciesMarkdown.sh](./cyclicDependenciesMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```
domains/cyclic-dependencies/
├── README.md                              # This file
├── cyclicDependenciesCsv.sh               # Entry point: CSV reports
├── cyclicDependenciesMarkdown.sh          # Entry point: Markdown summary
├── explore/
│   ├── CyclicDependenciesJavaExploration.ipynb       # Interactive Java cyclic dependency analysis
│   ├── CyclicDependenciesTypescriptExploration.ipynb # Interactive TypeScript cyclic dependency analysis
│   └── CyclicDependenciesScipExploration.ipynb       # Interactive SCIP cyclic dependency analysis
├── queries/                               # 11 Cypher queries (cycle analysis, flat)
│   ├── Cyclic_Dependencies.cypher
│   ├── Cyclic_Dependencies_Breakdown.cypher
│   ├── Cyclic_Dependencies_Breakdown_Backward_Only.cypher
│   ├── Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher
│   ├── Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.cypher
│   ├── Cyclic_Dependencies_Breakdown_for_Typescript.cypher
│   ├── Cyclic_Dependencies_Breakdown_for_SCIP_Module.cypher
│   ├── Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher
│   ├── Cyclic_Dependencies_between_SCIP_Artifacts_as_unwinded_List.cypher
│   ├── Cyclic_Dependencies_for_Typescript.cypher
│   └── Cyclic_Dependencies_for_SCIP_Module.cypher
└── summary/
    ├── cyclicDependenciesSummary.sh           # Markdown assembly logic
    ├── report.template.md                     # Main report template
    ├── report_no_cycles_data.template.md      # Fallback: no cyclic dependencies found
    ├── report_no_typescript_data.template.md  # Fallback: no TypeScript detected
    └── report_no_scip_data.template.md        # Fallback: no SCIP data detected
```

## Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain.

- Neo4j running with scanned artifacts loaded
- `DEPENDS_ON` relationships between `Type`, `Package`, and `Artifact` nodes
- `scripts/prepareAnalysis.sh` executed prior to this domain

For SCIP Semantic Index analysis, additionally:

- SCIP index imported via the [`scip-index-import`](../scip-index-import/README.md) domain
- `SemanticCodeIndexModule`, `SemanticCodeIndexArtifact`, and `SemanticCodeIndexInternalType` nodes present
- `DEPENDS_ON` relationships between `SemanticCodeIndexInternalType` nodes

## Execution Order

1. **`cyclicDependenciesCsv.sh`** — runs Cypher queries, writes CSV files
2. **`cyclicDependenciesMarkdown.sh`** — assembles the final Markdown report

## What This Domain Produces

All output goes into `reports/cyclic-dependencies/`, organised by abstraction level:

```
reports/cyclic-dependencies/
├── Java_Package/
│   ├── Cyclic_Dependencies.csv
│   ├── Cyclic_Dependencies_Breakdown.csv
│   └── Cyclic_Dependencies_Breakdown_Backward_Only.csv
├── Java_Artifact/
│   └── CyclicArtifactDependenciesUnwinded.csv
├── Typescript_Module/
│   ├── Cyclic_Dependencies_for_Typescript.csv
│   ├── Cyclic_Dependencies_Breakdown_for_Typescript.csv
│   └── Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.csv
├── SCIP_Semantic_Index_Module/
│   ├── Cyclic_Dependencies_for_SCIP_Module.csv
│   ├── Cyclic_Dependencies_Breakdown_for_SCIP_Module.csv
│   └── Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.csv
├── SCIP_Semantic_Index_Artifact/
│   └── Cyclic_Dependencies_between_SCIP_Artifacts_as_unwinded_List.csv
└── cyclic_dependencies_report.md
```
