//2 Create directed subgraph without empty artifacts

CALL gds.beta.graph.project.subgraph(
  'artifact-dependencies-directed-without-empty',
  'artifact-dependencies-directed',
  'n.outgoingDependencies > 0 OR n.incomingDependencies > 0',
  '*'
)
 YIELD graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter
RETURN graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter