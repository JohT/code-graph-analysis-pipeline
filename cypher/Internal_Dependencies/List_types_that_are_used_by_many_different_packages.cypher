// List types that are used by many different packages

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)-[:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)<-[:CONTAINS]-(dependentArtifact:Artifact)
WHERE package <> dependentPackage
WITH  dependentType
     ,labels(dependentType)       AS dependentTypeLabels
     ,COUNT(DISTINCT package.fqn) AS numberOfUsingPackages
RETURN dependentType.fqn   AS fullQualifiedDependentTypeName
      ,dependentType.name  AS dependentTypeName
      ,dependentTypeLabels
      ,numberOfUsingPackages
 ORDER BY numberOfUsingPackages DESC, dependentTypeName ASC