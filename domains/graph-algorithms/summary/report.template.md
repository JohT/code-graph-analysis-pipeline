<!-- include:GraphAlgorithmsReportFrontMatter.md -->

# 📊 Graph Algorithms Report

## 1. Overview

This report summarises graph algorithm results computed from the code graph stored in Neo4j.
It covers centrality scores, community detection assignments, and node similarity.

- **Centrality** — which nodes (packages, types, artifacts) are most influential in the dependency graph
- **Community Detection** — how code units cluster into communities based on their dependencies
- **Similarity** — which code units are structurally most similar to each other (Jaccard)

> **Reading the tables**: Rows are sorted by algorithm score — the **first rows are the most significant**.

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [Centrality](#2-centrality)
1. [Community Detection](#3-community-detection)
1. [Similarity](#4-similarity)

---

## 2. Centrality

Centrality scores indicate how important a node is in the dependency graph.
High PageRank scores indicate nodes that are depended on by many other important nodes.
High betweenness scores indicate nodes that act as bridges between different parts of the graph.

### 2.1 Top Nodes by PageRank

<!-- include:TopNodesByPageRank.md|report_no_graph_data.template.md -->

### 2.2 Top Nodes by ArticleRank

<!-- include:TopNodesByArticleRank.md|report_no_graph_data.template.md -->

### 2.3 Top Nodes by Betweenness Centrality

<!-- include:TopNodesByBetweenness.md|report_no_graph_data.template.md -->

---

## 3. Community Detection

Community detection algorithms group code units that are tightly connected to each other.
High community sizes may indicate large, monolithic modules.
Many small communities may indicate well-modularised code.

### 3.1 Leiden Communities Overview

<!-- include:LeidenCommunityOverview.md|report_no_graph_data.template.md -->

### 3.2 Strongly Connected Components (SCC)

Strongly connected components identify cycles in directed dependency graphs.
Components with more than one member indicate circular dependencies.

<!-- include:SCCOverview.md|report_no_graph_data.template.md -->

### 3.3 Weakly Connected Components (WCC)

Weakly connected components identify isolated clusters of code units.

<!-- include:WCCOverview.md|report_no_graph_data.template.md -->

### 3.4 Local Clustering Coefficient

The local clustering coefficient measures how tightly interconnected a node's neighbours are.
High values indicate a node whose dependencies are also heavily dependent on each other.

<!-- include:LCCNodesByCoefficient.md|report_no_graph_data.template.md -->

---

## 4. Similarity

Node similarity (Jaccard) identifies code units that share many common dependencies.
High similarity scores may indicate duplicated or closely related functionality.

### 4.1 Top Jaccard Similarity Pairs

<!-- include:JaccardSimilarityTopPairs.md|report_no_graph_data.template.md -->
