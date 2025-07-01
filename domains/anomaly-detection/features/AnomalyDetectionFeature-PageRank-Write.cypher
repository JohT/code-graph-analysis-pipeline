// Calculates and writes the Page Rank centrality score for anomaly detection

CALL gds.pageRank.write(
 $projection_name + '-directed-cleaned', {
   maxIterations: 50
  ,relationshipWeightProperty: $projection_weight_property
  ,writeProperty: 'centralityPageRank'
})
 YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis