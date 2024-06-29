//Cyclic Dependencies as List for Typescript

MATCH (module:TS:Module)-[:EXPORTS]->(forwardSource:TS)-[:DEPENDS_ON]->(forwardTarget:TS)<-[:EXPORTS]-(dependentModule:TS:Module)
MATCH (dependentModule)-[:EXPORTS]->(backwardSource:TS)-[:DEPENDS_ON]->(backwardTarget:TS)<-[:EXPORTS]-(module)
// Get the project of the module if available
OPTIONAL MATCH (project:Directory)<-[:HAS_ROOT]-(:TS:Project)-[:CONTAINS]->(module)
OPTIONAL MATCH (dependentProject:Directory)<-[:HAS_ROOT]-(:TS:Project)-[:CONTAINS]->(dependentModule)
WHERE module.globalFqn <> dependentModule.globalFqn
 WITH project.absoluteFileName                                            AS projectFileName
     ,replace(
         module.globalFqn
        ,project.absoluteFileName + '/', ''
      )                                                                   AS moduleName
     ,dependentProject.absoluteFileName                                   AS dependentProjectFileName
     ,replace(
         dependentModule.globalFqn
        ,dependentProject.absoluteFileName + '/', ''
      )                                                                   AS dependentModulePathName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)   AS forwardDependencies
     ,collect(DISTINCT backwardTarget.name + '<-' + backwardSource.name)  AS backwardDependencies
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
RETURN projectFileName
      ,moduleName
      ,dependentProjectFileName
      ,dependentModulePathName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS forwardDependencyExamples
      ,backwardDependencies[0..9]   AS backwardDependencyExamples
ORDER BY forwardToBackwardBalance DESC, moduleName ASC