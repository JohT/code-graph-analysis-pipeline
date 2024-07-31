// Adds a relation "RESOLVES_TO" from a Typescript element to an external declaration if their global fully qualified names match.
// Inspired by https://github.com/jQAssistant/jqassistant/blob/4cd7face5d6d2953449d8e6ff5b484f00ffbdc2f/plugin/java/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5
// Related to https://github.com/jqassistant-plugin/jqassistant-typescript-plugin/issues/35

MATCH (element:TS&!ExternalDeclaration)
WHERE  element.globalFqn IS NOT NULL
MATCH (external:TS&ExternalDeclaration)
WHERE  element.globalFqn IS NOT NULL 
  AND  element.globalFqn = external.globalFqn
  AND  element <> external
 CALL {  WITH element, external
        MERGE (external)-[:RESOLVES_TO]->(element)
      } IN TRANSACTIONS
RETURN count(*) AS resolvedElements