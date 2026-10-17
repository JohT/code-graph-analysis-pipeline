# Anomaly Detection Domain

This directory contains the implementation and resources related to the Anomaly Detection domain within the Code Graph Analysis Pipeline project.

The Anomaly Detection domain uses machine learning (Graph Neural Networks + Isolation Forest) to detect structural anomalies. It identifies **Bridge** nodes (structural vulnerability points) and **Outlier** nodes (structurally unusual code units).

**Note:** Structural archetypes like Authority, Bottleneck, and Hub are managed by the separate [archetypes domain](../archetypes/). This domain focuses exclusively on ML-detected anomalies.

## Entry Points

The following scripts serve as entry points for various anomaly detection tasks and reports. They will be invoked by [AllReports.sh](./../../scripts/reports/compilations/AllReports.sh) an its sub-scripts dynamically by their names.

- [anomalyDetectionCsv.sh](./anomalyDetectionCsv.sh): Entry point for CSV reports based solely on Graph queries.
- [anomalyDetectionPython.sh](./anomalyDetectionPython.sh): Entry point for Python-based anomaly detection tasks and reports.
- [anomalyDetectionVisualization.sh](./anomalyDetectionVisualization.sh): Entry point for Graph visualization reports.
- [anomalyDetectionMarkdown.sh](./anomalyDetectionMarkdown.sh): Entry point for generating the Markdown summary report.

## Folder Structure

- [documentation](./documentation): Contains documentation including architecture diagrams.
- [explore](./explore/): Jupyter notebooks for interactive, exploratory anomaly detection analysis.
  - [AnomalyDetectionScipExploration.ipynb](./explore/AnomalyDetectionScipExploration.ipynb): SCIP-specific anomaly detection exploration.
- [features](./features/): Cypher queries to extract features and run graph algorithms relevant for anomaly detection.
  - [AnomalyDetectionFeature_Abstractness_ScipInternalType.cypher](./features/AnomalyDetectionFeature_Abstractness_ScipInternalType.cypher): Abstractness for `SemanticCodeIndexInternalType`.
  - [AnomalyDetectionFeature_Abstractness_ScipModule.cypher](./features/AnomalyDetectionFeature_Abstractness_ScipModule.cypher): Abstractness for `SemanticCodeIndexModule`.
  - [AnomalyDetectionFeature_Abstractness_ScipArtifact.cypher](./features/AnomalyDetectionFeature_Abstractness_ScipArtifact.cypher): Abstractness for `SemanticCodeIndexArtifact`.
- [graphs](./graphs/): Cypher queries and GraphViz templates for Graph visualizations (Bridge/Outlier tree maps).
- [labels](./labels/): Cypher queries to label nodes as Bridge (structural vulnerability) or Outlier (structural anomaly).
- [queries](./queries/): Cypher queries to identify structural patterns (not anomalies).
- [reset](./reset/): Cypher queries to reset the graph database state related to anomaly detection.
- [summary](./summary/): Markdown templates and resources for generating the summary report.
- [scipTreemapAnomalyDetection.py](./scipTreemapAnomalyDetection.py): Generates treemap SVGs for SCIP anomaly detection results using `SemanticCodeIndexInternalType.file` paths.

## Relationship to `archetypes` Domain

- **Anomaly Detection** owns: Bridge and Outlier (ML-detected anomalies)
- **Archetypes Domain** owns: Authority, Bottleneck, Hub (structural patterns)

For structural insights at different code levels (Package, Type, Module), run both domains via:

```shell
analyze.sh --domain archetypes,anomaly-detection
```

## SCIP Support

Anomaly detection runs on SCIP-indexed code at three abstraction levels using `referenceCount` on `DEPENDS_ON` edges as the weight property:

| Level | Node Label | Minimum nodes |
|-------|-----------|---------------|
| InternalType | `SemanticCodeIndexInternalType` | 15 (Python ML pipeline) |
| Module | `SemanticCodeIndexModule` | 15 (Python ML pipeline) |
| Artifact | `SemanticCodeIndexArtifact` | 15 (Python ML pipeline) |

- The 15-node minimum is enforced by `is_sufficient_data_available` in `anomalyDetectionPython.sh`. Levels below the threshold are silently skipped.
- Treemap SVGs (`SCIPTreemap1…4.svg`) are generated for `SemanticCodeIndexInternalType` only, which has the `file` path property used for directory layout.
- CSV reports (no minimum) are always generated when nodes with `DEPENDS_ON` relationships exist.
- Explore the results interactively via [AnomalyDetectionScipExploration.ipynb](./explore/AnomalyDetectionScipExploration.ipynb).

## Pipeline Architecture Overview

![Anomaly Detection Architecture](./documentation/Architecture.svg)