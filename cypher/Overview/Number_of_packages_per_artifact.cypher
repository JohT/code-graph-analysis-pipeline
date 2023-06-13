// Number of packages per artifact

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,count(DISTINCT package.fqn) as numberOfPackages
 RETURN artifactName, numberOfPackages