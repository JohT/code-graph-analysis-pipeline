//Community Detection 4 Louvain Stream

CALL gds.louvain.stream('package-dependencies-without-empty', {
    maxLevels: 10,
    maxIterations: 10,
    tolerance: 0.0001,
    relationshipWeightProperty: 'weight25PercentInterfaces',
    includeIntermediateCommunities: true
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