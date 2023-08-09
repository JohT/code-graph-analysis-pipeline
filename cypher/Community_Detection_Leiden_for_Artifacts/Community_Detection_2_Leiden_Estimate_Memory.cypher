//Community Detection 2 Leiden Estimate Memory

CALL gds.beta.leiden.write.estimate('artifact-dependencies-without-empty', {
  gamma: 1.11,
  theta: 0.001,
  consecutiveIds: true,
  relationshipWeightProperty: 'weight',
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