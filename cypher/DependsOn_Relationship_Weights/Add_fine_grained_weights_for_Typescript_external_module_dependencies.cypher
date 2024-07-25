// Add fine grained weight properties for dependencies between Typescript modules

// Get the top level dependency between a Typescript module and the external modules it uses
 MATCH (source:TS:Module)-[moduleDependency:DEPENDS_ON]->(target:ExternalModule)
// Exclude all targets where an ExternalModule was found that resolves to them
// because those are covered in the fine grained weights for "ExternalModule"s.
 WHERE NOT EXISTS { (target)-[:RESOLVES_TO]->(source) }
OPTIONAL MATCH (source)-[resolvedModuleDependency:DEPENDS_ON]->(resolvedTarget:TS:Module)<-[:RESOLVES_TO]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,resolvedModuleDependency
      ,moduleDependency.cardinality AS externalModuleCardinality
// Get optional external (e.g. type) declarations that the external module (target) provides and the source module uses
OPTIONAL MATCH (source)-[rd:DEPENDS_ON]->(declaration:ExternalDeclaration)<-[:EXPORTS]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,resolvedModuleDependency
      ,externalModuleCardinality
      ,count(DISTINCT declaration.globalFqn)         AS declarationCount
      ,sum(rd.cardinality)                           AS declarationCardinality
      ,collect(DISTINCT declaration.globalFqn)[0..4] AS declarationExamples 
      ,collect(declaration)                          AS declarations
// Get optional low coupling elements (TypeAlias, Interface) that the source module contains and defines (low level) that depend on the external module (target)
UNWIND declarations AS declaration
OPTIONAL MATCH (source)-[ra:DEPENDS_ON]->(declaration)-[:RESOLVES_TO]->(abstractType:TypeAlias|Interface)
  WITH source
      ,target
      ,moduleDependency
      ,resolvedModuleDependency
      ,externalModuleCardinality
      ,declarationCount
      ,declarationCardinality
      ,declarationExamples
      ,count(DISTINCT abstractType.globalFqn)         AS abstractTypeCount
      ,sum(ra.cardinality)                            AS abstractTypeCardinality
      ,collect(DISTINCT abstractType.globalFqn)[0..4] AS abstractTypeExamples 
// Set additional fine grained relationship properties (weights) to distinguish low and high coupling elements.
// The "cardinality" property is similar to "weight" property for Java dependencies and comes from the jQAssistant Typescript Plugin.
// - "abstractTypeCardinality" is the sum of all TypeAlias and Interface cardinality properties (if available)
//   and corresponds to the "weightInterfaces" relationship property for Java.
// - "declarationCardinality"  is the sum of all cardinality properties (including available Interface and TypeAlias)
//   and is the same as the already existing "cardinality" of the moduleDependency. Thats why its left out.
// - "lowCouplingElement25PercentWeight" subtracts 75% of the weights for abstract types like Interfaces and Type aliases
//   to compensate for their low coupling influence. Not included "high coupling" elements like Functions and Classes 
//   remain in the weight as they were. The same applies for "lowCouplingElement10PercentWeight" but with in a stronger manner.
  SET moduleDependency.declarationCount        = coalesce(declarationCount, 0)
     ,moduleDependency.abstractTypeCount       = coalesce(abstractTypeCount, 0)
     ,moduleDependency.abstractTypeCardinality = coalesce(abstractTypeCardinality, 0)
     ,moduleDependency.lowCouplingElement25PercentWeight = 
        toInteger(moduleDependency.cardinality - round(abstractTypeCardinality * 0.75))
     ,moduleDependency.lowCouplingElement10PercentWeight = 
        toInteger(moduleDependency.cardinality - round(abstractTypeCardinality * 0.90))
 // Set all new properties also to a resolved (direct) dependency relationship if it exists.    
     ,resolvedModuleDependency.declarationCount        = coalesce(declarationCount, 0)
     ,resolvedModuleDependency.abstractTypeCount       = coalesce(abstractTypeCount, 0)
     ,resolvedModuleDependency.abstractTypeCardinality = coalesce(abstractTypeCardinality, 0)
     ,resolvedModuleDependency.lowCouplingElement25PercentWeight = toInteger(resolvedModuleDependency.cardinality - round(abstractTypeCardinality * 0.75))
     ,resolvedModuleDependency.lowCouplingElement10PercentWeight = toInteger(resolvedModuleDependency.cardinality - round(abstractTypeCardinality * 0.90))
RETURN source.globalFqn    AS sourceName
      ,target.globalFqn    AS targetName
      ,declarationCount
      ,abstractTypeCount
      ,externalModuleCardinality
      ,declarationCardinality
      ,abstractTypeCardinality
      ,moduleDependency.lowCouplingElement25PercentWeight
      ,moduleDependency.lowCouplingElement10PercentWeight
      ,declarationExamples
      ,abstractTypeExamples
ORDER BY sourceName ASC