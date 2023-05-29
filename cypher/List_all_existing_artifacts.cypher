// List all existing artifacts

MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type) 
 WITH last(split(artifact.fileName, '/')) AS artifactName
     ,COUNT(DISTINCT package) AS packages
     ,COUNT(DISTINCT type) AS types
RETURN artifactName, packages, types