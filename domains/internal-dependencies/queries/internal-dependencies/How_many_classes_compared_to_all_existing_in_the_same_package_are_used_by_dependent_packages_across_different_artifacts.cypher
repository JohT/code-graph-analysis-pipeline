// How many classes compared to all existing in the same package are used by dependent packages across different artifacts. Requires "Add_file_name_and_extension.cypher".

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)-[:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)<-[:CONTAINS]-(dependentArtifact:Artifact)
MATCH (dependentPackage)-[:CONTAINS]->(dependentPackageType:Type)
WHERE type <> dependentType
  AND artifact <> dependentArtifact
  WITH artifact.name AS artifactName
      ,dependentArtifact.name AS dependentArtifactName
      ,package.fqn            AS fullPackageName
      ,dependentPackage.fqn   AS fullDependentPackageName
      ,COUNT(DISTINCT dependentType)        AS dependentTypes
      ,COUNT(DISTINCT dependentPackageType) AS dependentPackageTypes
      ,collect(DISTINCT dependentType.fqn)[0..9] AS dependentTypeNameExamples
RETURN artifactName
      ,dependentArtifactName
      ,fullPackageName
      ,fullDependentPackageName
      ,dependentTypes
      ,dependentPackageTypes
      ,round(toFloat(dependentTypes) / (dependentPackageTypes + 1E-38), 4) AS typeUsagePercentage
      ,dependentTypeNameExamples
ORDER BY typeUsagePercentage ASC