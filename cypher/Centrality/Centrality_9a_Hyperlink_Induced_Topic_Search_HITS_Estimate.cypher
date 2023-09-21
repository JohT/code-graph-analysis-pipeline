// Centrality 9a Hyperlink-Induced Topic Search (HITS) Memory Estimation

  CALL gds.alpha.hits.write.estimate(
 $dependencies_projection + '-without-empty', {
     hitsIterations: 20
    ,authProperty: $dependencies_projection_write_property
    ,hubProperty: 'centralityHyperlinkInducedTopicSearchHub'
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView