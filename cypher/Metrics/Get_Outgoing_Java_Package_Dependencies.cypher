// Get Java Packages with the most outgoing dependencies first (if set before)

MATCH (p:Java:Package)
WHERE p.outgoingDependencies IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName 
      ,p.fqn                         AS fullQualifiedPackageName
      ,p.name                        AS packageName
      ,p.outgoingDependencies        AS outgoingDependencies
      ,p.outgoingDependenciesWeight  AS outgoingDependenciesWeight
      ,p.outgoingDependentTypes      AS outgoingDependentTypes
      ,p.outgoingDependentInterfaces AS outgoingDependentInterfaces
      ,p.outgoingDependentPackages   AS outgoingDependentPackages
      ,p.outgoingDependentArtifacts  AS outgoingDependentArtifacts
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first