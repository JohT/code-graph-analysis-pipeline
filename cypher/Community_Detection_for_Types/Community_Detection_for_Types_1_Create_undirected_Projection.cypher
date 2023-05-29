//Community Detection for Types 1 Create undirected Projection

CALL gds.graph.project('type-dependencies',
    ['Class', 'Interface', 'Enum'],
    {
        DEPENDS_ON: {
            orientation: 'UNDIRECTED'
        }
    },
    {
        relationshipProperties: ['weight']
    }
)