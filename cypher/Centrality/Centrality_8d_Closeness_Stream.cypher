// Centrality 8c Closeness Stream

CALL gds.closeness.stream(
  $dependencies_projection + '-without-empty', {
   useWassermanFaust: true
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS member, score
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,score
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, memberName ASC