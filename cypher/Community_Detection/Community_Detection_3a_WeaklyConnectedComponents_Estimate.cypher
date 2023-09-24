// Community Detection Label Propagation Estimate

CALL gds.labelPropagation.write.estimate(
 $dependencies_projection + '-without-empty', {
  relationshipWeightProperty: $dependencies_projection_weight_property,
  consecutiveIds: true,
  writeProperty: 'labelPropagationCommunityId'
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
      ,mapView