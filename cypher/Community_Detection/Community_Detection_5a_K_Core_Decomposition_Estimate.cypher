// Community Detection K-Core Decomposition Estimate

CALL gds.kcore.write.estimate(
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
      //,mapView //doesn't work on Windows with git bash jq version jq-1.7-dirty