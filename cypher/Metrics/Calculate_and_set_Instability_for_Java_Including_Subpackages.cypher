// Calculate and set Instability = outgoing / (outgoing + incoming) Dependencies. Requires "Add_file_name and_extension.cypher".

 MATCH (p:Java:Package)
 WHERE p.incomingDependenciesIncludingSubpackages > 0 
   AND p.outgoingDependenciesIncludingSubpackages > 0
  WITH p
      ,toFloat(p.outgoingDependenciesIncludingSubpackages) / (p.outgoingDependenciesIncludingSubpackages + p.incomingDependenciesIncludingSubpackages + 1E-38) as instability
      ,toFloat(p.outgoingDependentTypesIncludingSubpackages) / (p.outgoingDependentTypesIncludingSubpackages + p.incomingDependentTypesIncludingSubpackages + 1E-38) as instabilityTypes
      ,toFloat(p.outgoingDependentInterfacesIncludingSubpackages) / (p.outgoingDependentInterfacesIncludingSubpackages + p.incomingDependentInterfacesIncludingSubpackages + 1E-38) as instabilityInterfaces
      ,toFloat(p.outgoingDependentPackagesIncludingSubpackages) / (p.outgoingDependentPackagesIncludingSubpackages + p.incomingDependentPackagesIncludingSubpackages + 1E-38) as instabilityPackages
      ,toFloat(p.outgoingDependentArtifactsIncludingSubpackages) / (p.outgoingDependentArtifactsIncludingSubpackages + p.incomingDependentArtifactsIncludingSubpackages + 1E-38) as instabilityArtifacts
   SET p.instabilityIncludingSubpackages           = instability
      ,p.instabilityTypesIncludingSubpackages      = instabilityTypes
      ,p.instabilityInterfacesIncludingSubpackages = instabilityInterfaces
      ,p.instabilityPackagesIncludingSubpackages   = instabilityPackages
      ,p.instabilityArtifactsIncludingSubpackages  = instabilityArtifacts
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
      ,p.outgoingDependenciesIncludingSubpackages, p.incomingDependenciesIncludingSubpackages 
      ,p.outgoingDependentTypesIncludingSubpackages, p.incomingDependentTypesIncludingSubpackages
      ,p.outgoingDependentInterfacesIncludingSubpackages, p.incomingDependentInterfacesIncludingSubpackages
      ,p.outgoingDependentPackagesIncludingSubpackages, p.incomingDependentPackagesIncludingSubpackages
      ,p.outgoingDependentArtifactsIncludingSubpackages, p.incomingDependentArtifactsIncludingSubpackages
ORDER BY instability ASC, p.fqn ASC