//Community Detection 5 Leiden Write property leidenCommunityIdGamma114With25PercentInterfaces

CALL gds.beta.leiden.write('package-dependencies-without-empty', {
  maxLevels: 10,
  gamma: 1.14,
  theta: 0.001,
  tolerance: 0.0001,
  consecutiveIds: true,
  relationshipWeightProperty: 'weight25PercentInterfaces',
  writeProperty: 'leidenCommunityIdGamma114With25PercentInterfaces'
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