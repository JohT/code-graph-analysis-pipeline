# Plan: Create Internal Dependencies Domain

Create a new self-contained `domains/internal-dependencies/` domain following the `external-dependencies` and `anomaly-detection` reference patterns. This domain covers **internal dependencies**, **cyclic dependencies**, **path finding**, and **topological sort** — all analyses of how internal code units depend on each other across multiple abstraction levels. Copy all relevant Cypher queries, shell scripts, and Jupyter notebooks. Convert path finding notebook charts to a Python SVG chart generator. Move original notebooks to an `explore/` folder with validation disabled. Assemble a Markdown summary report. No moves or deletions of originals.

### Decisions

- **Domain name**: `internal-dependencies`. Path finding, topological sort, and cyclic dependencies are implementation details or analysis methods applied to internal dependencies across different abstraction levels.
- **Topological Sort**: Included in the domain. All 5 Cypher queries and the full `TopologicalSortCsv.sh` logic are copied.
- **Cyclic Dependencies**: Included. Only the 7 Cypher files actually used by existing scripts and notebooks are copied (excluding `Cyclic_Dependencies_Concatenated.cypher` and `Cyclic_Dependencies_as_Nodes.cypher` which are unreferenced).
- **Report output directory**: Everything under `reports/internal-dependencies/`. This is a **breaking change** vs. the old directories (`internal-dependencies-csv/`, `path-finding-csv/`, `topology-csv/`, `internal-dependencies-visualization/`, `path-finding-visualization/`). When the old scripts are eventually removed, a major version bump is required.
- **Report subdirectory structure**: Orient by abstraction level following the anomaly-detection pattern: `Java_Package/`, `Java_Artifact/`, `Java_Type/`, `Typescript_Module/`, `NPM_NonDevPackage/`, `NPM_DevPackage/`. General results (e.g. file distance, overall cyclic dependencies) go into the main `reports/internal-dependencies/` directory. Graph visualizations within an abstraction level get a `Graph_Visualizations/` subfolder when there are multiple files.
- **Dependencies_Projection**: Documented as a core prerequisite. Not copied. Follow-up planned to rethink core dependency placement.
- **projectionFunctions.sh**: Documented as a core prerequisite. Not copied. Sourced from `../../scripts/`.
- **Charts**: Only path finding notebooks produce charts (~27 bar + pie charts). Internal dependencies notebooks are tables only. The Python chart script converts path finding visualizations to SVG.
- **Entry point naming**: camelCase prefix matching domain name: `internalDependenciesCsv.sh`, `internalDependenciesPython.sh`, `internalDependenciesVisualization.sh`, `internalDependenciesMarkdown.sh`.
- **Extra Cypher files from notebooks**: `Artifacts_with_duplicate_packages.cypher` (from `Artifact_Dependencies/`) and `Annotated_code_elements.cypher` (from `Java/`) are referenced by `InternalDependenciesJava.ipynb`. These are copied into the domain `queries/` directory for the explore notebook but are NOT executed by the CSV entry point (they serve exploratory analysis).
- **Reset folder**: Not needed. Internal dependency analysis does not create persistent labels that need removal.
- **Markdown summary**: Rich, structured report with tables, chart references, architectural descriptions, and a glossary. Designed for both humans and AI agents. Every linked table and chart gets a short description (1–3 sentences). Algorithm explanations and domain concepts from the Jupyter notebooks are distilled into concise, improved prose in the report template — not copied verbatim but condensed for clarity and LLM-friendliness.
- **Deprecated files tracking**: A `COPIED_FILES.md` documents every file that was copied so a follow-up task can cleanly remove the originals.

### Prerequisites (Documented in README and PREREQUISITES.md, Not Copied)

The following are provided by the central pipeline and must run *before* this domain:

