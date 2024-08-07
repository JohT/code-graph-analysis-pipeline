//Community Detection Louvain write node property communityLouvainId

CALL gds.louvain.write(
 $dependencies_projection + '-cleaned', {
    tolerance: 0.00001,
    consecutiveIds: true,
    relationshipWeightProperty: $dependencies_projection_weight_property,
    writeProperty: 'communityLouvainId'
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