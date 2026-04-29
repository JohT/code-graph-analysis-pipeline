// Centrality 10a Bridges Estimate

CALL gds.bridges.stream.estimate($dependencies_projection + '-cleaned', {})
 YIELD nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView
RETURN nodeCount, relationshipCount, bytesMin, bytesMax, heapPercentageMin, heapPercentageMax, treeView