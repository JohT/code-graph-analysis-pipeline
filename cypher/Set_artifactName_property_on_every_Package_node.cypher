// Set artifactName property on every Package node

MATCH (a:Artifact:File)-[:CONTAINS]->(p:Package)
WHERE a.fileName IS NOT NULL
 WITH p, replace(last(split(a.fileName, '/')), '.jar', '') AS artifactName
  SET p.artifactName = artifactName
RETURN p, artifactName