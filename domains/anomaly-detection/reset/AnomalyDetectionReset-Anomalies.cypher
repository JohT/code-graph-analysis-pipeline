// Reset all results related to anomaly detection for code units to force a clean recalculation

  MATCH (codeUnit)
  WHERE $projection_node_label IN labels(codeUnit)
 REMOVE codeUnit.anomalyLabel
       ,codeUnit.anomalyScore
       ,codeUnit.anomalyTopFeature1
       ,codeUnit.anomalyTopFeature2
       ,codeUnit.anomalyTopFeature3
       ,codeUnit.anomalyTopFeatureSHAPValue1
       ,codeUnit.anomalyTopFeatureSHAPValue2
       ,codeUnit.anomalyTopFeatureSHAPValue3