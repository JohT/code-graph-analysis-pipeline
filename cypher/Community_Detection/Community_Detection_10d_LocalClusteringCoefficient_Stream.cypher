// Community Detection - Local Clustering Coefficient - Stream

CALL gds.localClusteringCoefficient.stream(
 $dependencies_projection + '-cleaned', {
})
 YIELD nodeId, localClusteringCoefficient
  WITH gds.util.asNode(nodeId) AS member
      ,localClusteringCoefficient
  WITH coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,localClusteringCoefficient
RETURN localClusteringCoefficient
      ,memberName
 ORDER BY localClusteringCoefficient DESC, memberName ASC