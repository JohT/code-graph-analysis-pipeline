// Similarity 2c Check Projection Relationship Topology with null nodes first

CALL gds.beta.graph.relationships.stream('package-similarity', ['DEPENDS_ON', 'CONTAINS'])
YIELD
  sourceNodeId, targetNodeId, relationshipType
RETURN
  sourceNodeId,
  gds.util.asNode(sourceNodeId).name AS source,
  targetNodeId,
  gds.util.asNode(targetNodeId).name AS target,
  relationshipType
ORDER BY source DESC, target DESC
LIMIT 100