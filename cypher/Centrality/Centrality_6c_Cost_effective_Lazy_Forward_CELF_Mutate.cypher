// Centrality 6c Cost-effective Lazy Forward (CELF) Mutate

  CALL gds.influenceMaximization.celf.mutate(
   $dependencies_projection + '-without-empty', {
      seedSetSize: 5
     ,mutateProperty: $dependencies_projection_write_property
 })
 YIELD nodePropertiesWritten
      ,nodeCount
      ,totalSpread
      ,computeMillis
      ,mutateMillis
RETURN nodePropertiesWritten
      ,nodeCount
      ,totalSpread
      ,computeMillis
      ,mutateMillis