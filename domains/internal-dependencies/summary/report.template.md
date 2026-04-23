<!-- include:InternalDependenciesReportFrontMatter.md -->

# 🔗 Internal Dependencies Report

## 1. Executive Overview

This report analyses how **internal packages, artifacts, TypeScript modules, and NPM packages depend on each other** within the codebase. It covers four interconnected topics:

- **Cyclic dependencies** — mutual dependency cycles that complicate builds and impede refactoring
- **Internal structure** — interface segregation, widely used types, and usage ratios between modules
- **Path finding** — shortest and longest path distributions revealing dependency chain depth and complexity
- **Topological sort** — build ordering derived from the acyclic view of the dependency graph

> **What to act on first?**  
> Cyclic dependencies are the highest-priority structural smell — they make modular decomposition impossible.  
> After eliminating cycles, use path finding results to identify and reduce excessive transitive depth.   
> **Reading the tables**: Rows are sorted by priority — the **first rows are the most critical** and should be addressed first.

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Cyclic Dependencies](#2-cyclic-dependencies)
1. [Java Internal Structure](#3-java-internal-structure)
1. [TypeScript Internal Structure](#4-typescript-internal-structure)
1. [Path Finding](#5-path-finding)
1. [Topological Sort](#6-topological-sort)
1. [Graph Visualizations](#7-graph-visualizations)
1. [Glossary and Column Definitions](#8-glossary-and-column-definitions)
1. [Object Oriented Design Metrics](#9-object-oriented-design-metrics)
1. [Visibility Metrics](#10-visibility-metrics)
1. [Code Vocabulary](#11-code-vocabulary)

---

## 2. Cyclic Dependencies

A **cycle group** is a set of code units (packages, modules) that mutually depend on each other — A depends on B and B depends on A, directly or transitively. Cyclic dependencies prevent independent compilation, complicate testing, and make architectural layering impossible.

The `forwardToBackwardBalance` metric identifies the easiest fix path: dependencies within a cycle are classified as _forward_ (in the direction of the cycle group majority) or _backward_ (against it). Removing or reversing a backward dependency dissolves the cycle. A balance near 1.0 means almost all dependencies are forward — there are very few backward ones to remove. A balance near 0.0 means many backward dependencies exist, making the cycle harder to resolve.

See [Section 3.1](#31-java-artifact-listing) for artifact sizes and dependency counts — useful for gauging the impact of cycles found here.

### 2.1 Java Package Cyclic Dependencies (Overview)

Each row represents one cycle group. `numberForward` counts how many dependencies flow in the direction of the cycle; `numberBackward` counts those going against it. Sorted by `forwardToBackwardBalance` descending — the top rows are the easiest to fix (fewest backward dependencies to remove).

<!-- include:Cyclic_Dependencies.md|report_no_cycles_data.template.md -->

### 2.2 Java Package Cyclic Dependencies (Breakdown)

Expands each cycle group into individual dependency pairs in `type1 → type2` format, showing both forward and backward dependencies. Use this to understand the concrete classes involved in each cycle.

<!-- include:Cyclic_Dependencies_Breakdown.md|report_no_cycles_data.template.md -->

### 2.3 Java Package Cyclic Dependencies (Backward Only)

Shows only the _backward_ dependencies — those going against the majority flow within the cycle group. These are the highest-value candidates for removal or reversal to break the cycle entirely.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only.md|report_no_cycles_data.template.md -->

### 2.4 Java Artifact Cyclic Dependencies

Cyclic dependencies at the artifact (JAR) level — the coarsest and most critical abstraction. Each row is one dependency that participates in a cycle between artifacts.

<!-- include:Cyclic_Dependencies_between_Artifacts.md|report_no_cycles_data.template.md -->

### 2.5 TypeScript Module Cyclic Dependencies (Overview)

Cycle groups among TypeScript modules. Interpretation is identical to the Java package view: sorted by `forwardToBackwardBalance` descending, easiest fixes at the top.

<!-- include:Cyclic_Dependencies_for_Typescript.md|report_no_typescript_data.template.md -->

### 2.6 TypeScript Module Cyclic Dependencies (Breakdown)

Individual dependency pairs within each TypeScript cycle group.

<!-- include:Cyclic_Dependencies_Breakdown_for_Typescript.md|report_no_typescript_data.template.md -->

### 2.7 TypeScript Module Cyclic Dependencies (Backward Only)

Backward TypeScript module dependencies — the most effective candidates for breaking cycles.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.md|report_no_typescript_data.template.md -->

---

## 3. Java Internal Structure

### 3.1 Java Artifact Listing

All Java artifacts (JARs) sorted by their number of packages, types, and incoming/outgoing dependencies. Reveals the largest and most connected components in the build. Large incoming dependency counts indicate widely shared libraries; large outgoing counts indicate aggregator or application-level modules.

<!-- include:List_all_Java_artifacts.md|empty.md -->

### 3.2 Interface Segregation Principle Candidates

Based on Robert C. Martin's **Interface Segregation Principle** — _"Clients should not be forced to depend upon interfaces that they do not use."_

This table lists Java interfaces that declare many public methods while one or more groups of callers invoke only a small subset. Each row is one such interface: how many methods it declares in total (including inherited), how many distinct callers actually use, the `usageRatio` (lower = stronger candidate), the number of distinct caller types, and the actual method names they call. Together these tell you precisely which focused sub-interface to extract.

**Rows are sorted by priority — the first rows (lowest `usageRatio`, highest `callerCount`) are the most critical candidates.**

Interpretation guidance:

- `usageRatio` near 0 means callers use almost none of the API — strong extraction candidate.
- High `callerCount` with low `usageRatio` signals that extracting a small sub-interface benefits many callers (higher priority).
- `exampleCalledMethods` is the concrete set of methods to expose on the new interface.


<!-- include:Candidates_for_Interface_Segregation.md|empty.md -->

### 3.3 Widely Used Java Types

Types used by the highest number of _different_ packages. These are typically cross-cutting concerns, core domain objects, or shared utilities. A very high usage count means that changes to these types will ripple across many calling packages.

**Rows are sorted by priority — the first rows (most widely used types) carry the highest risk for ripple effects.**

<!-- include:List_types_that_are_used_by_many_different_packages.md|empty.md -->

### 3.4 Overly Broad Artifact Dependencies

Identifies potentially unnecessary or over-broad artifact dependencies. For each artifact, shows which other artifacts depend on it and what percentage of its packages are actually used by those dependents. 

A low `usedPackagesPercent` indicates that a dependent artifact imports only a small fraction of the artifact's packages—suggesting the dependency might be unnecessarily broad. In such cases, the dependent artifact may only need to import a focused subset of the target artifact's packages, or might not need the dependency at all.

**Rows are sorted by priority — the first rows (lowest `usedPackagesPercent`) are the best candidates for optimization or removal.**

<!-- include:How_many_packages_used_by_dependent_artifacts.md|empty.md -->

### 3.5 Class Usage Across Artifacts

Classes that are used by multiple different artifacts — candidates for extraction into a shared library. High cross-artifact reuse indicates that a type has grown beyond its original module boundary.

**Rows are sorted by priority — the first rows (most reused classes across artifacts) are the highest-value extraction candidates.**

<!-- include:How_many_classes_used_by_dependent_packages.md|empty.md -->

### 3.6 File Distance Distribution

The **file distance** between a source file and the dependency it uses is the minimum number of `cd` (change directory) commands required to navigate from one to the other in the filesystem. It provides an intuitive measure of physical co-location:

- **Distance 0**: Both files are in the same directory — tightly co-located.
- **Distance 1**: One directory apart — closely related.
- **Distance N**: N traversals required — the files are in very different parts of the source tree.

High average distances indicate that architectural boundaries do not align with the directory structure.

<!-- include:File_distance_distribution.md|empty.md -->

---

## 4. TypeScript Internal Structure

### 4.1 TypeScript Module Listing

All TypeScript modules sorted by their number of elements (functions, classes, interfaces), and incoming/outgoing dependency counts. Reveals the most central and most complex modules.

<!-- include:List_all_Typescript_modules.md|report_no_typescript_data.template.md -->

### 4.2 Widely Used TypeScript Elements

TypeScript elements (functions, classes, interfaces, type aliases) that are imported by the highest number of different modules. High usage counts indicate shared utilities or core domain concepts that many modules rely on.

**Rows are sorted by priority — the first rows (most widely used elements) carry the highest risk for ripple effects.**

<!-- include:List_elements_used_by_many_modules.md|report_no_typescript_data.template.md -->

### 4.3 Module Element Usage by Dependent Modules

For each TypeScript module, which other modules import it and how many of its exposed elements do they actually use? A low `usedElementsPercent` signals that the module's public API is wider than what callers need — a candidate for splitting into a leaner interface.

**Rows are sorted by priority — the first rows (lowest `usedElementsPercent`) are the strongest candidates for a narrower API.**

<!-- include:How_many_elements_used_by_dependent_modules.md|report_no_typescript_data.template.md -->

---

## 5. Path Finding

Path finding algorithms reveal the **depth and complexity of dependency chains**.

- **All Pairs Shortest Path (APSP)**: For every connected pair of nodes, computes the minimum number of hops (direct dependency = distance 1, one intermediary = distance 2, etc.). The **graph diameter** — the longest shortest path — is the key complexity metric: a diameter of 6 means at least one pair of modules requires a chain of 6 transitive dependencies to connect.
- **Longest Path** (for directed acyclic graphs): The maximum-length directed path through the dependency graph. Relevant for build ordering — a node can only be built after all its transitive dependencies. A long longest path means a deep sequential build chain.

> **Note on Longest Path**: The algorithm requires a Directed Acyclic Graph (DAG). Results are unreliable when cyclic dependencies exist. Eliminate cycles first for accurate results.

### 5.1 Java Package Path Finding

Dependency path analysis at the Java package level. Intra-artifact pairs (both source and target in the same artifact) are highlighted; intermediate paths may cross artifact boundaries, reflecting real-world transitive coupling.

#### 5.1.1 All Pairs Shortest Path

The graph diameter reveals the longest shortest path among all package pairs. Higher values indicate deeper transitive dependencies and more interconnectedness.

<!-- include:JavaPackageAllPairsShortestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaPackageAllPairsShortestPathCharts.md|empty.md -->

#### 5.1.2 Longest Path

The maximum-length path through the dependency graph shows the deepest sequential dependency chain. For Java packages, this represents the worst-case build order depth if dependencies cannot be parallelized.

<!-- include:JavaPackageLongestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaPackageLongestPathCharts.md|empty.md -->

### 5.2 Java Artifact Path Finding

Dependency path analysis at the artifact (JAR) level — the coarsest view. Useful for understanding build parallelism and maximum sequential build depth.

#### 5.2.1 All Pairs Shortest Path

The graph diameter at the artifact level. Artifact-level cycles are rare, so this metric is reliable for understanding transitive build dependencies.

<!-- include:JavaArtifactAllPairsShortestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaArtifactAllPairsShortestPathCharts.md|empty.md -->

#### 5.2.2 Longest Path

The longest dependency sequence at the artifact level—the critical path for sequential artifact building.

<!-- include:JavaArtifactLongestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaArtifactLongestPathCharts.md|empty.md -->

### 5.3 TypeScript Module Path Finding

Dependency path analysis for TypeScript modules. Comparable to the Java Package view; a long longest path indicates deep sequential import chains.

#### 5.3.1 All Pairs Shortest Path

The graph diameter reveals the longest shortest path among all TypeScript module pairs. Higher values indicate deeper transitive import dependencies.

<!-- include:TypescriptModuleAllPairsShortestPathDistribution.md|report_no_typescript_data.template.md -->

<!-- include:TypescriptModuleAllPairsShortestPathCharts.md|empty.md -->

#### 5.3.2 Longest Path

The maximum-length path through the dependency graph shows the deepest sequential import chain for TypeScript modules.

<!-- include:TypescriptModuleLongestPathDistribution.md|report_no_typescript_data.template.md -->

<!-- include:TypescriptModuleLongestPathCharts.md|empty.md -->

---

## 6. Topological Sort

Topological sorting assigns a **build level** to every node in the dependency graph:

- **Level 0**: No dependencies — can be built first, in parallel with all other level-0 nodes.
- **Level N**: Depends on at least one node at level N−1. Must be built after all lower levels.

The maximum level is the **critical path length** — the minimum number of sequential build steps even with full parallelism. Reducing this number (by removing unnecessary dependencies) directly speeds up builds.

> **Interpretation of extremes**: The node at the **highest level** is the most central — all others (transitively) must be built before it. The node at **level 0** is the most peripheral — it depends on nothing.

### 6.1 Critical Path Lengths

The table below summarises the maximum build level (critical path length) and the total number of sorted nodes per abstraction level. A higher `maxBuildLevel` means a deeper mandatory sequential build chain.

<!-- include:Topological_Sort_Critical_Path_Length.md|empty.md -->

Full topological sort results (node-level build order and level assignments) are in the abstraction-level CSV files under each subdirectory of `reports/internal-dependencies/`.

---

## 7. Graph Visualizations

Directed dependency graphs showing build levels (node color = level) and longest path structures.
Each graph uses the topological sort level to color nodes: darker colors indicate higher levels (more transitive dependencies above them).

### 7.1 Java Artifact Graphs

**Build levels graph**: Directed graph of Java artifacts where node color corresponds to build level. Level-0 artifacts (no dependencies) appear in the lightest color. Reveals the full artifact dependency hierarchy.

**Longest paths graphs**: Isolated view shows only the nodes and edges on the longest dependency chain. Contributor view adds all artifacts that feed into (contribute to) that chain.

<!-- include:JavaArtifactGraphVisualizations.md|empty.md -->

### 7.2 TypeScript Module Graphs

**Build levels graph**: TypeScript module dependency graph, colored by topological sort level. Useful for understanding module layering and identifying circular or overly deep dependency chains.

**Longest paths graphs**: Isolated and contributor views of the longest TypeScript dependency chain.

<!-- include:TypescriptModuleGraphVisualizations.md|report_no_typescript_data.template.md -->

### 7.3 NPM Package Graphs

Build level and longest path graphs for NPM packages (both production and development dependencies).

<!-- include:NpmPackageGraphVisualizations.md|report_no_typescript_data.template.md -->

---

## 8. Glossary and Column Definitions

| Term | Definition |
|------|-----------|
| `forwardToBackwardBalance` | Ratio of forward-to-total dependencies within a cycle group. Values near 1.0 = mostly forward (few backward dependencies to remove to break the cycle); near 0.0 = mostly backward (harder to fix). |
| `numberForward` | Count of dependencies flowing in the majority direction within a cycle group. |
| `numberBackward` | Count of dependencies flowing against the majority direction — primary refactoring targets. |
| `Graph Diameter` | The longest shortest path across all pairs in the dependency graph. A measure of structural depth and complexity. Higher values indicate more transitive coupling. |
| `Longest Path` | Maximum-length directed path through the DAG — the worst-case dependency chain and the critical build path. |
| `File Distance` | Minimum number of directory traversals between a source file and the file it depends on. Distance 0 = same directory; Distance N = N `cd` commands required. |
| `Build Level` | Topological sort level. Level 0 = no dependencies; Level N = depends on nodes at levels 0 through N−1. Minimum sequential build steps = max level + 1. |
| `usedTypesPercent` | Percentage of a package's types that dependent packages actually use. Low values indicate Interface Segregation violations. |
| `usedPackagesPercent` | Percentage of packages within an artifact that dependent artifacts actually import. Low values indicate wide API surfaces. |
| `usedElementsPercent` | Percentage of TypeScript module elements that dependent modules actually import. |
| `pairCount` | Number of node pairs at a given path distance. |
| `distanceTotalPairCount` | Total number of connected node pairs across all distances (used for normalisation). |
| `isDifferentTargetProject` | Whether the source and target node belong to different projects/artifacts. |
| `Instability` | Ratio of outgoing to total (incoming + outgoing) dependencies for a package or module. 0 = fully stable (no outgoing couplings); 1 = fully unstable (no incoming). Stable components are harder to change; unstable ones are easier. |
| `Abstractness` | Ratio of abstract types (abstract classes + interfaces) to total types in a package or module. 0 = fully concrete; 1 = fully abstract. Abstract components are more flexible but require concrete implementations elsewhere. |
| `Distance from Main Sequence` | How far a component is from the ideal balance line `A + I = 1` (the "Main Sequence"). Distance 0 = perfectly balanced; higher values indicate components in the Zone of Pain or Zone of Uselessness. |
| `Zone of Pain` | Low abstractness + low instability — components that are concrete yet stable. Difficult to extend and difficult to remove; changes have a wide blast radius. |
| `Zone of Uselessness` | High abstractness + high instability — abstract components with no stable consumers. Effectively dead abstractions that could be removed. |

---

## 9. Object-Oriented Design Metrics

**Object-Oriented Design metrics** measure how well packages and modules conform to Robert C. Martin's _Stable Abstractions Principle_: _"A component should be as abstract as it is stable."_ Components that are stable (many dependents, few dependencies of their own) should rely heavily on abstractions so that they can still be extended. Concrete components should be unstable so they can be changed freely.

The scatter chart plots every component on the **Abstractness vs. Instability** plane. The green dashed diagonal is the **Main Sequence** (`A + I = 1`). Components near the line are well-balanced; those far from it occupy one of two problem zones:

- **Zone of Pain** (bottom-left corner): concrete and stable — cannot be changed or extended easily.
- **Zone of Uselessness** (top-right corner): abstract and unstable — nobody depends on these abstractions.

**Bar charts** show the top packages/modules by incoming and outgoing dependency counts, making it easy to spot the most heavily connected elements.

### 9.1 Java Packages (without sub-packages)

<!-- include:Java_Package_MainSequence.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncomingDependencies_Bar.md|report_no_java_data.template.md -->

<!-- include:Java_Package_OutgoingDependencies_Bar.md|report_no_java_data.template.md -->

### 9.2 Java Packages (including sub-packages)

<!-- include:Java_Package_IncludingSubpackages_MainSequence.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncludingSubpackages_IncomingDependencies_Bar.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncludingSubpackages_OutgoingDependencies_Bar.md|report_no_java_data.template.md -->

### 9.3 TypeScript Modules

<!-- include:Typescript_Module_MainSequence.md|report_no_typescript_data.template.md -->

<!-- include:Typescript_Module_IncomingDependencies_Bar.md|report_no_typescript_data.template.md -->

<!-- include:Typescript_Module_OutgoingDependencies_Bar.md|report_no_typescript_data.template.md -->

---

## 10. Visibility Metrics

**Visibility metrics** measure how much of a component's API is exposed publicly versus kept internal. A high relative visibility means most types or elements are public — potentially exposing more than necessary. A low relative visibility means a tightly encapsulated API.

The **percentile subplots** display three percentile levels of relative visibility (p25, p50, p75) against the artifact or project's total type/element count on a log scale. This reveals whether large, complex artifacts tend to expose more or less of their API compared to smaller ones.

The **artifact/project scatter** plots each artifact or project as a single point using its median (p50) relative visibility versus its size — a quick view for identifying outliers at the coarsest granularity.

The **package/module scatter** shows relative visibility for every individual package or module against its type/element count — useful for identifying outlier packages with unusually high or low visibility.

### 10.1 Java Visibility

#### 10.1.1 Artifact-Level Visibility Percentiles

<!-- include:Java_Artifact_VisibilityPercentiles.md|report_no_java_data.template.md -->

#### 10.1.2 Artifact-Level Relative Visibility

<!-- include:Java_Artifact_RelativeVisibility.md|report_no_java_data.template.md -->

#### 10.1.3 Package-Level Relative Visibility

<!-- include:Java_Package_RelativeVisibility.md|report_no_java_data.template.md -->

### 10.2 TypeScript Visibility

#### 10.2.1 Project-Level Visibility Percentiles

<!-- include:Typescript_Module_VisibilityPercentiles.md|report_no_typescript_data.template.md -->

#### 10.2.2 Project-Level Relative Visibility

<!-- include:Typescript_Project_RelativeVisibility.md|report_no_typescript_data.template.md -->

#### 10.2.3 Module-Level Relative Visibility

<!-- include:Typescript_Module_RelativeVisibility.md|report_no_typescript_data.template.md -->

---

## 11. Code Vocabulary

The **word cloud** visualises the vocabulary used across all code element names — package names, class names, method names, type names, module names. Frequently occurring words appear larger.

Common generic words (`builder`, `handler`, `util`, `factory`, `type`, `module`, `get`, `set`, …) are filtered out so that domain-specific and project-specific words stand out. Words that dominate the cloud reveal the core domain concepts and architectural patterns in use. Unexpected clusters of non-domain words may indicate naming inconsistencies or missing abstraction layers.

<!-- include:CodeNamesWordcloud.md|empty.md -->
