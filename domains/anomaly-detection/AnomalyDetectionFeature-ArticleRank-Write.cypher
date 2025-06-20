// Calculates and writes the Article Rank centrality score for anomaly detection

CALL gds.articleRank.write(
 $projection_name + '-cleaned', {
   maxIterations: 50
  ,relationshipWeightProperty: $projection_weight_property
  ,scaler: "MinMax"
  ,writeProperty: 'centralityArticleRank'
})
 YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis