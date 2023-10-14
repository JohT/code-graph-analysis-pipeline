// Centrality 4a Article Rank Estimate Memory

CALL gds.articleRank.write.estimate(
  $dependencies_projection + '-without-empty', {
   writeProperty: $dependencies_projection_write_property
  ,maxIterations: 30
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
  ,scaler: "L1Norm"
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView