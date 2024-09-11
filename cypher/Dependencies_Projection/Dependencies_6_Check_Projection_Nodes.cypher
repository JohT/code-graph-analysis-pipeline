// Check Projection Node Properties

 CALL gds.graph.nodeProperties.stream(
    $dependencies_projection + '-cleaned'
   ,['incomingDependencies', 'outgoingDependencies']
 )
 YIELD nodeId, propertyValue
  WITH * ,gds.util.asNode(nodeId) AS source               
RETURN nodeId
      ,coalesce(source.fqn, source.fileName, source.name) AS sourceName
      ,propertyValue
      ,labels(source)[0..4] AS first5NodeLabels
 ORDER BY sourceName ASC
 LIMIT 50