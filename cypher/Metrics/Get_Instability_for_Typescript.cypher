// Get Typscript Modules with the lowest Instability (outgoing / all dependencies) first (if set before)

 MATCH (module:TS:Module)
 WHERE module.instability IS NOT NULL 
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(module)
RETURN reverse(split(reverse(projectdir.absoluteFileName), '/')[0]) AS projectName
      ,module.globalFqn                 AS fullQualifiedModuleName
      ,module.name                      AS moduleName
      ,module.instability               AS instability
      ,module.instabilityAbstractTypes  AS instabilityAbstractTypes
      ,module.instabilityModules        AS instabilityModules
      ,module.instabilityPackages       AS instabilityPackages
      ,module.outgoingDependencies, module.incomingDependencies 
      ,module.outgoingDependentAbstractTypes, module.incomingDependentAbstractTypes
      ,module.outgoingDependentModules, module.incomingDependentModules
      ,module.outgoingDependentPackages, module.incomingDependentPackages
ORDER BY instability ASC, fullQualifiedModuleName ASC