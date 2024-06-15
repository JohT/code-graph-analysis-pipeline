// External Typescript module usage overall

 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
  WITH count(DISTINCT internalElement.globalFqn)  AS allInternalElements
      ,count(DISTINCT internalModule.globalFqn)   AS allModules
      ,collect(DISTINCT internalElement)          AS internalElementList
UNWIND internalElementList AS internalElement
 MATCH (internalElement)-[externalDependency:DEPENDS_ON]->(externalDeclaration:ExternalDeclaration)
 WHERE externalDeclaration.isExternalImport = true
 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement)
 MATCH (externalModule:ExternalModule)-[:EXPORTS]->(externalDeclaration)
  WITH allInternalElements
      ,allModules
      ,coalesce(nullIf(externalModule.namespace, '') + '/' + externalModule.name, externalModule.name) AS externalModuleName
      ,count(DISTINCT internalModule.globalFqn)         AS numberOfExternalCallerModules
      ,count(DISTINCT internalElement.globalFqn)        AS numberOfExternalCallerElements
      ,count(externalDependency)                        AS numberOfExternalDeclarationCalls
      ,sum(externalDependency.cardinality)              AS numberOfExternalDeclarationCallsWeighted
      ,collect('<' + internalElement.name 
             + '> of module <'
             + internalModule.name
             + '> imports <'  
             + externalDeclaration.name
             + '> from external module <'
             + externalModule.name + '>')[0..4]         AS exampleStories
RETURN externalModuleName
      ,numberOfExternalCallerModules
      ,numberOfExternalCallerElements
      ,numberOfExternalDeclarationCalls
      ,numberOfExternalDeclarationCallsWeighted
      ,allModules
      ,allInternalElements
      ,exampleStories
 ORDER BY numberOfExternalCallerModules DESC, externalModuleName ASC