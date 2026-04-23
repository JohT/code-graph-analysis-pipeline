// Calculate distance between abstractness and instability for Typescript

MATCH (module:TS:Module)
OPTIONAL MATCH (projectDirectory:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(module)
RETURN reverse(split(reverse(projectDirectory.absoluteFileName), '/')[0]) AS artifactName
      ,module.globalFqn      AS fullQualifiedName
      ,module.localFqn       AS name
      ,abs(module.abstractness + module.instability - 1) AS distance     
      ,module.abstractness  AS abstractness
      ,module.instability   AS instability
      ,module.numberOfTypes AS elementsCount
 ORDER BY distance DESC, elementsCount DESC