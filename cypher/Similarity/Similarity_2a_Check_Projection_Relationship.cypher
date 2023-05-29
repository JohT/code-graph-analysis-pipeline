// Similarity 2a Check Projection Relationship

CALL gds.graph.relationshipProperty.stream('package-similarity', 'weight', ['DEPENDS_ON'])
YIELD
  sourceNodeId, targetNodeId, propertyValue AS weight, relationshipType
RETURN
  gds.util.asNode(sourceNodeId).name AS source,
  gds.util.asNode(targetNodeId).name AS target,
  weight,
  relationshipType
ORDER BY weight DESC, source