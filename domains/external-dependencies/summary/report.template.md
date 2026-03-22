<!-- include:ExternalDependenciesReportFrontMatter.md -->

# 📦 External Dependencies Report

## 1. Executive Overview

This report analyses which **external packages, modules, and namespaces** the codebase depends on, how widely those dependencies are spread across internal modules, and how dependency usage breaks down per artifact.

> **Who imports whom?**  
> External dependencies reveal coupling to third-party libraries, infrastructure frameworks, and platform APIs.  
> High spread (many internal modules referencing the same external package) indicates a candidate for a **facade** or **anti-corruption layer**.

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Java External Dependencies](#2-java-external-dependencies)
1. [TypeScript External Dependencies](#3-typescript-external-dependencies)
1. [Package Management](#4-package-management)
1. [Glossary](#5-glossary)

---

## 2. Java External Dependencies

### 2.1 Most Used External Packages

The table below lists external Java packages ranked by how many *internal types* call into them.  
High `numberOfExternalCallerTypes` values indicate packages that are deeply embedded in the codebase.

<!-- include:External_package_usage_overall.md|empty.md -->

### 2.2 Most Used External Packages — Second-Level Grouping

Second-level package names (e.g. `javax.xml` from `javax.xml.stream`) reveal **framework-level** coupling that is hidden when viewing full package names.

<!-- include:External_second_level_package_usage_overall.md|empty.md -->

### 2.3 Most Spread External Packages

Packages referenced from the highest number of **different internal packages**.  
High spread indicates a pervasive cross-cutting dependency that is hard to replace.

<!-- include:External_package_usage_spread.md|empty.md -->

### 2.4 External Package Usage per Artifact (Top)

Which artifacts are most exposed to external packages?  
Ranked by total number of internal packages with external dependencies.

<!-- include:External_package_usage_per_artifact_sorted_top.md|empty.md -->

### 2.5 Aggregated External Package Usage per Artifact

Statistical summary: for each artifact, how many internal packages use external ones, and what percentage is that?

<!-- include:External_package_usage_per_artifact_package_aggregated.md|empty.md -->

### 2.6 Java Charts

<!-- include:JavaExternalDependencyCharts.md|empty.md -->

---

## 3. TypeScript External Dependencies

### 3.1 Most Used External Modules

External npm modules ranked by how many internal TypeScript elements import them.

<!-- include:External_module_usage_overall_for_Typescript.md|empty.md -->

### 3.2 Most Used External Namespaces

Some npm packages expose multiple namespaces. This view groups by namespace to show  
declaration-level coupling within a package.

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

Java dependencies declared in Maven `pom.xml` files — declared vs. analysed.

<!-- include:Maven_POM_dependencies.md|empty.md -->

### 4.2 package.json Declared Dependencies

TypeScript / Node.js dependencies declared in `package.json` files, ranked by occurrence
across repository packages.

<!-- include:Package_json_dependencies_occurrence.md|empty.md -->

---

## 5. Glossary

| Term | Definition |
|------|-----------|
| **External dependency** | A type, module, or namespace whose source code is *not* part of the scanned internal codebase. |
| **External package** | A fully-qualified Java package belonging to an external library (e.g. `org.springframework.web`). |
| **Second-level package** | The first two dot-separated segments of a package name (e.g. `org.springframework`). Used to group many variant packages under one framework name. |
| **External module** | A TypeScript/JavaScript npm package imported via `import ... from 'module-name'`. |
| **External namespace** | A named export group within an external TypeScript module (e.g. `node:fs`, `@angular/core`). |
| **numberOfExternalCallerTypes** | Count of *internal Java types* that directly reference the external package. |
| **numberOfExternalCallerPackages** | Count of *internal Java packages* that contain at least one type referencing the external package. |
| **numberOfExternalCallerElements** | Count of *internal TypeScript elements* (functions, classes, variables) that import from the external module. |
| **numberOfExternalCallerModules** | Count of *internal TypeScript modules* that import from the external module. |
| **sumNumberOfTypes / sumNumberOfPackages** | Sum across all artifacts of internal types/packages dependent on the external package. Measures total spread. |
| **sumNumberOfUsedExternalDeclarations** | Total distinct external declarations (functions, types) imported from the module across all internal modules. |
| **packagesCallingExternalRate** | Ratio of internal packages with external references to total artifact packages. |
| **typesCallingExternalRate** | Ratio of internal types with external references to total artifact types. |
| **Anti-Corruption Layer (ACL)** | An architectural pattern that isolates the internal domain from external library APIs by wrapping them behind an internal interface. Recommended when a high-spread dependency must be replaced or abstracted. |
| **Façade** | A simplified interface that hides the complexity of one or more external libraries. Useful when many internal modules call the same external package. |
| **Hexagonal Architecture** | An architectural style (Ports & Adapters) that pushes all external dependencies to the outer ring, preventing them from leaking into the core domain. |
