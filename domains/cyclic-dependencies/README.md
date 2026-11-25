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
- **Strongly Connected Component (SCC) Analysis**: Groups cycles into larger components (3+ members) with complexity classification based on size, density, cumulative weight, and architectural impact. Requires Neo4j Graph Data Science library.

> **Broader internal dependency analysis** (interface segregation, widely used types, path finding, topological sort) is in the [`internal-dependencies`](../internal-dependencies/README.md) domain.

## Prioritization Strategy

Cycles are ranked by **effort-to-resolution (easiest first)**, combining three factors:

1. **Forward-to-Backward Balance** (primary): Cycles where most dependencies flow in one direction are easier to fix by removing just a few reverse dependencies. Cycles are binned by balance rounding down to 0.1 (0.9, 0.8, 0.7, etc.), so cycles with balance 0.95 and 0.91 sort into the same 0.9 bin—keeping similar-difficulty cycles together.

2. **Parent-Child Relationship** (per bin): Non-parent-child cycles appear first within each bin because they represent true cross-module coupling, while parent-child cycles (e.g., `com.foo` ↔ `com.foo.bar`) indicate simpler hierarchical dependencies that are often acceptable architectural patterns.

3. **Exact Balance** (tiebreaker within bin): Within the same bin and parent-child status, cycles with higher exact balance sort first.

4. **Name** (final tiebreaker): Deterministic order for identical cycles.

**Example ordering** for a bin of balance 0.8:

- Cycles with 0.85–0.89 balance and no parent-child relationship first
- Then cycles with 0.85–0.89 balance and parent-child relationship
- Then cycles with 0.80–0.84 balance (non-parent-child, then parent-child)

## Strongly Connected Component Classification

When Neo4j Graph Data Science library is available, the domain automatically detects Strongly Connected Components (SCCs): groups of code units where every member is reachable from every other member through directed dependency edges. All components (including single-member) are created to ensure a cycle-free component graph for downstream algorithms like topological sort. SCCs are classified by complexity based on four factors:

- **Size**: Number of members (simple: 2–3 nodes, intermediate: 4–8, complex: 9+)
- **Density**: Ratio of actual internal edges to possible edges (0.0 to 1.0)
- **Cumulative Weight**: Sum of all dependency relationships among members (indicates coupling strength)
- **Complexity Score**: Normalized composite (0.0 to 1.0) combining size, density, and weight

**Classification tiers** (simple → intermediate → complex) guide refactoring effort expectations. Only components with 2+ members are reported in overview queries, as single-member components are structural elements but not cycles.

**Implementation Details**:

- SCC feature queries are parameterized by node label (`$scc_projection_node`, `$scc_projection_name`) to support any node type (Package, Module, etc.)
- Projection is created per node label to focus analysis on specific code unit types
- All components (1+ members) are created as nodes to guarantee cycle-free graph structure
- When SCC function is available, all SCC queries execute with fail-fast principle (errors propagate immediately)
- Idempotency is handled via `communityStronglyConnectedComponentId` property: if already set, re-running SCC overwrites but doesn't fail

## Execution Order

1. **`cyclicDependenciesCsv.sh`** - runs Cypher queries including optional SCC analysis (if GDS available), writes CSV files
2. **`cyclicDependenciesMarkdown.sh`** - assembles the final Markdown report

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

For Strongly Connected Component (SCC) analysis, additionally:

- Neo4j Graph Data Science library with `gds.scc.write` procedure available
- Directed dependency graph projection named `cyclic-dependencies-directed` (created by SCC feature queries)

## What This Domain Produces

Output into `reports/cyclic-dependencies/`:

- **CSV data**: Cyclic dependency detection at applicable abstraction levels (varies by data present: Java packages/artifacts, TypeScript modules, SCIP modules/directories/artifacts)
  - Overview tables: cycle groups with prioritization metrics
  - Breakdown: individual dependency pairs within cycles
  - Backward-only: removal candidates per cycle
  - **SCC Analysis** (when GDS available, only for 3+ member components):
    - SCC Overview: component metrics including complexity classification
    - SCC Members: mapping of code units to their SCC
- **Graph visualizations**: SVG diagrams of top cycle pairs (forward/backward dependencies highlighted)
- **`cyclic_dependencies_report.md`**: Assembled summary with cycle definitions, prioritization guidance, and conditional sections per abstraction level detected
