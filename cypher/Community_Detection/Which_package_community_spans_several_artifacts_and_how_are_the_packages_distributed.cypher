// Which package community spans several artifacts and how are the packages distributed? Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (externalArtifact:Artifact)-[:CONTAINS]->(externalPackage:Package)
 WHERE artifact.fileName <> externalArtifact.fileName
   AND package.communityLeidenId 
     = externalPackage.communityLeidenId
  WITH package.communityLeidenId AS communityId
      ,artifact.name AS artifactName
      ,collect(DISTINCT package.name)  AS packageNames
      ,size(collect(DISTINCT package)) AS packageCount
 WHERE communityId IS NOT NULL
RETURN communityId, artifactName, packageCount, packageNames
 ORDER BY communityId, artifactName