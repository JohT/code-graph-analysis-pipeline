//Community Detection Leiden Statistics

CALL gds.beta.leiden.stats(
 $dependencies_projection + '-without-empty', {
  gamma: toFloat($dependencies_leiden_gamma),
  theta: 0.001,
  tolerance: 0.0000001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: $dependencies_projection_weight_property
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