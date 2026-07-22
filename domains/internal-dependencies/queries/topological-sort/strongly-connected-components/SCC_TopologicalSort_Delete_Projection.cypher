// Delete projection if existing

CALL gds.graph.drop($dependencies_projection + '-components', false)
YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime
