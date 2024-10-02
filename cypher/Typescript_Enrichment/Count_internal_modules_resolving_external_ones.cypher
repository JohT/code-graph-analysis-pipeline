// How many internal modules resolve/represent external ones (for manual exploration)?

 MATCH (internal_module:TS:Module)
  WITH count(internal_module)   AS totalNumberOfInternalModules
      ,collect(internal_module) AS internal_modules
 UNWIND internal_modules AS internal_module
 MATCH (external_module:TS:ExternalModule)-[:RESOLVES_TO]->(internal_module)
 WHERE NOT external_module.isNodeModule = true
RETURN totalNumberOfInternalModules
      ,COUNT { (all_external_modules:TS:ExternalModule) 
               WHERE NOT all_external_modules.isNodeModule = true} 
                                       AS totalNumberOfExternalModules
      ,count(DISTINCT external_module) AS numberOfResolvedExternalModules
      ,collect(external_module.globalFqn + ' -> ' + internal_module.globalFqn)[0..4] AS exampleFullNames