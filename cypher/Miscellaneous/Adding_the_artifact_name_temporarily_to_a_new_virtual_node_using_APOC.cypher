// Adding the artifact name temporarily to a new virtual node using APOC.
// Doesn't take all relationships into account and therefore doesn't work yet.
 MATCH (source:Package)-[dependency:DEPENDS_ON]->(dependent:Package) 
 MATCH (sourceArtifact:Artifact)-[:CONTAINS]->(source)
 MATCH (dependentArtifact:Artifact)-[:CONTAINS]->(dependent)
 WHERE sourceArtifact.fileName CONTAINS 'modelling'
  CALL apoc.create.vNode(
    labels(source), 
    source{.*, artifactName:sourceArtifact.fileName}
  ) YIELD node AS vSource
  CALL apoc.create.vNode(
    labels(dependent), 
    dependent{.*, artifactName:dependentArtifact.fileName}
  ) YIELD node AS vDependent
  CALL apoc.create.vRelationship(
    vSource, type(dependency), dependency{.*}, vDependent)
    YIELD rel AS vDependency
RETURN vSource
      ,vDependency
      ,vDependent
 LIMIT 10