//Centrality 4c Article Rank Mutate

CALL gds.articleRank.mutate(
 $dependencies_projection + '-without-empty', {
   maxIterations: 30
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,scaler: "L2Norm"
  ,relationshipWeightProperty: $dependencies_projection_weight_property
  ,mutateProperty: $dependencies_projection_write_property
})
 YIELD nodePropertiesWritten
      ,didConverge
      ,ranIterations
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution
RETURN nodePropertiesWritten
      ,didConverge
      ,ranIterations
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99
      ,centralityDistribution.p999