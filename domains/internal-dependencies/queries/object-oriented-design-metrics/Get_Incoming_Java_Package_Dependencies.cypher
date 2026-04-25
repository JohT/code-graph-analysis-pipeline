// Get Java Packages with the most incoming dependencies first (if set before). Requires "Add_file_name and_extension.cypher".

MATCH (p:Java:Package)
WHERE  p.incomingDependencies IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN artifact.name AS artifactName
      ,p.fqn                         AS fullQualifiedPackageName
      ,p.name                        AS packageName
      ,p.incomingDependencies        AS incomingDependencies
      ,p.incomingDependenciesWeight  AS incomingDependenciesWeight
      ,p.incomingDependentTypes      AS incomingDependentTypes
      ,p.incomingDependentInterfaces AS incomingDependentInterfaces
      ,p.incomingDependentPackages   AS incomingDependentPackages
      ,p.incomingDependentArtifacts  AS incomingDependentArtifacts
ORDER BY incomingDependencies DESC, p.fqn ASC // package with most incoming dependencies first