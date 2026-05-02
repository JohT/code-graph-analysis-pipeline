// Centrality 7c Harmonic Closeness Mutate

CALL gds.closeness.harmonic.mutate(
  $dependencies_projection + '-cleaned', {
    mutateProperty: $dependencies_projection_write_property
})
 YIELD nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution
RETURN nodePropertiesWritten
      ,preProcessingMillis
      ,computeMillis
      ,mutateMillis
      ,postProcessingMillis
      ,centralityDistribution.min
      ,centralityDistribution.mean
      ,centralityDistribution.max
      ,centralityDistribution.p50
      ,centralityDistribution.p75
      ,centralityDistribution.p90
      ,centralityDistribution.p95
      ,centralityDistribution.p99
      ,centralityDistribution.p999