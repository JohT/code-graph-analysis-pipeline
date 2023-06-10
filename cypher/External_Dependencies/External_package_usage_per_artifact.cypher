// External package usage per artifact 

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type)
  WITH artifact, count(type) as numberOfTypesInArtifact, collect(type) as typeList
UNWIND typeList as type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:Type)
 WHERE externalType.byteCodeVersion IS NULL
  WITH numberOfTypesInArtifact
      ,externalDependency
      ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
      ,(NOT externalType.fqn CONTAINS '.')            AS isPrimitiveType
      ,(externalType.fqn STARTS WITH 'java.')         AS isJavaType
      ,exists((externalType)-[:RESOLVES_TO]->(:Type)) AS isAlsoInternalType
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
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
ORDER BY artifactName ASC, numberOfExternalTypeCaller DESC