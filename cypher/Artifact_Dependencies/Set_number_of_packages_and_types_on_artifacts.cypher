// Set number of packages and types on artifacts

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
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