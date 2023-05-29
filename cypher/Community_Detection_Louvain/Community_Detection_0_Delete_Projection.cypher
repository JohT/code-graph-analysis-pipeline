//Community Detection 0 Delete Projection

  CALL gds.graph.drop('package-dependencies', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime