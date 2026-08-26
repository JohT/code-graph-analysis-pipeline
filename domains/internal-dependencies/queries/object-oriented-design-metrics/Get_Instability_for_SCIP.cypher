// Get SCIP Semantic Index modules with the lowest Instability first (if already set).

MATCH (m:SemanticCodeIndexModule)
WHERE m.instability IS NOT NULL
RETURN m.projectName                  AS projectName
      ,m.fqn                            AS fullQualifiedModuleName
      ,m.name                           AS moduleName
      ,m.instability                    AS instability
      ,m.instabilityModules             AS instabilityModules
      ,m.instabilityArtifacts           AS instabilityArtifacts
      ,m.outgoingDependencies           AS outgoingDependencies
      ,m.incomingDependencies           AS incomingDependencies
      ,m.outgoingDependentArtifacts     AS outgoingDependentArtifacts
      ,m.incomingDependentArtifacts     AS incomingDependentArtifacts
ORDER BY instability ASC, fullQualifiedModuleName ASC
