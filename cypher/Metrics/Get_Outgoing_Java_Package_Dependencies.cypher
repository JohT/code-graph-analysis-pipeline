// Get Java Packages with the most outgoing dependencies first (if set before). Requires "Add_file_name and_extension.cypher".

MATCH (p:Java:Package)
WHERE p.outgoingDependencies IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(p)
RETURN artifact.name AS artifactName 
      ,p.fqn                         AS fullQualifiedPackageName
      ,p.name                        AS packageName
      ,p.outgoingDependencies        AS outgoingDependencies
      ,p.outgoingDependenciesWeight  AS outgoingDependenciesWeight
      ,p.outgoingDependentTypes      AS outgoingDependentTypes
      ,p.outgoingDependentInterfaces AS outgoingDependentInterfaces
      ,p.outgoingDependentPackages   AS outgoingDependentPackages
      ,p.outgoingDependentArtifacts  AS outgoingDependentArtifacts
ORDER BY outgoingDependencies DESC, p.fqn ASC // package with most incoming dependencies first