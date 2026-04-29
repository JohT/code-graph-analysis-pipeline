// Community Detection Approximate Maximum k-cut Stream

CALL gds.maxkcut.stream(
 $dependencies_projection + '-cleaned', {
})
 YIELD nodeId, communityId
  WITH gds.util.asNode(nodeId) AS member
      ,communityId
  WITH member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,communityId
  WITH communityId
      ,count(DISTINCT member)       AS memberCount
      ,collect(DISTINCT memberName) AS memberNames
RETURN communityId
      ,memberCount
      ,memberNames
 ORDER BY memberCount DESC, communityId ASC