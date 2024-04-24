// Get Java Packages with the lowest Instability (outgoing / all dependencies) first (if set before)
// Instability = outgoing / (outgoing + incoming) Dependencies

 MATCH (p:Java:Package)
 WHERE p.instability IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
  RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,p.fqn                   AS fullQualifiedPackageName
      ,p.name                  AS packageName
      ,p.instability           AS instability
      ,p.instabilityTypes      AS instabilityTypes
      ,p.instabilityInterfaces AS instabilityInterfaces
      ,p.instabilityPackages   AS instabilityPackages
      ,p.instabilityArtifacts  AS instabilityArtifacts
      ,p.outgoingDependencies, p.incomingDependencies 
      ,p.outgoingDependentTypes, p.incomingDependentTypes
      ,p.outgoingDependentInterfaces, p.incomingDependentInterfaces 
      ,p.outgoingDependentPackages, p.incomingDependentPackages
      ,p.outgoingDependentArtifacts, p.incomingDependentArtifacts
ORDER BY instability ASC, p.fqn ASC