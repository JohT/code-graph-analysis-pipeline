// Centrality 7a Harmonic Closeness Stream

CALL gds.closeness.harmonic.stream($dependencies_projection + '-without-empty', {})
 YIELD nodeId, centrality
  WITH gds.util.asNode(nodeId) AS member, centrality
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,centrality
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY centrality DESC, memberName ASC