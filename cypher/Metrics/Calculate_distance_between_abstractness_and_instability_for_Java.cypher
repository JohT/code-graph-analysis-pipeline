// Calculate distance between abstractness and instability. Requires "Add_file_name and_extension.cypher".

MATCH (artifact:Artifact)-[:CONTAINS]->(package:Java:Package)
RETURN artifact.name AS artifactName
      ,package.fqn           AS fullQualifiedName
      ,package.name          AS name
      ,abs(package.abstractness + package.instability - 1) AS distance     
      ,package.abstractness  AS abstractness
      ,package.instability   AS instability
      ,package.numberOfTypes AS elementsCount
 ORDER BY distance DESC, elementsCount DESC