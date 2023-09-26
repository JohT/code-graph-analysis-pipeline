//Centrality 3c Page Rank Stream

CALL gds.pageRank.stream(
 $dependencies_projection + '-without-empty', {
   maxIterations: 50
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: $dependencies_projection_weight_property
  ,scaler: "L2Norm"
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS member, score
RETURN coalesce(member.fqn, member.fileName, member.name) AS memberName
      ,score
      ,member.incomingDependencies AS incomingDependencies
      ,member.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, memberName ASC