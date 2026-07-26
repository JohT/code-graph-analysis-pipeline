// Calculate and set Instability for SCIP Semantic Index modules. Requires "Set_Incoming_SCIP_Module_Dependencies.cypher" and "Set_Outgoing_SCIP_Module_Dependencies.cypher" from the scip-index-import enrichment phase.
// Reuses existing incomingDependencies and outgoingDependencies already set during enrichment.

MATCH (m:SemanticCodeIndexModule)
WHERE m.incomingDependencies IS NOT NULL
  AND m.outgoingDependencies IS NOT NULL
 WITH m
     ,toFloat(m.outgoingDependencies) / (m.outgoingDependencies + m.incomingDependencies + 1E-38) AS instability
  SET m.instability = instability
RETURN m.projectName          AS projectName
      ,m.fqn                  AS fullQualifiedModuleName
      ,m.name                 AS moduleName
      ,instability
      ,m.outgoingDependencies AS outgoingDependencies
      ,m.incomingDependencies AS incomingDependencies
ORDER BY instability ASC, fullQualifiedModuleName ASC
