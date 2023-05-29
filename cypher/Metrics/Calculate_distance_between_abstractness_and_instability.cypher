// Calculate distance between abstractness and instability

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)-[:CONTAINS]->(type:Type)
 WITH replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,package
     ,abs(package.abstractness + package.instability - 1) AS distance
     ,count(type) AS typesInPackage
RETURN artifactName
      ,package.fqn          AS fullQualifiedPackageName
      ,package.name         AS packageName
      ,distance     
      ,package.abstractness AS abstractness
      ,package.instability  AS instability
      ,typesInPackage
 ORDER BY distance DESC, typesInPackage DESC