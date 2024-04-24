// Calculate distance between abstractness and instability including subpackages

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Java:Package)
 WHERE package.abstractnessIncludingSubpackages  IS NOT NULL
   AND package.instabilityIncludingSubpackages   IS NOT NULL
   AND package.numberOfTypesIncludingSubpackages IS NOT NULL
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn           AS fullQualifiedName
      ,package.name          AS name
      ,abs(package.abstractnessIncludingSubpackages + package.instabilityIncludingSubpackages - 1) AS distance     
      ,package.abstractnessIncludingSubpackages  AS abstractness
      ,package.instabilityIncludingSubpackages   AS instability
      ,package.numberOfTypesIncludingSubpackages AS elementsCount
 ORDER BY distance DESC, elementsCount DESC