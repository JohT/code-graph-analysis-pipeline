// Community Detection - Local Clustering Coefficient - Stream Aggregated

CALL gds.localClusteringCoefficient.stream(
 $dependencies_projection + '-cleaned', {
})
 YIELD nodeId, localClusteringCoefficient
  WITH gds.util.asNode(nodeId) AS member
      ,localClusteringCoefficient
  WITH coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,localClusteringCoefficient
  WITH round(localClusteringCoefficient, 2) AS localClusteringCoefficient
      ,collect(DISTINCT memberName)[0..9]   AS memberNameExamples
      ,count(DISTINCT memberName)           AS memberCount
RETURN localClusteringCoefficient
      ,memberCount
      ,memberNameExamples
 ORDER BY localClusteringCoefficient DESC, memberCount DESC