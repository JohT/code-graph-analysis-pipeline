// Community Detection Modularity Members

CALL gds.modularity.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
  WITH collect({communityId: communityId, modularity: modularity}) AS modularities
 MATCH (member)
 WHERE member[$dependencies_projection_write_property] IS NOT NULL
   AND $dependencies_projection_node IN LABELS(member)
  WITH modularities 
      ,member[$dependencies_projection_write_property]                               AS communityId
      ,coalesce(member.fqn, member.fileName, member.name)                            AS memberName
      ,coalesce(member.name, replace(last(split(member.fileName, '/')), '.jar', '')) AS shortMemberName
  WITH modularities
      ,communityId
      ,count(DISTINCT memberName)        AS memberCount
      ,collect(DISTINCT shortMemberName) AS shortMemberNames
      ,collect(DISTINCT memberName)      AS memberNames
      ,reduce(memberModularity = 0, modularity IN modularities | 
        CASE modularity.communityId WHEN communityId THEN modularity.modularity 
        ELSE memberModularity END)       AS memberModularity
 RETURN communityId
       ,memberModularity
       ,memberCount
       ,shortMemberNames
       ,memberNames
ORDER BY communityId ASCENDING