1. **Neo4j running** with scanned artifacts loaded
2. **DEPENDS_ON relationships** between types (jQAssistant scan)
3. **Type labels** ([cypher/Types/](../../cypher/Types/)): `PrimitiveType`, `Void`, `JavaType`, `ResolvedDuplicateType`
4. **Weight properties** on DEPENDS_ON ([cypher/DependsOn_Relationship_Weights/](../../cypher/DependsOn_Relationship_Weights/)): `weight`, `weightInterfaces`, `weight25PercentInterfaces`
5. **Dependencies Projection** ([cypher/Dependencies_Projection/](../../cypher/Dependencies_Projection/)): provides `createDirectedDependencyProjection` and related graph projection management. Used by path finding and topological sort.
6. **Projection functions** ([scripts/projectionFunctions.sh](../../scripts/projectionFunctions.sh)): shell functions wrapping Dependencies_Projection Cypher queries
7. **TypeScript enrichment** ([cypher/Typescript_Enrichment/](../../cypher/Typescript_Enrichment/)): module properties, namespace, `isNodeModule`, `IS_IMPLEMENTED_IN` resolution, npm linking, `lowCouplingElement25PercentWeight`
8. **General enrichment** ([cypher/General_Enrichment/](../../cypher/General_Enrichment/)): `name` and `extension` properties on `File` nodes
9. **Metrics** ([cypher/Metrics/](../../cypher/Metrics/)): dependency degree calculations (incoming/outgoing) used indirectly

### Domain Directory Structure

```
domains/internal-dependencies/
├── README.md
├── PREREQUISITES.md                                     # Detailed prerequisite documentation
├── COPIED_FILES.md                                      # Tracking: original → copy mapping for deprecation follow-up
├── internalDependenciesCsv.sh                           # Entry point: CSV reports (*Csv.sh)
├── internalDependenciesPython.sh                        # Entry point: Python charts (*Python.sh)
├── internalDependenciesVisualization.sh                 # Entry point: Graph visualizations (*Visualization.sh)
├── internalDependenciesMarkdown.sh                      # Entry point: Markdown summary (*Markdown.sh)
├── pathFindingCharts.py                                 # Chart generation: bar, pie → SVG
├── explore/
│   ├── InternalDependenciesJava.ipynb                   # Original notebook (ValidateAlwaysFalse)
│   ├── InternalDependenciesTypescript.ipynb              # Original notebook (ValidateAlwaysFalse)
│   ├── PathFindingJava.ipynb                            # Original notebook (ValidateAlwaysFalse)
│   └── PathFindingTypescript.ipynb                      # Original notebook (ValidateAlwaysFalse)
├── queries/
│   ├── internal-dependencies/                           # 14 files from cypher/Internal_Dependencies/
│   │   ├── Candidates_for_Interface_Segregation.cypher
│   │   ├── Get_file_distance_as_shortest_contains_path_for_dependencies.cypher
│   │   ├── How_many_classes_compared_to_all_existing_in_the_same_package_are_used_by_dependent_packages_across_different_artifacts.cypher
│   │   ├── How_many_elements_compared_to_all_existing_are_used_by_dependent_modules_for_Typescript.cypher
│   │   ├── How_many_packages_compared_to_all_existing_are_used_by_dependent_artifacts.cypher
│   │   ├── Inter_scan_and_project_dependencies_of_Typescript_modules.cypher
│   │   ├── Java_Artifact_build_levels_for_graphviz.cypher
│   │   ├── List_all_Java_artifacts.cypher
│   │   ├── List_all_Typescript_modules.cypher
│   │   ├── List_elements_that_are_used_by_many_different_modules_for_Typescript.cypher
│   │   ├── List_types_that_are_used_by_many_different_packages.cypher
│   │   ├── NPM_Package_build_levels_for_graphviz.cypher
│   │   ├── Set_file_distance_as_shortest_contains_path_for_dependencies.cypher
│   │   └── Typescript_Module_build_levels_for_graphviz.cypher
│   ├── cyclic-dependencies/                             # 7 files from cypher/Cyclic_Dependencies/
│   │   ├── Cyclic_Dependencies.cypher
│   │   ├── Cyclic_Dependencies_between_Artifacts_as_unwinded_List.cypher
│   │   ├── Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.cypher
│   │   ├── Cyclic_Dependencies_Breakdown_Backward_Only.cypher
│   │   ├── Cyclic_Dependencies_Breakdown_for_Typescript.cypher
│   │   ├── Cyclic_Dependencies_Breakdown.cypher
│   │   └── Cyclic_Dependencies_for_Typescript.cypher
│   ├── path-finding/                                    # 15 files from cypher/Path_Finding/
│   │   ├── Path_Finding_1_Create_Projection.cypher
│   │   ├── Path_Finding_2_Estimate_Memory.cypher
│   │   ├── Path_Finding_3_Depth_First_Search_Path.cypher
│   │   ├── Path_Finding_4_Breadth_First_Search_Path.cypher
│   │   ├── Path_Finding_5_All_pairs_shortest_path_distribution_overall.cypher
│   │   ├── Path_Finding_5_All_pairs_shortest_path_distribution_per_project.cypher
│   │   ├── Path_Finding_5_All_pairs_shortest_path_examples.cypher
│   │   ├── Path_Finding_6_Longest_paths_contributors_for_graphviz.cypher
│   │   ├── Path_Finding_6_Longest_paths_distribution_overall.cypher
│   │   ├── Path_Finding_6_Longest_paths_distribution_per_project.cypher
│   │   ├── Path_Finding_6_Longest_paths_examples.cypher
│   │   ├── Path_Finding_6_Longest_paths_for_graphviz.cypher
│   │   ├── Set_Parameters.cypher
│   │   ├── Set_Parameters_NonDevNpmPackage.cypher
│   │   └── Set_Parameters_Typescript_Module.cypher
│   ├── topological-sort/                                # 5 files from cypher/Topological_Sort/
│   │   ├── Set_Parameters.cypher
│   │   ├── Topological_Sort_Exists.cypher
│   │   ├── Topological_Sort_List.cypher
│   │   ├── Topological_Sort_Query.cypher
│   │   └── Topological_Sort_Write.cypher
│   └── exploration/                                     # 2 files only referenced by explore/ notebooks
│       ├── Artifacts_with_duplicate_packages.cypher
│       └── Annotated_code_elements.cypher
├── graphs/
│   └── internalDependenciesGraphs.sh                    # Graph visualization orchestration
└── summary/
    ├── internalDependenciesSummary.sh                   # Markdown assembly logic
    └── report.template.md                               # Main report template
```

