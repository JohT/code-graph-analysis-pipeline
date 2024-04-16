// Get Java Packages with the lowest abstractness first (if set before)

MATCH (package:Java:Package)
WHERE package.abstractness IS NOT NULL
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
     ,package.fqn                   AS fullQualifiedPackageName
     ,package.name                  AS packageName
     ,package.abstractness          AS abstractness
     ,package.numberOfAbstractTypes AS numberAbstractTypes
     ,package.numberOfTypes         AS numberTypes
ORDER BY abstractness ASC, numberTypes DESC