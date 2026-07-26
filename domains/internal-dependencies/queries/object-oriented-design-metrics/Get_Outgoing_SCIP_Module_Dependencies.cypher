// Get SCIP Semantic Index modules with the most outgoing dependencies first (if already set by enrichment).

MATCH (m:SemanticCodeIndexModule)
WHERE m.outgoingDependencies IS NOT NULL
RETURN m.projectName          AS projectName
      ,m.fqn                  AS fullQualifiedModuleName
      ,m.name                 AS moduleName
      ,m.outgoingDependencies AS outgoingDependencies
      ,m.incomingDependencies AS incomingDependencies
ORDER BY outgoingDependencies DESC, fullQualifiedModuleName ASC
