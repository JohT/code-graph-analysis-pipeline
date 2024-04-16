// Get Java Packages including their sub-packages with the most incoming dependencies first (if set before)

MATCH (p:Java:Package)
WHERE p.incomingDependenciesIncludingSubpackages IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,p.fqn                                             AS fullQualifiedPackageName
      ,p.name                                            AS packageName
      ,p.incomingDependenciesIncludingSubpackages        AS incomingDependencies
      ,p.incomingDependenciesWeightIncludingSubpackages  AS incomingDependenciesWeight
      ,p.incomingDependentTypesIncludingSubpackages      AS incomingDependentTypes
      ,p.incomingDependentInterfacesIncludingSubpackages AS incomingDependentInterfaces
      ,p.incomingDependentPackagesIncludingSubpackages   AS incomingDependentPackages
      ,p.incomingDependentArtifactsIncludingSubpackages  AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first