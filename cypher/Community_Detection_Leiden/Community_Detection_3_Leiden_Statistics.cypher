//Community Detection 3 Leiden Statistics

CALL gds.beta.leiden.stats('package-dependencies-without-empty', {
  maxLevels: 10,
  gamma: 1.14,
  theta: 0.001,
  tolerance: 0.0001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: 'weight25PercentInterfaces'
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