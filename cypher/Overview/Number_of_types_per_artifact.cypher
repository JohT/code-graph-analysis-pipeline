// Number of types per artifact

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type) 
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,count(DISTINCT type.fqn) AS numberOfArtifactTypes
      ,collect(DISTINCT type)   AS types
UNWIND types AS type
  WITH artifactName
      ,numberOfArtifactTypes
      ,type
      ,labels(type) AS typeLabels
UNWIND typeLabels AS typeLabel
  WITH artifactName
      ,numberOfArtifactTypes
      ,type
      ,typeLabel
 WHERE typeLabel IN ['Class', 'Interface', 'Annotation', 'Enum']
RETURN artifactName
      ,numberOfArtifactTypes
      ,typeLabel    AS languageElement
      ,count(type)  AS numberOfTypes
 ORDER BY numberOfArtifactTypes DESC, artifactName ASC