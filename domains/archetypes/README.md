# Archetypes Domain

This directory contains the implementation and resources related to the Archetypes domain within the Code Graph Analysis Pipeline project.

The Archetypes domain classifies code units into structural archetypes based on graph metrics (PageRank, Betweenness centrality, local clustering coefficient). Archetype detection uses Cypher queries; optional treemap visualization of results is generated via Python.

## Archetypes

| Archetype | Description | Key Metric |
|-----------|-------------|------------|
| **Authority** | Widely referenced but contributes less back — utility libraries, framework entry points | High PageRank, high PageRank-to-ArticleRank difference |
| **Bottleneck** | Critical hubs that control flow — if removed, module communication breaks | High Betweenness centrality |
| **Hub** | Many connections but not well integrated into a cluster | High degree, low local clustering coefficient |

## Entry Points

The following scripts serve as entry points for various archetype tasks and reports. They will be invoked by [AllReports.sh](./../../scripts/reports/compilations/AllReports.sh) and its sub-scripts dynamically by their names.

- [archetypesCsv.sh](./archetypesCsv.sh): Entry point for CSV reports — computes features, runs structural queries, and writes archetype labels.
- [archetypesVisualization.sh](./archetypesVisualization.sh): Entry point for Graph visualization reports.
- [archetypesMarkdown.sh](./archetypesMarkdown.sh): Entry point for generating the Markdown summary report.

## Folder Structure

- [features](./features/): Cypher queries to extract features and run graph algorithms (copies from anomaly-detection).
- [graphs](./graphs/): Cypher queries and GraphViz templates for Graph visualizations (Authority, Bottleneck, Hub).
- [labels](./labels/): Cypher queries to label nodes with `Mark4TopArchetypeAuthority`, `Mark4TopArchetypeBottleneck`, `Mark4TopArchetypeHub`.
- [queries](./queries/): Heuristic structural Cypher queries (dependency orchestrators, bottlenecks, bridges, etc.).
- [summary](./summary/): Markdown templates and resources for generating the summary report.

## Relationship to `anomaly-detection`

The archetypes domain uses the same `archetypeAuthorityRank`, `archetypeBottleneckRank`, `archetypeHubRank` properties as the `anomaly-detection` domain. When both domains run, the `anomaly-detection` domain skips Authority/Bottleneck/Hub labeling if archetypes already set those properties (skip-if-exists pattern).

`anomaly-detection` exclusively owns `Mark4TopAnomalyBridge`/`anomalyBridgeRank` and `Mark4TopAnomalyOutlier`/`anomalyOutlierRank` (ML-dependent archetypes).
