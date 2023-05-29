//Centrality 2a Page Rank Estimate Memory

CALL gds.pageRank.write.estimate('package-centrality-without-empty', {
   writeProperty: 'pageRank'
  ,maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: 'weight25PercentInterfaces'
  ,scaler: "L1Norm"
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView