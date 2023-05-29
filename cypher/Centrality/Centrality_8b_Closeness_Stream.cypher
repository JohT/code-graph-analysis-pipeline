// Centrality 8b Closeness Stream

CALL gds.beta.closeness.stream('package-centrality-without-empty', {
   useWassermanFaust: true
})
 YIELD nodeId, score
  WITH gds.util.asNode(nodeId) AS package, score
RETURN package.fqn                  AS fullQualifiedPackageName
      ,package.name                 AS packageName
      ,score
      ,package.incomingDependencies AS incomingDependencies
      ,package.outgoingDependencies AS outgoingDependencies
 ORDER BY score DESC, packageName ASC