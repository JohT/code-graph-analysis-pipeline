// Compare Louvain vs. Leiden Community Detection Results. Variables: dependencies_projection_node (e.g. "Artifact", "Package", "Type")

 MATCH (member)
 WHERE $dependencies_projection_node IN LABELS(member)
 WITH member.communityLouvainId    AS louvainCommunityId
     ,member.communityLeidenId     AS leidenCommunityId
     ,coalesce(member.fqn, member.fileName, member.signature, member.name)          AS memberName
     ,coalesce(member.name, replace(last(split(member.fileName, '/')), '.jar', '')) AS shortMemberName
 WHERE louvainCommunityId IS NOT NULL
   AND leidenCommunityId  IS NOT NULL
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