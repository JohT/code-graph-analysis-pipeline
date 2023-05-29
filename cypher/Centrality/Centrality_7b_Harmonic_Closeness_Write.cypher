// Centrality 7b Harmonic Closeness Write

CALL gds.alpha.closeness.harmonic.write('package-centrality-without-empty', {
   writeProperty: 'harmonicCentrality'
})
YIELD nodes
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,writeProperty
     ,centralityDistribution
RETURN nodes
     ,preProcessingMillis
     ,computeMillis
     ,writeMillis
     ,writeProperty
     ,centralityDistribution.min
     ,centralityDistribution.mean
     ,centralityDistribution.max
     ,centralityDistribution.p50
     ,centralityDistribution.p75
     ,centralityDistribution.p90
     ,centralityDistribution.p95
     ,centralityDistribution.p99