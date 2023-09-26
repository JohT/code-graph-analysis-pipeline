//Centrality 5b Betweeness Statistics

 CALL gds.betweenness.stats(
  $dependencies_projection + '-without-empty', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    })
 YIELD preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,centralityDistribution
RETURN preProcessingMillis
      ,computeMillis
      ,postProcessingMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99