// Create directed projection. Variables: dependencies_projection, dependencies_projection_node, dependencies_projection_weight_property

  CALL gds.graph.project(
    $dependencies_projection,
    $dependencies_projection_node, 
      'DEPENDS_ON', {
        relationshipProperties: [$dependencies_projection_weight_property],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
  })
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount