// Cyclic Dependencies Breakdown for SCIP Directories containing files. Unwraps individual dependencies (direct only).

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
UNWIND (backwardDependencies + forwardDependencies) AS dependency
RETURN directoryName
      ,dependentDirectoryName
      ,dependency
      ,((directoryName STARTS WITH dependentDirectoryName) OR (dependentDirectoryName STARTS WITH directoryName)) AS parentChildCycle
      ,toFloat(ABS(numberOfForwardDependencies - numberOfBackwardDependencies)) / numberOfAllCyclicDependencies AS forwardToBackwardBalance
      ,numberOfForwardDependencies  AS numberForward
      ,numberOfBackwardDependencies AS numberBackward
ORDER BY round(forwardToBackwardBalance, 1, 'DOWN') DESC // easiest to remove first in bins of 0.1 like 0.9, 0.8, 0.7, ...
        ,parentChildCycle // parent-child cycles last (less critical) per bin
        ,forwardToBackwardBalance DESC // within each bin, sort by actual balance descending
        ,directoryName ASC // in the rare case of identical balance and parent-child status, sort by directory name
