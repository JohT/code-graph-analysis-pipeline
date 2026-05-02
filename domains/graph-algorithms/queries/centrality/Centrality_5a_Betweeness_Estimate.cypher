// Centrality 5a Betweeness Estimate

CALL gds.betweenness.write.estimate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
    ,writeProperty: $dependencies_projection_write_property
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView