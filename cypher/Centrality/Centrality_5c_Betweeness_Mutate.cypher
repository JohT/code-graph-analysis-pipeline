// Centrality 5c Betweeness Mutate

CALL gds.betweenness.mutate(
 $dependencies_projection + '-without-empty', {
   relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
  ,mutateProperty: $dependencies_projection_write_property
})
 YIELD nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution
RETURN nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99
      ,centralityDistribution.p999