//Centrality 8b Closeness Statistics

CALL gds.closeness.stats(
 $dependencies_projection + '-cleaned', {
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