<!-- include:InternalDependenciesReportFrontMatter.md -->

# 🔗 Internal Dependencies Report

## 1. Executive Overview

Analyzes internal dependencies: packages, artifacts, modules, NPM packages within codebase.

**Topics**:

- **Internal structure** — interface segregation, widely used types, and usage ratios between modules
- **Path finding** — shortest and longest path distributions revealing dependency chain depth and complexity
- **Topological sort** — build ordering derived from the acyclic view of the dependency graph

> Cyclic analysis is in `cyclic-dependencies` domain. Rows sorted by priority (highest first).

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Java Internal Structure](#2-java-internal-structure)
1. [TypeScript Internal Structure](#3-typescript-internal-structure)
1. [Path Finding](#4-path-finding)
1. [Topological Sort](#5-topological-sort)
1. [Graph Visualizations](#6-graph-visualizations)
1. [Glossary and Column Definitions](#7-glossary-and-column-definitions)
1. [Object Oriented Design Metrics](#8-object-oriented-design-metrics)
1. [Visibility Metrics](#9-visibility-metrics)
1. [Code Vocabulary](#10-code-vocabulary)

---

## 2. Java Internal Structure

### 2.1 Java Artifact Listing

Artifacts by size and connectivity. High incoming = shared library; high outgoing = aggregator/app-level.

<!-- include:List_all_Java_artifacts.md|empty.md -->

### 2.2 Interface Segregation Principle Candidates

Based on Robert C. Martin's **Interface Segregation Principle** — _"Clients should not be forced to depend upon interfaces that they do not use."_

Interfaces with many declared methods but callers use only a subset. Extract focused sub-interfaces.

`usageRatio` (lower = stronger candidate), `callerCount` (high + low ratio = high priority). `exampleCalledMethods` shows methods to extract.

<!-- include:Candidates_for_Interface_Segregation.md|empty.md -->

### 2.3 Widely Used Java Types

Types used by most packages (high ripple risk on changes). Sorted by usage count descending.

<!-- include:List_types_that_are_used_by_many_different_packages.md|empty.md -->

### 2.4 Overly Broad Artifact Dependencies

Artifact dependencies where dependents use only a small `usedPackagesPercent`. Low % = optimization/removal candidate.

A low `usedPackagesPercent` indicates that a dependent artifact imports only a small fraction of the artifact's packages.

<!-- include:How_many_packages_used_by_dependent_artifacts.md|empty.md -->

### 2.5 Class Usage Across Artifacts

Classes used across artifacts — extraction candidates. High reuse = type grown beyond original boundary.

> Rows are sorted by priority — most reused classes across artifacts first.

<!-- include:How_many_classes_used_by_dependent_packages.md|empty.md -->

### 2.6 File Distance Distribution

**File distance** = min directory changes to reach dependency. High distance = misalignment between architecture and folder structure. Distance 0 = same directory.

<!-- include:File_distance_distribution.md|empty.md -->

---

## 3. TypeScript Internal Structure

### 3.1 TypeScript Module Listing

Modules by element count and dependency connectivity. Reveals central and complex modules.

<!-- include:List_all_Typescript_modules.md|report_no_typescript_data.template.md -->

### 3.2 Widely Used TypeScript Elements

Elements imported by most modules (high ripple risk). Shared utilities or core domain concepts.

<!-- include:List_elements_used_by_many_modules.md|report_no_typescript_data.template.md -->

### 3.3 Module Element Usage by Dependent Modules

Low `usedElementsPercent` = public API wider than needed. Candidates for narrower interface.

<!-- include:How_many_elements_used_by_dependent_modules.md|report_no_typescript_data.template.md -->

---

## 4. Path Finding

Reveals dependency chain **depth and complexity**.

**All Pairs Shortest Path (APSP)**: Graph diameter = longest shortest path. Metric of structural depth.

**Longest Path**: Max directed path in DAG. Critical for build ordering. Requires acyclic graph — run after cyclic-dependencies domain.

### 4.1 Java Package Path Finding

Dependency path analysis at the Java package level. Intra-artifact pairs (both source and target in the same artifact) are highlighted; intermediate paths may cross artifact boundaries, reflecting real-world transitive coupling.

#### 4.1.1 All Pairs Shortest Path

Graph diameter = longest shortest path. Higher = deeper transitive dependencies.

<!-- include:JavaPackageAllPairsShortestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaPackageAllPairsShortestPathCharts.md|empty.md -->

#### 4.1.2 Longest Path

Deepest sequential dependency chain. Worst-case build depth if non-parallelized.

<!-- include:JavaPackageLongestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaPackageLongestPathCharts.md|empty.md -->

### 4.2 Java Artifact Path Finding

Coarsest view — artifact (JAR) level. Build parallelism and max sequential depth.

#### 4.2.1 All Pairs Shortest Path

Artifact-level graph diameter. Cycles rare at this level.

<!-- include:JavaArtifactAllPairsShortestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaArtifactAllPairsShortestPathCharts.md|empty.md -->

#### 4.2.2 Longest Path

Critical path for sequential artifact building.

<!-- include:JavaArtifactLongestPathDistribution.md|report_no_java_data.template.md -->

<!-- include:JavaArtifactLongestPathCharts.md|empty.md -->

### 4.3 TypeScript Module Path Finding

TypeScript module dependency chains. Comparable to Java Package view.

#### 4.3.1 All Pairs Shortest Path

Graph diameter = longest shortest path among module pairs. Higher = deeper transitive imports.

<!-- include:TypescriptModuleAllPairsShortestPathDistribution.md|report_no_typescript_data.template.md -->

<!-- include:TypescriptModuleAllPairsShortestPathCharts.md|empty.md -->

#### 4.3.2 Longest Path

Deepest sequential TypeScript import chain.

<!-- include:TypescriptModuleLongestPathDistribution.md|report_no_typescript_data.template.md -->

<!-- include:TypescriptModuleLongestPathCharts.md|empty.md -->

---

## 5. Topological Sort

Assigns **build level** to each node: Level 0 (no dependencies) → Level N (depends on level N−1).

**Critical path** = max level = min sequential build steps with full parallelism. Highest-level node = most central.

### 5.1 Critical Path Lengths

Max build level per abstraction. Higher = deeper sequential chain.

<!-- include:Topological_Sort_Critical_Path_Length.md|empty.md -->

Full topological sort results (node-level build order and level assignments) are in the abstraction-level CSV files under each subdirectory of `reports/internal-dependencies/`.

---

## 6. Graph Visualizations

Directed graphs: node color = build level (darker = higher level = more transitive deps above).

### 6.1 Java Artifact Graphs

**Build levels**: Full artifact hierarchy. **Longest paths**: Isolated chain + contributor view.

<!-- include:JavaArtifactGraphVisualizations.md|empty.md -->

### 6.2 TypeScript Module Graphs

**Build levels**: Module layering view. **Longest paths**: Isolated chain + contributor view.

<!-- include:TypescriptModuleGraphVisualizations.md|report_no_typescript_data.template.md -->

### 6.3 NPM Package Graphs

Build levels and longest paths for NPM packages (prod + dev dependencies).

<!-- include:NpmPackageGraphVisualizations.md|report_no_typescript_data.template.md -->

---

## 7. Glossary and Column Definitions

| Term | Definition |
|------|-----------|
| `Graph Diameter` | Longest shortest path. Structural depth metric. |
| `Longest Path` | Max directed path in DAG; critical build path. |
| `File Distance` | Min directory changes to dependency. |
| `Build Level` | Topological sort level (0 = no deps). |
| `usedTypesPercent` | % of package types actually used by dependents. Low = ISP violation. |
| `usedPackagesPercent` | % of artifact packages used by dependents. Low = wide API. |
| `usedElementsPercent` | % of module elements imported by dependents. |
| `Instability` | Outgoing / (incoming + outgoing) deps. 0 = stable; 1 = unstable. |
| `Abstractness` | (Abstract types) / (total types). 0 = concrete; 1 = abstract. |
| `Distance from Main Sequence` | Gap from ideal balance `A + I = 1`. High = pain or uselessness. |
| `Zone of Pain` | Concrete + stable = hard to change/remove. |
| `Zone of Uselessness` | Abstract + unstable = unused abstractions. |

---

## 8. Object-Oriented Design Metrics

Measures conformance to Stable Abstractions Principle(Robert C. Martin): stable components should be abstract; concrete ones unstable.

**Scatter chart**: Abstractness vs. Instability. Green diagonal = Main Sequence (`A + I = 1`). Far off = problem zone.

**Problem zones**: Zone of Pain (concrete + stable) | Zone of Uselessness (abstract + unstable).

**Bar charts**: Top connected packages/modules.

### 8.1 Java Packages (without sub-packages)

<!-- include:Java_Package_MainSequence.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncomingDependencies_Bar.md|report_no_java_data.template.md -->

<!-- include:Java_Package_OutgoingDependencies_Bar.md|report_no_java_data.template.md -->

### 8.2 Java Packages (including sub-packages)

<!-- include:Java_Package_IncludingSubpackages_MainSequence.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncludingSubpackages_IncomingDependencies_Bar.md|report_no_java_data.template.md -->

<!-- include:Java_Package_IncludingSubpackages_OutgoingDependencies_Bar.md|report_no_java_data.template.md -->

### 8.3 TypeScript Modules

<!-- include:Typescript_Module_MainSequence.md|report_no_typescript_data.template.md -->

<!-- include:Typescript_Module_IncomingDependencies_Bar.md|report_no_typescript_data.template.md -->

<!-- include:Typescript_Module_OutgoingDependencies_Bar.md|report_no_typescript_data.template.md -->

---

## 9. Visibility Metrics

Measures public vs. internal API exposure. High visibility = exposed more than necessary; low = tightly encapsulated.

**Percentile plots** (p25, p50, p75) vs. size (log scale): large artifacts vs. small visibility patterns.

**Scatter charts**: Artifact/project median visibility vs. size • Package/module individual visibility vs. size.

### 9.1 Java Visibility

#### 9.1.1 Artifact-Level Visibility Percentiles

<!-- include:Java_Artifact_VisibilityPercentiles.md|report_no_java_data.template.md -->

#### 9.1.2 Artifact-Level Relative Visibility

<!-- include:Java_Artifact_RelativeVisibility.md|report_no_java_data.template.md -->

#### 9.1.3 Package-Level Relative Visibility

<!-- include:Java_Package_RelativeVisibility.md|report_no_java_data.template.md -->

### 9.2 TypeScript Visibility

#### 9.2.1 Project-Level Visibility Percentiles

<!-- include:Typescript_Module_VisibilityPercentiles.md|report_no_typescript_data.template.md -->

#### 9.2.2 Project-Level Relative Visibility

<!-- include:Typescript_Project_RelativeVisibility.md|report_no_typescript_data.template.md -->

#### 9.2.3 Module-Level Relative Visibility

<!-- include:Typescript_Module_RelativeVisibility.md|report_no_typescript_data.template.md -->

---

## 10. Code Vocabulary

**Word cloud**: Vocabulary from all code element names (filtered for generic words). Reveals domain concepts and naming patterns.

<!-- include:CodeNamesWordcloud.md|empty.md -->
