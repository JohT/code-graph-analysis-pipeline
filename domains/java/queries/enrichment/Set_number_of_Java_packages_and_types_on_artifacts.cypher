// Set number of Java packages and types on artifacts

 MATCH (artifact:Java:Artifact)-[:CONTAINS]->(package:Java:Package)
 MATCH (package)-[:CONTAINS]->(type:Type)
  WITH artifact
      ,COUNT(DISTINCT package.fqn) AS numberOfPackages
      ,COUNT(DISTINCT type.fqn)    AS numberOfTypes
   SET artifact.numberOfPackages = numberOfPackages
      ,artifact.numberOfTypes    = numberOfTypes
RETURN artifact.fileName
      ,numberOfPackages
      ,numberOfTypes
 ORDER BY artifact.fileName