// Effective Method Line Count Distribution

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type)-[:DECLARES]->(method:Method)
 WHERE method.effectiveLineCount > 0
  WITH last(split(artifact.fileName, '/'))     AS artifactName
       ,method.effectiveLineCount              AS effectiveLineCount
       ,count(method)                          AS methods
RETURN artifactName, effectiveLineCount, methods
 ORDER BY artifactName asc, effectiveLineCount