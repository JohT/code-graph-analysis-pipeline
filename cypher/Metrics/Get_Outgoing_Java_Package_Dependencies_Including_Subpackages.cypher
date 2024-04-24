// Get Java Packages including their sub packages with the most outgoing dependencies first (if set before)

MATCH (p:Java:Package)
WHERE p.outgoingDependenciesIncludingSubpackages IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,p.fqn                                             AS fullQualifiedPackageName
      ,p.name                                            AS packageName
      ,p.outgoingDependenciesIncludingSubpackages        AS outgoingDependencies
      ,p.outgoingDependenciesWeightIncludingSubpackages  AS outgoingDependenciesWeight
      ,p.outgoingDependentTypesIncludingSubpackages      AS outgoingDependentTypes
      ,p.outgoingDependentInterfacesIncludingSubpackages AS outgoingDependentInterfaces
      ,p.outgoingDependentPackagesIncludingSubpackages   AS outgoingDependentPackages
      ,p.outgoingDependentArtifactsIncludingSubpackages  AS outgoingDependentArtifacts
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first