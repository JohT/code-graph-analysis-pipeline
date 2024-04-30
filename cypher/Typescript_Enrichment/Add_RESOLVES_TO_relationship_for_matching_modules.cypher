// Adds a relation "RESOLVES_TO" from an external module to a module if their global fully qualified names match.
// Inspired by https://github.com/jQAssistant/jqa-java-plugin/blob/f092122b62bb13d597840b64b73b2010bd074d1f/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5
// Related to https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/35

MATCH (module:TS:Module)
WHERE  module.globalFqn IS NOT NULL
MATCH (externalModule:TS:ExternalModule)
WHERE module.globalFqn IS NOT NULL
  AND (module.globalFqn = externalModule.globalFqn
   OR  module.globalFqn = split(externalModule.globalFqn, '/index.')[0]
   OR  externalModule.globalFqn = split(module.globalFqn, '/index.')[0]
      )
  AND module <> externalModule
 CALL {  WITH module, externalModule
        MERGE (externalModule)-[:RESOLVES_TO]->(module)
      } IN TRANSACTIONS
RETURN count(*) AS resolvedModules