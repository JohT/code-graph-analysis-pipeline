// Centrality 5e Betweeness Write

CALL gds.betweenness.write(
 $dependencies_projection + '-without-empty', {
    relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
   ,writeProperty: $dependencies_projection_write_property
})
YIELD nodePropertiesWritten
     ,preProcessingMillis
     ,computeMillis
     ,postProcessingMillis
     ,writeMillis
     ,centralityDistribution
RETURN nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99