// External package usage per type

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:Type)
 WHERE externalType.byteCodeVersion IS NULL
  WITH externalDependency
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
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
  WITH artifactName
      ,fullPackageName
      ,packageName
      ,fullTypeName
      ,typeName
      ,count(externalDependency)             AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)        AS numberOfExternalTypeCalls
      ,count  (DISTINCT externalPackageName) AS numberOfExternalPackages
      ,collect(DISTINCT externalPackageName) AS externalPackageNames
      ,count  (DISTINCT externalPackageName + '.' + externalTypeName) AS numberOfExternalTypes
      ,collect(DISTINCT externalPackageName + '.' + externalTypeName) AS externalTypeNames
RETURN artifactName, fullPackageName, typeName
      ,numberOfExternalTypeCaller, numberOfExternalTypeCalls, numberOfExternalPackages, numberOfExternalTypes
      ,externalPackageNames, externalTypeNames
      ,packageName
      ,fullTypeName
ORDER BY numberOfExternalPackages DESC, artifactName ASC, fullPackageName ASC