//Community Detection for Types 3 Leiden Stream

//Tweaked for Modularity > 0.3 (aiming 0.4) and distribution percentile 75 > 1 
CALL gds.beta.leiden.stream('type-dependencies', {
  maxLevels: 10,
  gamma: 7.0,
  theta: 0.001,
  tolerance: 0.0000001,
  relationshipWeightProperty: 'weight',
  consecutiveIds: true
})
 YIELD nodeId, communityId
  WITH communityId, gds.util.asNode(nodeId) AS type
 MATCH (type)<-[:CONTAINS]-(package:Package)<-[:CONTAINS]-(artifact:Artifact)
RETURN communityId
      ,COUNT(DISTINCT type)                AS typeCount
      ,COUNT(DISTINCT package)             AS packageCount
      ,COUNT(DISTINCT artifact)            AS artifactCount
      ,collect(DISTINCT artifact.fileName) AS artifacts
      ,collect(DISTINCT package.name)      AS packages
      ,collect(DISTINCT type.fqn)          AS types
 ORDER BY typeCount DESC, packageCount DESC, communityId ASC
 LIMIT 25