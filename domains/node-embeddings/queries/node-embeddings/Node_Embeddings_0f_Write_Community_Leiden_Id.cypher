// Write Leiden community detection results to nodes in the given projection as 'communityLeidenId'. Variables: dependencies_projection, dependencies_projection_weight_property

CALL gds.leiden.write(
  $dependencies_projection + '-cleaned', {
    theta: 0.001
   ,tolerance: 0.0000001
   ,consecutiveIds: true
   ,relationshipWeightProperty: $dependencies_projection_weight_property
   ,writeProperty: 'communityLeidenId'
  }
)
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
