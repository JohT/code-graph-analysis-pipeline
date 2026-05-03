// Cyclomatic Complexity Method Complexity Distribution

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type)-[:DECLARES]->(method:Method)
 WHERE method.effectiveLineCount > 0
  WITH last(split(artifact.fileName, '/')) AS artifactName
       ,method.cyclomaticComplexity        AS cyclomaticComplexity
       ,count(method)                      AS methods
RETURN artifactName, cyclomaticComplexity, methods
 ORDER BY artifactName asc, cyclomaticComplexity