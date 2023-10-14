// Centrality 4b Article Rank Statistics

CALL gds.articleRank.stats(
 $dependencies_projection + '-without-empty', {
   maxIterations: 30
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
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