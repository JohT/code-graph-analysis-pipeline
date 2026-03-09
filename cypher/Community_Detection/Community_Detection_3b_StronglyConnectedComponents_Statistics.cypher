// Community Detection Strongly Connected Components Statistics

CALL gds.scc.stats(
 $dependencies_projection + '-cleaned', {
     consecutiveIds: true
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