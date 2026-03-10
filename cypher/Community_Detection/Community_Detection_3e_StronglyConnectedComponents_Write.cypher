// Community Detection Strongly Connected Components write node property communityStronglyConnectedComponentId

CALL gds.scc.write(
 $dependencies_projection + '-cleaned', {
       consecutiveIds: true
      ,writeProperty: 'communityStronglyConnectedComponentId'
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