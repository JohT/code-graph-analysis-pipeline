// Reset all clustering results related to anomaly detection for code units to force a clean recalculation

  MATCH (codeUnit)
  WHERE $projection_node_label IN labels(codeUnit)
 REMOVE codeUnit.clusteringHDBSCANLabel
       ,codeUnit.clusteringHDBSCANProbability
       ,codeUnit.clusteringHDBSCANNoise
       ,codeUnit.clusteringHDBSCANMedoid
       ,codeUnit.clusteringHDBSCANSize