// Get Java Packages including their sub packages with the lowest abstractness first (if set before). Requires "Add_file_name and_extension.cypher".

 MATCH path = (package:Java:Package)-[:CONTAINS*0..]->(subpackage:Java:Package)
 WHERE package.abstractnessIncludingSubpackages IS NOT NULL
 MATCH (artifact:Artifact)-[:CONTAINS]->(package)
RETURN artifact.name AS artifactName
      ,package.fqn   AS fullQualifiedPackageName
      ,package.name  AS packageName
      ,package.abstractnessIncludingSubpackages          AS abstractness
      ,package.numberOfAbstractTypesIncludingSubpackages AS numberAbstractTypes
      ,package.numberOfTypesIncludingSubpackages         AS numberTypes
      ,max(length(path))                                 AS maxSubpackageDepth
ORDER BY abstractness ASC, maxSubpackageDepth DESC, numberTypes DESC