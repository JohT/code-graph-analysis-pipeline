// Calculate distance between abstractness and instability including subpackages

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Package)
 WHERE package.abstractnessIncludingSubpackages  IS NOT NULL
   AND package.instabilityIncludingSubpackages   IS NOT NULL
   AND package.numberOfTypesIncludingSubpackages IS NOT NULL
RETURN replace(last(split(artifact.fileName, '/')), '.jar', '') AS artifactName
      ,package.fqn           AS fullQualifiedPackageName
      ,package.name          AS packageName
      ,abs(package.abstractnessIncludingSubpackages + package.instabilityIncludingSubpackages - 1) AS distance     
      ,package.abstractnessIncludingSubpackages  AS abstractness
      ,package.instabilityIncludingSubpackages   AS instability
      ,package.numberOfTypesIncludingSubpackages AS typesInPackage
 ORDER BY distance DESC, typesInPackage DESC