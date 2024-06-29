// External Typescript module usage distribution for internal modules

 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
  WITH internalModule.name                       AS internalModuleName
      ,count(DISTINCT internalElement.globalFqn) AS numberOfAllInternalElements
      ,collect(DISTINCT internalElement)         AS internalElementList
UNWIND internalElementList AS internalElement
 MATCH (internalElement)-[:DEPENDS_ON]->(externalElement:ExternalDeclaration)
 WHERE externalElement.isExternalImport = true
 MATCH (internalModule:Module)-[:EXPORTS]->(internalElement)
 MATCH (externalModule:ExternalModule)-[:EXPORTS]->(externalElement)
  WITH internalModuleName
      ,numberOfAllInternalElements
      ,internalModule.globalFqn      AS fullInternalModuleName
      ,internalElement.globalFqn     AS fullInternalElementName
      ,coalesce(
          nullIf(externalModule.namespace, '') + '/' + externalModule.name, 
          externalModule.name)       AS externalModuleName
  WITH internalModuleName
      ,numberOfAllInternalElements
      ,count(DISTINCT externalModuleName)              AS externalModuleCount
      ,COLLECT(DISTINCT externalModuleName)[0..9]      AS externalModuleExamples
      ,count(DISTINCT fullInternalElementName)         AS internalElementCount
      ,COLLECT(DISTINCT fullInternalElementName)[0..9] AS internalElementExamples
RETURN internalModuleName
      ,numberOfAllInternalElements
      ,externalModuleCount
      ,internalElementCount
      ,100.0 / numberOfAllInternalElements * internalElementCount AS internalElementsCallingExternalRate
      ,externalModuleExamples
      ,internalElementExamples
ORDER BY internalElementCount DESC, internalModuleName ASC