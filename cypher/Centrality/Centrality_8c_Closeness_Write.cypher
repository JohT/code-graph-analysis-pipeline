// Centrality 8c Closeness Write

CALL gds.beta.closeness.write('package-centrality-without-empty', {
   useWassermanFaust: true,
   writeProperty: 'closeness'
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