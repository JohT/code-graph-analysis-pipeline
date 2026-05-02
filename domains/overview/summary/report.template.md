<!-- include:OverviewReportFrontMatter.md -->

# Overview Report

## 1. Overview

This report provides a high-level summary of the graph database contents after scanning code artifacts.

It covers the **general graph structure** (node label combinations, individual node labels, and relationship type distributions), followed by a **Java overview** (artifact sizes, type composition, and package counts), and a **TypeScript overview** (module element counts and element type composition).

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [General](#2-general)
1. [Java](#3-java)
1. [TypeScript](#4-typescript)

---

## 2. General

### 2.1 Node label combinations

Shows how many nodes carry each combination of labels and their share of the total node count.

<!-- include:NodeLabelCombinationCount.md|report_no_data.template.md -->

<!-- include:NodeLabelCombinationCharts.md|empty.md -->

---

### 2.2 Node labels

Shows the number of nodes carrying each individual label, sorted by count descending.

<!-- include:NodeLabelCount.md|report_no_data.template.md -->

<!-- include:NodeLabelCharts.md|empty.md -->

---

### 2.3 Relationship types

Shows the number of relationships for each type and their share of the total relationship count.

<!-- include:RelationshipTypeCount.md|report_no_data.template.md -->

<!-- include:RelationshipTypeCharts.md|empty.md -->

---

### 2.4 Node labels and their relationships

Shows which node labels are connected by each relationship type, with count and percentage share.
<!-- include:NodeLabelsAndTheirRelationships.md|empty.md -->

---

### 2.5 Graph density

Statistical measures of the graph structure: node count, relationship count, and density metric.

<!-- include:GeneralGraphDensity.md|empty.md -->

---

### 2.6 Dependency node labels

Shows node labels present on dependency nodes — nodes that represent external dependencies not scanned as artifacts.

<!-- include:DependencyNodeLabels.md|empty.md -->

---

## 3. Java

### 3.1 Artifact size

Overview of scanned Java artifacts: number of packages, types, methods, and lines of code.

<!-- include:JavaOverviewSize.md|report_no_data.template.md -->

### 3.2 Java overview charts

<!-- include:OverviewJavaCharts.md|empty.md -->

---

## 4. TypeScript

### 4.1 Module size

Overview of scanned TypeScript modules: number of exported language elements per module.

<!-- include:TypescriptOverviewSize.md|report_no_data.template.md -->

### 4.2 TypeScript overview charts

<!-- include:OverviewTypescriptCharts.md|empty.md -->
