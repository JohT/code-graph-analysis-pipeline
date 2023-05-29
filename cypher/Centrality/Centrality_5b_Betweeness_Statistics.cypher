//Centrality 5b Betweeness Statistics

 CALL gds.betweenness.stats('package-centrality-without-empty', {
     relationshipWeightProperty: 'weight25PercentInterfaces'
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