// Create undirected projection. Variables: dependencies_projection, dependencies_projection_node, dependencies_projection_weight_property

CALL gds.graph.project(
    $dependencies_projection,
    $dependencies_projection_node, 
    {
        DEPENDS_ON: {
            orientation: 'UNDIRECTED'
        }
    },
    {
        relationshipProperties: [$dependencies_projection_weight_property],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies', 'testMarkerInteger']
    }
)
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount