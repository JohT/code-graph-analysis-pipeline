// Centrality 6b Cost-effective Lazy Forward (CELF) Statistics

CALL gds.influenceMaximization.celf.stats(
  $dependencies_projection + '-cleaned', {
    seedSetSize: 5
  })
 YIELD computeMillis
      ,totalSpread
      ,nodeCount
RETURN computeMillis
      ,totalSpread
      ,nodeCount