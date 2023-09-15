//Community Detection 3 Leiden Statistics

CALL gds.beta.leiden.stats('artifact-dependencies-without-empty', {
  gamma: 1.11,
  theta: 0.001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: 'weight'
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