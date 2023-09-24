//Community Detection Louvain Estimate Memory

CALL gds.louvain.write.estimate(
 $dependencies_projection + '-without-empty', {
  tolerance: 0.00001,
  relationshipWeightProperty: $dependencies_projection_weight_property,
  writeProperty: 'louvainCommunityId',
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