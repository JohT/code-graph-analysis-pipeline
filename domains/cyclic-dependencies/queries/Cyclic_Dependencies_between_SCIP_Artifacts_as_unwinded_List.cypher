// Cyclic Dependencies between SCIP Semantic Index Artifacts as unwinded List.

MATCH (module:SemanticCodeIndexModule)-[:CONTAINS]->(forwardSource:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(forwardTarget:SemanticCodeIndexInternalType)<-[:CONTAINS]-(dependentModule:SemanticCodeIndexModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SemanticCodeIndexInternalType)-[:DEPENDS_ON]->(backwardTarget:SemanticCodeIndexInternalType)<-[:CONTAINS]-(module)
MATCH (artifact:SemanticCodeIndexArtifact)-[:CONTAINS]->(module)
MATCH (dependentArtifact:SemanticCodeIndexArtifact)-[:CONTAINS]->(dependentModule)
WHERE artifact <> dependentArtifact
  AND module   <> dependentModule
 WITH artifact
     ,dependentArtifact
     ,module
     ,dependentModule
     ,collect(DISTINCT forwardSource.name  + '->' + forwardTarget.name)   AS forwardDependencies
     ,collect(DISTINCT backwardTarget.name + '<-' + backwardSource.name)  AS backwardDependencies
 WITH artifact
     ,dependentArtifact
     ,module
     ,dependentModule
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  module.fqn >= dependentModule.fqn))
UNWIND (backwardDependencies + forwardDependencies) AS dependency
RETURN artifact.name          AS artifactName
      ,dependentArtifact.name AS dependentArtifactName
      ,module.fqn             AS moduleName
      ,dependentModule.fqn    AS dependentModuleName
      ,dependency
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY forwardToBackwardBalance DESC, moduleName ASC
