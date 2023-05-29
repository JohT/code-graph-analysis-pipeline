//Centrality 6c Cost-effective Lazy Forward (CELF) Stream

  CALL gds.beta.influenceMaximization.celf.stream('package-centrality-without-empty', {seedSetSize: 5})
 YIELD nodeId, spread
  WITH gds.util.asNode(nodeId) AS package, spread
RETURN package.fqn                  AS fullQualifiedPackageName
      ,package.name                 AS packageName
      ,spread
      ,package.incomingDependencies AS incomingDependencies
      ,package.outgoingDependencies AS outgoingDependencies
 ORDER BY spread DESC, packageName ASC