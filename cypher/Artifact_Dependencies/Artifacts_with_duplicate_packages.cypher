// Artifacts with the same full qualified package name (duplicate packages). These can lead to confusion and provide access to package protected classes to another artifact that might not be intended.

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 WHERE EXISTS ((package)-[:CONTAINS]->(:Type))
  WITH package.fqn AS packageName
      ,replace(last(split(artifact.fileName, '/')), '.jar', '') as artifactName
  WITH packageName
      ,collect(DISTINCT artifactName) AS artifactNames
      ,count(*) AS duplicates 
 WHERE duplicates > 1
RETURN packageName, duplicates, artifactNames
 ORDER BY duplicates DESCENDING