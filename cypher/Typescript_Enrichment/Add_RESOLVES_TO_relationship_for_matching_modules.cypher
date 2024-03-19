// Adds a relation "RESOLVES_TO" from an external module to a module if their global fully qualified names match.
// Inspired by https://github.com/jQAssistant/jqa-java-plugin/blob/f092122b62bb13d597840b64b73b2010bd074d1f/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5

MATCH (module:TS:Module)
MATCH (externalModule:TS:ExternalModule)
WHERE (toLower(module.globalFqn) = toLower(externalModule.globalFqn)
   OR  toLower(module.globalFqn) = split(toLower(externalModule.globalFqn), '/index.')[0]
   OR  toLower(externalModule.globalFqn) = split(toLower(module.globalFqn), '/index.')[0]
      )
  AND module <> externalModule
 CALL {  WITH module, externalModule
        MERGE (externalModule)-[:RESOLVES_TO]->(module)
      } IN TRANSACTIONS
RETURN count(*) AS resolvedModules