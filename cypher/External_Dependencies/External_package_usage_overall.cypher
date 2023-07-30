// External package usage overall

 MATCH (type:Type)
  WITH count(type) as allTypes, collect(type) as typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
  WITH allTypes
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,count(externalDependency)                              AS numberOfExternalTypeCaller
      ,sum(externalDependency.weight)                         AS numberOfExternalTypeCalls
      ,collect(DISTINCT externalType.name)                    AS externalTypeNames
RETURN externalPackageName
      ,numberOfExternalTypeCaller
      ,numberOfExternalTypeCalls
      ,allTypes
      ,externalTypeNames
 ORDER BY numberOfExternalTypeCaller DESC, externalPackageName ASC