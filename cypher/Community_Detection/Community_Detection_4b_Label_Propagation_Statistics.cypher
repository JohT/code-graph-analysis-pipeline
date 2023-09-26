// Community Detection Label Propagation Statistics

CALL gds.labelPropagation.stats(
 $dependencies_projection + '-without-empty', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,consecutiveIds: true
})
YIELD communityCount
     ,ranIterations
     ,didConverge
     ,preProcessingMillis
     ,computeMillis
     ,postProcessingMillis
     ,communityDistribution
RETURN communityCount
      ,ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99
      ,communityDistribution.p999