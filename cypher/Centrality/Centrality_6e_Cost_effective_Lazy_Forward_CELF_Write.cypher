// Centrality 6e Cost-effective Lazy Forward (CELF) Write

  CALL gds.influenceMaximization.celf.write(
    $dependencies_projection + '-without-empty', {
      seedSetSize: 5
     ,writeProperty: $dependencies_projection_write_property
})
 YIELD writeMillis
      ,nodePropertiesWritten
      ,computeMillis
      ,totalSpread
      ,nodeCount
RETURN writeMillis
      ,nodePropertiesWritten
      ,computeMillis
      ,totalSpread
      ,nodeCount