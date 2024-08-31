// Compare Louvain vs. Leiden Community Detection Results. Variables: dependencies_projection_node (e.g. "Artifact", "Package", "Type"). Requires "Add_file_name and_extension.cypher".

 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member)
   AND member.louvainCommunityId IS NOT NULL
   AND member.leidenCommunityId  IS NOT NULL
 WITH member.communityLouvainId    AS louvainCommunityId
     ,member.communityLeidenId     AS leidenCommunityId
     ,coalesce(member.fqn, member.fileName, member.signature, member.name)          AS memberName
     ,member.name AS shortMemberName
 WITH louvainCommunityId
     ,leidenCommunityId
     ,collect(DISTINCT shortMemberName) AS shortMemberNames
     ,count(DISTINCT memberName)        AS memberCount
     ,collect(DISTINCT memberName)      AS memberNames
RETURN louvainCommunityId
      ,leidenCommunityId
      ,memberCount
      ,shortMemberNames
      ,memberNames
ORDER BY louvainCommunityId ASC, memberCount DESC