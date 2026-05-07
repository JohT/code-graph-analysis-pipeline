// Anomaly Detection Labels: Reset/Remove marker labels for Bridge and Outlier anomalies before relabeling.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
  REMOVE codeUnit:Mark4TopAnomalyBridge
  REMOVE codeUnit:Mark4TopAnomalyOutlier
