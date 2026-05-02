// Community Detection Louvain Mutate

CALL gds.louvain.mutate(
 $dependencies_projection + '-cleaned', {
    tolerance: 0.00001,
    consecutiveIds: NOT toBoolean($dependencies_include_intermediate_communities),
    includeIntermediateCommunities: toBoolean($dependencies_include_intermediate_communities),
    relationshipWeightProperty: $dependencies_projection_weight_property,
    mutateProperty: $dependencies_projection_write_property
})
 YIELD communityCount
      ,nodePropertiesWritten
      ,ranLevels
      ,modularity
      ,modularities
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,communityDistribution
RETURN communityCount
      ,nodePropertiesWritten
      ,ranLevels
      ,modularity
      ,modularities
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99
      ,communityDistribution.p999