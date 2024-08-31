// Number of packages per artifact. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
  WITH artifact.name AS artifactName
      ,count(DISTINCT package.fqn) as numberOfPackages
 RETURN artifactName, numberOfPackages