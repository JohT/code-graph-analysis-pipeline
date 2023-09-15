//0 Delete Projections for directed artifact dependencies

  CALL gds.graph.drop('artifact-dependencies-directed', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime