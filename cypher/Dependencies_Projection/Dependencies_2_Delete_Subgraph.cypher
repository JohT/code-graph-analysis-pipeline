// Delete filtered subgraph projection if exists. Variables: dependencies_projection

  CALL gds.graph.drop($dependencies_projection + '-without-empty', false)
 YIELD graphName, nodeCount, relationshipCount, creationTime, modificationTime
RETURN graphName, nodeCount, relationshipCount, creationTime, modificationTime