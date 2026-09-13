// External SCIP artifact usage per internal artifact sorted top - internal artifacts ranked by external usage rate.

MATCH (a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m:SemanticCodeIndexModule)
  WITH a, count(DISTINCT m) AS artifactModules
MATCH (a)-[:CONTAINS]->(m2:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
  WITH a.name                    AS internalArtifactName
      ,artifactModules
      ,count(DISTINCT m2)        AS numberOfModulesUsingExternal
      ,count(DISTINCT e.module)  AS numberOfExternalArtifacts
RETURN internalArtifactName
      ,artifactModules
      ,numberOfModulesUsingExternal
      ,numberOfExternalArtifacts
      ,toFloat(numberOfModulesUsingExternal) / toFloat(artifactModules) AS modulesUsingExternalRate
 ORDER BY modulesUsingExternalRate DESC, internalArtifactName ASC
 LIMIT 30
