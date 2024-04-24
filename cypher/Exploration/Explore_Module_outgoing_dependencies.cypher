// Explore outgoing dependencies of modules

MATCH (source:Module)-[rm:DEPENDS_ON]->(module:ExternalModule)
OPTIONAL MATCH (module)-[:EXPORTS]->(declaration:ExternalDeclaration)<-[re:DEPENDS_ON]-(source)
OPTIONAL MATCH (source)-[:DECLARES]->(implementation:Function|Variable)-[ri:DEPENDS_ON]->(module)
OPTIONAL MATCH (source)-[:DECLARES]->(abstract:Interface|TypeAlias)-[ra:DEPENDS_ON]->(module)
RETURN source.globalFqn               AS module
      ,count(DISTINCT abstract)       AS numberOfAbstract
      ,count(DISTINCT declaration)    AS numberOfExternalDeclarations
      ,count(DISTINCT implementation) AS numberOfImplementations
      ,sum(rm.cardinality)            AS sumModuleDependencyWeights
      ,sum(re.cardinality)            AS sumExternalDeclarationWeights
      ,sum(ri.cardinality)            AS sumImplementationWeights
      ,sum(ra.cardinality)            AS sumAbstractWeights
      //TODO sumWeights should sum up to sumModuleDependencyWeights
      ,sum(re.cardinality) + sum(ri.cardinality) + sum(ra.cardinality) as sumWeights
ORDER BY source.globalFqn ASC