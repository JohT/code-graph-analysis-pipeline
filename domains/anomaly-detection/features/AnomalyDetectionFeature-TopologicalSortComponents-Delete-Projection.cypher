// Delete projection if existing. Variables: projection_name

  CALL gds.graph.drop($projection_name + '-components', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime