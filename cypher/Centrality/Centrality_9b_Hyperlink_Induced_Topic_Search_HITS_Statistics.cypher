// Centrality 9b Hyperlink-Induced Topic Search (HITS) Statistics

  CALL gds.alpha.hits.stats(
 $dependencies_projection + '-without-empty', {
    hitsIterations: 20
})
 YIELD ranIterations, didConverge, preProcessingMillis, computeMillis
RETURN ranIterations, didConverge, preProcessingMillis, computeMillis