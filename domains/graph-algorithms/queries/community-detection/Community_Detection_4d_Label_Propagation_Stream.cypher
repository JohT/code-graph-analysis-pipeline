// Community Detection Label Propagation Stream

CALL gds.labelPropagation.stream(
 $dependencies_projection + '-cleaned', {
     relationshipWeightProperty: $dependencies_projection_weight_property
    ,consecutiveIds: true
})
 YIELD nodeId, communityId
  WITH communityId
      ,gds.util.asNode(nodeId) AS member
  WITH communityId
      ,member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
  WITH communityId
      ,count(DISTINCT member)                             AS memberCount
      ,collect(DISTINCT memberName)                       AS memberNames
RETURN communityId
      ,memberCount
      ,memberNames
 ORDER BY memberCount DESC, communityId ASC