// Adds a relation "RESOLVES_TO" from a Typescript element to an external declaration if their global fully qualified names match.
// Inspired by https://github.com/jQAssistant/jqa-java-plugin/blob/f092122b62bb13d597840b64b73b2010bd074d1f/src/main/resources/META-INF/jqassistant-rules/java-classpath.xml#L5

MATCH (element:TS&!ExternalDeclaration)
MATCH (external:TS&ExternalDeclaration)
WHERE (element.globalFqn = external.globalFqn
   OR  toLower(element.globalFqn) = toLower(external.globalFqn))
  AND element <> external
 CALL {  WITH element, external
        MERGE (external)-[:RESOLVES_TO]->(element)
      } IN TRANSACTIONS
RETURN count(*) AS resolvedElements