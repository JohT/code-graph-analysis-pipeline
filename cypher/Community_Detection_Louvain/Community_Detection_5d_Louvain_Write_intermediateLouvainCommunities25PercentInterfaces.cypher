//Community Detection 5d Louvain Write intermediateLouvainCommunities25PercentInterfaces

CALL gds.louvain.write('package-dependencies-without-empty', {
    maxIterations: 10,
    tolerance: 0.00001,
    writeProperty: 'intermediateLouvainCommunities25PercentInterfaces',
    relationshipWeightProperty: 'weight25PercentInterfaces',
    includeIntermediateCommunities: true
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