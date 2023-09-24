// Check Projection Node Properties

CALL gds.graph.nodeProperties.stream(
   $dependencies_projection + '-without-empty'
  ,['incomingDependencies', 'outgoingDependencies']
)
YIELD nodeId, targetNodeId, propertyValue, relationshipType
  WITH nodeId                        AS sourceNodeId
      ,gds.util.asNode(nodeId)       AS sourceNode
      ,nodeProperty                  
      ,propertyValue
      ,nodeLabels
RETURN sourceNodeId
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceName
      ,nodeProperty
      ,propertyValue
      ,nodeLabels
 ORDER BY sourceName ASC
 LIMIT 50