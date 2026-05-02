// Centrality 9e Hyperlink-Induced Topic Search (HITS) Write

  CALL gds.hits.write(
 $dependencies_projection + '-cleaned', {
     hitsIterations: 20
    ,authProperty: $dependencies_projection_write_property + 'Authority'
    ,hubProperty: $dependencies_projection_write_property + 'Hub'
})
YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis