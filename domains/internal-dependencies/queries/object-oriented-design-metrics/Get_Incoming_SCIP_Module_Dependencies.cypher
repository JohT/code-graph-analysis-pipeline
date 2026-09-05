// Get SCIP Semantic Index modules with the most incoming dependencies first (if already set by enrichment).

MATCH (m:SemanticCodeIndexModule)
WHERE m.incomingDependencies IS NOT NULL
RETURN m.projectName                  AS projectName
      ,m.fqn                            AS fullQualifiedModuleName
      ,m.name                           AS moduleName
      ,m.incomingDependencies           AS incomingDependencies
      ,m.incomingDependenciesWeight     AS incomingDependenciesWeight
      ,m.incomingDependentModules       AS incomingDependentModules
      ,m.incomingDependentArtifacts     AS incomingDependentArtifacts
      ,m.outgoingDependencies           AS outgoingDependencies
      ,m.outgoingDependenciesWeight     AS outgoingDependenciesWeight
      ,m.outgoingDependentModules       AS outgoingDependentModules
      ,m.outgoingDependentArtifacts     AS outgoingDependentArtifacts
ORDER BY incomingDependencies DESC, fullQualifiedModuleName ASC
