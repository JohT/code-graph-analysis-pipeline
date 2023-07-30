//Cyclic Dependencies as List

MATCH (package:Package)-[:CONTAINS]->(forwardSource:Type)-[:DEPENDS_ON]->(forwardTarget:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(backwardSource:Type)-[:DEPENDS_ON]->(backwardTarget:Type)<-[:CONTAINS]-(package)
WHERE package <> dependentPackage
 WITH package
     ,dependentPackage
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)   AS forwardDependencies
     ,collect(DISTINCT backwardSource.name + '->' + backwardTarget.name)  AS backwardDependencies
 WITH package
     ,dependentPackage
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(package.fqn)    >= size(dependentPackage.fqn)))
RETURN package.fqn          AS packageName
      ,dependentPackage.fqn AS dependentPackageName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies
      ,backwardDependencies
ORDER BY forwardToBackwardBalance DESC, packageName ASC