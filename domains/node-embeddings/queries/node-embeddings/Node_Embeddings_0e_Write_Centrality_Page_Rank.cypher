// Write PageRank centrality score to nodes in the given projection as 'centralityPageRank'. Variables: dependencies_projection, dependencies_projection_weight_property

CALL gds.pageRank.write(
  $dependencies_projection + '-cleaned', {
    maxIterations: 50
   ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
   ,writeProperty: 'centralityPageRank'
  }
)
 YIELD nodePropertiesWritten
      ,ranIterations
      ,didConverge
      ,preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,writeMillis
      ,centralityDistribution
RETURN nodePropertiesWritten
      ,ranIterations
      ,didConverge
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
