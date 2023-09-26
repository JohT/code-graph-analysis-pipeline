//Centrality 3d Page Rank Write

CALL gds.pageRank.write(
 $dependencies_projection + '-without-empty', {
   maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: $dependencies_projection_weight_property
  ,scaler: "L2Norm"
  ,writeProperty: $dependencies_projection_write_property
})
 YIELD nodePropertiesWritten
      ,ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,centralityDistribution
RETURN nodePropertiesWritten
      ,ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99