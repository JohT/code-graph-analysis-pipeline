// External package usage per artifact

 MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(type:Type)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,count(type)   AS numberOfTypesInArtifact
      ,collect(type) AS typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
  WITH numberOfTypesInArtifact
      ,externalDependency
      ,artifactName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
  WITH numberOfTypesInArtifact
      ,artifactName
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
RETURN artifactName
      ,externalPackageName
      ,numberOfExternalTypeCaller
      ,numberOfExternalTypeCalls
      ,numberOfTypesInArtifact
      ,externalTypeNames
ORDER BY artifactName ASC, numberOfExternalTypeCaller DESC, externalPackageName ASC