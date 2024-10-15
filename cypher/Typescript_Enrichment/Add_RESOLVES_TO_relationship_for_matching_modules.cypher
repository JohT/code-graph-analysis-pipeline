// Adds a relation "RESOLVES_TO" from an external module to a module if their global fully qualified names match.
// Depends on "Add_module_properties.cypher" to be run first
// Inspired by https://github.com/jQAssistant/jqassistant/blob/4cd7face5d6d2953449d8e6ff5b484f00ffbdc2f/plugin/java/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5
// Related to https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/35

MATCH (module:TS:Module)
WHERE  module.globalFqn IS NOT NULL
MATCH (externalModule:TS:ExternalModule)
WHERE module.globalFqn IS NOT NULL
  AND ((module.globalFqn = externalModule.globalFqn)
   OR  (module.module    = externalModule.module)
   OR  (  externalModule.name              = module.name 
      AND externalModule.moduleName        = module.moduleName 
      AND externalModule.namespace         = module.namespace
      AND externalModule.extensionExtended = module.extensionExtended
      AND externalModule.globalFqn ENDS WITH module.localModulePath
       )
      )
  AND module <> externalModule
 CALL {  WITH module, externalModule
        MERGE (externalModule)-[:RESOLVES_TO]->(module)
      } IN TRANSACTIONS
RETURN count(*) AS resolvedModules