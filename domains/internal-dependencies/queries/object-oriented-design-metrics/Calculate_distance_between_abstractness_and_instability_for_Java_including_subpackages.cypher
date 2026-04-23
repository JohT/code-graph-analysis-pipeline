// Calculate distance between abstractness and instability including subpackages. Requires "Add_file_name and_extension.cypher".

 MATCH (artifact:Artifact)-[:CONTAINS]->(package:Java:Package)
 WHERE package.abstractnessIncludingSubpackages  IS NOT NULL
   AND package.instabilityIncludingSubpackages   IS NOT NULL
   AND package.numberOfTypesIncludingSubpackages IS NOT NULL
RETURN artifact.name AS artifactName
      ,package.fqn           AS fullQualifiedName
      ,package.name          AS name
      ,abs(package.abstractnessIncludingSubpackages + package.instabilityIncludingSubpackages - 1) AS distance     
      ,package.abstractnessIncludingSubpackages  AS abstractness
      ,package.instabilityIncludingSubpackages   AS instability
      ,package.numberOfTypesIncludingSubpackages AS elementsCount
 ORDER BY distance DESC, elementsCount DESC