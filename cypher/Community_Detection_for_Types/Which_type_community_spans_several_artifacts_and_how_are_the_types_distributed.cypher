// Which type community spans several artifacts and how are the types distributed?

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
 MATCH (externalArtifact:Artifact)-[:CONTAINS]->(externalPackage:Package)-[:CONTAINS]->(externalType:Type)
 WHERE artifact.fileName <> externalArtifact.fileName
   AND package.fqn <> externalPackage.fqn
   AND type.leidenTypeCommunityIdGamma7
     = externalType.leidenTypeCommunityIdGamma7
  WITH type.leidenTypeCommunityIdGamma7 AS communityId
      ,size(collect(DISTINCT artifact)) AS artifactCount
      ,collect(DISTINCT replace(last(split(artifact.fileName, '/')), '.jar', '')) AS artifactNames
      ,size(collect(DISTINCT package)) AS packageCount
      ,collect(DISTINCT package.name) AS packageNames
      ,size(collect(DISTINCT type)) AS typeCount
      ,collect(DISTINCT type.name) AS typeNames
RETURN communityId, artifactCount, packageCount, typeCount, artifactNames, packageNames, typeNames
 ORDER BY artifactCount DESC, communityId