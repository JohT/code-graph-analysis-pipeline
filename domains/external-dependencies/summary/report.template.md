<!-- include:ExternalDependenciesReportFrontMatter.md -->

# 📦 External Dependencies Report

## 1. Executive Overview

Analyzes which external packages, modules, and namespaces the codebase depends on, their spread, and per-artifact usage.

> **Who imports whom?**
> High spread (many internal modules referencing the same external package) = candidate for a **facade** or **anti-corruption layer**.

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Java External Dependencies](#2-java-external-dependencies)
1. [TypeScript External Dependencies](#3-typescript-external-dependencies)
1. [Package Management](#4-package-management)
1. [SCIP External Dependencies](#5-scip-external-dependencies)
1. [Glossary](#6-glossary)

---

## 2. Java External Dependencies

### 2.1 Most Used External Packages

External Java packages by internal caller type count. High `numberOfExternalCallerTypes` = deeply embedded.

<!-- include:External_package_usage_overall.md|empty.md -->

### 2.2 Most Used External Packages — Second-Level Grouping

Second-level package names (e.g. `javax.xml` from `javax.xml.stream`) reveal **framework-level** coupling that is hidden when viewing full package names.

<!-- include:External_second_level_package_usage_overall.md|empty.md -->

### 2.3 Most Spread External Packages

Packages referenced from the highest number of **different internal packages**.  
High spread indicates a pervasive cross-cutting dependency that is hard to replace.

<!-- include:External_package_usage_spread.md|empty.md -->

### 2.4 External Package Usage per Artifact (Top)

Artifacts ranked by number of internal packages with external dependencies.

<!-- include:External_package_usage_per_artifact_sorted_top.md|empty.md -->

### 2.5 Aggregated External Package Usage per Artifact

Per-artifact: how many internal packages use external ones and their percentage.

<!-- include:External_package_usage_per_artifact_package_aggregated.md|empty.md -->

### 2.6 Java Charts

<!-- include:JavaExternalDependencyCharts.md|empty.md -->

---

## 3. TypeScript External Dependencies

### 3.1 Most Used External Modules

External npm modules ranked by how many internal TypeScript elements import them.

<!-- include:External_module_usage_overall_for_Typescript.md|empty.md -->

### 3.2 Most Used External Namespaces

Groups by namespace to reveal declaration-level coupling within npm packages.

<!-- include:External_namespace_usage_overall_for_Typescript.md|empty.md -->

### 3.3 Most Spread External Modules

External modules referenced from the highest number of **different internal TypeScript modules**.

<!-- include:External_module_usage_spread_for_Typescript.md|empty.md -->

### 3.4 External Module Usage per Internal Module (Sorted)

Which internal TypeScript modules depend on the most external modules?

<!-- include:External_module_usage_per_internal_module_sorted_for_Typescript.md|empty.md -->

### 3.5 TypeScript Charts

<!-- include:TypescriptExternalDependencyCharts.md|empty.md -->

---

## 4. Package Management

### 4.1 Maven POM Declared Dependencies

Java dependencies declared in Maven `pom.xml` files.

<!-- include:Maven_POM_dependencies.md|empty.md -->

### 4.2 package.json Declared Dependencies

Node.js dependencies declared in `package.json` files, ranked by occurrence across repository packages.

<!-- include:Package_json_dependencies_occurrence.md|empty.md -->

---

## 5. SCIP External Dependencies

Language-agnostic external dependency analysis based on SCIP index data. Groups by external artifact (`module` property). Applicable to any language with a SCIP indexer.

### 5.1 Most Used External Artifacts

External artifacts ranked by the number of distinct internal caller modules.

<!-- include:External_artifact_usage_overall_for_Scip.md|empty.md -->

#### 5.1.1 Most Used External Artifacts — Excluding Tests

<!-- include:External_artifact_usage_overall_excluding_tests_for_Scip.md|empty.md -->

#### 5.1.2 Most Used External Artifacts — Normalized Names

Groups by `packageId` (slashes replaced with dots) instead of `module`. Resolves ambiguous single-segment names such as `core` → `reactor.core`.

<!-- include:External_artifact_usage_overall_normalized_for_Scip.md|empty.md -->

### 5.2 Most Spread External Artifacts

External artifacts referenced from the highest number of distinct internal artifacts. High spread is a candidate for an Anti-Corruption Layer.

<!-- include:External_artifact_usage_spread_for_Scip.md|empty.md -->

#### 5.2.1 Most Spread External Artifacts — Excluding Tests

<!-- include:External_artifact_usage_spread_excluding_tests_for_Scip.md|empty.md -->

#### 5.2.2 Most Spread External Artifacts — Normalized Names

<!-- include:External_artifact_usage_spread_normalized_for_Scip.md|empty.md -->

### 5.3 External Artifact Usage per Internal Artifact (Top)

Internal artifacts ranked by the rate of modules with external dependencies.

<!-- include:External_artifact_usage_per_internal_artifact_sorted_top_for_Scip.md|empty.md -->

### 5.4 External Artifact Usage per Internal Module

Internal modules ranked by the number of distinct external artifacts they depend on.

<!-- include:External_artifact_usage_per_internal_module_sorted_for_Scip.md|empty.md -->

### 5.5 SCIP Charts

<!-- include:ScipExternalDependencyCharts.md|empty.md -->

---

## 6. Glossary

| Term | Definition |
|------|-----------|
| **Second-level package** | First two dot-separated segments of a package name (e.g. `org.springframework`). Used to group variant packages under one framework name. |
| **numberOfExternalCallerTypes** | Count of *internal Java types* that directly reference the external package. |
| **numberOfExternalCallerPackages** | Count of *internal Java packages* containing at least one type referencing the external package. |
| **numberOfExternalCallerElements** | Count of *internal TypeScript elements* that import from the external module. |
| **numberOfExternalCallerModules** | Count of *internal TypeScript modules* that import from the external module. |
| **sumNumberOfTypes / sumNumberOfPackages** | Sum across all artifacts of internal types/packages dependent on the external package. Measures total spread. |
| **sumNumberOfUsedExternalDeclarations** | Total distinct external declarations imported from the module across all internal modules. |
| **packagesCallingExternalRate** | Ratio of internal packages with external references to total artifact packages. |
| **typesCallingExternalRate** | Ratio of internal types with external references to total artifact types. |
| **Anti-Corruption Layer (ACL)** | Isolates the internal domain from external library APIs by wrapping them behind an internal interface. |
| **Façade** | Simplified interface hiding external library complexity. Useful when many internal modules call the same external package. |
| **Hexagonal Architecture** | Ports & Adapters style that pushes all external dependencies to the outer ring, preventing them from leaking into the core domain. |
