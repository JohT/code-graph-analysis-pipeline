// Adding the artifact name temporarily to the Package node using map projection
 MATCH (source:Package)-[dependency:DEPENDS_ON]->(dependent:Package) 
 MATCH (sourceArtifact:Artifact)-[:CONTAINS]->(source)
 MATCH (dependentArtifact:Artifact)-[:CONTAINS]->(dependent)
 WHERE sourceArtifact.fileName CONTAINS 'modelling' 
RETURN source{.*, artifactName:sourceArtifact.fileName}
      ,dependency
      ,dependent{.*, artifactName:dependentArtifact.fileName}
 LIMIT 10