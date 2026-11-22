//Cyclic Dependencies between Artifacts as unwinded List

MATCH (package:Package)-[:CONTAINS]->(forwardSource:Type)-[:DEPENDS_ON]->(forwardTarget:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(backwardSource:Type)-[:DEPENDS_ON]->(backwardTarget:Type)<-[:CONTAINS]-(package)
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
MATCH (dependentArtifact:Artifact)-[:CONTAINS]->(dependentPackage)
WHERE artifact <> dependentArtifact
  AND package  <> dependentPackage
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
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(package.fqn)    >= size(dependentPackage.fqn)))
UNWIND (backwardDependencies + forwardDependencies) AS dependency
RETURN artifact.fileName          AS artifactName
      ,dependentArtifact.fileName AS dependentArtifactName
      ,package.fqn                AS packageName
      ,dependentPackage.fqn       AS dependentPackageName
      ,dependency
      ,((package.fqn STARTS WITH dependentPackage.fqn) OR (dependentPackage.fqn STARTS WITH package.fqn)) AS parentChildCycle
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY round(forwardToBackwardBalance, 1, 'DOWN') DESC // easiest to remove first in bins of 0.1 like 0.9, 0.8, 0.7, ...
        ,parentChildCycle // parent-child cycles last (less critical) per bin
        ,forwardToBackwardBalance DESC // within each bin, sort by actual balance descending
        ,packageName ASC // in the rare case of identical balance and parent-child status, sort by package name