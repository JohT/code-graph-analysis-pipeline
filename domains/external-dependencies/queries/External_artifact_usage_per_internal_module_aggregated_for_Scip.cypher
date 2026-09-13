// External SCIP artifact usage per internal module aggregated - per internal artifact: aggregated stats on module external usage.

MATCH (a:SemanticCodeIndexArtifact {isExternal: false})-[:CONTAINS]->(m:SemanticCodeIndexModule)
  WITH a, count(DISTINCT m) AS artifactModules
MATCH (a)-[:CONTAINS]->(m2:SemanticCodeIndexModule)-[:CONTAINS]->(i:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(e:SemanticCodeIndexExternalType)
  WITH a
      ,artifactModules
      ,e.module                   AS externalArtifactName
      ,count(DISTINCT m2)         AS modulesUsingExternal
  WITH a.name                     AS internalArtifactName
      ,artifactModules
      ,count(DISTINCT externalArtifactName)                                                           AS numberOfExternalArtifacts
      ,max(toFloat(modulesUsingExternal) / toFloat(artifactModules) * 100.0)                          AS maxNumberOfModulesPercentage
      ,percentileCont(toFloat(modulesUsingExternal) / toFloat(artifactModules) * 100.0, 0.5)          AS medNumberOfModulesPercentage
      ,avg(toFloat(modulesUsingExternal) / toFloat(artifactModules) * 100.0)                          AS avgNumberOfModulesPercentage
      ,stDev(toFloat(modulesUsingExternal) / toFloat(artifactModules) * 100.0)                        AS stdNumberOfModulesPercentage
RETURN internalArtifactName
      ,artifactModules
      ,numberOfExternalArtifacts
      ,maxNumberOfModulesPercentage
      ,medNumberOfModulesPercentage
      ,avgNumberOfModulesPercentage
      ,stdNumberOfModulesPercentage
 ORDER BY numberOfExternalArtifacts DESC
