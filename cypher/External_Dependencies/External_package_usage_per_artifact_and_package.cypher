// External package usage per artifact and package 

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
  WITH artifact, package, count(type) AS numberOfTypesInPackage, collect(type) as typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:Type)
 WHERE externalType.byteCodeVersion IS NULL
  WITH numberOfTypesInPackage
      ,externalDependency
      ,replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn  AS fullPackageName
      ,package.name AS packageName
      ,type.fqn     AS fullTypeName
      ,type.name    AS typeName
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
      ,(NOT externalType.fqn CONTAINS '.')            AS isPrimitiveType
      ,(externalType.fqn STARTS WITH 'java.')         AS isJavaType
      ,exists((externalType)-[:RESOLVES_TO]->(:Type)) AS isAlsoInternalType
      ,exists((externalType)<-[:OF_TYPE]-()<-[:ANNOTATED_BY]-()) AS isAnnotation
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
   AND isAnnotation       = false
  WITH numberOfTypesInPackage
      ,artifactName
      ,fullPackageName
      ,packageName
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
RETURN artifactName, fullPackageName
      ,externalPackageName
      ,numberOfExternalTypeCaller, numberOfExternalTypeCalls, numberOfTypesInPackage
      ,externalTypeNames
      ,packageName
ORDER BY numberOfExternalTypeCaller DESC, artifactName ASC, fullPackageName ASC