// Propagates "DEPENDS_ON" relations between modules to their resolved modules with a property "resolved:true".
// Inspired by https://github.com/jQAssistant/jqa-java-plugin/blob/f092122b62bb13d597840b64b73b2010bd074d1f/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L59

 MATCH (module:TS:Module)-[dependsOn:DEPENDS_ON]->(externalModule:TS:ExternalModule)
 MATCH (externalModule)-[:RESOLVES_TO]->(resolvedModule:TS:Module)
 WHERE module <> resolvedModule
  CALL {  WITH module, dependsOn, resolvedModule
         MERGE (module)-[resolvedDependsOn:DEPENDS_ON]->(resolvedModule)
           SET resolvedDependsOn = dependsOn
              ,resolvedDependsOn.resolved=true
       } IN TRANSACTIONS
RETURN count(*) as resolvedDependencies