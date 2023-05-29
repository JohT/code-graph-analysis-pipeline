//Centrality 0 Delete Projection

  CALL gds.graph.drop('package-centrality', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime