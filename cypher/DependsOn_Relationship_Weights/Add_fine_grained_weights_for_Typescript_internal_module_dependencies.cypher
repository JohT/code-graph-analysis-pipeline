// Add fine grained weight properties for dependencies between internal Typescript modules

// Get the top level dependency between a Typescript module and the external modules it uses
 MATCH (source:TS:Module)-[moduleDependency:DEPENDS_ON]->(target:Module)
// Exclude all that already have extended weight properties
// for example because those were covered in the fine grained weights for "ExternalModule"s.
 WHERE moduleDependency.declarationCount IS NULL
// Ruling out resolved targets also filters out entries that aren't covered by the fine grained weights for "ExternalModule"s.
// Therefore, the exists filter is commented out for now and replaced by focussing on missing detailed weight properties to catch them all.
//WHERE NOT EXISTS { (target)<-[:RESOLVES_TO]-(resolvedTarget:ExternalModule) }
  WITH source
      ,target
      ,moduleDependency
      ,moduleDependency.cardinality AS targetModuleCardinality
// Get optional external (e.g. type) declarations that the external module (target) provides and the source module uses
OPTIONAL MATCH (source)-[elementDependency:DEPENDS_ON|EXPORTS]->(elementType:TS)<-[:EXPORTS]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,targetModuleCardinality      
      ,coalesce(count(DISTINCT elementType.globalFqn), 0) AS elementTypeCount
      ,sum(elementDependency.cardinality)                 AS elementTypeCardinality
      ,collect(DISTINCT elementType.globalFqn)[0..4]      AS elementTypeExamples
// Get optional low coupling elements (TypeAlias, Interface) that the source module contains and defines (low level) that depend on the external module (target)
OPTIONAL MATCH (source)-[abstractDependency:DEPENDS_ON|EXPORTS]->(abstractType:TypeAlias|Interface)<-[:EXPORTS]-(target)
  WITH source
      ,target
      ,moduleDependency
      ,targetModuleCardinality      
      ,elementTypeCount        
      ,elementTypeCardinality   
      ,elementTypeExamples     
      ,coalesce(count(DISTINCT abstractType.globalFqn), 0) AS abstractTypeCount
      ,sum(abstractDependency.cardinality)                 AS abstractTypeCardinality
      ,collect(DISTINCT abstractType.globalFqn)[0..4]      AS abstractTypeExamples 
// Set additional fine grained relationship properties (weights) to distinguish low and high coupling elements.
// The "cardinality" property is similar to "weight" property for Java dependencies and comes from the jQAssistant Typescript Plugin.
// - "abstractTypeCardinality" is the sum of all TypeAlias and Interface cardinality properties (if available)
//   and corresponds to the "weightInterfaces" relationship property for Java.
// - "declarationCardinality"  is the sum of all cardinality properties (including available Interface and TypeAlias)
//   and is the same as the already existing "cardinality" of the moduleDependency. Thats why its left out.
// - "lowCouplingElement25PercentWeight" subtracts 75% of the weights for abstract types like Interfaces and Type aliases
//   to compensate for their low coupling influence. Not included "high coupling" elements like Functions and Classes 
//   remain in the weight as they were. The same applies for "lowCouplingElement10PercentWeight" but with in a stronger manner.
//   If there are no declarations and therefore the elementTypeCardinality is zero then the original targetModuleCardinality is used.
 SET moduleDependency.declarationCount        = elementTypeCount
    ,moduleDependency.abstractTypeCount       = abstractTypeCount
    ,moduleDependency.abstractTypeCardinality = abstractTypeCardinality
    ,moduleDependency.lowCouplingElement25PercentWeight = toInteger(
        coalesce(nullif(elementTypeCardinality, 0), targetModuleCardinality) - 
        round(abstractTypeCardinality * 0.75)
     )
    ,moduleDependency.lowCouplingElement10PercentWeight = toInteger(
        coalesce(nullif(elementTypeCardinality, 0), targetModuleCardinality) - 
        round(abstractTypeCardinality * 0.90)
     )
RETURN source.globalFqn    AS sourceName
      ,target.globalFqn    AS targetName
      ,elementTypeCount
      ,abstractTypeCount
      ,targetModuleCardinality      
      ,elementTypeCardinality
      ,abstractTypeCardinality
      ,moduleDependency.lowCouplingElement25PercentWeight
      ,moduleDependency.lowCouplingElement10PercentWeight
      ,elementTypeExamples
      ,abstractTypeExamples
ORDER BY sourceName ASC