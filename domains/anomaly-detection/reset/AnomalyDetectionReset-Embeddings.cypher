// Reset all embeddings related to anomaly detection for code units to force a clean recalculation

  MATCH (codeUnit)
  WHERE $projection_node_label IN labels(codeUnit)
 REMOVE codeUnit.embeddingsFastRandomProjectionTunedForClustering
       ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationX
       ,codeUnit.embeddingsFastRandomProjectionTunedForClusteringVisualizationY