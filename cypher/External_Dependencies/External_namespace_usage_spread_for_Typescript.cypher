// External Typescript namespace usage spread

// Get the overall internal modules statistics first
 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
 WHERE NOT internalModule:TestRelated
  WITH count(DISTINCT internalModule.globalFqn)                  AS internalModulesCountOverall
      ,count(DISTINCT internalElement.globalFqn)                 AS internalElementsCountOverall
      ,collect(DISTINCT internalElement)                         AS internalElementList

// Get the external declarations for each internal element
UNWIND internalElementList AS internalElement
 MATCH (internalElement)-[:DEPENDS_ON]->(externalDeclaration:ExternalDeclaration)
 WHERE externalDeclaration.isExternalImport = true
 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement)
 MATCH (externalModule:TS:ExternalModule)-[:EXPORTS]->(externalDeclaration)
  WITH internalModulesCountOverall
      ,internalElementsCountOverall
      ,externalModule.namespace                               AS externalModuleNamespace
      ,coalesce(nullIf(internalModule.namespace, '') + '/' + internalModule.name, internalModule.name) AS internalModuleName
      
      // Gathering counts for every internal element and the external module it uses
      ,count  (DISTINCT externalDeclaration.globalFqn)        AS externalDeclarationsCount
      ,COLLECT(DISTINCT externalDeclaration.globalFqn )[0..9] AS externalDeclarationsExamples
      ,count  (DISTINCT internalElement.globalFqn)            AS internalElementsCount
      ,COLLECT(DISTINCT internalElement.globalFqn )[0..9]     AS internalElementsExamples
      ,100.0 / internalModulesCountOverall 
             * count(DISTINCT internalElement.globalFqn)      AS internalElementsCallingExternalRate

// Group by external module namespace
RETURN externalModuleNamespace
      ,count(DISTINCT internalModuleName)             AS numberOfInternalModules

      // Statistics about how many internal modules are using that external module
      ,sum(externalDeclarationsCount)                 AS sumNumberOfUsedExternalDeclarations
      ,min(externalDeclarationsCount)                 AS minNumberOfUsedExternalDeclarations
      ,max(externalDeclarationsCount)                 AS maxNumberOfUsedExternalDeclarations
      ,percentileCont(externalDeclarationsCount, 0.5) AS medNumberOfUsedExternalDeclarations
      ,avg(externalDeclarationsCount)                 AS avgNumberOfUsedExternalDeclarations
      ,stDev(externalDeclarationsCount)               AS stdNumberOfUsedExternalDeclarations

      // Statistics about the internal elements and their external module usage
      ,sum(internalElementsCount)                     AS sumNumberOfInternalElements
      ,min(internalElementsCount)                     AS minNumberOfInternalElements
      ,max(internalElementsCount)                     AS maxNumberOfInternalElements
      ,percentileCont(internalElementsCount, 0.5)     AS medNumberOfInternalElements
      ,avg(internalElementsCount)                     AS avgNumberOfInternalElements
      ,stDev(internalElementsCount)                   AS stdNumberOfInternalElements

      // Statistics about the types and their external package usage count percentage
      ,min(internalElementsCallingExternalRate)       AS minNumberOfInternalElementsPercentage
      ,max(internalElementsCallingExternalRate)       AS maxNumberOfInternalElementsPercentage
      ,percentileCont(internalElementsCallingExternalRate, 0.5) AS medNumberOfInternalElementsPercentage
      ,avg(internalElementsCallingExternalRate)       AS avgNumberOfInternalElementsPercentage
      ,stDev(internalElementsCallingExternalRate)     AS stdNumberOfInternalElementsPercentage

      ,collect(DISTINCT internalModuleName)[0..4]     AS internalModuleExamples
      
// Order the results descending by the number of internal modules that use the external namespace
ORDER BY numberOfInternalModules DESC, externalModuleNamespace ASC