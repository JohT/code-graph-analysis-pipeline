// Cyclic Dependencies between SCIP Semantic Index Artifacts as unwinded List. Includes both types and functions via SemanticCodeIndexInternalSymbol.

MATCH (module:SemanticCodeIndexModule)-[:CONTAINS]->(forwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(forwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(dependentModule:SemanticCodeIndexModule)
MATCH (dependentModule)-[:CONTAINS]->(backwardSource:SemanticCodeIndexInternalSymbol)-[:DEPENDS_ON]->(backwardTarget:SemanticCodeIndexInternalSymbol)<-[:CONTAINS]-(module)
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
      ,((module.fqn STARTS WITH dependentModule.fqn) OR (dependentModule.fqn STARTS WITH module.fqn)) AS parentChildCycle
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY round(forwardToBackwardBalance, 1, 'DOWN') DESC // easiest to remove first in bins of 0.1 like 0.9, 0.8, 0.7, ...
        ,parentChildCycle // parent-child cycles last (less critical) per bin
        ,forwardToBackwardBalance DESC // within each bin, sort by actual balance descending
        ,moduleName ASC // in the rare case of identical balance and parent-child status, sort by module name
