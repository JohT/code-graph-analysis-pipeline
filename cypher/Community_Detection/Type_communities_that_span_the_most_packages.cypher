// Communities that span the most packages. Requires "Add_file_name and_extension.cypher".

 MATCH (a:Artifact)-[:CONTAINS]->(p:Package)-[:CONTAINS]->(t:Type)
  WITH a.name AS artifactName
      ,t.communityLeidenId                               AS communityId  
      ,collect(DISTINCT p.fqn)                           AS packageNames
      ,count(DISTINCT p.fqn)                             AS packageCount
      ,collect(DISTINCT t.fqn)                           AS typeNames
      ,count(DISTINCT t.fqn)                             AS typeCount
 WHERE communityId IS NOT NULL
RETURN artifactName
      ,communityId
      ,packageCount
      ,typeCount
      ,packageNames
      ,typeNames
ORDER BY packageCount DESCENDING
        ,typeCount    DESCENDING
        ,communityId  ASCENDING