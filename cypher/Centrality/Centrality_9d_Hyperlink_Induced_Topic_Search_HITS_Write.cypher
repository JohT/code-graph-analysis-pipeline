// Centrality 9d Hyperlink-Induced Topic Search (HITS) Memory Write

  CALL gds.alpha.hits.write(
 $dependencies_projection + '-without-empty', {
     hitsIterations: 20
    ,authProperty: $dependencies_projection_write_property
    ,hubProperty: 'centralityHyperlinkInducedTopicSearchHub'
})
YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis