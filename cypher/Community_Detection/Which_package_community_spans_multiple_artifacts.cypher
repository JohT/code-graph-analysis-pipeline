// Which package community spans multiple artifacts? Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
  WITH package.communityLeidenId AS communityId
      ,collect(DISTINCT artifact.name) AS artifactNames
      ,size(collect(DISTINCT artifact)) AS artifactCount
 WHERE communityId IS NOT NULL
RETURN communityId, artifactNames, artifactCount
 ORDER BY artifactCount DESC, communityId