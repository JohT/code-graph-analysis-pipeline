// Create multi relationship projection.  Variables: dependencies_projection, dependencies_projection_node

  CALL gds.graph.project(
    $dependencies_projection,
    $dependencies_projection_node,
    ['DEPENDS_ON', 'CONTAINS'],
    {
        relationshipProperties: {
          weight: {
            defaultValue: 1.0
          },
          weightInterfaces: {
            defaultValue: 1.0
          },
          weight25PercentInterfaces: {
            defaultValue: 1.0
          }
        },
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
    }
  )
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount