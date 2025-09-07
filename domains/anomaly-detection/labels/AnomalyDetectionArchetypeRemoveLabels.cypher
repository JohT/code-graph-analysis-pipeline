// Anomaly Detection Labels: Reset/Remove all marker labels intended to be used before setting them for a clean state.

   MATCH (codeUnit)
   WHERE $projection_node_label IN labels(codeUnit)
  REMOVE codeUnit:Mark4TopAnomalyAuthority
  REMOVE codeUnit:Mark4TopAnomalyBottleneck
  REMOVE codeUnit:Mark4TopAnomalyBridge
  REMOVE codeUnit:Mark4TopAnomalyHub
  REMOVE codeUnit:Mark4TopAnomalyOutlier