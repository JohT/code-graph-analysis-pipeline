// Similarity Stream. Requires "Add_file_name and_extension.cypher".

 CALL gds.nodeSimilarity.stream(
  $dependencies_projection + '-cleaned', {
      relationshipWeightProperty: $dependencies_projection_weight_property
     ,relationshipTypes: ['DEPENDS_ON']
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
     ,artifact1.name AS artifactName1
     ,artifact2.name AS artifactName2
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