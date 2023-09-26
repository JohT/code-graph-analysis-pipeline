// Community Detection Weakly Connected Components Stream

CALL gds.wcc.stream(
 $dependencies_projection + '-without-empty', {
      relationshipWeightProperty: $dependencies_projection_weight_property,
      consecutiveIds: true
})
 YIELD nodeId, componentId
  WITH componentId
      ,gds.util.asNode(nodeId) AS member
  WITH componentId
      ,member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
  WITH componentId
      ,count(DISTINCT member)                             AS memberCount
      ,collect(DISTINCT memberName)                       AS memberNames
RETURN componentId
      ,memberCount
      ,memberNames
 ORDER BY memberCount DESC, componentId ASC