// External package usage per type distribution

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '')  AS artifactName
      ,count(type)                                               AS artifactTypes
      ,collect(type)                                             AS typeList
UNWIND typeList AS type
 MATCH (type)-[:DEPENDS_ON]->(externalType:Type)
 WHERE externalType.byteCodeVersion IS NULL
  WITH artifactName
      ,artifactTypes
      ,type.fqn                                                  AS fullTypeName
      ,replace(externalType.fqn, '.' + externalType.name, '')    AS externalPackageName
      ,(NOT externalType.fqn CONTAINS '.')                       AS isPrimitiveType
      ,(externalType.fqn STARTS WITH 'java.')                    AS isJavaType
      ,exists((externalType)-[:RESOLVES_TO]->(:Type))            AS isAlsoInternalType
      ,exists((externalType)<-[:OF_TYPE]-()<-[:ANNOTATED_BY]-()) AS isAnnotation
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
   AND isAnnotation       = false
  WITH artifactName
      ,artifactTypes
      ,fullTypeName
      ,count(DISTINCT externalPackageName) AS numberOfExternalPackages    
  WITH artifactName
      ,artifactTypes
      ,numberOfExternalPackages
      ,count(DISTINCT fullTypeName)   AS numberOfTypes
      ,COLLECT(DISTINCT fullTypeName) AS nameOfTypes
RETURN artifactName
      ,artifactTypes
      ,numberOfExternalPackages
      ,numberOfTypes
      ,100.0 / artifactTypes * numberOfTypes AS numberOfTypesPercentage
      ,nameOfTypes
ORDER BY artifactName ASC, numberOfExternalPackages ASC