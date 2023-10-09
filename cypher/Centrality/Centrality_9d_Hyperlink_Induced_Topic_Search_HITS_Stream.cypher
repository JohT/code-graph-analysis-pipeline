// Centrality 9d Hyperlink-Induced Topic Search (HITS) Stream

  CALL gds.alpha.hits.stream(
 $dependencies_projection + '-without-empty', {
    hitsIterations: 20
})
 YIELD nodeId, values
  WITH gds.util.asNode(nodeId) AS member, values
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,values.auth                 AS authority
      ,values.hub                  AS hub
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY values.auth DESC, memberName ASC