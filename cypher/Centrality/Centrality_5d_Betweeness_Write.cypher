// Centrality 5d Betweeness Write

CALL gds.betweenness.write('package-centrality-without-empty', {
   relationshipWeightProperty: 'weight25PercentInterfaces',
   writeProperty: 'betweenness25PercentInterfaces'
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