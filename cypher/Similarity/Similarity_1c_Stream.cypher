// Similarity Stream

 CALL gds.nodeSimilarity.stream(
  $dependencies_projection + '-without-empty', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,topK: 3
 })
YIELD node1, node2, similarity
 WITH gds.util.asNode(node1) AS node1
     ,gds.util.asNode(node2) AS node2
     ,similarity
OPTIONAL MATCH (artifact1:Artifact)-[:CONTAINS]->(node1)
OPTIONAL MATCH (artifact2:Artifact)-[:CONTAINS]->(node2)
 WITH node1
     ,node2
     ,replace(last(split(artifact1.fileName, '/')), '.jar', '') AS artifactName1
     ,replace(last(split(artifact2.fileName, '/')), '.jar', '') AS artifactName2
     ,similarity
RETURN similarity
      ,artifactName1
      ,coalesce(node1.fqn, node1.fileName, node1.name) AS node1Name
      ,node1.incomingDependencies                      AS node1IncomingDependencies  
      ,node1.outgoingDependencies                      AS node1OutgoingDependencies   
      ,artifactName2
      ,coalesce(node2.fqn, node2.fileName, node2.name) AS node2Name
      ,node2.incomingDependencies                      AS node2IncomingDependencies  
      ,node2.outgoingDependencies                      AS node2OutgoingDependencies  
ORDER BY similarity DESCENDING, node1Name, node2Name