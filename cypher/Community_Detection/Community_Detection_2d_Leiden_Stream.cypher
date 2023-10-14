//Community Detection Leiden Stream

CALL gds.beta.leiden.stream(
 $dependencies_projection + '-cleaned', {
  gamma: toFloat($dependencies_leiden_gamma),
  theta: 0.001,
  tolerance: 0.0000001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: $dependencies_projection_weight_property
})
 YIELD nodeId, communityId, intermediateCommunityIds
  WITH communityId
      ,intermediateCommunityIds
      ,gds.util.asNode(nodeId) AS member
  WITH communityId
      ,intermediateCommunityIds
      ,member
      ,coalesce(member.fqn, member.fileName, member.name) AS memberName
  WITH communityId
      ,intermediateCommunityIds
      ,count(DISTINCT member)       AS memberCount
      ,collect(DISTINCT memberName) AS memberNames
RETURN intermediateCommunityIds[0]  AS firstCommunityId 
      ,communityId                  AS finalCommunityId
      ,memberCount
      ,memberNames
      ,intermediateCommunityIds
 ORDER BY memberCount DESC, communityId ASC