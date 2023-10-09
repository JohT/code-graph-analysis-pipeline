// Centrality 8d Closeness Write

CALL gds.closeness.write(
 $dependencies_projection + '-without-empty', {
    useWassermanFaust: true
   ,writeProperty: $dependencies_projection_write_property
})
YIELD nodePropertiesWritten
     ,preProcessingMillis
     ,computeMillis
     ,postProcessingMillis
     ,writeMillis
     ,writeProperty
     ,centralityDistribution
RETURN nodePropertiesWritten
     ,preProcessingMillis
     ,computeMillis
     ,postProcessingMillis
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