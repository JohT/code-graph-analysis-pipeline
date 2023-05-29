//Centrality 1 Create Projection

  CALL gds.graph.project('package-centrality', 'Package', 'DEPENDS_ON', {
        relationshipProperties: ['weight', 'weightInterfaces', 'weight25PercentInterfaces'],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
  })
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount