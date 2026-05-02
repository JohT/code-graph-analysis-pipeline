//Community Detection Louvain Statistics

CALL gds.louvain.stats(
 $dependencies_projection + '-cleaned', {
  tolerance: 0.00001,
  relationshipWeightProperty: $dependencies_projection_weight_property,
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
      ,communityDistribution.p999