//Community Detection 1 Create undirected Projection
CALL gds.graph.project('package-dependencies', 'Package', 
    {
        DEPENDS_ON: {
            orientation: 'UNDIRECTED'
        }
    },
    {
        relationshipProperties: ['weight', 'weightInterfaces', 'weight25PercentInterfaces'],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
    }
)
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount