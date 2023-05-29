//Centrality 0b Delete Subgraph Projection

 CALL gds.graph.drop('package-centrality-without-empty', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime