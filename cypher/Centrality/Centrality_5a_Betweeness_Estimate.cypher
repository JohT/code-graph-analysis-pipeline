//Centrality 5a Betweeness Estimate

CALL gds.betweenness.write.estimate('package-centrality-without-empty', { 
    writeProperty: 'betweenness' 
})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView