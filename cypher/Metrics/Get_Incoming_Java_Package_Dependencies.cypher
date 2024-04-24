// Get Java Packages with the most incoming dependencies first (if set before)

MATCH (p:Java:Package)
WHERE  p.incomingDependencies IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,p.fqn                         AS fullQualifiedPackageName
      ,p.name                        AS packageName
      ,p.incomingDependencies        AS incomingDependencies
      ,p.incomingDependenciesWeight  AS incomingDependenciesWeight
      ,p.incomingDependentTypes      AS incomingDependentTypes
      ,p.incomingDependentInterfaces AS incomingDependentInterfaces
      ,p.incomingDependentPackages   AS incomingDependentPackages
      ,p.incomingDependentArtifacts  AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first