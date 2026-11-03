// Cyclic Dependencies Breakdown for SCIP Semantic Index Modules. Includes both types and functions via SemanticCodeIndexInternalSymbol.

MATCH (module:SemanticCodeIndexModule)-[:CONTAINS]->(forwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(forwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(dependentModule:SemanticCodeIndexModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(backwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(module)
WHERE module.fqn <> dependentModule.fqn
 WITH module.projectName                                                            AS projectName
     ,module.fqn                                                                    AS moduleName
     ,dependentModule.projectName                                                   AS dependentProjectName
     ,dependentModule.fqn                                                           AS dependentModuleName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)             AS forwardDependencies
     ,collect(DISTINCT backwardTarget.name + '<-' + backwardSource.name)            AS backwardDependencies
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
UNWIND (backwardDependencies + forwardDependencies) AS dependency
RETURN projectName
      ,moduleName
      ,dependentProjectName
      ,dependentModuleName
      ,dependency
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY forwardToBackwardBalance DESC, moduleName ASC
