//Community Detection 0b Delete Projection

  CALL gds.graph.drop('package-dependencies-without-empty', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime