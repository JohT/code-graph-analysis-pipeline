// Community Detection Weakly Connected Components Mutate

CALL gds.wcc.mutate(
 $dependencies_projection + '-cleaned', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,mutateProperty: $dependencies_projection_write_property
     ,consecutiveIds: true
})
 YIELD componentCount
      ,nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,componentDistribution
RETURN componentCount
      ,nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,componentDistribution.min
      ,componentDistribution.mean
      ,componentDistribution.max
      ,componentDistribution.p50
      ,componentDistribution.p75
      ,componentDistribution.p90
      ,componentDistribution.p95
      ,componentDistribution.p99
      ,componentDistribution.p999