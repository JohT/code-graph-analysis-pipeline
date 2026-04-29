// Centrality 9b Hyperlink-Induced Topic Search (HITS) Statistics

  CALL gds.hits.stats(
 $dependencies_projection + '-cleaned', {
    hitsIterations: 20
})
 YIELD ranIterations, didConverge, preProcessingMillis, computeMillis
RETURN ranIterations, didConverge, preProcessingMillis, computeMillis