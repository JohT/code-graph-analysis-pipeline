// Centrality 7d Harmonic Closeness Write

CALL gds.closeness.harmonic.write(
    $dependencies_projection + '-cleaned', {
    ,writeProperty: $dependencies_projection_write_property
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