// Artifacts with the same full qualified package name (duplicate packages). These can lead to confusion and provide access to package protected classes to another artifact that might not be intended. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 WHERE EXISTS ((package)-[:CONTAINS]->(:Type))
  WITH package.fqn AS packageName
      ,artifact.name as artifactName
  WITH packageName
      ,collect(DISTINCT artifactName) AS artifactNames
      ,count(*) AS duplicates 
 WHERE duplicates > 1
RETURN packageName, duplicates, artifactNames
 ORDER BY duplicates DESCENDING