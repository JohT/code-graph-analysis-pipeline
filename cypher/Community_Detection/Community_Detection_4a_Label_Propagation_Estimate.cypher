// Community Detection Label Propagation Estimate

CALL gds.labelPropagation.write.estimate(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,writeProperty: $dependencies_projection_write_property
    ,consecutiveIds: true
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