---

### Steps

#### Phase 1: Scaffolding & Cypher Queries

**1.1** Create the domain directory structure with all subdirectories:
`domains/internal-dependencies/{explore,queries/{internal-dependencies,cyclic-dependencies,path-finding,topological-sort,exploration},graphs,summary}`

**1.2** Copy the 14 `.cypher` files from [cypher/Internal_Dependencies/](../../cypher/Internal_Dependencies/) into `queries/internal-dependencies/`.

**1.3** Copy the 7 used `.cypher` files from [cypher/Cyclic_Dependencies/](../../cypher/Cyclic_Dependencies/) into `queries/cyclic-dependencies/`.
Excluded: `Cyclic_Dependencies_Concatenated.cypher`, `Cyclic_Dependencies_as_Nodes.cypher` (unreferenced by any script or notebook).

**1.4** Copy all 15 `.cypher` files from [cypher/Path_Finding/](../../cypher/Path_Finding/) into `queries/path-finding/`.

**1.5** Copy all 5 `.cypher` files from [cypher/Topological_Sort/](../../cypher/Topological_Sort/) into `queries/topological-sort/`.

**1.6** Copy 2 exploration-only `.cypher` files into `queries/exploration/`:
- [cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher](../../cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher)
- [cypher/Java/Annotated_code_elements.cypher](../../cypher/Java/Annotated_code_elements.cypher)

**1.7** Create `PREREQUISITES.md` documenting all external dependencies (see Prerequisites section above).

**1.8** Create `COPIED_FILES.md` tracking every original → copy mapping for the deprecation follow-up.

**1.9** Create `README.md` — domain overview, entry points, folder structure, prerequisites reference, what the domain produces (matching [external-dependencies README](../../domains/external-dependencies/README.md) format).

#### Phase 2: CSV Entry Point Script

**2.1** Create `internalDependenciesCsv.sh`:
- Follow exact boilerplate pattern of [anomalyDetectionCsv.sh](../../domains/anomaly-detection/anomalyDetectionCsv.sh) for the domain script directory resolution (`BASH_SOURCE`/`CDPATH`, `set -o errexit -o pipefail`)
- Source `../../scripts/executeQueryFunctions.sh` for `execute_cypher()` and `execute_cypher_queries_until_results()`
- Source `../../scripts/projectionFunctions.sh` for `createDirectedDependencyProjection` and related projection functions
- Main report directory: `reports/internal-dependencies`
- Create abstraction-level subdirectories: `Java_Artifact/`, `Java_Package/`, `Java_Type/`, `Typescript_Module/`, `NPM_NonDevPackage/`, `NPM_DevPackage/`
- Combine logic from [InternalDependenciesCsv.sh](../../scripts/reports/InternalDependenciesCsv.sh), [PathFindingCsv.sh](../../scripts/reports/PathFindingCsv.sh), and [TopologicalSortCsv.sh](../../scripts/reports/TopologicalSortCsv.sh)
- General results (file distance, overall cyclic deps) go into main report directory
- Per-abstraction-level results go into their respective subdirectories

