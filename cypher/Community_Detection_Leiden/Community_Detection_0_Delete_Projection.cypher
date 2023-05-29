//Community Detection 0 Delete Projection

  CALL gds.graph.drop('package-dependencies'
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime