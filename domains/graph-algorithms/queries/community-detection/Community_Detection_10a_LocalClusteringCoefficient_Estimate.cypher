// Community Detection - Local Clustering Coefficient - Estimate

CALL gds.localClusteringCoefficient.write.estimate(
 $dependencies_projection + '-cleaned', {
    writeProperty: $dependencies_projection_write_property
})
 YIELD requiredMemory
      ,nodeCount
      ,relationshipCount
      ,bytesMin
      ,bytesMax
      ,heapPercentageMin
      ,heapPercentageMax
      ,treeView
      ,mapView
RETURN requiredMemory
      ,nodeCount
      ,relationshipCount
      ,bytesMin
      ,bytesMax
      ,heapPercentageMin
      ,heapPercentageMax
      ,treeView