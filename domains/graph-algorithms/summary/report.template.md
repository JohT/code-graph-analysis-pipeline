<!-- include:GraphAlgorithmsReportFrontMatter.md -->

# 📊 Graph Algorithms Report

## 1. Overview

Graph algorithm results from the code graph: centrality, community detection, and node similarity.

- **Centrality** — which nodes (packages, types, artifacts) are most influential
- **Community Detection** — how code units cluster based on dependencies
- **Similarity** — which code units share the most common dependencies (Jaccard)

> **Reading the tables**: Rows are sorted by algorithm score — the **first rows are the most significant**.

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [Centrality](#2-centrality)
1. [Community Detection](#3-community-detection)
1. [Similarity](#4-similarity)

---

## 2. Centrality

High PageRank = depended on by many important nodes. High betweenness = bridge between graph parts.

### 2.1 Top Nodes by PageRank

<!-- include:TopNodesByPageRank.md|report_no_graph_data.template.md -->

### 2.2 Top Nodes by ArticleRank

<!-- include:TopNodesByArticleRank.md|report_no_graph_data.template.md -->

### 2.3 Top Nodes by Betweenness Centrality

<!-- include:TopNodesByBetweenness.md|report_no_graph_data.template.md -->

---

## 3. Community Detection

High community sizes may indicate monolithic modules; many small = well-modularised.

### 3.1 Leiden Communities Overview

<!-- include:LeidenCommunityOverview.md|report_no_graph_data.template.md -->

### 3.2 Strongly Connected Components (SCC)

Components with more than one member = circular dependencies.

<!-- include:StronglyConnectedComponentsOverview.md|report_no_graph_data.template.md -->

### 3.3 Weakly Connected Components (WCC)

Weakly connected components identify isolated clusters of code units.

<!-- include:WeaklyConnectedComponentsOverview.md|report_no_graph_data.template.md -->

### 3.4 Local Clustering Coefficient

How tightly interconnected a node's neighbours are. High = dependencies are also mutually dependent.

<!-- include:LCCNodesByCoefficient.md|report_no_graph_data.template.md -->

---

## 4. Similarity

Jaccard similarity: code units sharing common dependencies. High = potential duplication or related functionality.

### 4.1 Top Jaccard Similarity Pairs

<!-- include:JaccardSimilarityTopPairs.md|report_no_graph_data.template.md -->
