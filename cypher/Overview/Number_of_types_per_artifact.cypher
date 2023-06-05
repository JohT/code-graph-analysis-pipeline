// Number of types per artifact

 MATCH (artifact:Artifact)-[:CONTAINS]->(type:Type) 
  WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,type
      ,labels(type) AS typeLabels
UNWIND typeLabels AS typeLabel
  WITH artifactName, type, typeLabel
 WHERE typeLabel IN ['Class', 'Interface', 'Annotation', 'Enum']
RETURN artifactName
      ,typeLabel    AS languageElement
      ,count(type)  AS numberOfTypes