**Internal dependencies queries** — replicate ordering from [InternalDependenciesCsv.sh](../../scripts/reports/InternalDependenciesCsv.sh):
1. File distance (Get + Set) → main directory
2. Java cyclic dependencies (3 queries) → `Java_Package/`
3. Artifact cyclic dependencies (unwinded) → `Java_Artifact/`
4. Interface segregation candidates → `Java_Package/`
5. List all Java artifacts → `Java_Artifact/`
6. Widely used types → `Java_Package/`
7. Package usage by dependent artifacts → `Java_Artifact/`
8. Class usage across artifacts → `Java_Artifact/`
9. TypeScript cyclic dependencies (3 queries) → `Typescript_Module/`
10. List all TypeScript modules → `Typescript_Module/`
11. Widely used TypeScript elements → `Typescript_Module/`
12. Module element usage → `Typescript_Module/`

**Path finding queries** — replicate logic from [PathFindingCsv.sh](../../scripts/reports/PathFindingCsv.sh):
1. Java Artifact: all pairs shortest path + longest path → `Java_Artifact/`
2. Java Package: all pairs shortest path + longest path → `Java_Package/`
3. TypeScript Module: all pairs shortest path + longest path → `Typescript_Module/`
4. NPM Non-Dev Package: all pairs shortest path + longest path → `NPM_NonDevPackage/`
5. NPM Dev Package: all pairs shortest path + longest path → `NPM_DevPackage/`
(Java Type and Method path finding remain deactivated as in original)

**Topological sort queries** — replicate logic from [TopologicalSortCsv.sh](../../scripts/reports/TopologicalSortCsv.sh):
1. Java Artifact → `Java_Artifact/`
2. Java Package → `Java_Package/`
3. Java Type → `Java_Type/`
4. TypeScript Module → `Typescript_Module/`
5. NPM Non-Dev Package → `NPM_NonDevPackage/`
6. NPM Dev Package → `NPM_DevPackage/`

**2.2** Clean-up: source `cleanupAfterReportGeneration.sh` for each subdirectory and the main directory.

#### Phase 3: Python Chart Generation Script (*parallel with Phase 4*)

**3.1** Create `pathFindingCharts.py`:
- Follow `Parameters` class pattern from [externalDependencyCharts.py](../../domains/external-dependencies/externalDependencyCharts.py): `--report_directory`, `--verbose` parameters
- Neo4j connection using `neo4j` Python driver
- Load and execute Cypher `.cypher` files from `queries/path-finding/` directory

**3.2** Data processing functions (extracted from PathFinding notebooks):
- `pivot_distribution_by_project(data_frame, distance_column, count_column, project_column)` → DataFrame
- `normalize_distribution_by_project(pivoted_data)` → DataFrame
- `format_pie_label(percentage, all_values)` → str (percentage + count format)

**3.3** Chart generation functions:
- `plot_distribution_bar(data_frame, distance_column, count_column, title, file_path)` → saves SVG
- `plot_distribution_pie(data_frame, distance_column, count_column, title, file_path)` → saves SVG
- `plot_per_project_stacked_bar(pivoted_data, title, file_path, use_log_scale)` → saves SVG
- `plot_per_project_normalized_bar(normalized_data, title, file_path)` → saves SVG
- `plot_diameter_bar(data_frame, project_column, diameter_column, title, file_path)` → saves SVG

**3.4** Per-abstraction-level chart generation:
- **Java Package**: all pairs shortest path (bar, pie, stacked log, stacked normalized, diameter) + longest path (bar, pie, stacked log, stacked normalized, max per artifact) = ~10 charts
- **Java Artifact**: all pairs shortest path (bar, pie) + longest path (bar, pie) = ~4 charts
- **TypeScript Module**: same as Java Package = ~10 charts
- **NPM packages**: if data exists, same pattern

**3.5** `main()` function: parse arguments, connect Neo4j, generate charts per abstraction level, handle "no data" gracefully and skip.

#### Phase 4: Entry Point Shell Scripts (*parallel with Phase 3*)

**4.1** Create `internalDependenciesPython.sh`:
- Follow pattern of [externalDependenciesPython.sh](../../domains/external-dependencies/externalDependenciesPython.sh)
- Set script directory, report directory
- Call `python pathFindingCharts.py --report_directory "${FULL_REPORT_DIRECTORY}" ${verboseMode}`

