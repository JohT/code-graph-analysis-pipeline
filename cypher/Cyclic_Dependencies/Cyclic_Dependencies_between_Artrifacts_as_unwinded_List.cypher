//Cyclic Dependencies between Artifacts as unwinded List

MATCH (package:Package)-[:CONTAINS]->(forwardSource:Type)-[:DEPENDS_ON]->(forwardTarget:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(backwardSource:Type)-[:DEPENDS_ON]->(backwardTarget:Type)<-[:CONTAINS]-(package)
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
MATCH (dependentArtifact:Artifact)-[:CONTAINS]->(dependentPackage)
 WITH artifact
     ,dependentArtifact
     ,package
     ,dependentPackage
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)   AS forwardDependencies
     ,collect(DISTINCT backwardTarget.name + '<-' + backwardSource.name)  AS backwardDependencies
 WITH artifact
     ,dependentArtifact
     ,package
     ,dependentPackage
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE artifact <> dependentArtifact
  AND package  <> dependentPackage
  AND (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(package.fqn)    >= size(dependentPackage.fqn)))
UNWIND (backwardDependencies + forwardDependencies) AS dependency
RETURN artifact.fileName          AS artifactName
      ,dependentArtifact.fileName AS dependentArtifactName
      ,package.fqn                AS packageName
      ,dependentPackage.fqn       AS dependentPackageName
      ,dependency
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY forwardToBackwardBalance DESC, packageName ASC