<!-- include:CyclicDependenciesReportFrontMatter.md -->

# ♻️ Cyclic Dependencies Report

## 1. Executive Overview

Analyzes **cyclic dependencies**: mutual cycles between Java packages, artifacts, and TypeScript modules.

**Cycle group**: Set of code units that depend on each other (A → B → A, directly or transitively). Prevents modular decomposition.

**Key metric**: `forwardToBackwardBalance` = ratio of forward to backward dependencies. Near 1.0 = easy fix (few backward deps to remove); near 0.0 = hard (many backward deps). Backward dependencies are removal candidates.

**Priority**: Rows sorted by `forwardToBackwardBalance` descending — highest priority first.

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Java Cyclic Dependencies](#2-java-cyclic-dependencies)
1. [TypeScript Cyclic Dependencies](#3-typescript-cyclic-dependencies)
1. [SCIP Semantic Index Cyclic Dependencies](#4-scip-semantic-index-cyclic-dependencies)
1. [Glossary](#5-glossary)

---

## 2. Java Cyclic Dependencies

### 2.1 Java Package Cyclic Dependencies (Overview)

`numberForward`: dependencies in cycle majority direction. `numberBackward`: against majority (removal candidates).

<!-- include:Cyclic_Dependencies.md|report_no_cycles_data.template.md -->

### 2.2 Java Package Cyclic Dependencies (Breakdown)

Individual dependency pairs per cycle group: concrete types involved.

<!-- include:Cyclic_Dependencies_Breakdown.md|report_no_cycles_data.template.md -->

### 2.3 Java Package Cyclic Dependencies (Backward Only)

Backward dependencies only — primary candidates for removal/reversal to break cycles.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only.md|report_no_cycles_data.template.md -->

### 2.4 Java Artifact Cyclic Dependencies

Artifact (JAR) level cycles — coarsest and most critical abstraction.

<!-- include:Cyclic_Dependencies_between_Artifacts.md|report_no_cycles_data.template.md -->

### 2.5 Java Package Cyclic Dependencies (Graph Visualizations)

Top cycle pairs visualized as graphs. Blue solid arrows: forward dependencies. Red dashed arrows: backward dependencies (removal candidates). Nodes are grouped by package.

<!-- include:GraphVisualizationsJavaPackageReference.md|empty.md -->

---

## 3. TypeScript Cyclic Dependencies

### 3.1 TypeScript Module Cyclic Dependencies (Overview)

TypeScript module cycles. Sorted by `forwardToBackwardBalance` descending (easiest fixes first).

<!-- include:Cyclic_Dependencies_for_Typescript.md|report_no_typescript_data.template.md -->

### 3.2 TypeScript Module Cyclic Dependencies (Breakdown)

Individual TypeScript module dependency pairs per cycle group.

<!-- include:Cyclic_Dependencies_Breakdown_for_Typescript.md|report_no_typescript_data.template.md -->

### 3.3 TypeScript Module Cyclic Dependencies (Backward Only)

Backward TypeScript dependencies — highest-value cycle breakers.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.md|report_no_typescript_data.template.md -->

### 3.4 TypeScript Module Cyclic Dependencies (Graph Visualizations)

Top TypeScript cycle pairs visualized as graphs. Blue solid arrows: forward dependencies. Red dashed arrows: backward dependencies (removal candidates). Nodes are grouped by module.

<!-- include:GraphVisualizationsTypescriptModuleReference.md|empty.md -->

---

## 4. SCIP Semantic Index Cyclic Dependencies

### 4.1 SCIP Module Cyclic Dependencies (Overview)

SCIP Semantic Index module cycles. Sorted by `forwardToBackwardBalance` descending (easiest fixes first).

<!-- include:Cyclic_Dependencies_for_SCIP_Module.md|report_no_scip_data.template.md -->

### 4.2 SCIP Module Cyclic Dependencies (Breakdown)

Individual SCIP module dependency pairs per cycle group.

<!-- include:Cyclic_Dependencies_Breakdown_for_SCIP_Module.md|report_no_scip_data.template.md -->

### 4.3 SCIP Module Cyclic Dependencies (Backward Only)

Backward SCIP module dependencies — highest-value cycle breakers.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only_for_SCIP_Module.md|report_no_scip_data.template.md -->

### 4.4 SCIP Artifact Cyclic Dependencies

SCIP artifact-level cycles — coarsest and most critical abstraction.

<!-- include:Cyclic_Dependencies_between_SCIP_Artifacts.md|report_no_scip_data.template.md -->

### 4.5 SCIP Module Cyclic Dependencies (Graph Visualizations)

Top SCIP module cycle pairs visualized as graphs. Blue solid arrows: forward dependencies. Red dashed arrows: backward dependencies (removal candidates). Nodes are grouped by module.

<!-- include:GraphVisualizationsScipModuleReference.md|empty.md -->

---

## 5. Glossary

| Term | Definition |
|------|-----------|
| **cycle group** | Set of code units that mutually depend on each other (directly or transitively). |
| **forwardToBackwardBalance** | Ratio of forward:backward dependencies. ~1.0 = easy fix; ~0.0 = hard. |
| **numberForward** | Forward dependencies in cycle majority direction. |
| **numberBackward** | Backward dependencies — removal candidates. |
| **forward dependency** | Dependency in cycle group majority direction. |
| **backward dependency** | Dependency against majority flow — highest-value removal candidate. |
| **SCIP module** | Directory-level code unit in a SCIP Semantic Index (`SemanticCodeIndexModule`). Equivalent to a Java package. |
| **SCIP artifact** | Package-level code unit in a SCIP Semantic Index (`SemanticCodeIndexArtifact`). Equivalent to a Java artifact (JAR). |
