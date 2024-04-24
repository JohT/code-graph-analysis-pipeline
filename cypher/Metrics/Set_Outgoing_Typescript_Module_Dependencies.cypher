// Set outgoing Typscript Module dependencies

// Get the top level dependency between a Typescript module and an external modules it uses
 MATCH (source:TS:Module)
OPTIONAL MATCH (source)-[moduleDependency:DEPENDS_ON]->(target:ExternalModule)
 WHERE NOT EXISTS {(target)-[:RESOLVES_TO]->(source)}
// Get the project of the external module if available
OPTIONAL MATCH (projectdir:Directory)<-[:HAS_ROOT]-(project:TS:Project)-[:CONTAINS]->(:TS:Module)<-[:RESOLVES_TO]-(target)
// Aggregate all gathered information for each (grouped by) source module
  WITH source
      ,collect(DISTINCT projectdir.absoluteFileName) AS projectNames
      ,count(DISTINCT target.globalFqn)              AS externalModuleCount
      ,sum(moduleDependency.declarationCount)        AS declarationCount
      ,sum(moduleDependency.abstractTypeCount)       AS abstractTypeCount
      ,sum(moduleDependency.cardinality)             AS totalCardinality
      ,sum(moduleDependency.abstractTypeCardinality) AS abstractTypeCardinality
      ,collect(DISTINCT target.globalFqn)[0..4]      AS externalModuleExamples
  SET source.outgoingDependencies                = declarationCount
     ,source.outgoingDependenciesWeight          = totalCardinality
     ,source.outgoingDependentAbstractTypes      = abstractTypeCount
     ,source.outgoingDependentAbstractTypeWeight = abstractTypeCardinality
     ,source.outgoingDependentModules            = externalModuleCount
     ,source.outgoingDependentPackages           = size(projectNames)
RETURN source.globalFqn        AS fullQualifiedModuleName
      ,source.name             AS moduleName
      ,declarationCount        AS outgoingDependencies
      ,totalCardinality        AS outgoingDependenciesWeight
      ,abstractTypeCount       AS outgoingDependentAbstractTypes
      ,abstractTypeCardinality AS outgoingDependentAbstractTypeWeight
      ,externalModuleCount     AS outgoingDependentModules
      ,size(projectNames)      AS outgoingDependentPackages
      ,externalModuleExamples
      ,projectNames
ORDER BY outgoingDependencies DESC, fullQualifiedModuleName ASC
