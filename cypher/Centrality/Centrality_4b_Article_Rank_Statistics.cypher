// Centrality 4b Article Rank Statistics

CALL gds.articleRank.stats(
 $dependencies_projection + '-cleaned', {
   maxIterations: 50
  ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
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