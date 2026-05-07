// Calculates and writes the Article Rank centrality score to determine archetypes.

CALL gds.articleRank.write(
 $projection_name + '-directed-cleaned', {
   maxIterations: 50
  ,relationshipWeightProperty: $projection_weight_property
  ,writeProperty: 'centralityArticleRank'
})
 YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis