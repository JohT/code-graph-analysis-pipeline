// External Typescript module usage per internal module sorted by external usage descending

 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
 WHERE NOT internalModule:TestRelated
 OPTIONAL MATCH (internalElement)-[:DEPENDS_ON]->(externalDeclaration:ExternalDeclaration)
          WHERE externalDeclaration.isExternalImport = true
 OPTIONAL MATCH (externalModule:ExternalModule)-[:EXPORTS]->(externalDeclaration)
  WITH internalModule.name                           AS internalModuleName
      ,count(DISTINCT internalElement.globalFqn)     AS numberOfAllElementsInInternalModule
      ,count(DISTINCT externalDeclaration.globalFqn) AS numberOfAllExternalDeclarationsUsedInInternalModule
      ,count(DISTINCT externalModule.globalFqn)      AS numberOfAllExternalModulesUsedInInternalModule
      ,collect(DISTINCT internalElement)             AS internalElementList
UNWIND internalElementList AS internalElement
 MATCH (internalElement)-[externalDependency:DEPENDS_ON]->(externalDeclaration:ExternalDeclaration)
 WHERE externalDeclaration.isExternalImport = true
 MATCH (externalModule:ExternalModule)-[:EXPORTS]->(externalDeclaration)
  WITH numberOfAllElementsInInternalModule
      ,numberOfAllExternalDeclarationsUsedInInternalModule
      ,numberOfAllExternalModulesUsedInInternalModule
      ,100.0 / numberOfAllElementsInInternalModule * numberOfAllExternalDeclarationsUsedInInternalModule AS externalDeclarationRate 
      ,externalDependency
      ,internalModuleName
      ,internalElement.globalFqn     AS fullInternalElementName
      ,internalElement.name          AS internalElementName
      ,externalModule.namespace      AS externalNamespaceName
      ,externalDeclaration.name      AS externalDeclarationName
  WITH numberOfAllElementsInInternalModule
      ,numberOfAllExternalDeclarationsUsedInInternalModule
      ,numberOfAllExternalModulesUsedInInternalModule
      ,externalDeclarationRate
      ,internalModuleName
      ,externalNamespaceName
      ,count(externalDependency)                 AS numberOfExternalDeclarationCaller
      ,sum(externalDependency.cardinality)       AS numberOfExternalDeclarationCalls
      ,collect(DISTINCT externalDeclarationName) AS externalDeclarationNames
RETURN internalModuleName
      ,externalNamespaceName
      ,numberOfExternalDeclarationCaller
      ,numberOfExternalDeclarationCalls
      ,numberOfAllElementsInInternalModule
      ,numberOfAllExternalDeclarationsUsedInInternalModule
      ,numberOfAllExternalModulesUsedInInternalModule
      ,externalDeclarationRate
      ,externalDeclarationNames
ORDER BY externalDeclarationRate DESC
        ,internalModuleName ASC
        ,numberOfExternalDeclarationCaller DESC
        ,externalNamespaceName ASC