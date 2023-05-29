//Cyclic Dependencies Concatenated
MATCH (package:Package)-[:CONTAINS]->(forwardSource:Type)-[:DEPENDS_ON]->(forwardTarget:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(backwardSource:Type)-[:DEPENDS_ON]->(backwardTarget:Type)<-[:CONTAINS]-(package)
WHERE package <> dependentPackage
 WITH package, dependentPackage
     ,collect(DISTINCT forwardSource) + collect(DISTINCT backwardTarget) +
      collect(DISTINCT backwardSource) + collect(DISTINCT backwardTarget)
      AS dependencies
UNWIND dependencies  AS dependenciesUnwind
RETURN package, dependentPackage
      ,collect(DISTINCT dependenciesUnwind) AS dependencies