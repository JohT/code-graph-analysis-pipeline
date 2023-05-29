//Community Detection 3 Louvain Statistics

CALL gds.louvain.stats('package-dependencies-without-empty', {
  maxLevels: 10,
  maxIterations: 10,
  tolerance: 0.0001,
  relationshipWeightProperty: 'weight25PercentInterfaces',
  includeIntermediateCommunities: true
})
YIELD communityCount
     ,ranLevels
     ,modularity
     ,modularities
     ,communityDistribution
RETURN communityCount
      ,ranLevels
      ,modularity
      ,modularities
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99