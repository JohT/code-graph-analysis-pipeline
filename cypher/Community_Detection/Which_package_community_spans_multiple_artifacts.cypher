// Which package community spans multiple artifacts?

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
  WITH package.leidenCommunityId AS communityId
      ,collect(DISTINCT replace(last(split(artifact.fileName, '/')), '.jar', '')) AS artifactNames
      ,size(collect(DISTINCT artifact)) AS artifactCount
 WHERE communityId IS NOT NULL
RETURN communityId, artifactNames, artifactCount
 ORDER BY artifactCount DESC, communityId