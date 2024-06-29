// How many elements compared to all existing are used by dependent Typescript modules?

MATCH (sourceModule:TS&Module)-[:EXPORTS]-(sourceElement:TS)
MATCH (sourceElement)-[:DEPENDS_ON]->(dependentElement:TS&!Module&!ExternalModule)
MATCH (dependentModule:TS&Module)-[:EXPORTS]->(dependentElement)
WHERE sourceModule <> dependentModule
MATCH (dependentModule)-[:EXPORTS]->(dependentModuleElement:TS)
  WITH sourceModule.name                                  AS sourceModuleName
      ,dependentModule.name                               AS dependentModuleName
      ,COUNT(DISTINCT dependentElement.globalFqn)         AS dependentElementsCount
      ,COUNT(DISTINCT dependentModuleElement.globalFqn)   AS dependentModuleElementsCount
      ,collect(DISTINCT dependentElement.globalFqn)[0..4] AS dependentElementFullNameExamples
      ,collect(DISTINCT dependentElement.name)[0..4]      AS dependentElementNameExamples
RETURN sourceModuleName
      ,dependentModuleName
      ,dependentElementsCount
      ,dependentModuleElementsCount
      ,toFloat(dependentElementsCount) / (dependentModuleElementsCount + 1E-38) AS elementUsagePercentage
      ,dependentElementFullNameExamples
      ,dependentElementNameExamples
ORDER BY elementUsagePercentage ASC