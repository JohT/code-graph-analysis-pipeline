//Centrality 2b Page Rank Statistics

CALL gds.pageRank.stats(
 $dependencies_projection + '-without-empty', {
   maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: $dependencies_projection_weight_property
  ,scaler: "L1Norm"
})
 YIELD ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,centralityDistribution
RETURN ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99