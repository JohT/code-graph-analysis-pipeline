// Community Detection Approximate Maximum k-cut Estimate

CALL gds.maxkcut.mutate.estimate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,mutateProperty: $dependencies_projection_write_property
    ,k: toInteger($dependencies_maxkcut)
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