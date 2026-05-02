// Centrality 6a Cost-effective Lazy Forward (CELF) Estimate

  CALL gds.influenceMaximization.celf.write.estimate(
 $dependencies_projection + '-cleaned', {
     seedSetSize: 5
    ,writeProperty: $dependencies_projection_write_property
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView