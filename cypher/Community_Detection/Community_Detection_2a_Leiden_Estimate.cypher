//Community Detection Leiden Estimate Memory

CALL gds.leiden.write.estimate(
 $dependencies_projection + '-cleaned', {
  gamma: toFloat($dependencies_leiden_gamma),
  theta: 0.001,
  tolerance: 0.0000001,
  consecutiveIds: true,
  relationshipWeightProperty: $dependencies_projection_weight_property,
  writeProperty: $dependencies_projection_write_property
})
YIELD nodeCount
     ,relationshipCount
     ,bytesMin
     ,bytesMax
     ,heapPercentageMin
     ,heapPercentageMax
     ,treeView
RETURN nodeCount
     ,relationshipCount
     ,bytesMin
     ,bytesMax
     ,heapPercentageMin
     ,heapPercentageMax
     ,treeView