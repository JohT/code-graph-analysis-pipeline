// Calculates and writes the Hyperlink-Induced Topic Search (HITS) centrality scores for anomaly detection

  CALL gds.hits.write(
 $projection_name + '-directed-cleaned', {
     authProperty: 'centralityHyperlinkInducedTopicSearchAuthority'
    ,hubProperty: 'centralityHyperlinkInducedTopicSearchHub'
})
YIELD nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis
RETURN nodePropertiesWritten, ranIterations, didConverge, preProcessingMillis, computeMillis, writeMillis