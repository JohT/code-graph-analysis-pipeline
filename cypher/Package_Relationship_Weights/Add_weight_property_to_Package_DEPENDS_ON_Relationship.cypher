// Add weight property to Package DEPENDS_ON Relationship 

 MATCH (sourcePackage:Package)-[:CONTAINS]->(sourceType:Type)-[typeDependency:DEPENDS_ON]->(dependentType:Type)<-[:CONTAINS]-(dependentPackage:Package)
 MATCH (sourcePackage)-[packageDependency:DEPENDS_ON]->(dependentPackage)
 WHERE sourcePackage.fqn <> dependentPackage.fqn
  WITH packageDependency
      ,sourcePackage.fqn                 AS sourcePackageName
      ,dependentPackage.fqn              AS dependentPackageName
      ,MIN(typeDependency.weight)        AS minTypeDependencyWeight
      ,MAX(typeDependency.weight)        AS maxTypeDependencyWeight
      ,AVG(typeDependency.weight)        AS avgTypeDependencyWeight
      ,SUM(typeDependency.weight)        AS packageDependencyWeight
      ,COUNT(dependentType.fqn)          AS dependentTypes
      ,COUNT(DISTINCT dependentType.fqn) AS distinctDependentTypes
   SET packageDependency.weight = packageDependencyWeight
RETURN sourcePackageName
      ,dependentPackageName
      ,minTypeDependencyWeight
      ,maxTypeDependencyWeight
      ,avgTypeDependencyWeight
      ,packageDependencyWeight
      ,dependentTypes
      ,distinctDependentTypes