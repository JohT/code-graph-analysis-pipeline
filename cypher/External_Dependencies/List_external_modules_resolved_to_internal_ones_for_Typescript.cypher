// Statistics about how many ExternalModule nodes were found that match internal Module nodes 

 MATCH (module:TS:Module)<-[resolved:RESOLVES_TO]-(external:TS:ExternalModule)
OPTIONAL MATCH (project:TS:Project)-[:CONTAINS]->(module)
  WITH project.name                               AS projectName
      ,count(DISTINCT module)                     AS resolvedModuleCount
      ,COUNT { (modules:Module) }                 AS totalModuleCount
      ,COUNT { (externalModules:ExternalModule) } AS totalExternalModuleCount
      ,collect(DISTINCT module.fileName + ' -> ' + external.globalFqn)[0..4] AS resolvedExamples
RETURN projectName
      ,resolvedModuleCount
      ,totalModuleCount
      ,round(100.0 / totalModuleCount 
                   * resolvedModuleCount, 2) AS resolvedModulePercentage 
      ,totalExternalModuleCount
      ,round(100.0 / totalExternalModuleCount 
                   * resolvedModuleCount, 2) AS resolvedExternalModulePercentage 
      ,resolvedExamples