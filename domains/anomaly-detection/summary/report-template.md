# 📊 Anomaly Detection Report

## 1. Executive Overview

This report analyzes structural and dependency anomalies across multiple abstraction levels of the codebase.
The goal is to detect potential **software quality, design, and architecture issues** using graph-based features, anomaly detection (Isolation Forest), and SHAP explainability.

### 1.1 Overview of Analyzed Structures

<!-- include:AnomaliesPerAbstractionLayer.md -->

### 1.2 Anomalies in total

<!-- include:AnomaliesPerAbstractionLayer.md -->

## 2. Deep Dives by Abstraction Level

<!-- include:AnomalyDetectionDeepDives.md -->

## 3. Taxonomy of Anomaly Archetypes

| Archetype | Feature Profile | Risk for Architecture |
|-----------|----------------|------------------------|
| **Hub** | High degree, low clustering coefficient | Central dependency, fragile hotspot |
| **Bottleneck** | High betweenness, low redundancy | Single point of failure, slows evolution |
| **Outlier** | High cluster distance, small cluster size | Misfit component, unusual dependency pattern |
| **Authority** | High PageRank but low articleRank | Over-relied utility with few reverse connections |
| **Bridge** | Embedding-driven anomaly, cross-cluster | Connects unrelated domains, risky coupling |

---

## 4. Recommendations

* **Refactor hubs:** Break down god classes/utilities into smaller abstractions.
* **Mitigate bottlenecks:** Add redundancy or alternative paths.
* **Investigate outliers:** Validate if they are justified exceptions or design flaws.
* **Enforce cohesion:** Raise clustering coefficient via better modular boundaries.
* **Stabilize authorities:** Encapsulate widely used but locally weak components, reduce over-generalization, and ensure stable APIs.  
* **Clarify bridges:** Validate whether cross-cluster connectors are intentional (adapters/facades) or accidental; refactor or relocate responsibilities to preserve modularity.

---

## 5. Appendix

* **Methodology:** Isolation Forest, Random Forest proxy, SHAP explanations.
* **Embedding generation:** Fast Random Projection, PCA (20–35 dims, \~0.9 target variance).
* **Clustering:** HDBSCAN tuned against Leiden communities (golden reference, AMI optimization).
* **Optimization:** Hyperparameter optimization for both Isolation Forest and Random Forest proxy with their F1 score
* **Feature set:**
  * Degree
  * PageRank
  * ArticleRank
  * Page-to-Article Rank Difference
  * Betweenness
  * Local Clustering Coefficient
  * Cluster Approximate Outlier Score ( = 1.0 - Cluster Probability)
  * Cluster Radius Average
  * Cluster Distance to Medoid
  * Cluster Size
  * Node Embedding
