// List all existing artifacts

MATCH (artifact:Artifact:Archive)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type) 
 WITH last(split(artifact.fileName, '/')) AS artifactName
     ,artifact.incomingDependencies       AS incomingDependencies
     ,artifact.outgoingDependencies       AS outgoingDependencies
     ,COUNT(DISTINCT package.fqn)         AS packages
     ,COUNT(DISTINCT type.fqn)            AS types
RETURN artifactName, packages, types, incomingDependencies, outgoingDependencies