//Cyclic Dependencies as List. Requires "Add_file_name and_extension.cypher".

MATCH (package:Package)-[:CONTAINS]->(forwardSource:Type)-[:DEPENDS_ON]->(forwardTarget:Type)<-[:CONTAINS]-(dependentPackage:Package)
MATCH (dependentPackage)-[:CONTAINS]->(backwardSource:Type)-[:DEPENDS_ON]->(backwardTarget:Type)<-[:CONTAINS]-(package)
MATCH (artifact:Artifact)-[:CONTAINS]->(package)
MATCH (dependentArtifact:Artifact)-[:CONTAINS]->(dependentPackage)
WHERE package.fqn <> dependentPackage.fqn
 WITH artifact.name                                                       AS artifactName
     ,package.fqn                                                         AS packageName
     ,dependentArtifact.name                                              AS dependentArtifactName
     ,dependentPackage.fqn                                                AS dependentPackageName
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)   AS forwardDependencies
     ,collect(DISTINCT backwardSource.name + '->' + backwardTarget.name)  AS backwardDependencies
 WITH artifactName
     ,packageName
     ,dependentArtifactName
     ,dependentPackageName
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  size(packageName)        >= size(dependentPackageName)))
RETURN artifactName
      ,packageName
      ,dependentArtifactName
      ,dependentPackageName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS someForwardDependencies
      ,backwardDependencies
ORDER BY forwardToBackwardBalance DESC, packageName ASC