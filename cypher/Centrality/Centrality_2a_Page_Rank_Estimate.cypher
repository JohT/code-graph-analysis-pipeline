// Centrality 2a Page Rank Estimate Memory

CALL gds.pageRank.write.estimate(
 $dependencies_projection + '-without-empty', {
   writeProperty: $dependencies_projection_write_property
  ,maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: $dependencies_projection_weight_property
  ,scaler: "L1Norm"
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView