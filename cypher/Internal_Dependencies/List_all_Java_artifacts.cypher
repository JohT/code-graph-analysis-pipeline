// List all existing artifacts

MATCH (artifact:Java:Artifact)-[:CONTAINS]->(package:Java:Package)-[:CONTAINS]->(type:Java:Type) 
 WITH last(split(artifact.fileName, '/')) AS artifactName
     ,artifact.incomingDependencies       AS incomingDependencies
     ,artifact.outgoingDependencies       AS outgoingDependencies
     ,COUNT(DISTINCT package.fqn)         AS packages
     ,COUNT(DISTINCT type.fqn)            AS types
RETURN artifactName, packages, types, incomingDependencies, outgoingDependencies