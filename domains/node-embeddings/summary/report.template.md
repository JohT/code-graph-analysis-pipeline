<!-- include:NodeEmbeddingsReportFrontMatter.md -->

# 🧬 Node Embeddings Report

## 1. Overview

This report summarises node embedding vectors computed from the code dependency graph via the Neo4j Graph Data Science Library.

Node embeddings approximate the structural position of each code unit (package, type, artifact, module) in the graph as a fixed-length vector of floating-point numbers. The embeddings are computed using:

- **FastRP** (Fast Random Projection) — efficient approximate embedding based on random projections
- **HashGNN** (Hash Graph Neural Networks) — lightweight GNN-inspired embedding
- **Node2Vec** — random-walk-based embedding that captures local neighbourhood structure

The UMAP scatter plots visualise the embeddings projected to 2D. Points are coloured by Leiden community (when available) to show how well the embeddings capture community structure.

## 📚 Table of Contents

1. [Overview](#1-overview)
1. [Embedding Properties](#2-embedding-properties)
1. [Embeddings with Community and Centrality](#3-embeddings-with-community-and-centrality)
1. [Package Embedding Charts](#4-package-embedding-charts)
1. [Artifact Embedding Charts](#5-artifact-embedding-charts)
1. [Type Embedding Charts](#6-type-embedding-charts)
1. [Module Embedding Charts](#7-module-embedding-charts)

---

## 2. Embedding Properties

Shows which embedding properties exist and on how many nodes per label.

<!-- include:EmbeddingPropertiesOverview.md|report_no_embedding_data.template.md -->

---

## 3. Embeddings with Community and Centrality

Sample of nodes showing FastRP embedding dimension count alongside Leiden community id and PageRank centrality.
Useful to verify that the embedding pipeline ran end-to-end and that the properties are co-located on the same nodes.

<!-- include:NodeEmbeddingsWithCommunityAndCentrality.md|report_no_embedding_data.template.md -->

---

## 4. Package Embedding Charts

UMAP 2D projections of Package node embeddings. Each algorithm produces one scatter plot.

<!-- include:PackageEmbeddingCharts.md|empty.md -->

---

## 5. Artifact Embedding Charts

UMAP 2D projections of Artifact node embeddings. Each algorithm produces one scatter plot.

<!-- include:ArtifactEmbeddingCharts.md|empty.md -->

---

## 6. Type Embedding Charts

UMAP 2D projections of Java Type node embeddings. Each algorithm produces one scatter plot.

<!-- include:TypeEmbeddingCharts.md|empty.md -->

---

## 7. Module Embedding Charts

UMAP 2D projections of TypeScript Module node embeddings. Each algorithm produces one scatter plot.

<!-- include:ModuleEmbeddingCharts.md|empty.md -->
