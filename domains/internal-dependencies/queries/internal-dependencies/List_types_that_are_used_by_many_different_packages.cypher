// List types that are used by many different packages

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)-[:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)<-[:CONTAINS]-(dependentArtifact:Artifact)
 WHERE package <> dependentPackage
 WITH  dependentType
      ,labels(dependentType)       AS dependentTypeLabels
      ,COUNT(DISTINCT package.fqn) AS numberOfUsingPackages
UNWIND dependentTypeLabels AS dependentTypeLabel
 WITH *
 WHERE NOT dependentTypeLabel STARTS WITH 'Mark4'
   AND NOT dependentTypeLabel IN ['File', 'ByteCode', 'Java', 'Type']
  WITH dependentType, collect(dependentTypeLabel) AS dependentTypeLabels, numberOfUsingPackages
RETURN dependentType.fqn   AS fullQualifiedDependentTypeName
      ,dependentType.name  AS dependentTypeName
      ,dependentTypeLabels[0] + coalesce(' ' + dependentTypeLabels[1], '') AS dependentTypeLabel
      ,numberOfUsingPackages
 ORDER BY numberOfUsingPackages DESC, dependentTypeName ASC