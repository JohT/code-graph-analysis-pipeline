// Centrality 7a Harmonic Closeness Stream

CALL gds.alpha.closeness.harmonic.stream('package-centrality-without-empty', {})
 YIELD nodeId, centrality
  WITH gds.util.asNode(nodeId) AS package, centrality
RETURN package.fqn                  AS fullQualifiedPackageName
      ,package.name                 AS packageName
      ,centrality
      ,package.incomingDependencies AS incomingDependencies
      ,package.outgoingDependencies AS outgoingDependencies
 ORDER BY centrality DESC, packageName ASC