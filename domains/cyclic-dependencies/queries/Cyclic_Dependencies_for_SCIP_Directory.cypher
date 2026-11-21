// Cyclic Dependencies as List for SCIP Directories containing files. Includes both forward and backward directions.

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
RETURN directoryName
      ,dependentDirectoryName
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
      ,forwardDependencies[0..9]    AS someForwardDependencies
      ,backwardDependencies
ORDER BY forwardToBackwardBalance DESC, directoryName ASC
