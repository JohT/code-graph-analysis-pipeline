// Get Java Packages including their sub packages with the lowest Instability. Requires "Add_file_name and_extension.cypher".
// Instability = outgoing / (outgoing + incoming) Dependencies

 MATCH (p:Java:Package)
 WHERE p.instabilityIncludingSubpackages IS NOT NULL
 MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN artifact.name AS artifactName
      ,p.fqn                   AS fullQualifiedPackageName
      ,p.name                  AS packageName
      ,p.instabilityIncludingSubpackages           AS instability
      ,p.instabilityTypesIncludingSubpackages      AS instabilityTypes
      ,p.instabilityInterfacesIncludingSubpackages AS instabilityInterfaces
      ,p.instabilityPackagesIncludingSubpackages   AS instabilityPackages
      ,p.instabilityArtifactsIncludingSubpackages  AS instabilityArtifacts
      ,p.outgoingDependenciesIncludingSubpackages, p.incomingDependenciesIncludingSubpackages 
      ,p.outgoingDependentTypesIncludingSubpackages, p.incomingDependentTypesIncludingSubpackages
      ,p.outgoingDependentInterfacesIncludingSubpackages, p.incomingDependentInterfacesIncludingSubpackages
      ,p.outgoingDependentPackagesIncludingSubpackages, p.incomingDependentPackagesIncludingSubpackages
      ,p.outgoingDependentArtifactsIncludingSubpackages, p.incomingDependentArtifactsIncludingSubpackages
ORDER BY instability ASC, p.fqn ASC