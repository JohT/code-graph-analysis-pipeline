// Centrality 5d Betweeness Stream

CALL gds.betweenness.stream(
 $dependencies_projection + '-cleaned', {
   relationshipWeightProperty: CASE $dependencies_projection_weight_property WHEN '' THEN null ELSE $dependencies_projection_weight_property END
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS member, score
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,score
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, memberName ASC