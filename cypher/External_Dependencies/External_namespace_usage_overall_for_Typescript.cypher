// External Typescript namespace usage overall

 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
 WHERE NOT internalModule:TestRelated
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
      ,coalesce(nullif(externalModule.namespace, ''), 'no namespace') AS externalNamespaceName
      ,count(DISTINCT internalModule.globalFqn)      AS numberOfExternalCallerModules
      ,count(DISTINCT internalElement.globalFqn)     AS numberOfExternalCallerElements
      ,count(externalDependency)                     AS numberOfExternalDeclarationCalls
      ,sum(externalDependency.cardinality)           AS numberOfExternalDeclarationCallsWeighted
      ,collect('<' + internalElement.name 
             + '> of module <'
             + internalModule.name
             + '> imports <'  
             + externalDeclaration.name
             + '> from external namespace <'
             + externalModule.namespace + '>')[0..4] AS exampleStories
RETURN externalNamespaceName
      ,numberOfExternalCallerModules
      ,numberOfExternalCallerElements
      ,numberOfExternalDeclarationCalls
      ,numberOfExternalDeclarationCallsWeighted
      ,allModules
      ,allInternalElements
      ,exampleStories
 ORDER BY numberOfExternalCallerModules DESC, externalNamespaceName ASC