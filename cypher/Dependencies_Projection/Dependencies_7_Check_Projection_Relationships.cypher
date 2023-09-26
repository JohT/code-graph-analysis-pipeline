// Check Projection Relationships

CALL gds.graph.relationshipProperty.stream(
   $dependencies_projection + '-without-empty',
  ,$dependencies_projection_weight_property
  ,['DEPENDS_ON']
)
YIELD sourceNodeId, targetNodeId, propertyValue, relationshipType
  WITH sourceNodeId
      ,targetNodeId
      ,gds.util.asNode(sourceNodeId) AS source
      ,gds.util.asNode(targetNodeId) AS target
      ,propertyValue                 AS weight
      ,relationshipType
RETURN sourceNodeId
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceName
      ,targetNodeId
      ,coalesce(target.fqn, target.fileName, target.name) AS targetName
      ,weight
      ,relationshipType
 ORDER BY weight DESC, sourceName ASC
 LIMIT 50