// How many classes compared to all existing in the same package are used by dependent packages across different artifacts?

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)-[:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)<-[:CONTAINS]-(dependentArtifact:Artifact)
MATCH (dependentPackage)-[:CONTAINS]->(dependentPackageType:Type)
WHERE type <> dependentType
  AND artifact <> dependentArtifact
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,replace(last(split(dependentArtifact.fileName, '/')), '.jar', '') AS dependentArtifactName
      ,package
      ,dependentPackage
      ,COUNT(DISTINCT dependentType)        AS dependentTypes
      ,COUNT(DISTINCT dependentPackageType) AS dependentPackageTypes
      ,collect(DISTINCT dependentType.fqn)  AS dependentTypeNames
RETURN artifactName
      ,dependentArtifactName
      ,package.fqn as packageName
      ,dependentPackage.fqn
      ,dependentTypes
      ,dependentPackageTypes
      ,toFloat(dependentTypes) / (dependentPackageTypes + 1E-38) AS typeUsagePercentage
      ,dependentTypeNames
ORDER BY typeUsagePercentage ASC