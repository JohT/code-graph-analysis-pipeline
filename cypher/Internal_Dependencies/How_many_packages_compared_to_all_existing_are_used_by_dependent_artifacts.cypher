// How many packages compared to all existing are used by dependent artifacts?

MATCH (artifact:Artifact)-[:CONTAINS]-(package:Package)-[:DEPENDS_ON]->(dependentPackage:Package)<-[:CONTAINS]-(dependentArtifact:Artifact)
MATCH (dependentArtifact)-[:CONTAINS]->(dependentArtifactPackage:Package)-[:CONTAINS]->(dependentArtifactType:Type)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,replace(last(split(dependentArtifact.fileName, '/')), '.jar', '') AS dependentArtifactName
      ,dependentArtifact
      ,COUNT(DISTINCT dependentPackage.fqn)     AS dependentPackages
      ,COUNT(DISTINCT dependentArtifactPackage) AS dependentArtifactPackages
      ,collect(DISTINCT dependentPackage.fqn)   AS dependentFullQualifiedPackageNames
      ,collect(DISTINCT dependentPackage.name)  AS dependentPackageNames
RETURN artifactName
      ,dependentArtifactName
      ,dependentPackages
      ,dependentArtifactPackages
      ,toFloat(dependentPackages) / (dependentArtifactPackages + 1E-38) AS packageUsagePercentage
      ,dependentFullQualifiedPackageNames
      ,dependentPackageNames
ORDER BY packageUsagePercentage ASC