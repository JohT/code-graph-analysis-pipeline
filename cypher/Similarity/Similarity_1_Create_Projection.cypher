//Similarity 1 Create Projection

  CALL gds.graph.project('package-similarity', 
    {
      Package: {
        properties: ['incomingDependencies', 'outgoingDependencies']
      }
    },
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
        }
    }
  )
 YIELD graphName, nodeCount, relationshipCount
RETURN graphName, nodeCount, relationshipCount