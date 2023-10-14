// Community Detection Weakly Connected Components Statistics

CALL gds.wcc.stats(
 $dependencies_projection + '-cleaned', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,consecutiveIds: true
})
 YIELD componentCount
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,componentDistribution
RETURN componentCount
      ,preProcessingMillis
      ,computeMillis
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