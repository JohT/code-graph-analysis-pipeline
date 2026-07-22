// Calculates and writes the Strongly Connected Components

CALL gds.scc.write(
 $dependencies_projection + '-cleaned', {
    writeProperty: 'communityStronglyConnectedComponentId',
    consecutiveIds: true
})
YIELD componentCount, nodePropertiesWritten, preProcessingMillis, computeMillis,
      postProcessingMillis, writeMillis, componentDistribution
RETURN componentCount, nodePropertiesWritten,
       componentDistribution.min, componentDistribution.mean, componentDistribution.max,
       componentDistribution.p50, componentDistribution.p75, componentDistribution.p90,
       componentDistribution.p95, componentDistribution.p99, componentDistribution.p999
