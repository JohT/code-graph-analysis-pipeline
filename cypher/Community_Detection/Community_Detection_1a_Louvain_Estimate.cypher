//Community Detection Louvain Estimate Memory

CALL gds.louvain.write.estimate(
 $dependencies_projection + '-cleaned', {
  tolerance: 0.00001,
  relationshipWeightProperty: $dependencies_projection_weight_property,
  writeProperty: $dependencies_projection_write_property,
  includeIntermediateCommunities: true
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