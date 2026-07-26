// Get SCIP Semantic Index modules with the most incoming dependencies first (if already set by enrichment).

MATCH (m:SemanticCodeIndexModule)
WHERE m.incomingDependencies IS NOT NULL
RETURN m.projectName          AS projectName
      ,m.fqn                  AS fullQualifiedModuleName
      ,m.name                 AS moduleName
      ,m.incomingDependencies AS incomingDependencies
      ,m.outgoingDependencies AS outgoingDependencies
ORDER BY incomingDependencies DESC, fullQualifiedModuleName ASC
