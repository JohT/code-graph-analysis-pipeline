//1 Create directed Projection
CALL gds.graph.project('artifact-dependencies-directed', 'Artifact', 'DEPENDS_ON',
    {
        relationshipProperties: ['weight'],
        nodeProperties: ['incomingDependencies', 'outgoingDependencies']
    }
)
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount