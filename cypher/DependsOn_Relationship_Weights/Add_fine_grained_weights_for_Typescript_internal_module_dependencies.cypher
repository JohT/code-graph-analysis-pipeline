// Add fine grained weight properties for dependencies between internal Typescript modules

// Get the top level dependency between a Typescript module and the external modules it uses
 MATCH (source:TS:Module)-[moduleDependency:DEPENDS_ON]->(target:Module)
// Exclude all targets where an ExternalModule was found that resolves to them
// because those are covered in the fine grained weights for "ExternalModule"s.
 WHERE NOT EXISTS { (target)<-[:RESOLVES_TO]-(resolvedTarget:ExternalModule) }
  WITH source
      ,target
      ,moduleDependency
OPTIONAL MATCH (source)-[elementDependency:DEPENDS_ON]->(elementType:TS)<-[:EXPORTS]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,count(DISTINCT elementType.globalFqn)          AS elementTypeCount
      ,sum(elementDependency.cardinality)             AS elementTypeCardinality
      ,collect(DISTINCT elementType.globalFqn)[0..4]  AS elementTypeExamples
OPTIONAL MATCH (source)-[abstractDependency:DEPENDS_ON]->(abstractType:TypeAlias|Interface)<-[:EXPORTS]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,elementTypeCount        
      ,elementTypeCardinality   
      ,elementTypeExamples     
      ,count(DISTINCT abstractType.globalFqn)         AS abstractTypeCount
      ,sum(abstractDependency.cardinality)            AS abstractTypeCardinality
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
 SET moduleDependency.abstractTypeCount       = abstractTypeCount
    ,moduleDependency.abstractTypeCardinality = abstractTypeCardinality
    ,moduleDependency.lowCouplingElement25PercentWeight = 
        toInteger(elementTypeCardinality - round(abstractTypeCardinality * 0.75))
    ,moduleDependency.lowCouplingElement10PercentWeight = 
        toInteger(elementTypeCardinality - round(abstractTypeCardinality * 0.90))
RETURN source.globalFqn    AS sourceName
      ,target.globalFqn    AS targetName
      ,abstractTypeCount
      ,elementTypeCount
      ,moduleDependency.cardinality AS externalModuleCardinality
      ,abstractTypeCardinality
      ,elementTypeCardinality
      ,moduleDependency.lowCouplingElement25PercentWeight
      ,moduleDependency.lowCouplingElement10PercentWeight
      ,abstractTypeExamples
      ,elementTypeExamples
ORDER BY sourceName ASC