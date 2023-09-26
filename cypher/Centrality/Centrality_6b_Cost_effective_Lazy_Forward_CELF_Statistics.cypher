// Centrality 6b Cost-effective Lazy Forward (CELF) Estimate

CALL gds.beta.influenceMaximization.celf.stats(
  $dependencies_projection + '-without-empty', {
    seedSetSize: 5
  })
 YIELD computeMillis
      ,totalSpread
      ,nodeCount
RETURN computeMillis
      ,totalSpread
      ,nodeCount