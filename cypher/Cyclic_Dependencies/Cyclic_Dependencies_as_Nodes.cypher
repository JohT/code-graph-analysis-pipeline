// Cyclic Dependencies
MATCH (package:Package)-[:CONTAINS]->(type:Type)-[:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(cycleType:Type)-[:DEPENDS_ON]->(cycleDependentType:Type)<-[:CONTAINS]-(package)
WHERE package <> dependentPackage
RETURN package, dependentPackage
      ,type, dependentType, cycleType, cycleDependentType
 LIMIT 100