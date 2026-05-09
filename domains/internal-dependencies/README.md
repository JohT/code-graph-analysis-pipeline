# Internal Dependencies Domain

This directory contains the implementation and resources for analysing **internal dependencies** within the Code Graph Analysis Pipeline. It follows the vertical-slice domain pattern: all Cypher queries, Python chart scripts, shell scripts, and report templates needed for this analysis live here.

This domain covers three related analysis areas:

- **Internal Dependencies**: How packages, artifacts, and TypeScript modules depend on each other — interface segregation, widely used types, usage ratios, and file distances.
- **Path Finding**: All-pairs shortest path and longest path algorithms — revealing dependency depth, graph diameter, and worst-case transitive chains.
- **Topological Sort**: Build ordering across all abstraction levels — packages, artifacts, types, modules, and NPM packages.

> **Cyclic dependency analysis** has been extracted into its own dedicated domain: [`cyclic-dependencies`](../cyclic-dependencies/README.md).

## Entry Points

The following scripts are discovered and invoked automatically by the central compilation scripts in [scripts/reports/compilations/](../../scripts/reports/compilations/). They are found by filename pattern.

- [internalDependenciesCsv.sh](./internalDependenciesCsv.sh): Entry point for CSV reports based on Cypher queries. Discovered by `CsvReports.sh` (`*Csv.sh` pattern).
- [internalDependenciesPython.sh](./internalDependenciesPython.sh): Entry point for Python-based SVG chart generation. Discovered by `PythonReports.sh` (`*Python.sh` pattern).
- [internalDependenciesVisualization.sh](./internalDependenciesVisualization.sh): Entry point for graph visualizations. Discovered by `VisualizationReports.sh` (`*Visualization.sh` pattern).
- [internalDependenciesMarkdown.sh](./internalDependenciesMarkdown.sh): Entry point for the Markdown summary report. Discovered by `MarkdownReports.sh` (`*Markdown.sh` pattern).

## Folder Structure

```
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
│   ├── topological-sort/                  # 5 Cypher queries (build ordering)
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
- `DEPENDS_ON` relationships between `Type`, `Package`, and `Artifact` nodes
- Type labels (`PrimitiveType`, `Void`, `JavaType`, `ResolvedDuplicateType`) from [`cypher/Types/`](../../cypher/Types/)
- Weight properties (`weight`, `weightInterfaces`, `weight25PercentInterfaces`) from [`cypher/DependsOn_Relationship_Weights/`](../../cypher/DependsOn_Relationship_Weights/)
- Dependencies Projection functions from [`cypher/Dependencies_Projection/`](../../cypher/Dependencies_Projection/) and [`scripts/projectionFunctions.sh`](../../scripts/projectionFunctions.sh)
- TypeScript enrichment from [`cypher/Typescript_Enrichment/`](../../cypher/Typescript_Enrichment/)
- General enrichment (`name`, `extension` on `File` nodes) from [`cypher/General_Enrichment/`](../../cypher/General_Enrichment/)

## Execution Order

1. **`internalDependenciesCsv.sh`** — runs Cypher queries, writes CSV files
2. **`internalDependenciesPython.sh`** — reads CSV data, generates SVG charts
3. **`internalDependenciesVisualization.sh`** — generates GraphViz DOT → SVG graph visualizations
4. **`internalDependenciesMarkdown.sh`** — assembles the final Markdown report

## What This Domain Produces

All output goes into `reports/internal-dependencies/`, organised by abstraction level:

```
reports/internal-dependencies/
├── Distance_distribution_between_dependent_files.csv
├── Java_Artifact/
│   ├── List_all_Java_artifacts.csv
│   ├── ArtifactPackageUsage.csv
│   ├── ClassesPerPackageUsageAcrossArtifacts.csv
│   ├── Artifact_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Artifact_longest_paths_distribution.csv
│   ├── Artifact_Topological_Sort.csv
│   └── Graph_Visualizations/
│       ├── JavaArtifactBuildLevels.{csv,dot,svg}
│       ├── JavaArtifactLongestPathsIsolated.{csv,dot,svg}
│       └── JavaArtifactLongestPaths.{csv,dot,svg}
├── Java_Package/
│   ├── InterfaceSegregationCandidates.csv
│   ├── WidelyUsedTypes.csv
│   ├── Package_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Package_longest_paths_distribution.csv
│   └── Package_Topological_Sort.csv
├── Java_Type/
│   └── Type_Topological_Sort.csv
├── Typescript_Module/
│   ├── List_all_Typescript_modules.csv
│   ├── WidelyUsedTypescriptElements.csv
│   ├── ModuleElementsUsageTypescript.csv
│   ├── Module_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── Module_longest_paths_distribution.csv
│   ├── Module_Topological_Sort.csv
│   └── Graph_Visualizations/
│       ├── TypeScriptModuleBuildLevels.{csv,dot,svg}
│       ├── TypeScriptModuleLongestPathsIsolated.{csv,dot,svg}
│       └── TypeScriptModuleLongestPaths.{csv,dot,svg}
├── NPM_NonDevPackage/
│   ├── NpmNonDevPackage_all_pairs_shortest_paths_distribution_per_project.csv
│   ├── NpmNonDevPackage_longest_paths_distribution.csv
│   ├── NpmNonDevPackage_Topological_Sort.csv
│   └── Graph_Visualizations/
│       ├── NpmPackageBuildLevels.{csv,dot,svg}
│       ├── NpmNonDevPackageLongestPathsIsolated.{csv,dot,svg}
│       └── NpmNonDevPackageLongestPaths.{csv,dot,svg}
└── NPM_DevPackage/
    ├── NpmDevPackage_all_pairs_shortest_paths_distribution_per_project.csv
    ├── NpmDevPackage_longest_paths_distribution.csv
    ├── NpmDevPackage_Topological_Sort.csv
    └── Graph_Visualizations/
        ├── NpmDevPackageLongestPathsIsolated.{csv,dot,svg}
        └── NpmDevPackageLongestPaths.{csv,dot,svg}
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
