//Community Detection 2 Louvain Estimate Memory

CALL gds.louvain.write.estimate('package-dependencies-without-empty', {
  maxLevels: 10,
  maxIterations: 10,
  tolerance: 0.0001,
  relationshipWeightProperty: 'weight25PercentInterfaces',
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