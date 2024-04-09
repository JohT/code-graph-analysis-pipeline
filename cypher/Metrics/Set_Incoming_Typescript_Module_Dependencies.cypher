// Set incoming Typscript Module dependencies

// Get the top level dependency between a Typescript module and an external modules it uses
 MATCH (source:TS:Module)
OPTIONAL MATCH (source)<-[:RESOLVES_TO]-(sourceExternal:ExternalModule)<-[moduleDependency:DEPENDS_ON]-(target:TS:Module)
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
   // Incoming dependencies properties can't easily be set on sourceExternal nodes
   // since there might be more than one per source. If this is needed in future
   // assure that there is no regression for the source nodes.
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
