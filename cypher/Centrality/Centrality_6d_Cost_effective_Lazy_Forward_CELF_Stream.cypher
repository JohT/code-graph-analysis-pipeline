// Centrality 6d Cost-effective Lazy Forward (CELF) Stream

  CALL gds.influenceMaximization.celf.stream(
   $dependencies_projection + '-without-empty', {
      seedSetSize: 5
 })
 YIELD nodeId, spread
  WITH gds.util.asNode(nodeId) AS member, spread
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,spread
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY spread DESC, memberName ASC