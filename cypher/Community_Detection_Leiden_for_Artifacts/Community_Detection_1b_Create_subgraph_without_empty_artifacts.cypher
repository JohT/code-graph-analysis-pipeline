//Community Detection 1b Create subgraph without empty artifacts

CALL gds.beta.graph.project.subgraph(
  'artifact-dependencies-without-empty',
  'artifact-dependencies',
  'n.outgoingDependencies > 0 OR n.incomingDependencies > 0',
  '*'
)
 YIELD graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter
RETURN graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter