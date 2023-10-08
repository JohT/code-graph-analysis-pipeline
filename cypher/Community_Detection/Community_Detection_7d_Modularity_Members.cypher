// Community Detection Modularity Members

CALL gds.modularity.stream(
 $dependencies_projection + '-without-empty', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,communityProperty: $dependencies_projection_write_property
})
 YIELD communityId, modularity
  WITH communityId, modularity
 MATCH (member)
 WHERE member[$dependencies_projection_write_property] = communityId
   AND $dependencies_projection_node IN LABELS(member)
  WITH communityId
      ,modularity
      ,coalesce(member.fqn, member.fileName, member.name)                            AS memberName
      ,coalesce(member.name, replace(last(split(member.fileName, '/')), '.jar', '')) AS shortMemberName
RETURN communityId
      ,modularity
      ,count(DISTINCT memberName)        AS memberCount
      ,collect(DISTINCT shortMemberName) AS shortMemberNames
      ,collect(DISTINCT memberName)      AS memberNames
ORDER BY communityId ASCENDING