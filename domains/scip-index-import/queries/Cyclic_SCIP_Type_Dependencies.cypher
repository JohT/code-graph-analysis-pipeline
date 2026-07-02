// Cyclic SCIP Type Dependencies as List. Requires "Link_SCIP_Module_CONTAINS_SCIP_InternalType.cypher" and "Link_SCIP_Artifact_CONTAINS_SCIP_Module.cypher".

MATCH (module:SCIPModule)-[:CONTAINS]->(forwardSource:SCIPType)-[:DEPENDS_ON]->(forwardTarget:SCIPType)<-[:CONTAINS]-(dependentModule:SCIPModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SCIPType)-[:DEPENDS_ON]->(backwardTarget:SCIPType)<-[:CONTAINS]-(module)
MATCH (artifact:SCIPArtifact)-[:CONTAINS]->(module)
MATCH (dependentArtifact:SCIPArtifact)-[:CONTAINS]->(dependentModule)
WHERE module.fqn <> dependentModule.fqn
 WITH artifact.name                                                          AS artifactName
     ,module.fqn                                                             AS moduleName
     ,dependentArtifact.name                                                 AS dependentArtifactName
     ,dependentModule.fqn                                                    AS dependentModuleName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)      AS forwardDependencies
     ,collect(DISTINCT backwardSource.name + '->' + backwardTarget.name)     AS backwardDependencies
 WITH artifactName
     ,moduleName
     ,dependentArtifactName
     ,dependentModuleName
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(moduleName)         >= size(dependentModuleName)))
RETURN artifactName
      ,moduleName
      ,dependentArtifactName
      ,dependentModuleName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS someForwardDependencies
      ,backwardDependencies
ORDER BY forwardToBackwardBalance DESC, moduleName ASC
