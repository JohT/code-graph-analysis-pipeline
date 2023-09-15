//Community Detection 4 Leiden Stream

CALL gds.beta.leiden.stream('artifact-dependencies-without-empty', {
  gamma: 1.11,
  theta: 0.001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: 'weight'
})
 YIELD nodeId, communityId, intermediateCommunityIds
  WITH communityId
      ,intermediateCommunityIds
      ,gds.util.asNode(nodeId) AS artifact
RETURN intermediateCommunityIds[0]         AS firstCommunityId 
      ,communityId                         AS finalCommunityId
      ,COUNT(DISTINCT artifact)            AS countOfMembers
      ,collect(DISTINCT replace(last(split(artifact.fileName, '/')), '.jar', '')) AS artifactNames
 ORDER BY countOfMembers DESC, communityId ASC