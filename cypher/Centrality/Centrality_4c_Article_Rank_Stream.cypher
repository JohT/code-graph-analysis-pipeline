//Centrality 4c Article Rank Stream

CALL gds.articleRank.stream('package-centrality-without-empty', {
   maxIterations: 30
  ,dampingFactor: 0.85
  ,tolerance: 0.00000001
  ,relationshipWeightProperty: 'weight25PercentInterfaces'
  ,scaler: "L2Norm"
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS package, score
RETURN package.fqn                  AS fullQualifiedPackageName
      ,package.name                 AS packageName
      ,score
      ,package.incomingDependencies AS incomingDependencies
      ,package.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, packageName ASC