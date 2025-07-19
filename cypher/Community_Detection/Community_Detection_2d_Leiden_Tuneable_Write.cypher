//Community Detection Leiden Write property communityLeidenId

CALL gds.leiden.write(
 $dependencies_projection + '-cleaned', {
  gamma: toFloat($dependencies_leiden_gamma),
  theta: toFloat($dependencies_leiden_theta),
  maxLevels: toInteger($dependencies_leiden_max_levels),
  tolerance: 0.0000001,
  consecutiveIds: true,
  relationshipWeightProperty: $dependencies_projection_weight_property,
  writeProperty: $dependencies_projection_write_property
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
      ,communityDistribution.p999
      ,modularities