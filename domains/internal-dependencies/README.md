# Internal Dependencies Domain

This directory contains the implementation and resources for analysing **internal dependencies** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, shell scripts, and report templates needed for this analysis live here.

This domain covers three related analysis areas:

- **Internal Dependencies**: How packages, artifacts, and TypeScript modules depend on each other — interface segregation, widely used types, usage ratios, and file distances.
- **Path Finding**: All-pairs shortest path and longest path algorithms — revealing dependency depth, graph diameter, and worst-case transitive chains. Includes support for Java, TypeScript, NPM packages, and SCIP semantic index artifacts/modules.
- **Topological Sort**: Build ordering across all abstraction levels — packages, artifacts, types, modules, and NPM packages. Handles cyclic dependencies by running topological sort on strongly connected components (SCCs), then propagating results back to member nodes.

> **Cyclic dependency analysis** has been extracted into its own dedicated domain: [`cyclic-dependencies`](../cyclic-dependencies/README.md).

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [internalDependenciesCsv.sh](./internalDependenciesCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [internalDependenciesPython.sh](./internalDependenciesPython.sh): Entry point for Python-based SVG chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [internalDependenciesVisualization.sh](./internalDependenciesVisualization.sh): Entry point for graph visualizations. Discovered by `VisualizationReports.sh` (`*Visualization.sh` pattern).
- [internalDependenciesMarkdown.sh](./internalDependenciesMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```text
domains/internal-dependencies/
├── README.md                              # This file
├── PREREQUISITES.md                       # Detailed prerequisite documentation
├── COPIED_FILES.md                        # Original → copy mapping for deprecation follow-up
├── internalDependenciesCsv.sh             # Entry point: CSV reports
├── internalDependenciesPython.sh          # Entry point: Python charts
├── internalDependenciesVisualization.sh   # Entry point: Graph visualizations
├── internalDependenciesMarkdown.sh        # Entry point: Markdown summary
├── pathFindingCharts.py                   # Chart generator: path finding bar + pie SVGs
├── explore/                               # Jupyter notebooks for interactive exploration
│   ├── InternalDependenciesJava.ipynb
│   ├── InternalDependenciesTypescript.ipynb
│   ├── PathFindingJava.ipynb
│   └── PathFindingTypescript.ipynb
├── queries/
│   ├── internal-dependencies/             # 14 Cypher queries (internal structure)
│   ├── path-finding/                      # 15 Cypher queries (path algorithms)
│   │   ├── Set_Parameters*.cypher         # Parameter templates for all path-finding node types
│   │   └── Path_Finding_*.cypher          # Path-finding algorithms (shortest path, longest path)
│   ├── topological-sort/                  # 6 core Cypher queries (build ordering)
│   └── strongly-connected-components/     # 9 queries: SCC detection → component sort → propagation
│       ├── SCC_*.cypher                   # Strongly Connected Component queries
│       └── SCC_TopologicalSort_*.cypher   # Component-level topological sort
│   └── exploration/                       # 2 Cypher queries (explore notebooks only)
├── graphs/
│   └── internalDependenciesGraphs.sh      # Graph visualization orchestration
└── summary/
    ├── internalDependenciesSummary.sh     # Markdown assembly logic
    └── report.template.md                 # Main report template
```

## Prerequisites

This domain requires the following to be in place before running. These are provided by the central pipeline and are **not** set up by this domain. See [PREREQUISITES.md](./PREREQUISITES.md) for full details.

- Neo4j running with scanned artifacts loaded
- `DEPENDS_ON` relationships between `Type`, `Package`, `Artifact`, and semantic index nodes
- Type labels (`PrimitiveType`, `Void`, `JavaType`, `ResolvedDuplicateType`) from [`cypher/Types/`](../../cypher/Types/)
- Weight properties (`weight`, `weightInterfaces`, `weight25PercentInterfaces`, `referenceCount`) from [`cypher/DependsOn_Relationship_Weights/`](../../cypher/DependsOn_Relationship_Weights/)
- Dependencies Projection functions from [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) and [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh)
- TypeScript enrichment from [`cypher/Typescript_Enrichment/`](../../cypher/Typescript_Enrichment/)
- General enrichment (`name`, `extension` on `File` nodes) from [`cypher/General_Enrichment/`](../../cypher/General_Enrichment/)
- SCIP semantic index nodes and relationships (if analyzing SCIP-indexed code)

## Topological Sort: Handling Cycles

The standard `gds.dag.topologicalSort` algorithm only works on directed acyclic graphs (DAGs) and excludes nodes that are part of cycles. To include all nodes:

1. **Detect strongly connected components (SCCs)** via `gds.scc.write`
2. **Create component nodes** for each SCC (named after the highest-degree member for readability)
3. **Create component-level `DEPENDS_ON` edges** (aggregating weights across members)
4. **Run topological sort on the component graph** (always a DAG)
5. **Propagate results back** to original nodes: `maxDistanceFromSource` + `topologicalSortIndex`

Result: All nodes receive topological sort values, including those in cycles. Nodes within a cycle share the same sort index (representing their component's position in the build order).

## Path Finding: SCC-based Longest Path for SCIP Nodes

The standard `gds.dag.longestPath` algorithm requires a DAG and fails on projections with cyclic edges. Java, TypeScript, and NPM projections use a `-cleaned` subgraph that removes cycles. SCIP semantic index data may contain cyclic dependencies and the `-cleaned` subgraph is therefore empty or incomplete.

For SCIP Module and Artifact nodes, longest path is computed at the SCC component level:

- The `-components` projection (a DAG of SCC components) created during topological sort is reused
- `gds.dag.longestPath` runs on `-components`, operating on `StronglyConnectedComponent` nodes
- Cycle components appear as single nodes labelled `"Cycle (N) around ModuleName"` in GraphViz output
- Results are written by `longestPathOnSCC` in `internalDependenciesCsv.sh` immediately after `topologicalSortOnSCC`, reusing the same projection without recreation

## Execution Order

1. **`internalDependenciesCsv.sh`** — runs Cypher queries, writes CSV files
2. **`internalDependenciesPython.sh`** — reads CSV data, generates SVG charts
3. **`internalDependenciesVisualization.sh`** — generates GraphViz DOT → SVG graph visualizations
4. **`internalDependenciesMarkdown.sh`** — assembles the final Markdown report

## What This Domain Produces

All output goes into `reports/internal-dependencies/`, organised by abstraction level and analysis type:

```
reports/internal-dependencies/
├── Distance_distribution_between_dependent_files.csv
├── Java_Artifact/
│   ├── List_all_Java_artifacts.csv
│   ├── ArtifactPackageUsage.csv
│   ├── ClassesPerPackageUsageAcrossArtifacts.csv
│   ├── Artifact_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Artifact_longest_paths_distribution.csv
│   ├── Artifact_Topological_Sort.csv  # Includes nodes from cycles
│   ├── Artifact_StronglyConnectedComponents_longest_paths_distribution.csv
│   └── Graph_Visualizations/
│       ├── JavaArtifactBuildLevels.{csv,dot,svg}
│       ├── JavaArtifactLongestPathsIsolated.{csv,dot,svg}
│       └── JavaArtifactLongestPaths.{csv,dot,svg}
├── Java_Package/
│   ├── InterfaceSegregationCandidates.csv
│   ├── WidelyUsedTypes.csv
│   ├── Package_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Package_longest_paths_distribution.csv
│   ├── Package_Topological_Sort.csv  # Includes nodes from cycles
│   └── Package_StronglyConnectedComponents_longest_paths_distribution.csv
├── Java_Type/
│   ├── Type_Topological_Sort.csv
│   └── Type_StronglyConnectedComponents_longest_paths_distribution.csv
├── Typescript_Module/
│   ├── List_all_Typescript_modules.csv
│   ├── WidelyUsedTypescriptElements.csv
│   ├── ModuleElementsUsageTypescript.csv
│   ├── Module_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Module_longest_paths_distribution.csv
│   ├── Module_Topological_Sort.csv
│   ├── Module_StronglyConnectedComponents_longest_paths_distribution.csv
│   └── Graph_Visualizations/
│       ├── TypeScriptModuleBuildLevels.{csv,dot,svg}
│       ├── TypeScriptModuleLongestPathsIsolated.{csv,dot,svg}
│       └── TypeScriptModuleLongestPaths.{csv,dot,svg}
├── NPM_NonDevPackage/
│   ├── NpmNonDevPackage_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── NpmNonDevPackage_longest_paths_distribution.csv
│   ├── NpmNonDevPackage_Topological_Sort.csv
│   ├── NpmNonDevPackage_StronglyConnectedComponents_longest_paths_distribution.csv
│   └── Graph_Visualizations/
│       ├── NpmPackageBuildLevels.{csv,dot,svg}
│       ├── NpmNonDevPackageLongestPathsIsolated.{csv,dot,svg}
│       └── NpmNonDevPackageLongestPaths.{csv,dot,svg}
├── NPM_DevPackage/
│   ├── NpmDevPackage_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── NpmDevPackage_longest_paths_distribution.csv
│   ├── NpmDevPackage_Topological_Sort.csv
│   └── NpmDevPackage_StronglyConnectedComponents_longest_paths_distribution.csv
├── SCIP_Semantic_Index_Type/
│   ├── SemanticCodeIndexInternalType_Topological_Sort.csv
│   └── SemanticCodeIndexInternalType_StronglyConnectedComponents_longest_paths_distribution.csv
├── SCIP_Semantic_Index_Module/
│   ├── SemanticCodeIndexModule_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── SemanticCodeIndexModule_Topological_Sort.csv
│   ├── SemanticCodeIndexModule_StronglyConnectedComponents_longest_paths_distribution.csv
│   └── Graph_Visualizations/
│       ├── ScipModuleLongestPathsIsolated.{csv,dot,svg}
│       └── ScipModuleLongestPaths.{csv,dot,svg}
└── SCIP_Semantic_Index_Artifact/
    ├── SemanticCodeIndexArtifact_all_pairs_shortest_paths_distribution_per_project.csv
    ├── SemanticCodeIndexArtifact_Topological_Sort.csv
    ├── SemanticCodeIndexArtifact_StronglyConnectedComponents_longest_paths_distribution.csv
    └── Graph_Visualizations/
        ├── ScipArtifactLongestPathsIsolated.{csv,dot,svg}
        └── ScipArtifactLongestPaths.{csv,dot,svg}
```

### SVG Charts (`reports/internal-dependencies/`)

Python-generated charts from [pathFindingCharts.py](./pathFindingCharts.py):

- **Java Package**: all-pairs shortest path (bar, pie, stacked log, stacked normalised, diameter) + longest path (bar, pie, stacked log, stacked normalised, max per artifact)
- **Java Artifact**: all-pairs shortest path (bar, pie) + longest path (bar, pie)
- **TypeScript Module**: all-pairs shortest path and longest path charts (same set as Java Package)
- **NPM packages**: same chart pattern where data exists

### Markdown Summary (`reports/internal-dependencies/internal_dependencies_report.md`)

A structured report covering cyclic dependencies, internal structure analysis, path finding insights, topological build levels, graph visualizations, and a glossary.

## Breaking Change Note

This domain uses a **new output directory** (`reports/internal-dependencies/`) consolidating what was previously split across:

- `reports/internal-dependencies-csv/`
- `reports/path-finding-csv/`
- `reports/topology-csv/`
- `reports/internal-dependencies-visualization/`
- `reports/path-finding-visualization/`

When the old scripts in `scripts/reports/` are eventually removed, a **major version bump** is required.
See [COPIED_FILES.md](./COPIED_FILES.md) for the full deprecation tracking.
