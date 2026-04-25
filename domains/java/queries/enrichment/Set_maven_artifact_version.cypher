// Set property "version" on Artifact nodes to what is specified in the Maven POM

   MATCH (artifact:Java:Artifact)-[:CONTAINS]-(pom:Maven:Pom)
   MATCH (pom)-[:HAS_ROOT_ELEMENT]->(pomProject:Element{name:'project'})
OPTIONAL MATCH (pomProject)-[:HAS_ELEMENT]->(:Element{name:'version'})-[:HAS_TEXT]->(versionValue:Text) 
OPTIONAL MATCH (pomProject)-[:HAS_ELEMENT]->(:Element{name:'parent'})
-[:HAS_ELEMENT]->(:Element{name:'version'})-[:HAS_TEXT]->(parentVersionValue:Text)
   WITH *, artifact, coalesce(versionValue.value, parentVersionValue.value) AS versionNumber
  WHERE versionNumber IS NOT NULL
    SET artifact.version = versionNumber
  RETURN count(DISTINCT artifact.fileName) AS numberOfUpdatedArtifacts
// Debugging
// RETURN artifact.name, versionNumber, versionValue.value, parentVersionValue.value
//  LIMIT 25