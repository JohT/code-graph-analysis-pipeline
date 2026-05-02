// Centrality 2a Page Rank Estimate Memory

CALL gds.pageRank.write.estimate(
 $dependencies_projection + '-cleaned', {
   writeProperty: $dependencies_projection_write_property
  ,maxIterations: 50
  ,relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView