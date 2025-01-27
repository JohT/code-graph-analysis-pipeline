// External package usage overall

 MATCH (package:Package)-[:CONTAINS]->(type:Type)
  WITH count(DISTINCT type.fqn)    AS allTypes
      ,count(DISTINCT package.fqn) AS allPackages
      ,collect(type) as typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:ExternalType)
 MATCH (typePackage:Package)-[:CONTAINS]->(type)
  WITH allTypes
      ,allPackages
      ,replace(externalType.fqn, '.' + externalType.name, '') AS externalPackageName
      ,count(DISTINCT typePackage.fqn)                        AS numberOfExternalCallerPackages
      ,count(DISTINCT type.fqn)                               AS numberOfExternalCallerTypes
      ,count(externalDependency)                              AS numberOfExternalTypeCalls
      ,sum(externalDependency.weight)                         AS numberOfExternalTypeCallsWeighted
      ,collect(DISTINCT externalType.name)                    AS externalTypeNames
where numberOfExternalTypeCalls <> numberOfExternalCallerTypes
RETURN externalPackageName
      ,numberOfExternalCallerPackages
      ,numberOfExternalCallerTypes
      ,numberOfExternalTypeCalls
      ,numberOfExternalTypeCallsWeighted
      ,allPackages
      ,allTypes
      ,externalTypeNames[0..9] AS tenExternalTypeNames
 ORDER BY numberOfExternalCallerPackages DESC, externalPackageName ASC