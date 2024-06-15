// External Typescript module usage per interal module aggregated

// Get the overall internal module statistics first
 MATCH (internalModule:TS:Module)-[:EXPORTS]->(internalElement:TS)
  WITH internalModule.name                       AS internalModuleName
      ,internalModule.communityLeidenId          AS leidenCommunityId
      ,count(DISTINCT internalElement.globalFqn) AS internalModuleElementsCount
      ,collect(DISTINCT internalElement)         AS internalElementList

// Get the external dependencies for each internal internalElement
UNWIND internalElementList AS internalElement
 MATCH (internalElement)-[:DEPENDS_ON]->(externalDeclaration:ExternalDeclaration)
 MATCH (internalModule:Module)-[:EXPORTS]->(internalElement)
 MATCH (externalModule:ExternalModule)-[:EXPORTS]->(externalDeclaration)
 WHERE externalDeclaration.isExternalImport = true
  WITH internalModuleName
      ,leidenCommunityId
      ,internalModuleElementsCount
      ,internalModule.globalFqn    AS fullInternalModuleName
      ,internalElement.globalFqn   AS fullInternalElementName
      ,coalesce(
          nullIf(externalModule.namespace, '') + '/' + externalModule.name, 
          externalModule.name)     AS externalModuleName

// Group by internalModule and external internalElement
  WITH internalModuleName
      ,leidenCommunityId
      ,internalModuleElementsCount
      ,externalModuleName
      ,count(DISTINCT fullInternalModuleName)          AS internalModulesCount
      ,COLLECT(DISTINCT fullInternalModuleName)[0..9]  AS internalModulesExamples
      ,count(DISTINCT fullInternalElementName)         AS internalElementsCount
      ,COLLECT(DISTINCT fullInternalElementName)[0..9] AS internalElementsExamples
      ,100.0 / internalModuleElementsCount * count(DISTINCT fullInternalElementName)   AS internalElementsCallingExternalRate

// Pre order the results by number of packages that use the external package dependency descending
ORDER BY internalModulesCount DESC, internalModuleName ASC

// Optionally filter out external dependencies that are only used by one internal module
// WHERE internalModulesCount > 1

// Group by internalModule, aggregate statistics and return the results
RETURN internalModuleName
      ,leidenCommunityId
      ,internalModuleElementsCount
      ,count(DISTINCT externalModuleName)        AS numberOfExternalModules
      
      // Statistics about the packages and their external package usage count
      ,min(internalModulesCount)                 AS minNumberOfInternalModules
      ,max(internalModulesCount)                 AS maxNumberOfInternalModules
      ,percentileCont(internalModulesCount, 0.5) AS medNumberOfInternalModules
      ,avg(internalModulesCount)                 AS avgNumberOfInternalModules
      ,stDev(internalModulesCount)               AS stdNumberOfInternalModules

      // Statistics about the types and their external package usage count
      ,min(internalElementsCount)                 AS minNumberOfInternalElements
      ,max(internalElementsCount)                 AS maxNumberOfInternalElements
      ,percentileCont(internalElementsCount, 0.5) AS medNumberOfInternalElements
      ,avg(internalElementsCount)                 AS avgNumberOfInternalElements
      ,stDev(internalElementsCount)               AS stdNumberOfInternalElements

      // Statistics about the types and their external package usage count percentage
      ,min(internalElementsCallingExternalRate)                 AS minNumberOfInternalElementsPercentage
      ,max(internalElementsCallingExternalRate)                 AS maxNumberOfInternalElementsPercentage
      ,percentileCont(internalElementsCallingExternalRate, 0.5) AS medNumberOfInternalElementsPercentage
      ,avg(internalElementsCallingExternalRate)                 AS avgNumberOfInternalElementsPercentage
      ,stDev(internalElementsCallingExternalRate)               AS stdNumberOfInternalElementsPercentage

      // Examples of external packages, caller packages and caller types
      ,collect(externalModuleName)[0..9]            AS top10ExternalPackageNamesByUsageDescending
      ,COLLECT(internalModulesExamples)[0]          AS internalModulesExamples
      ,COLLECT(internalElementsExamples)[0]         AS internalElementsExamples

ORDER BY maxNumberOfInternalModules DESC, internalModuleName ASC