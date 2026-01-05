// Node Embeddings 0b: Prepare: Calculate Degree Property.

CALL gds.degree.mutate(
 $dependencies_projection + '-cleaned', {
   orientation: 'UNDIRECTED'
  ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
  ,mutateProperty: 'degreeForNodeEmbeddings'
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