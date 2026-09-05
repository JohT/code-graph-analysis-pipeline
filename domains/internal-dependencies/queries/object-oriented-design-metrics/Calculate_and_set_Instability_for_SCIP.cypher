// Calculate and set Instability for SCIP Semantic Index modules. Requires "Set_Incoming_SCIP_Module_Dependencies.cypher" and "Set_Outgoing_SCIP_Module_Dependencies.cypher" from the scip-index-import enrichment phase.

MATCH (m:SemanticCodeIndexModule)
WHERE m.incomingDependencies IS NOT NULL
  AND m.outgoingDependencies IS NOT NULL
 WITH m
     ,toFloat(m.outgoingDependencies)        / (m.outgoingDependencies        + m.incomingDependencies        + 1E-38) AS instability
     ,toFloat(m.outgoingDependentModules)    / (m.outgoingDependentModules    + m.incomingDependentModules    + 1E-38) AS instabilityModules
     ,toFloat(m.outgoingDependentArtifacts)  / (m.outgoingDependentArtifacts  + m.incomingDependentArtifacts  + 1E-38) AS instabilityArtifacts
  SET m.instability          = instability
     ,m.instabilityModules   = instabilityModules
     ,m.instabilityArtifacts = instabilityArtifacts
RETURN m.projectName               AS projectName
      ,m.fqn                       AS fullQualifiedModuleName
      ,m.name                      AS moduleName
      ,instability
      ,instabilityModules
      ,instabilityArtifacts
      ,m.outgoingDependencies      AS outgoingDependencies
      ,m.outgoingDependenciesWeight AS outgoingDependenciesWeight
      ,m.incomingDependencies      AS incomingDependencies
      ,m.incomingDependenciesWeight AS incomingDependenciesWeight
      ,m.outgoingDependentModules  AS outgoingDependentModules
      ,m.incomingDependentModules  AS incomingDependentModules
      ,m.outgoingDependentArtifacts AS outgoingDependentArtifacts
      ,m.incomingDependentArtifacts AS incomingDependentArtifacts
ORDER BY instability ASC, fullQualifiedModuleName ASC
