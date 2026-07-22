// Creates a projection of the strongly connected components graph for the given member type. Requires "SCC_CreateDependency.cypher".

MATCH (sourceComponent:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(sourceComponent)
OPTIONAL MATCH (sourceComponent)-[:DEPENDS_ON]->(targetComponent:StronglyConnectedComponent)
WHERE $dependencies_projection_node + 'Members' IN labels(targetComponent)
WITH gds.graph.project($dependencies_projection + '-components', sourceComponent, targetComponent) AS graph
RETURN graph.graphName AS graphName
      ,graph.nodeCount AS nodeCount
      ,graph.relationshipCount AS relationshipCount
