// Creates a projection of the strongly connected components graph for the given member type. Requires: "AnomalyDetectionFeature-StronglyConnectedComponents-CreateDependency.cypher"

   MATCH (sourceComponent:StronglyConnectedComponent)
OPTIONAL MATCH (sourceComponent)-[:DEPENDS_ON]->(targetComponent:StronglyConnectedComponent)
   WHERE $projection_node_label + 'Members' IN labels(sourceComponent)
     AND $projection_node_label + 'Members' IN labels(targetComponent)
    WITH gds.graph.project($projection_name + '-components', sourceComponent, targetComponent) AS graph
  RETURN graph.graphName         AS graphName
        ,graph.nodeCount         AS nodeCount
        ,graph.relationshipCount AS relationshipCount