//Community Detection 2 Leiden Estimate Memory

CALL gds.beta.leiden.write.estimate('package-dependencies-without-empty', {
  maxLevels: 10,
  gamma: 1.06,
  theta: 0.00001,
  tolerance: 0.0000001,
  consecutiveIds: true,
  relationshipWeightProperty: 'weight25PercentInterfaces',
  writeProperty: 'leidenCommunityId'
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