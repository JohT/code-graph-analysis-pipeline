// Which package community spans several artifacts and how are the packages distributed?

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (externalArtifact:Artifact)-[:CONTAINS]->(externalPackage:Package)
 WHERE artifact.fileName <> externalArtifact.fileName
   AND package.leidenCommunityIdGamma114With25PercentInterfaces 
     = externalPackage.leidenCommunityIdGamma114With25PercentInterfaces
  WITH package.leidenCommunityIdGamma114With25PercentInterfaces AS communityId
      ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,collect(DISTINCT package.name)  AS packageNames
      ,size(collect(DISTINCT package)) AS packageCount
 WHERE communityId IS NOT NULL
RETURN communityId, artifactName, packageCount, packageNames
 ORDER BY communityId, artifactName