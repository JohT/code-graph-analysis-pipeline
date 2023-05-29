// Centrality 5c Betweeness Stream

CALL gds.betweenness.stream('package-centrality-without-empty', {
   relationshipWeightProperty: 'weight25PercentInterfaces'
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS package, score
RETURN package.fqn                  AS fullQualifiedPackageName
      ,package.name                 AS packageName
      ,score
      ,package.incomingDependencies AS incomingDependencies
      ,package.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, packageName ASC