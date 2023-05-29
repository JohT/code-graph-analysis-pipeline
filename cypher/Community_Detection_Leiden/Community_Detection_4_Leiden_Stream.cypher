//Community Detection 4 Leiden Stream

CALL gds.beta.leiden.stream('package-dependencies-without-empty', {
  maxLevels: 10,
  gamma: 1.06,
  theta: 0.00001,
  tolerance: 0.0000001,
  includeIntermediateCommunities: true,
  relationshipWeightProperty: 'weight25PercentInterfaces'
})
 YIELD nodeId, communityId, intermediateCommunityIds
  WITH communityId
      ,intermediateCommunityIds
      ,gds.util.asNode(nodeId) AS package
// MATCH (package)<-[:CONTAINS]-(artifact:Artifact)
RETURN intermediateCommunityIds[0]         AS firstCommunityId 
      ,communityId                         AS finalCommunityId
      ,COUNT(DISTINCT package)             AS countOfMembers
      ,collect(DISTINCT package.fqn)       AS packages
// Remove multiple collections before CSV convertion
//      ,collect(DISTINCT artifact.fileName) AS artifacts
//      ,intermediateCommunityIds
 ORDER BY countOfMembers DESC, communityId ASC