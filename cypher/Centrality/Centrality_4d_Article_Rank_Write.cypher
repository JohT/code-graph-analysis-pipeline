//Centrality 4d Article Rank Write

CALL gds.articleRank.write('package-centrality-without-empty', {
   maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: 'weight25PercentInterfaces'
  ,scaler: "L2Norm"
  ,writeProperty: "articleRank25PercentInterfaces"
})
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