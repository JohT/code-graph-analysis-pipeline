<!-- include:CyclicDependenciesReportFrontMatter.md -->

# ♻️ Cyclic Dependencies Report

## 1. Executive Overview

This report analyses **cyclic dependencies** within the codebase — mutual dependency cycles between Java packages, Java artifacts, and TypeScript modules.

A **cycle group** is a set of code units (packages, modules) that mutually depend on each other — A depends on B and B depends on A, directly or transitively. Cyclic dependencies prevent independent compilation, complicate testing, and make architectural layering impossible.

The `forwardToBackwardBalance` metric identifies the easiest fix path: dependencies within a cycle are classified as _forward_ (in the direction of the cycle group majority) or _backward_ (against it). Removing or reversing a backward dependency dissolves the cycle. A balance near 1.0 means almost all dependencies are forward — there are very few backward ones to remove. A balance near 0.0 means many backward dependencies exist, making the cycle harder to resolve.

> **What to act on first?**  
> Cyclic dependencies are the highest-priority structural smell — they make modular decomposition impossible.  
> **Reading the tables**: Rows are sorted by priority — the **first rows are the most critical** and should be addressed first.

## 📚 Table of Contents

1. [Executive Overview](#1-executive-overview)
1. [Java Cyclic Dependencies](#2-java-cyclic-dependencies)
1. [TypeScript Cyclic Dependencies](#3-typescript-cyclic-dependencies)
1. [Glossary](#4-glossary)

---

## 2. Java Cyclic Dependencies

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

---

## 3. TypeScript Cyclic Dependencies

### 3.1 TypeScript Module Cyclic Dependencies (Overview)

Cycle groups among TypeScript modules. Interpretation is identical to the Java package view: sorted by `forwardToBackwardBalance` descending, easiest fixes at the top.

<!-- include:Cyclic_Dependencies_for_Typescript.md|report_no_typescript_data.template.md -->

### 3.2 TypeScript Module Cyclic Dependencies (Breakdown)

Individual dependency pairs within each TypeScript cycle group.

<!-- include:Cyclic_Dependencies_Breakdown_for_Typescript.md|report_no_typescript_data.template.md -->

### 3.3 TypeScript Module Cyclic Dependencies (Backward Only)

Backward TypeScript module dependencies — the most effective candidates for breaking cycles.

<!-- include:Cyclic_Dependencies_Breakdown_Backward_Only_for_Typescript.md|report_no_typescript_data.template.md -->

---

## 4. Glossary

| Term | Definition |
|------|-----------|
| **cycle group** | A set of code units (packages, modules) that mutually depend on each other — directly or transitively. |
| **forwardToBackwardBalance** | Ratio of forward to backward dependencies within a cycle group. Values near 1.0 = mostly forward (few backward dependencies to remove to break the cycle); near 0.0 = mostly backward (harder to fix). |
| **numberForward** | Count of dependencies flowing in the majority direction within a cycle group. |
| **numberBackward** | Count of dependencies flowing against the majority direction — primary refactoring targets. |
| **forward dependency** | A dependency flowing in the direction of the cycle group majority. |
| **backward dependency** | A dependency going against the majority flow within the cycle group — highest-value candidate for removal to break the cycle. |
