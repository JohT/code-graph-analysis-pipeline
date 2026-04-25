// Calculate and set Instability for Java. Requires "Add_file_name and_extension.cypher".
// Instability = outgoing / (outgoing + incoming) Dependencies

 MATCH (p:Java:Package)
WHERE p.incomingDependencies > 0 
  AND p.outgoingDependencies > 0
  WITH p
      ,toFloat(p.outgoingDependencies) / (p.outgoingDependencies + p.incomingDependencies + 1E-38) as instability
      ,toFloat(p.outgoingDependentTypes) / (p.outgoingDependentTypes + p.incomingDependentTypes + 1E-38) as instabilityTypes
      ,toFloat(p.outgoingDependentInterfaces) / (p.outgoingDependentInterfaces + p.incomingDependentInterfaces + 1E-38) as instabilityInterfaces
      ,toFloat(p.outgoingDependentPackages) / (p.outgoingDependentPackages + p.incomingDependentPackages + 1E-38) as instabilityPackages
      ,toFloat(p.outgoingDependentArtifacts) / (p.outgoingDependentArtifacts + p.incomingDependentArtifacts + 1E-38) as instabilityArtifacts
   SET p.instability           = instability
      ,p.instabilityTypes      = instabilityTypes
      ,p.instabilityInterfaces = instabilityInterfaces
      ,p.instabilityPackages   = instabilityPackages
      ,p.instabilityArtifacts  = instabilityArtifacts
  WITH p
      ,instability
      ,instabilityTypes
      ,instabilityInterfaces
      ,instabilityPackages
      ,instabilityArtifacts
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN artifact.name AS artifactName
      ,p.fqn                   AS fullQualifiedPackageName
      ,p.name                  AS packageName
      ,instability
      ,instabilityTypes
      ,instabilityInterfaces
      ,instabilityPackages
      ,instabilityArtifacts
      ,p.outgoingDependencies, p.incomingDependencies 
      ,p.outgoingDependentTypes, p.incomingDependentTypes
      ,p.outgoingDependentInterfaces, p.incomingDependentInterfaces 
      ,p.outgoingDependentPackages, p.incomingDependentPackages
      ,p.outgoingDependentArtifacts, p.incomingDependentArtifacts
ORDER BY instability ASC, p.fqn ASC