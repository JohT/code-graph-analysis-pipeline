// Cyclic Dependencies as List for SCIP Semantic Index Modules. Includes both types and functions via SemanticCodeIndexInternalSymbol.

MATCH (module:SemanticCodeIndexModule)-[:CONTAINS]->(forwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(forwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(dependentModule:SemanticCodeIndexModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(backwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(module)
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
      ,((moduleName STARTS WITH dependentModuleName) OR (dependentModuleName STARTS WITH moduleName)) AS parentChildCycle
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS someForwardDependencies
      ,backwardDependencies
ORDER BY round(forwardToBackwardBalance, 1, 'DOWN') DESC // easiest to remove first in bins of 0.1 like 0.9, 0.8, 0.7, ...
        ,parentChildCycle // parent-child cycles last (less critical) per bin
        ,forwardToBackwardBalance DESC // within each bin, sort by actual balance descending
        ,moduleName ASC // in the rare case of identical balance and parent-child status, sort by module name
