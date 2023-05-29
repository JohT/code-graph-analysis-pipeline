//Centrality 8a Closeness Statistics

CALL gds.beta.closeness.stats('package-centrality-without-empty', {
   useWassermanFaust: true
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