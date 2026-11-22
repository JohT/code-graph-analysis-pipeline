// Calculates and writes the Strongly Connected Components for cyclic dependency analysis. Parameterized by projection name ($dependencies_projection). Requires Neo4j GDS library with gds.scc.write procedure available.

CALL gds.scc.write(
  $dependencies_projection, {
    writeProperty: 'communityStronglyConnectedComponentId',
    consecutiveIds: true
  })
YIELD componentCount, nodePropertiesWritten, preProcessingMillis, computeMillis, postProcessingMillis, writeMillis, componentDistribution
RETURN componentCount
      ,nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,componentDistribution.min
      ,componentDistribution.mean
      ,componentDistribution.max
      ,componentDistribution.p50
      ,componentDistribution.p75
      ,componentDistribution.p90
      ,componentDistribution.p95
      ,componentDistribution.p99
      ,componentDistribution.p999
