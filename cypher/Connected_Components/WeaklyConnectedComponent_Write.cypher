// Calculates and writes the Weakly Connected Components

CALL gds.wcc.write(
 $dependencies_projection + '-cleaned', {
    writeProperty: 'communityWeaklyConnectedComponentId',
    consecutiveIds: true
})
YIELD componentCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis, componentDistribution
RETURN componentCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis
      ,componentDistribution.min
      ,componentDistribution.mean
      ,componentDistribution.max
      ,componentDistribution.p50
      ,componentDistribution.p75
      ,componentDistribution.p90
      ,componentDistribution.p95
      ,componentDistribution.p99
      ,componentDistribution.p999
