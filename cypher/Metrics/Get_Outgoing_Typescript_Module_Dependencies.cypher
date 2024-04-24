// Get Typscript Modules with the most outgoing dependencies first (if set before)

 MATCH (module:TS:Module)
 WHERE module.outgoingDependencies IS NOT NULL 
RETURN module.globalFqn                           AS fullQualifiedModuleName
      ,module.name                                AS sourceName
      ,module.outgoingDependencies                AS outgoingDependencies
      ,module.outgoingDependenciesWeight          AS outgoingDependenciesWeight
      ,module.outgoingDependentAbstractTypes      AS outgoingDependentAbstractTypes
      ,module.outgoingDependentAbstractTypeWeight AS outgoingDependentAbstractTypeWeight
      ,module.outgoingDependentModules            AS outgoingDependentModules
      ,module.outgoingDependentPackages           AS outgoingDependentPackages
ORDER BY outgoingDependencies DESC, fullQualifiedModuleName ASC