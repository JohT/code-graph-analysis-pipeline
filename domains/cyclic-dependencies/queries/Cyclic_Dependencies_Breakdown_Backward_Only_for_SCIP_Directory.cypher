// Cyclic Dependencies Breakdown Backward Only for SCIP Directories containing files. Shows only backward dependencies to remove.

MATCH (sourceDirectory:SemanticCodeIndexInternalFile)-[:DEPENDS_ON]->(forwardTargetFile:SemanticCodeIndexInternalFile)
MATCH (backwardSourceFile:SemanticCodeIndexInternalFile)-[:DEPENDS_ON]->(targetDirectory:SemanticCodeIndexInternalFile)
WHERE sourceDirectory.directory <> forwardTargetFile.directory
  AND backwardSourceFile.directory <> targetDirectory.directory
  AND sourceDirectory.directory = targetDirectory.directory
  AND forwardTargetFile.directory = backwardSourceFile.directory
 WITH sourceDirectory.directory                                                      AS directoryName
     ,forwardTargetFile.directory                                                    AS dependentDirectoryName
     ,collect(DISTINCT sourceDirectory.fileName + '->' + forwardTargetFile.fileName) AS forwardDependencies
     ,collect(DISTINCT targetDirectory.fileName + '<-' + backwardSourceFile.fileName) AS backwardDependencies
 WITH directoryName
     ,dependentDirectoryName
     ,forwardDependencies
     ,backwardDependencies
     ,size(forwardDependencies)  AS numberOfForwardDependencies
     ,size(backwardDependencies) AS numberOfBackwardDependencies
     ,size(forwardDependencies) + size(backwardDependencies) AS numberOfAllCyclicDependencies
WHERE (size(forwardDependencies) > size(backwardDependencies)
   OR (size(forwardDependencies) = size(backwardDependencies)
  AND  directoryName >= dependentDirectoryName))
UNWIND backwardDependencies AS dependency
RETURN directoryName
      ,dependentDirectoryName
      ,dependency
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY forwardToBackwardBalance DESC, directoryName ASC
