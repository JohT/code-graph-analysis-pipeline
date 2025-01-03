// Which type community spans several artifacts and how are the types distributed? Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
 MATCH (externalArtifact:Artifact)-[:CONTAINS]->(externalPackage:Package)-[:CONTAINS]->(externalType:Type)
 WHERE artifact.fileName <> externalArtifact.fileName
   AND package.fqn <> externalPackage.fqn
   AND type.communityLeidenId = externalType.communityLeidenId
  WITH type.communityLeidenId AS communityId
      ,size(collect(DISTINCT artifact)) AS artifactCount
      ,collect(DISTINCT artifact.name) AS artifactNames
      ,size(collect(DISTINCT package)) AS packageCount
      ,collect(DISTINCT package.name) AS packageNames
      ,size(collect(DISTINCT type)) AS typeCount
      ,collect(DISTINCT type.name) AS typeNames
RETURN communityId, artifactCount, packageCount, typeCount, artifactNames, packageNames, typeNames
 ORDER BY artifactCount DESC, communityId