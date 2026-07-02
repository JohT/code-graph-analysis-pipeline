// External SCIP type package (module) usage overall. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher" and "Import_SCIP_Type_Edges.cypher".

 MATCH (module:SCIPModule)-[:CONTAINS]->(type:SCIPInternalType)
  WITH count(DISTINCT type.symbol)  AS allTypes
      ,count(DISTINCT module.fqn)   AS allModules
      ,collect(type)                AS typeList
UNWIND typeList AS type
 MATCH (type)-[externalDependency:DEPENDS_ON]->(externalType:SCIPExternalType)
 MATCH (typeModule:SCIPModule)-[:CONTAINS]->(type)
  WITH allTypes
      ,allModules
      ,externalType.module                          AS externalPackageName
      ,count(DISTINCT typeModule.fqn)               AS numberOfExternalCallerModules
      ,count(DISTINCT type.symbol)                  AS numberOfExternalCallerTypes
      ,count(externalDependency)                    AS numberOfExternalTypeCalls
      ,sum(externalDependency.referenceCount)       AS numberOfExternalTypeCallsWeighted
      ,collect(DISTINCT externalType.name)          AS externalTypeNames
RETURN externalPackageName
      ,numberOfExternalCallerModules
      ,numberOfExternalCallerTypes
      ,numberOfExternalTypeCalls
      ,numberOfExternalTypeCallsWeighted
      ,allModules
      ,allTypes
      ,externalTypeNames[0..9] AS tenExternalTypeNames
 ORDER BY numberOfExternalCallerModules DESC, externalPackageName ASC
