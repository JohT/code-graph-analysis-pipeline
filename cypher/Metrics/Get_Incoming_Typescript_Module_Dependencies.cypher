// Get Typscript Modules with the most incoming dependencies first (if set before)

 MATCH (module:TS:Module)
 WHERE module.incomingDependencies IS NOT NULL 
RETURN module.globalFqn                           AS fullQualifiedModuleName
      ,module.name                                AS moduleName
      ,module.incomingDependencies                AS incomingDependencies
      ,module.incomingDependenciesWeight          AS incomingDependenciesWeight
      ,module.incomingDependentAbstractTypes      AS incomingDependentAbstractTypes
      ,module.incomingDependentAbstractTypeWeight AS incomingDependentAbstractTypeWeight
      ,module.incomingDependentModules            AS incomingDependentModules
      ,module.incomingDependentPackages           AS incomingDependentPackages
ORDER BY incomingDependencies DESC, fullQualifiedModuleName ASC 