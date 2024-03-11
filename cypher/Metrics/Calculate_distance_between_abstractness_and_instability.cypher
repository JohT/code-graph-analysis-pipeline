// Calculate distance between abstractness and instability

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn           AS fullQualifiedPackageName
      ,package.name          AS packageName
      ,abs(package.abstractness + package.instability - 1) AS distance     
      ,package.abstractness  AS abstractness
      ,package.instability   AS instability
      ,package.numberOfTypes AS typesInPackage
 ORDER BY distance DESC, typesInPackage DESC