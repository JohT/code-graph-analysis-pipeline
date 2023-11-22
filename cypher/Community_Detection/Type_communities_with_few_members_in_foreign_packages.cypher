// Type communities with few members in foreign packages

 MATCH (t:Type)
  WITH t.communityLeidenId   AS communityId
      ,count(DISTINCT t.fqn) AS numberOfTypesInCommunity
 WHERE communityId           IS NOT NULL
 MATCH (a:Artifact)-[:CONTAINS]->(p:Package)-[:CONTAINS]->(communityType:Type)
 MATCH (p)-[:CONTAINS]->(packageType:Type)
 WHERE communityType.communityLeidenId = communityId
   AND packageType.communityLeidenId IS NOT NULL
  WITH replace(last(split(a.fileName, '/')), '.jar', '') AS artifactName
      ,p.fqn                           AS packageName
      ,numberOfTypesInCommunity
      ,count(DISTINCT packageType.fqn) AS numberOfTypesInPackage
      ,collect(communityType)          AS packageTypes
UNWIND packageTypes                    AS packageType
  WITH artifactName
      ,packageName
      ,packageType.communityLeidenId   AS communityId
      ,numberOfTypesInPackage
      ,numberOfTypesInCommunity
      ,count(DISTINCT packageType.fqn) AS numberOfTypes
 WHERE numberOfTypes < numberOfTypesInCommunity
   AND numberOfTypes < numberOfTypesInPackage
RETURN artifactName
      ,packageName
      ,communityId
      ,numberOfTypesInPackage
      ,numberOfTypesInCommunity
      ,numberOfTypes
ORDER BY numberOfTypes            ASCENDING
        ,numberOfTypesInCommunity DESCENDING
        ,numberOfTypesInPackage   DESCENDING
        ,packageName              ASCENDING