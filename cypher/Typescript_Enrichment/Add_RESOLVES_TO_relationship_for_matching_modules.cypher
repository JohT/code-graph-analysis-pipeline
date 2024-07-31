// Adds a relation "RESOLVES_TO" from an external module to a module if their global fully qualified names match.
// Inspired by https://github.com/jQAssistant/jqassistant/blob/4cd7face5d6d2953449d8e6ff5b484f00ffbdc2f/plugin/java/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5
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