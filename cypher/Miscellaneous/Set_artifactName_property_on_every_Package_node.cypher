// Set artifactName property on every Package node. Requires "Add_file_name and_extension.cypher".

MATCH (a:Artifact:File)-[:CONTAINS]->(p:Package)
WHERE a.fileName IS NOT NULL
 WITH p, a.name AS artifactName
  SET p.artifactName = artifactName
RETURN p, artifactName