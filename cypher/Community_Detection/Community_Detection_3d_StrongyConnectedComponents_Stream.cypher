// Community Detection Strongly Connected Components Stream

CALL gds.scc.stream(
 $dependencies_projection + '-cleaned', {
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