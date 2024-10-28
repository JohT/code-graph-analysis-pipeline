// Cyclic Dependencies Breakdown Backward-Only for Typescript

MATCH (module:TS:Module)-[:EXPORTS]->(forwardSource:TS)-[:DEPENDS_ON]->(forwardTarget:TS)<-[:EXPORTS]-(dependentModule:TS:Module)
MATCH (dependentModule)-[:EXPORTS]->(backwardSource:TS)-[:DEPENDS_ON]->(backwardTarget:TS)<-[:EXPORTS]-(module)
WHERE module.globalFqn <> dependentModule.globalFqn
// Get the project of the module if available
OPTIONAL MATCH (project:TS:Project)-[:CONTAINS]->(module)
OPTIONAL MATCH (dependentProject:TS:Project)-[:CONTAINS]->(dependentModule)
 WITH project.name                                                       AS projectFileName
     ,module.localFqn                                                    AS moduleName
     ,dependentProject.name                                              AS dependentProjectFileName
     ,dependentModule.localFqn                                           AS dependentModulePathName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)  AS forwardDependencies
     ,collect(DISTINCT backwardTarget.name + '<-' + backwardSource.name) AS backwardDependencies
 WITH projectFileName
     ,moduleName
     ,dependentProjectFileName
     ,dependentModulePathName
     ,forwardDependencies
     ,backwardDependencies 
     ,size(forwardDependencies)                              AS numberOfForwardDependencies
     ,size(backwardDependencies)                             AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(moduleName)        >= size(dependentModulePathName)))
UNWIND backwardDependencies        AS dependency
RETURN projectFileName
      ,moduleName
      ,dependentProjectFileName
      ,dependentModulePathName
      ,dependency
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY forwardToBackwardBalance DESC, moduleName ASC