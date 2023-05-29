// Similarity 4 Stream

 CALL gds.nodeSimilarity.stream('package-similarity', {
     relationshipWeightProperty: 'weight25PercentInterfaces'
 })
YIELD node1, node2, similarity
 WITH gds.util.asNode(node1) AS package1
     ,gds.util.asNode(node2) AS package2
     ,similarity
MATCH (artifact1:Artifact)-[:CONTAINS]->(package1)
MATCH (artifact2:Artifact)-[:CONTAINS]->(package2)
 WITH replace(last(split(artifact1.fileName, '/')), '.jar', '') AS artifactName1
     ,replace(last(split(artifact2.fileName, '/')), '.jar', '') AS artifactName2
     ,package1
     ,package2
     ,similarity
RETURN similarity
      ,package1.fqn
      ,package2.fqn
      ,artifactName1
      ,package1.name
      ,package1.incomingDependencies
      ,package1.outgoingDependencies
      ,artifactName2
      ,package2.name
      ,package2.incomingDependencies
      ,package2.outgoingDependencies
ORDER BY similarity DESCENDING, package1.name, package2.name