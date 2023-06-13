// External package usage overall

 MATCH (type:Type)
  WITH count(type) as allTypes, collect(type) as typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:Type)
  WITH allTypes
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,externalType.name                              AS externalTypeName
      ,externalDependency
      ,(NOT externalType.fqn CONTAINS '.')            AS isPrimitiveType
      ,(externalType.fqn STARTS WITH 'java.')         AS isJavaType
      ,exists((externalType)-[:RESOLVES_TO]->(:Type)) AS isAlsoInternalType
      ,(externalType.byteCodeVersion IS NULL)         AS isExternalType
 WHERE isPrimitiveType    = false
   AND isJavaType         = false
   AND isAlsoInternalType = false
   AND isExternalType     = true
  WITH allTypes
      ,externalPackageName
      ,count(externalDependency)          AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)     AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalTypeName) AS externalTypeNames
RETURN externalPackageName
      ,numberOfExternalTypeCaller
      ,numberOfExternalTypeCalls
      ,allTypes
      ,externalTypeNames
 ORDER BY numberOfExternalTypeCaller DESC, externalTypeNames ASC