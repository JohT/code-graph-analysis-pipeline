// Community Detection Label Propagation Mutate

CALL gds.labelPropagation.mutate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,mutateProperty: $dependencies_projection_write_property
    ,consecutiveIds: true
})
YIELD ranIterations
     ,didConverge
     ,communityCount
     ,preProcessingMillis
     ,computeMillis
     ,mutateMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
     ,communityDistribution
RETURN ranIterations
      ,didConverge
      ,communityCount
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,nodePropertiesWritten
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99
      ,communityDistribution.p999