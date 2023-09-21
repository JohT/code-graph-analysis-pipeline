// Centrality 6c Cost-effective Lazy Forward (CELF) Estimate

  CALL gds.beta.influenceMaximization.celf.write.estimate(
 $dependencies_projection + '-without-empty', {
     seedSetSize: 5
    ,writeProperty: $dependencies_projection_write_property
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView