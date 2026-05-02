// Community Detection Label Propagation write node property communityLabelPropagationId

CALL gds.labelPropagation.write(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,consecutiveIds: true
    ,writeProperty: 'communityLabelPropagationId'
})
YIELD ranIterations
     ,didConverge
     ,communityCount
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,postProcessingMillis
     ,nodePropertiesWritten
     ,communityDistribution
RETURN ranIterations
      ,didConverge
      ,communityCount
      ,preProcessingMillis
      ,computeMillis
      ,writeMillis
      ,postProcessingMillis
      ,nodePropertiesWritten
      ,communityDistribution.min
      ,communityDistribution.mean
      ,communityDistribution.max
      ,communityDistribution.p50
      ,communityDistribution.p75
      ,communityDistribution.p90
      ,communityDistribution.p95
      ,communityDistribution.p99
      ,communityDistribution.p999