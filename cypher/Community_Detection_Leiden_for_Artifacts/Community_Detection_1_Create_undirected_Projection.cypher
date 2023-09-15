//Community Detection 1 Create undirected Projection

CALL gds.graph.project('artifact-dependencies', 'Artifact', 
    {
        DEPENDS_ON: {
            orientation: 'UNDIRECTED'
        }
    },
    {
        relationshipProperties: ['weight'],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
    }
)
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount