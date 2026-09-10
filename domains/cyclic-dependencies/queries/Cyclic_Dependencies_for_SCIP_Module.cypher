// Cyclic Dependencies as List for SCIP Semantic Index Modules.

MATCH (module:SemanticCodeIndexModule)-[:CONTAINS]->(forwardSource:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(forwardTarget:SemanticCodeIndexInternalType)<-[:CONTAINS]-(dependentModule:SemanticCodeIndexModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(backwardTarget:SemanticCodeIndexInternalType)<-[:CONTAINS]-(module)
WHERE module.fqn <> dependentModule.fqn
 WITH module.projectName                                                            AS projectName
     ,module.fqn                                                                    AS moduleName
     ,dependentModule.projectName                                                   AS dependentProjectName
     ,dependentModule.fqn                                                           AS dependentModuleName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)             AS forwardDependencies
     ,collect(DISTINCT backwardSource.name + '->' + backwardTarget.name)            AS backwardDependencies
 WITH projectName
     ,moduleName
     ,dependentProjectName
     ,dependentModuleName
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  moduleName >= dependentModuleName))
RETURN projectName
      ,moduleName
      ,dependentProjectName
      ,dependentModuleName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS someForwardDependencies
      ,backwardDependencies
ORDER BY forwardToBackwardBalance DESC, moduleName ASC
