// Community Detection K-Core Decomposition Stream

CALL gds.kcore.stream(
 $dependencies_projection + '-cleaned', {
})
 YIELD nodeId, coreValue
  WITH gds.util.asNode(nodeId) AS member
      ,coreValue
  WITH member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,coreValue
  WITH count(DISTINCT member)       AS memberCount
      ,collect(DISTINCT memberName) AS memberNames
      ,coreValue
RETURN memberCount
      ,coreValue
      ,memberNames
 ORDER BY memberCount DESC, coreValue ASC