**4.2** Create `internalDependenciesVisualization.sh`:
- Follow entry-point delegation pattern of [anomalyDetectionVisualization.sh](../../domains/anomaly-detection/anomalyDetectionVisualization.sh)
- Delegate to `graphs/internalDependenciesGraphs.sh`

**4.3** Create `internalDependenciesMarkdown.sh`:
- Follow entry-point delegation pattern of [anomalyDetectionMarkdown.sh](../../domains/anomaly-detection/anomalyDetectionMarkdown.sh)
- Delegate to `summary/internalDependenciesSummary.sh`

#### Phase 5: Graph Visualizations

**5.1** Create `graphs/internalDependenciesGraphs.sh`:
- Combine logic from [InternalDependenciesVisualization.sh](../../scripts/reports/InternalDependenciesVisualization.sh) and [PathFindingVisualization.sh](../../scripts/reports/PathFindingVisualization.sh)
- Source `../../scripts/executeQueryFunctions.sh`, `../../scripts/projectionFunctions.sh`
- Use `../../scripts/visualization/visualizeQueryResults.sh` for CSV → DOT → SVG conversion
- Output structure:
  - `Java_Artifact/Graph_Visualizations/JavaArtifactBuildLevels.{csv,dot,svg}`
  - `Java_Artifact/Graph_Visualizations/JavaArtifactLongestPathsIsolated.{csv,dot,svg}`
  - `Java_Artifact/Graph_Visualizations/JavaArtifactLongestPaths.{csv,dot,svg}`
  - `Typescript_Module/Graph_Visualizations/TypeScriptModuleBuildLevels.{csv,dot,svg}`
  - `Typescript_Module/Graph_Visualizations/TypeScriptModuleLongestPathsIsolated.{csv,dot,svg}`
  - `Typescript_Module/Graph_Visualizations/TypeScriptModuleLongestPaths.{csv,dot,svg}`
  - `NPM_NonDevPackage/Graph_Visualizations/NpmPackageBuildLevels.{csv,dot,svg}`
  - `NPM_NonDevPackage/Graph_Visualizations/NpmNonDevPackageLongestPathsIsolated.{csv,dot,svg}`
  - `NPM_NonDevPackage/Graph_Visualizations/NpmNonDevPackageLongestPaths.{csv,dot,svg}`
  - `NPM_DevPackage/Graph_Visualizations/NpmDevPackageLongestPathsIsolated.{csv,dot,svg}`
  - `NPM_DevPackage/Graph_Visualizations/NpmDevPackageLongestPaths.{csv,dot,svg}`
- For each visualization: create projection, ensure topological sort exists for level info, execute graphviz query, run visualizeQueryResults.sh

#### Phase 6: Markdown Summary

**Design principle**: The Jupyter notebooks contain valuable explanatory descriptions that **must** be distilled into the Markdown summary. Rewrite them in a concise, improved, and summarized way optimized for both human readability and LLM consumption. Every linked table and chart in the report should have a short description (1–3 sentences) explaining what it shows and how to interpret it. Algorithm explanations should be condensed from the multi-paragraph notebook prose into focused paragraphs.

**6.1** Create `summary/report.template.md`:
- YAML front matter (title, date, model version)

- **Section 1: Executive Overview** — total artifacts, packages, modules, key structural observations

- **Section 2: Cyclic Dependencies**
  - Introductory paragraph: Explain what cyclic dependencies are, why they complicate builds and maintenance, and the resolution strategy. Condense from the notebook: *"A cycle group is a set of packages with mutual dependencies. The `forwardToBackwardBalance` metric indicates which dependencies, when reversed, would most effectively dissolve the cycle — values near 1.0 mean mostly forward dependencies (few backward dependencies to remove)."*
  - Java package/artifact cycle tables (Table 2a, 2b, 2c pattern) with short per-table descriptions:
    - **Table 2a (Overview)**: "Lists cycle groups with `numberForward` (dependencies in cycle direction) and `numberBackward` (dependencies against cycle direction). Sorted by `forwardToBackwardBalance` descending — groups at the top are easiest to fix."
    - **Table 2b (Breakdown)**: "Expands each cycle group into individual dependencies in `type1 → type2` format, forward and backward."
    - **Table 2c (Backward Only)**: "Shows only backward dependencies — the most promising candidates for removal or reversal to break cycles."
  - TypeScript module cycles (same table pattern)

