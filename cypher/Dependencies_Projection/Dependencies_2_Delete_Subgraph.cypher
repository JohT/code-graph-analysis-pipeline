// Delete filtered subgraph projection if exists. Variables: dependencies_projection

  CALL gds.graph.drop($dependencies_projection + '-cleaned', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime