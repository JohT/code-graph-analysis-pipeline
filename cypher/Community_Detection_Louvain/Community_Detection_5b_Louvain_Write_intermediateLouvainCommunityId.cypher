//Community Detection 5b Louvain Write intermediateLouvainCommunityId

CALL gds.louvain.write('package-dependencies-without-empty', {
    maxIterations: 10,
    tolerance: 0.00001,
    writeProperty: 'intermediateLouvainCommunityId',
    relationshipWeightProperty: 'weight',
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