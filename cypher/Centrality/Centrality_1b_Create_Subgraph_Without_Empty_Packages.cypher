//Centrality 1b Create subgraph without empty packages

CALL gds.beta.graph.project.subgraph(
  'package-centrality-without-empty',
  'package-centrality',
  'n.outgoingDependencies > 0 OR n.incomingDependencies > 0',
  '*'
)
 YIELD graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter
RETURN graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter