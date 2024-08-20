// Propagates "DEPENDS_ON" relations between modules to their resolved modules with a property "resolved:true".
// Inspired by https://github.com/jQAssistant/jqassistant/blob/4cd7face5d6d2953449d8e6ff5b484f00ffbdc2f/plugin/java/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5

 MATCH (module:TS:Module)-[dependsOn:DEPENDS_ON]->(externalModule:TS:ExternalModule)
 MATCH (externalModule)-[:RESOLVES_TO]->(resolvedModule:TS:Module)
 WHERE module <> resolvedModule
  CALL {  WITH module, dependsOn, resolvedModule
         MERGE (module)-[resolvedDependsOn:DEPENDS_ON]->(resolvedModule)
            ON CREATE SET resolvedDependsOn          = dependsOn
                         ,resolvedDependsOn.resolved = true
       } IN TRANSACTIONS
RETURN count(*) as resolvedDependencies