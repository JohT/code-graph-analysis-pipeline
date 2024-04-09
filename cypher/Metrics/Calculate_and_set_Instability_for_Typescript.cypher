// Calculate and set Instability = outgoing / (outgoing + incoming) Dependencies

 MATCH (module:TS:Module)
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(module)
  WITH module
      ,reverse(split(reverse(projectdir.absoluteFileName), '/')[0]) AS projectName
      ,toFloat(module.outgoingDependencies) / (module.outgoingDependencies + module.incomingDependencies + 1E-38) as instability
      ,toFloat(module.outgoingDependentAbstractTypes) / (module.outgoingDependentAbstractTypes + module.incomingDependentAbstractTypes + 1E-38) as instabilityAbstractTypes
      ,toFloat(module.outgoingDependentModules) / (module.outgoingDependentModules + module.incomingDependentModules + 1E-38) as instabilityModules
      ,toFloat(module.outgoingDependentPackages) / (module.outgoingDependentPackages + module.incomingDependentPackages + 1E-38) as instabilityPackages
   SET module.instability              = instability
      ,module.instabilityAbstractTypes = instabilityAbstractTypes
      ,module.instabilityModules       = instabilityModules
      ,module.instabilityPackages      = instabilityPackages
  WITH module
      ,projectName
      ,instability
      ,instabilityAbstractTypes
      ,instabilityModules
      ,instabilityPackages
WHERE module.incomingDependencies IS NOT NULL
  AND module.outgoingDependencies IS NOT NULL
RETURN DISTINCT 
       projectName
      ,module.globalFqn AS fullQualifiedModuleName
      ,module.name      AS moduleName
      ,instability
      ,instabilityAbstractTypes
      ,instabilityModules
      ,instabilityPackages
      ,module.outgoingDependencies, module.incomingDependencies 
      ,module.outgoingDependentAbstractTypes, module.incomingDependentAbstractTypes
      ,module.outgoingDependentModules, module.incomingDependentModules
      ,module.outgoingDependentPackages, module.incomingDependentPackages
ORDER BY instability ASC, fullQualifiedModuleName ASC