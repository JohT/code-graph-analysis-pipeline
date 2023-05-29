//Similarity 1b Create subgraph without empty packages

  CALL gds.beta.graph.project.subgraph(
    'package-similarity-without-empty',
    'package-similarity',
    'n.outgoingDependencies > 0 OR n.incomingDependencies > 0',
    '*'
  )
 YIELD graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter
RETURN graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter