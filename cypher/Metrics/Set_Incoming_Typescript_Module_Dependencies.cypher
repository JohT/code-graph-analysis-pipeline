// Set incoming Typscript Module dependencies

// Get the top level dependency between a Typescript module and other modules that uses it
 MATCH (source:TS:Module)
OPTIONAL MATCH (source)<-[moduleDependency:DEPENDS_ON]-(target:TS:Module)
 WHERE source <> target
// Get the project of the external module if available
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(target)
// Aggregate all gathered information for each (grouped by) source module
  WITH source
      ,collect(DISTINCT projectdir.absoluteFileName) AS projectNames
      ,count(DISTINCT target.globalFqn)              AS externalModuleCount
      ,sum(moduleDependency.declarationCount)        AS declarationCount
      ,sum(moduleDependency.abstractTypeCount)       AS abstractTypeCount
      ,sum(moduleDependency.cardinality)             AS totalCardinality
      ,sum(moduleDependency.abstractTypeCardinality) AS abstractTypeCardinality
      ,collect(DISTINCT target.globalFqn)[0..4]      AS externalModuleExamples
  SET source.incomingDependencies                = declarationCount
     ,source.incomingDependenciesWeight          = totalCardinality
     ,source.incomingDependentAbstractTypes      = abstractTypeCount
     ,source.incomingDependentAbstractTypeWeight = abstractTypeCardinality
     ,source.incomingDependentModules            = externalModuleCount
     ,source.incomingDependentPackages           = size(projectNames)
RETURN source.globalFqn        AS fullQualifiedModuleName
      ,source.name             AS moduleName
      ,declarationCount        AS incomingDependencies
      ,totalCardinality        AS incomingDependenciesWeight
      ,abstractTypeCount       AS incomingDependentAbstractTypes
      ,abstractTypeCardinality AS incomingDependentAbstractTypeWeight
      ,externalModuleCount     AS incomingDependentModules
      ,size(projectNames)      AS incomingDependentPackages
      ,externalModuleExamples
      ,projectNames
ORDER BY incomingDependencies DESC, fullQualifiedModuleName ASC // modules with most incoming dependencies first
