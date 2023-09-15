//Community Detection 5 Leiden Write property leidenCommunityId

CALL gds.beta.leiden.write('artifact-dependencies-without-empty', {
  gamma: 1.11,
  theta: 0.001,
  consecutiveIds: true,
  relationshipWeightProperty: 'weight',
  writeProperty: 'leidenCommunityId'
})
YIELD preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
     ,communityCount
     ,ranLevels
     ,modularity
     ,modularities
     ,communityDistribution
RETURN preProcessingMillis
      ,computeMillis
      ,writeMillis
      ,postProcessingMillis
      ,nodePropertiesWritten
      ,communityCount
      ,ranLevels
      ,modularity
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99
      ,modularities