// Read the similarity relationship from the projection. Variables: dependencies_projection

CALL gds.graph.relationshipProperty.stream(
     $dependencies_projection + '-cleaned'
    ,'score'
    ,['SIMILAR']
)
 YIELD sourceNodeId
      ,targetNodeId
      ,relationshipType
      ,propertyValue
 WITH gds.util.asNode(sourceNodeId) AS sourceNode
     ,gds.util.asNode(targetNodeId) AS targetNode
     ,propertyValue                 AS similarity
OPTIONAL MATCH (sourceArtifact:Artifact)-[:CONTAINS]->(sourceNode)
OPTIONAL MATCH (targetArtifact:Artifact)-[:CONTAINS]->(targetNode)
 WITH sourceNode
     ,targetNode
     ,replace(last(split(sourceArtifact.fileName, '/')), '.jar', '')  AS sourceArtifactName
     ,replace(last(split(targetArtifact.fileName, '/')), '.jar', '')  AS targetArtifactName
     ,similarity
 WHERE (sourceNode.incomingDependencies > 0
   OR   sourceNode.outgoingDependencies > 0)
   AND (targetNode.incomingDependencies > 0
   OR   targetNode.outgoingDependencies > 0)
RETURN similarity
      ,sourceArtifactName
      ,coalesce(sourceNode.fqn, sourceNode.fileName, sourceNode.name) AS sourceNodeName
      ,sourceNode.incomingDependencies                                AS sourceNodeIncomingDependencies  
      ,sourceNode.outgoingDependencies                                AS sourceNodeOutgoingDependencies   
      ,targetArtifactName
      ,coalesce(targetNode.fqn, targetNode.fileName, targetNode.name) AS targetNodeName
      ,targetNode.incomingDependencies                                AS targetNodeIncomingDependencies  
      ,targetNode.outgoingDependencies                                AS targetNodeOutgoingDependencies  
ORDER BY similarity DESCENDING, sourceNodeName, targetNodeName