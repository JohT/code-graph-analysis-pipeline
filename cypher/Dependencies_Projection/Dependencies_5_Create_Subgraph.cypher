//Create filtered subgraph projection without zero-degree nodes. Variables: dependencies_projection, dependencies_projection_node

CALL gds.graph.filter(
  $dependencies_projection + '-cleaned',
  $dependencies_projection,
  'n.testMarkerInteger = 0 AND (n.outgoingDependencies > 0 OR n.incomingDependencies > 0)',
  '*'
)
 YIELD graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter
RETURN graphName, fromGraphName, nodeCount, relationshipCount, nodeFilter