- **Section 3: Java Internal Structure**
  - **Artifact listings**: Short description: "Java artifacts sorted by their number of packages, types, and incoming/outgoing dependencies. Reveals the largest and most connected components."
  - **Interface Segregation Principle candidates**: Condense from notebook: *"Based on Robert C. Martin's Interface Segregation Principle — 'Clients should not be forced to depend upon interfaces that they do not use.' This table shows packages where dependent packages use only a small fraction of the available types, indicating potential for splitting."* Short description for the linked table: "Packages sorted by the ratio of types actually used vs. types available."
  - **Widely used types**: "Types used by the highest number of different packages. These are cross-cutting concerns or core abstractions."
  - **Package usage by dependent artifacts**: "Packages where dependent artifacts use only a few of the available packages, indicating loose coupling at the artifact level."
  - **Class usage across artifacts**: "Classes used by multiple artifacts — candidates for extraction into a shared library."
  - **Duplicate package names**: Condense from notebook: *"Duplicate package names across artifacts can cause class loader conflicts and break package-protected access assumptions."*
  - **Annotated elements**: "Code elements with annotations — reveals framework coupling and configuration density."
  - **File distance distribution**: Condense from notebook: *"Intuitively, the distance is the fewest number of `cd` (change directory) commands needed to navigate between a source file and the dependency it uses. Aggregated to show how many dependencies are co-located (distance 0), one directory apart (distance 1), and so on."*

- **Section 4: TypeScript Internal Structure**
  - **Module listings**: "TypeScript modules sorted by their number of elements, incoming/outgoing dependencies."
  - **Widely used elements**: "Elements used by the highest number of different modules."
  - **Module element usage**: "Modules where dependents use only a few of the available elements, indicating over-broad module interfaces."
  - **File distance distribution**: Same explanation as Java (adapted for modules)

- **Section 5: Path Finding**
  - Introductory paragraph: Condense the notebook's algorithm overview into a focused explanation: *"Path finding algorithms reveal the depth and complexity of dependency chains. **All Pairs Shortest Path** computes the minimum distance between every pair of connected nodes — distance 1 = direct dependency, distance 2 = one intermediary, etc. The **Graph Diameter** (longest shortest path) is a complexity metric: a diameter of 6 means at least one pair of modules requires a chain of 6 dependencies to connect. The **Longest Path** (for directed acyclic graphs) shows the worst-case dependency chain — relevant for build ordering since an artifact can only be built after everything it depends on."*
  - Per-abstraction-level subsections (Java Package, Java Artifact, TypeScript Module, NPM packages):
    - **All pairs shortest path**: "Distribution of shortest path distances. A peak at distance 1 indicates many direct dependencies; a long tail suggests deep transitive chains."
      - Total distribution (bar + pie chart with descriptions: "Bar chart showing path count per distance" / "Pie chart showing percentage of paths per distance")
      - Per-artifact/project distribution: Short description: *"Stacked bar charts (absolute and normalized) showing how shortest path distances distribute across artifacts/projects. Filtering is applied to pairs within the same artifact; however, intermediate nodes may cross artifact boundaries, reflecting real-world transitive dependencies."*
      - Graph diameter per artifact/project: "Top artifacts/projects ranked by their graph diameter (longest shortest path)."
    - **Longest path**: "The longest dependency chain for directed acyclic graphs. Higher values indicate deeper dependency hierarchies and greater build complexity."
      - Note: *"Requires a Directed Acyclic Graph (DAG). Results may be inaccurate when cycles exist."*
      - Total distribution (bar + pie chart)
      - Per-artifact/project distribution (stacked bar charts)
      - Max longest path per artifact/project

- **Section 6: Topological Sort** — build order and build levels per abstraction level. Short description: "Build levels derived from topological ordering of the dependency graph. Level 0 nodes have no dependencies; higher levels depend on lower ones."

- **Section 7: Graph Visualizations** — build level and longest path SVG references. Per visualization: 1-sentence description of what the graph shows (e.g., "Directed graph of Java artifacts colored by build level, showing the build dependency hierarchy.")

- **Section 8: Glossary & Column Definitions**
  - `forwardToBackwardBalance`: "Ratio indicating how many dependencies in a cycle group flow forward vs. backward. Values near 1.0 = mostly forward (easy to fix); near 0.0 = mostly backward."
  - `numberForward` / `numberBackward`: "Count of dependencies flowing in cycle direction / against it."
  - `Graph Diameter`: "The longest shortest path across all pairs — a measure of dependency depth and structural complexity."
  - `Longest Path`: "Maximum-length directed path in a DAG — the worst-case dependency chain."
  - `File Distance`: "Minimum number of directory traversals between a source file and its dependency."
  - `Build Level`: "Topological sort level. Level 0 = no dependencies, level N = depends on nodes at levels < N."

**6.2** Create `summary/internalDependenciesSummary.sh`:
- Follow [externalDependenciesSummary.sh](../../domains/external-dependencies/summary/externalDependenciesSummary.sh) pattern
- Execute summary-specific Cypher queries → Markdown table includes
- Conditionally include SVG chart references if files exist
- Conditionally include graph visualization SVG references
- Generate front matter (title, date, git tag)
- Use `scripts/markdown/embedMarkdownIncludes.sh` for template assembly
- Assemble final `internal_dependencies_report.md`

**6.3** Create `internalDependenciesMarkdown.sh`:
- Thin delegator to `summary/internalDependenciesSummary.sh`

#### Phase 7: Exploration Notebooks

**7.1** Copy [jupyter/InternalDependenciesJava.ipynb](../../jupyter/InternalDependenciesJava.ipynb) → `explore/InternalDependenciesJava.ipynb`, change metadata `"code_graph_analysis_pipeline_data_validation"` from `"ValidateJavaInternalDependencies"` to `"ValidateAlwaysFalse"`.

**7.2** Copy [jupyter/InternalDependenciesTypescript.ipynb](../../jupyter/InternalDependenciesTypescript.ipynb) → `explore/InternalDependenciesTypescript.ipynb`, change metadata `"code_graph_analysis_pipeline_data_validation"` from `"ValidateTypescriptModuleDependencies"` to `"ValidateAlwaysFalse"`.

**7.3** Copy [jupyter/PathFindingJava.ipynb](../../jupyter/PathFindingJava.ipynb) → `explore/PathFindingJava.ipynb`, change metadata `"code_graph_analysis_pipeline_data_validation"` from `"ValidateJavaPackageDependencies"` to `"ValidateAlwaysFalse"`.

**7.4** Copy [jupyter/PathFindingTypescript.ipynb](../../jupyter/PathFindingTypescript.ipynb) → `explore/PathFindingTypescript.ipynb`, change metadata `"code_graph_analysis_pipeline_data_validation"` from `"ValidateTypescriptModuleDependencies"` to `"ValidateAlwaysFalse"`.

---

### Relevant Files

**To create** (in `domains/internal-dependencies/`):
- `README.md`, `PREREQUISITES.md`, `COPIED_FILES.md`
- 4 entry point `.sh` files
- `pathFindingCharts.py`
- `graphs/internalDependenciesGraphs.sh`
- `summary/internalDependenciesSummary.sh`, `summary/report.template.md`

**To copy** (43 `.cypher` + 4 `.ipynb`):
- [cypher/Internal_Dependencies/](../../cypher/Internal_Dependencies/) (14 files) → `queries/internal-dependencies/`
- [cypher/Cyclic_Dependencies/](../../cypher/Cyclic_Dependencies/) (7 of 9 files) → `queries/cyclic-dependencies/`
- [cypher/Path_Finding/](../../cypher/Path_Finding/) (15 files) → `queries/path-finding/`
- [cypher/Topological_Sort/](../../cypher/Topological_Sort/) (5 files) → `queries/topological-sort/`
- [cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher](../../cypher/Artifact_Dependencies/Artifacts_with_duplicate_packages.cypher) → `queries/exploration/`
- [cypher/Java/Annotated_code_elements.cypher](../../cypher/Java/Annotated_code_elements.cypher) → `queries/exploration/`
- [jupyter/InternalDependenciesJava.ipynb](../../jupyter/InternalDependenciesJava.ipynb) → `explore/`
- [jupyter/InternalDependenciesTypescript.ipynb](../../jupyter/InternalDependenciesTypescript.ipynb) → `explore/`
- [jupyter/PathFindingJava.ipynb](../../jupyter/PathFindingJava.ipynb) → `explore/`
- [jupyter/PathFindingTypescript.ipynb](../../jupyter/PathFindingTypescript.ipynb) → `explore/`

**Reference (read-only)**:
- [scripts/executeQueryFunctions.sh](../../scripts/executeQueryFunctions.sh) — `execute_cypher()`, `extractQueryParameter()`, `execute_cypher_queries_until_results()`
- [scripts/projectionFunctions.sh](../../scripts/projectionFunctions.sh) — `createDirectedDependencyProjection`, `createDirectedJavaTypeDependencyProjection`
- [scripts/cleanupAfterReportGeneration.sh](../../scripts/cleanupAfterReportGeneration.sh)
- [scripts/visualization/visualizeQueryResults.sh](../../scripts/visualization/visualizeQueryResults.sh) — CSV → GraphViz DOT → SVG
- [scripts/markdown/embedMarkdownIncludes.sh](../../scripts/markdown/embedMarkdownIncludes.sh) — template `<!-- include:... -->` expansion
- [scripts/reports/InternalDependenciesCsv.sh](../../scripts/reports/InternalDependenciesCsv.sh) — query ordering reference
- [scripts/reports/PathFindingCsv.sh](../../scripts/reports/PathFindingCsv.sh) — path finding logic reference
- [scripts/reports/TopologicalSortCsv.sh](../../scripts/reports/TopologicalSortCsv.sh) — topological sort logic reference
- [scripts/reports/InternalDependenciesVisualization.sh](../../scripts/reports/InternalDependenciesVisualization.sh) — build level visualization reference
- [scripts/reports/PathFindingVisualization.sh](../../scripts/reports/PathFindingVisualization.sh) — longest path visualization reference
- [domains/external-dependencies/externalDependencyCharts.py](../../domains/external-dependencies/externalDependencyCharts.py) — `Parameters`, Neo4j query pattern
- [domains/external-dependencies/externalDependenciesCsv.sh](../../domains/external-dependencies/externalDependenciesCsv.sh) — domain CSV boilerplate
- [domains/external-dependencies/summary/externalDependenciesSummary.sh](../../domains/external-dependencies/summary/externalDependenciesSummary.sh) — template assembly reference
- [domains/anomaly-detection/anomalyDetectionCsv.sh](../../domains/anomaly-detection/anomalyDetectionCsv.sh) — subdirectory creation pattern
- [domains/anomaly-detection/anomalyDetectionVisualization.sh](../../domains/anomaly-detection/anomalyDetectionVisualization.sh) — visualization delegation pattern
- [domains/anomaly-detection/anomalyDetectionMarkdown.sh](../../domains/anomaly-detection/anomalyDetectionMarkdown.sh) — markdown delegation pattern

### Verification

1. **Structure**: Domain contains 4 `.sh` entry points, 1 `.py`, 43 `.cypher` in queries/, 4 `.ipynb` in explore/, `graphs/` with `.sh`, `summary/` with `.sh` and `.md`
2. **Shell lint**: `shellcheck domains/internal-dependencies/*.sh domains/internal-dependencies/graphs/*.sh domains/internal-dependencies/summary/*.sh`
3. **Python lint**: `python -m py_compile domains/internal-dependencies/pathFindingCharts.py`
4. **Pipeline discovery**: `find domains/ -name "*Csv.sh"`, `*Python.sh`, `*Visualization.sh`, `*Markdown.sh` all return the new domain's scripts
5. **Notebook metadata**: All 4 explore/ notebooks contain `"code_graph_analysis_pipeline_data_validation": "ValidateAlwaysFalse"`
6. **Cypher count**: `find domains/internal-dependencies/queries/ -name "*.cypher" | wc -l` = 43
7. **No external changes**: No modifications to files outside `domains/internal-dependencies/`
8. **README completeness**: Documents prerequisites, entry points, folder structure, produced outputs
9. **COPIED_FILES.md**: Lists every original → copy mapping for deprecation tracking

### Scope Boundaries

**Included**: 43 Cypher queries (14 internal deps + 7 cyclic deps + 15 path finding + 5 topological sort + 2 exploration), ~27 SVG chart conversions, CSV/Visualization/Python/Markdown entry points, Markdown summary, exploration notebooks, prerequisites documentation, graph visualizations, copied files tracking

**Excluded**: Moving/deleting originals, Dependencies_Projection queries (core infrastructure), projectionFunctions.sh (core infrastructure), changes to central pipeline scripts, `Cyclic_Dependencies_Concatenated.cypher`, `Cyclic_Dependencies_as_Nodes.cypher` (unreferenced)
