// Community Detection Weakly Connected Components write node property weaklyConnectedComponentId

CALL gds.wcc.write(
 $dependencies_projection + '-without-empty', {
       relationshipWeightProperty: $dependencies_projection_weight_property
      ,consecutiveIds: true
      ,writeProperty: 'weaklyConnectedComponentId'
})
YIELD componentCount
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
     ,componentDistribution
RETURN componentCount
      ,preProcessingMillis
      ,computeMillis
      ,writeMillis
      ,postProcessingMillis
      ,nodePropertiesWritten
      ,componentDistribution.min
      ,componentDistribution.mean
      ,componentDistribution.max
      ,componentDistribution.p50
      ,componentDistribution.p75
      ,componentDistribution.p90
      ,componentDistribution.p95
      ,componentDistribution.p99
      ,componentDistribution.p999